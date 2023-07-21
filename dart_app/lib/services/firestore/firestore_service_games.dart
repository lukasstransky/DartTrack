import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_app/constants.dart';
import 'package:dart_app/models/firestore/stats_firestore_c.dart';
import 'package:dart_app/models/firestore/stats_firestore_d_t.dart';
import 'package:dart_app/models/firestore/stats_firestore_s_t.dart';
import 'package:dart_app/models/firestore/stats_firestore_sc_t.dart';
import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/models/games/game_cricket_p.dart';
import 'package:dart_app/models/games/game_score_training_p.dart';
import 'package:dart_app/models/games/game_single_double_training_p.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/models/firestore/open_games_firestore.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats.dart';
import 'package:dart_app/models/firestore/stats_firestore_x01_p.dart';
import 'package:dart_app/models/settings_p.dart';
import 'package:dart_app/services/firestore/firestore_service_player_stats.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class FirestoreServiceGames {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  FirestoreServiceGames(this._firestore, this._firebaseAuth);

  /************************************************************************************/
  /*****************************          GAMES            ****************************/
  /************************************************************************************/

  Future<String> postGame(
      Game_P game, OpenGamesFirestore openGamesFirestore) async {
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
      setLegWithPlayerOrTeamWhoFinishedIt: [],
    );

    // delete open game
    if (game.getIsOpenGame) {
      deleteOpenGame(game.getGameId, openGamesFirestore);
    }

    Map<String, dynamic> data = {};
    if (game is GameX01_P) {
      data = gameToSave.toMapX01(game, false);
    } else if (game is GameScoreTraining_P) {
      data = gameToSave.toMapScoreTraining(game, false);
    } else if (game is GameSingleDoubleTraining_P) {
      data = gameToSave.toMapSingleDoubleTraining(game, false);
    } else if (game is GameCricket_P) {
      data = gameToSave.toMapCricket(game, false);
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

  Future<void> deleteGame(String gameId, BuildContext context,
      bool teamStatsAvailable, GameMode mode) async {
    final FirestoreServicePlayerStats firestoreServicePlayerStats =
        context.read<FirestoreServicePlayerStats>();
    final dynamic firestoreStats =
        Utils.getFirestoreStatsProviderBasedOnMode(mode, context);

    // remove locally stored game (and player stats for X01 mode)
    firestoreStats.games.removeWhere((game) => game.getGameId == gameId);
    if (firestoreStats.games.length == 0) {
      firestoreStats.noGamesPlayed = true;
    } else {
      firestoreStats.noGamesPlayed = false;
    }
    if (mode == GameMode.X01) {
      firestoreStats.filteredGames
          .removeWhere((game) => game.getGameId == gameId);

      firestoreStats.getPlayerOrTeamGameStats
          .removeWhere((stats) => stats.getGameId == gameId);
      firestoreStats.getFilteredPlayerOrTeamGameStats
          .removeWhere((stats) => stats.getGameId == gameId);
    }

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

  Future<void> resetStatistics(BuildContext context,
      [bool deleteDefaultSettings = false]) async {
    final Settings_P settings = context.read<Settings_P>();

    context.read<StatsFirestoreX01_P>().resetForResettingStats();
    context.read<StatsFirestoreCricket_P>().resetForResettingStats();
    context.read<StatsFirestoreDoubleTraining_P>().resetForResettingStats();
    context.read<StatsFirestoreSingleTraining_P>().resetForResettingStats();
    context.read<StatsFirestoreScoreTraining_P>().resetForResettingStats();

    settings.setIsResettingStatsOrDeletingAccount = true;
    settings.notify();

    try {
      List<Future<void>> futureList = [
        _deleteCollection(_firestore.collection(_getFirestoreGamesPath())),
        _deleteCollection(_firestore.collection(_getFirestoreOpenGamesPath())),
        _deleteCollection(
            _firestore.collection(_getFirestorePlayerStatsPath())),
        _deleteCollection(_firestore.collection(_getFirestoreTeamStatsPath())),
      ];

      if (deleteDefaultSettings) {
        futureList.add(_deleteCollection(
            _firestore.collection(_getFirestoreDefaultSettingsX01Path())));
      }

      await Future.wait(futureList);
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'An unexpected error occurred. Please try again later.',
          toastLength: Toast.LENGTH_LONG);
    } finally {
      settings.setIsResettingStatsOrDeletingAccount = false;
      settings.notify();
    }
  }

  Future<void> _deleteCollection(CollectionReference collection) async {
    try {
      final snapshot = await collection.get();

      await Future.wait(
          snapshot.docs.map((doc) => doc.reference.delete()).toList());
    } catch (e) {
      Fluttertoast.showToast(
          msg: 'An unexpected error occurred. Please try again later.',
          toastLength: Toast.LENGTH_LONG);
    }
  }

  Future<void> checkIfAtLeastOneX01GameIsPlayed(BuildContext context) async {
    final QuerySnapshot<Object?> games = await _firestore
        .collection(this._getFirestoreGamesPath())
        .where('name', isEqualTo: GameMode.X01.name)
        .get();
    final StatsFirestoreX01_P statisticsFirestoreX01 =
        context.read<StatsFirestoreX01_P>();

    statisticsFirestoreX01.noGamesPlayed = games.docs.isEmpty ? true : false;
    if (!statisticsFirestoreX01.noGamesPlayed &&
        !statisticsFirestoreX01.playerOrTeamGameStatsLoaded) {
      statisticsFirestoreX01.calculateX01Stats();
    }
    statisticsFirestoreX01.notify();
  }

  Future<void> getGames(GameMode mode, BuildContext context,
      FirestoreServicePlayerStats firestoreServicePlayerStats) async {
    final dynamic statsFirestore =
        Utils.getFirestoreStatsProviderBasedOnMode(mode, context);
    final bool isX01 = mode == GameMode.X01;

    if (!statsFirestore.loadGames) {
      return;
    }

    final CollectionReference collectionReference =
        _firestore.collection(_getFirestoreGamesPath());
    final Query query = collectionReference.where('name', isEqualTo: mode.name);
    final QuerySnapshot<Object?> games = await query.get();

    statsFirestore.resetGames();
    if (isX01) {
      statsFirestore.resetFilteredGames();
    }

    if (games.docs.isEmpty) {
      statsFirestore.noGamesPlayed = true;
      statsFirestore.notify();
    } else {
      statsFirestore.noGamesPlayed = false;

      await Future.forEach(games.docs, (QueryDocumentSnapshot element) async {
        final Game_P game =
            Game_P.fromMap(element.data(), mode, element.id, false);

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
        if (isX01) {
          statsFirestore.filteredGames.add(game);
        }
      });

      if (isX01) {
        statsFirestore.gamesLoaded = true;
      }
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
      setLegWithPlayerOrTeamWhoFinishedIt:
          game_p.getLegSetWithPlayerOrTeamWhoFinishedIt,
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
    } else if (game_p is GameCricket_P) {
      data = gameToSave.toMapCricket(game_p, true);
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

  Future<void> deleteOpenGame(
      String gameId, OpenGamesFirestore openGamesFirestore) async {
    await _firestore
        .collection(_getFirestoreOpenGamesPath())
        .doc(gameId)
        .delete()
        .then((value) async => {
              await getOpenGames(openGamesFirestore),
            });
  }

  Future<void> deleteAllOpenGames() async {
    await _firestore
        .collection(_getFirestoreOpenGamesPath())
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((doc) => doc.reference.delete());
    });
  }

  Future<void> getOpenGames(OpenGamesFirestore openGamesFirestore) async {
    final CollectionReference collectionReference =
        _firestore.collection(this._getFirestoreOpenGamesPath());

    openGamesFirestore.reset();

    await collectionReference.get().then((openGames) => {
          openGames.docs.forEach((openGame) {
            final Game_P game = _createGameFromMap(
                openGame.data() as Map<String, dynamic>, openGame);
            openGamesFirestore.openGames.add(game);
            openGamesFirestore.notify();
          })
        });

    openGamesFirestore.openGames.sort();
    openGamesFirestore.init = true;
    openGamesFirestore.notify();
  }

  Game_P _createGameFromMap(
      Map<String, dynamic> map, DocumentSnapshot openGame) {
    if (map.containsValue(GameMode.X01.name)) {
      return GameX01_P.fromMapX01(
          openGame.data(), GameMode.X01, openGame.id, true);
    } else if (map.containsValue(GameMode.ScoreTraining.name)) {
      return Game_P.fromMap(
          openGame.data(), GameMode.ScoreTraining, openGame.id, true);
    } else if (map.containsValue(GameMode.SingleTraining.name) ||
        map.containsValue(GameMode.DoubleTraining.name)) {
      final GameMode mode = map.containsValue(GameMode.SingleTraining.name)
          ? GameMode.SingleTraining
          : GameMode.DoubleTraining;

      return GameSingleDoubleTraining_P.fromMapSingleDoubleTraining(
          openGame.data(), mode, openGame.id, true);
    } else if (map.containsValue(GameMode.Cricket.name)) {
      return GameCricket_P.fromMapCricket(
          openGame.data(), GameMode.Cricket, openGame.id, true);
    } else {
      throw Exception('Unknown game mode');
    }
  }

  /************************************************************************************/
  /***********************         FAVOURITE GAMES            *************************/
  /************************************************************************************/

  Future<void> changeFavouriteStateOfGame(String gameId, bool state) async {
    await _firestore
        .collection(_getFirestoreGamesPath())
        .doc(gameId)
        .update({'isFavouriteGame': state});
  }

  String _getFirestoreGamesPath() {
    return 'users/${_firebaseAuth.currentUser!.uid}/games';
  }

  String _getFirestoreOpenGamesPath() {
    return 'users/${_firebaseAuth.currentUser!.uid}/openGames';
  }

  String _getFirestorePlayerStatsPath() {
    return 'users/${_firebaseAuth.currentUser!.uid}/playerGameStatistics';
  }

  String _getFirestoreTeamStatsPath() {
    return 'users/${_firebaseAuth.currentUser!.uid}/teamGameStatistics';
  }

  String _getFirestoreDefaultSettingsX01Path() {
    return 'users/${_firebaseAuth.currentUser!.uid}/defaultSettingsX01';
  }
}
