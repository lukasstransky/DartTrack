import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/models/firestore/open_games_firestore.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_statistics.dart';
import 'package:dart_app/models/firestore/statistics_firestore_x01.dart';
import 'package:dart_app/services/firestore/firestore_service_player_stats.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FirestoreServiceGames {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  FirestoreServiceGames(this._firestore, this._firebaseAuth);

  Future<String> postGame(Game game) async {
    final Game gameToSave = Game.Firestore(
        name: game.getName,
        isGameFinished: true,
        dateTime: game.getDateTime,
        gameSettings: game.getGameSettings,
        playerGameStatistics: [],
        teamGameStatistics: []);

    Map<String, dynamic> data = {};
    if (game is GameX01) {
      data = gameToSave.toMapX01(game, false);
    }
    //add other modes like cricket...

    String gameId = '';
    await _firestore
        .collection(this._getFirestoreGamesPath())
        .add(data)
        .then((value) => {
              gameId = value.id,
            });

    return gameId;
  }

  Future<void> checkIfAtLeastOneX01GameIsPlayed(BuildContext context) async {
    final QuerySnapshot<Object?> games = await _firestore
        .collection(this._getFirestoreGamesPath())
        .where('name', isEqualTo: 'X01')
        .get();
    final StatisticsFirestoreX01 statisticsFirestoreX01 =
        context.read<StatisticsFirestoreX01>();

    statisticsFirestoreX01.noGamesPlayed = games.docs.isEmpty ? true : false;
    if (!statisticsFirestoreX01.noGamesPlayed) {
      //todo not the best solution to load all statistics here (-> only precise scores are needed)
      context.read<FirestoreServicePlayerStats>().getStatistics(context);
    }
    statisticsFirestoreX01.notify();
  }

  Future<void> getGames(String mode, BuildContext context) async {
    late dynamic firestoreStats;
    switch (mode) {
      case 'X01':
        firestoreStats = context.read<StatisticsFirestoreX01>();
      //add other modes
    }

    final CollectionReference collectionReference =
        _firestore.collection(this._getFirestoreGamesPath());
    Query query = collectionReference.where('name', isEqualTo: mode);

    if (firestoreStats.currentFilterValue == FilterValue.Year ||
        firestoreStats.currentFilterValue == FilterValue.Month) {
      query = query.where('dateTimeForFiltering',
          isGreaterThanOrEqualTo:
              firestoreStats.getDateTimeFromCurrentFilterValue());
    } else if (firestoreStats.currentFilterValue == FilterValue.Custom) {
      query = query.where('dateTimeForFiltering',
          isGreaterThanOrEqualTo: firestoreStats.getCustomStartDate());
      query = query.where('dateTimeForFiltering',
          isLessThanOrEqualTo: firestoreStats.getCustomEndDate());
    }

    final QuerySnapshot<Object?> games = await query.get();

    firestoreStats.resetGames();

    if (games.docs.isEmpty) {
      firestoreStats.noGamesPlayed = true;
      firestoreStats.notify();
    } else {
      firestoreStats.noGamesPlayed = false;

      games.docs.forEach((element) async {
        final Game game = Game.fromMap(element.data(), mode, element.id, false);

        PlayerOrTeamGameStatistics? playerOrTeamGameStatistics;
        for (String playerGameStatsId in element.get('playerGameStatsIds')) {
          playerOrTeamGameStatistics = await context
              .read<FirestoreServicePlayerStats>()
              .getPlayerOrTeamGameStatisticById(playerGameStatsId, mode, false);

          game.getPlayerGameStatistics.add(playerOrTeamGameStatistics);
        }

        for (String teamGameStatsId in element.get('teamGameStatsIds')) {
          playerOrTeamGameStatistics = await context
              .read<FirestoreServicePlayerStats>()
              .getPlayerOrTeamGameStatisticById(teamGameStatsId, mode, true);

          game.getTeamGameStatistics.add(playerOrTeamGameStatistics);
        }

        firestoreStats.games.add(game);
        firestoreStats.notify();
      });
    }
  }

  /************************************************************************************/
  /***************************         OPEN GAMES            **************************/
  /************************************************************************************/

  Future<void> postOpenGame(Game game, BuildContext context) async {
    final Game gameToSave = Game.Firestore(
        gameId: game.getGameId,
        name: game.getName,
        isGameFinished: false,
        dateTime: game.getDateTime,
        gameSettings: game.getGameSettings,
        playerGameStatistics: game.getPlayerGameStatistics,
        teamGameStatistics: game.getTeamGameStatistics,
        currentPlayerToThrow: game.getCurrentPlayerToThrow);
    final openGamesFirestore = context.read<OpenGamesFirestore>();
    final CollectionReference collectionReference =
        _firestore.collection(this._getFirestoreOpenGamesPath());

    bool openGameAlreadyExists = false;
    for (Game openGame in openGamesFirestore.openGames) {
      if (openGame.getGameId == game.getGameId) {
        openGameAlreadyExists = true;
        break;
      }
    }

    Map<String, dynamic> data = {};
    if (game is GameX01) {
      data = gameToSave.toMapX01(game, true);
    }
    //add other modes like cricket...

    //update (e.g. save game again that was already open)
    if (openGameAlreadyExists) {
      await collectionReference.doc(gameToSave.getGameId).update(data);
    } else {
      //create new one
      await _firestore
          .collection(this._getFirestoreOpenGamesPath())
          .add(data)
          .then((value) async => {
                await _firestore
                    .collection(this._getFirestoreOpenGamesPath())
                    .doc(value.id)
                    .update({'gameId': value.id})
              });
    }
  }

  Future<void> deleteOpenGame(String gameId, BuildContext context) async {
    await _firestore
        .collection(this._getFirestoreOpenGamesPath())
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
            if ((openGame.data() as Map<String, dynamic>)
                .containsValue('X01')) {
              mode = 'X01';
            } else if ((openGame.data() as Map<String, dynamic>)
                .containsValue('Cricket')) {
              mode = 'Cricket';
            }

            final Game game =
                Game.fromMap(openGame.data(), mode, openGame.id, true);
            openGamesFirestore.openGames.add(game);
            openGamesFirestore.notify();
          })
        });

    openGamesFirestore.init = true;
    openGamesFirestore.notify();
  }

  String _getFirestoreGamesPath() {
    return 'users/' + _firebaseAuth.currentUser!.uid + '/games';
  }

  String _getFirestoreOpenGamesPath() {
    return 'users/' + _firebaseAuth.currentUser!.uid + '/openGames';
  }
}
