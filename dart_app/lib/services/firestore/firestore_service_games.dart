import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/models/games/game_score_training_p.dart';
import 'package:dart_app/models/games/game_single_double_training_p.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/models/firestore/open_games_firestore.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats.dart';
import 'package:dart_app/models/firestore/stats_firestore_x01_p.dart';
import 'package:dart_app/services/firestore/firestore_service_player_stats.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FirestoreServiceGames {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  FirestoreServiceGames(this._firestore, this._firebaseAuth);

  /************************************************************************************/
  /*****************************          GAMES            ****************************/
  /************************************************************************************/

  Future<String> postGame(Game_P game) async {
    final Game_P gameToSave = Game_P.Firestore(
      name: game.getName,
      isGameFinished: true,
      isOpenGame: false,
      isFavouriteGame: false,
      dateTime: game.getDateTime,
      gameSettings: game.getGameSettings,
      revertPossible: false,
      playerGameStatistics: [],
      teamGameStatistics: [],
      currentThreeDarts: [],
    );

    Map<String, dynamic> data = {};
    if (game is GameX01_P) {
      data = gameToSave.toMapX01(game, false);
    } else if (game is GameScoreTraining_P) {
      data = gameToSave.toMapScoreTraining(game, false);
    } else if (game is GameSingleDoubleTraining_P) {
      data = gameToSave.toMapSingleDoubleTraining(game, false);
    }

    String gameId = '';
    await _firestore
        .collection(_getFirestoreGamesPath())
        .add(data)
        .then((value) => {
              gameId = value.id,
            });

    return gameId;
  }

  Future<void> deleteGame(
      String gameId, BuildContext context, bool teamStatsAvailable) async {
    final FirestoreServicePlayerStats firestoreServicePlayerStats =
        context.read<FirestoreServicePlayerStats>();

    // delete playerStats or teamStats
    await firestoreServicePlayerStats.deletePlayerOrTeamStats(gameId, false);
    if (teamStatsAvailable) {
      await firestoreServicePlayerStats.deletePlayerOrTeamStats(gameId, true);
    }

    await _firestore
        .collection(this._getFirestoreGamesPath())
        .doc(gameId)
        .delete();
  }

  Future<void> resetStatistics(BuildContext context) async {
    final StatsFirestoreX01_P statisticsFirestoreX01 =
        context.read<StatsFirestoreX01_P>();

    for (Game_P game in statisticsFirestoreX01.games) {
      deleteGame(game.getGameId, context,
          game.getTeamGameStatistics.length > 0 ? true : false);
    }
  }

  Future<void> checkIfAtLeastOneX01GameIsPlayed(BuildContext context) async {
    final QuerySnapshot<Object?> games = await _firestore
        .collection(this._getFirestoreGamesPath())
        .where('name', isEqualTo: 'X01')
        .get();
    final StatsFirestoreX01_P statisticsFirestoreX01 =
        context.read<StatsFirestoreX01_P>();

    statisticsFirestoreX01.noGamesPlayed = games.docs.isEmpty ? true : false;
    if (!statisticsFirestoreX01.noGamesPlayed) {
      //todo not the best solution to load all statistics here (-> only precise scores are needed)
      context.read<FirestoreServicePlayerStats>().getX01Statistics(context);
    }
    statisticsFirestoreX01.notify();
  }

  Future<void> getGames(String mode, BuildContext context) async {
    final dynamic statsFirestore =
        Utils.getFirestoreStatsProviderBasedOnMode(mode, context);

    final CollectionReference collectionReference =
        _firestore.collection(_getFirestoreGamesPath());
    final Query query = collectionReference.where('name', isEqualTo: mode);
    final QuerySnapshot<Object?> games = await query.get();

    statsFirestore.resetGames();

    if (games.docs.isEmpty) {
      statsFirestore.noGamesPlayed = true;
      if (mode != 'X01') {
        statsFirestore.gamesLoaded = true;
      }
      statsFirestore.notify();
    } else {
      statsFirestore.noGamesPlayed = false;

      await Future.forEach(games.docs, (QueryDocumentSnapshot element) async {
        final Game_P game =
            Game_P.fromMap(element.data(), mode, element.id, false);
        final FirestoreServicePlayerStats firestoreServicePlayerStats =
            context.read<FirestoreServicePlayerStats>();

        PlayerOrTeamGameStats? playerOrTeamGameStatistics;

        for (String playerGameStatsId in element.get('playerGameStatsIds')) {
          playerOrTeamGameStatistics = await firestoreServicePlayerStats
              .getPlayerOrTeamGameStatisticById(playerGameStatsId, mode, false);

          game.getPlayerGameStatistics.add(playerOrTeamGameStatistics);
        }

        if ((element.data() as Map<String, dynamic>)
            .containsKey('teamGameStatsIds')) {
          for (String teamGameStatsId in element.get('teamGameStatsIds')) {
            playerOrTeamGameStatistics = await firestoreServicePlayerStats
                .getPlayerOrTeamGameStatisticById(teamGameStatsId, mode, true);

            game.getTeamGameStatistics.add(playerOrTeamGameStatistics);
          }
        }

        if (game.getIsFavouriteGame) {
          statsFirestore.favouriteGames.add(game);
        }

        statsFirestore.games.add(game);
      });

      statsFirestore.gamesLoaded = true;
      statsFirestore.notify();
    }
  }

  /************************************************************************************/
  /****************************        OPEN GAMES            **************************/
  /************************************************************************************/

  Future<void> postOpenGame(Game_P game_p, BuildContext context) async {
    final Game_P gameToSave = Game_P.Firestore(
      gameId: game_p.getGameId,
      name: game_p.getName,
      isGameFinished: false,
      isOpenGame: true,
      isFavouriteGame: false,
      revertPossible: game_p.getRevertPossible,
      dateTime: game_p.getDateTime,
      gameSettings: game_p.getGameSettings,
      playerGameStatistics: game_p.getPlayerGameStatistics,
      teamGameStatistics: game_p.getTeamGameStatistics,
      currentPlayerToThrow: game_p.getCurrentPlayerToThrow,
      currentTeamToThrow: game_p.getCurrentTeamToThrow,
      currentThreeDarts: game_p.getCurrentThreeDarts,
    );
    final openGamesFirestore = context.read<OpenGamesFirestore>();
    final CollectionReference collectionReference =
        _firestore.collection(this._getFirestoreOpenGamesPath());

    bool openGameAlreadyExists = false;
    for (Game_P openGame in openGamesFirestore.openGames) {
      if (openGame.getGameId == game_p.getGameId) {
        openGameAlreadyExists = true;
        break;
      }
    }

    Map<String, dynamic> data = {};
    if (game_p is GameX01_P) {
      data = gameToSave.toMapX01(game_p, true);
    } else if (game_p is GameScoreTraining_P) {
      data = gameToSave.toMapScoreTraining(game_p, true);
    } else if (game_p is GameSingleDoubleTraining_P) {
      data = gameToSave.toMapSingleDoubleTraining(game_p, true);
    }

    // update (e.g. save game again that was already open)
    if (openGameAlreadyExists) {
      await collectionReference.doc(gameToSave.getGameId).update(data);
    } else {
      // create new one
      await _firestore
          .collection(_getFirestoreOpenGamesPath())
          .add(data)
          .then((value) async => {
                await _firestore
                    .collection(_getFirestoreOpenGamesPath())
                    .doc(value.id)
                    .update({'gameId': value.id})
              });
    }
  }

  Future<void> deleteOpenGame(String gameId, BuildContext context) async {
    await _firestore
        .collection(_getFirestoreOpenGamesPath())
        .doc(gameId)
        .delete()
        .then((value) async => {
              await getOpenGames(context),
            });
  }

  Future<void> getOpenGames(BuildContext context) async {
    final CollectionReference collectionReference =
        _firestore.collection(this._getFirestoreOpenGamesPath());
    final openGamesFirestore = context.read<OpenGamesFirestore>();

    openGamesFirestore.reset();

    await collectionReference.get().then((openGames) => {
          openGames.docs.forEach((openGame) {
            String mode = '';
            Map<String, dynamic> map =
                (openGame.data() as Map<String, dynamic>);
            if (map.containsValue('X01')) {
              mode = 'X01';
            } else if (map.containsValue('Score Training')) {
              mode = 'Score Training';
            } else if (map.containsValue('Single Training')) {
              mode = 'Single Training';
            } else if (map.containsValue('Double Training')) {
              mode = 'Double Training';
            }

            if (mode == 'X01' || mode == 'Score Training') {
              final Game_P game =
                  Game_P.fromMap(openGame.data(), mode, openGame.id, true);
              openGamesFirestore.openGames.add(game);
            } else if (mode == 'Single Training' || mode == 'Double Training') {
              final GameSingleDoubleTraining_P game =
                  GameSingleDoubleTraining_P.fromMapSingleDoubleTraining(
                      openGame.data(), mode, openGame.id, true);
              openGamesFirestore.openGames.add(game);
            }

            openGamesFirestore.notify();
          })
        });

    openGamesFirestore.openGames.sort();
    openGamesFirestore.init = true;
    openGamesFirestore.notify();
  }

  /************************************************************************************/
  /***********************         FAVOUTIRE GAMES            *************************/
  /************************************************************************************/

  Future<void> changeFavouriteStateOfGame(String gameId, bool state) async {
    await _firestore
        .collection(_getFirestoreGamesPath())
        .doc(gameId)
        .update({'isFavouriteGame': state});
  }

  String _getFirestoreGamesPath() {
    return 'users/' + _firebaseAuth.currentUser!.uid + '/games';
  }

  String _getFirestoreOpenGamesPath() {
    return 'users/' + _firebaseAuth.currentUser!.uid + '/openGames';
  }
}
