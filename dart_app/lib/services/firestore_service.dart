import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/models/games/game_x01.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_app/models/player_statistics/player_game_statistics.dart';
import 'package:dart_app/models/player_statistics/player_game_statistics_x01.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer';

class FirestoreService {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  FirestoreService(this._firestore, this._firebaseAuth);

  Future<String> postGame(GameX01 gameX01) async {
    Game gameToSave = Game.firestore(
        name: gameX01.getName,
        dateTime: gameX01.getDateTime,
        gameSettings: gameX01.getGameSettings);

    String gameId = "";
    await _firestore
        .collection("users/" + _firebaseAuth.currentUser!.uid + "/games")
        .add(gameToSave.toMapX01())
        .then((value) => {
              gameId = value.id,
            });
    return gameId;
  }

  Future<void> postPlayerGameStatistics(GameX01 gameX01, String gameId) async {
    List<String> playerGameStatsIds = [];

    for (PlayerGameStatisticsX01 stats in gameX01.getPlayerGameStatistics) {
      PlayerGameStatistics playerGameStatisticsToSave =
          PlayerGameStatistics(player: stats.getPlayer, mode: stats.getMode);

      await _firestore
          .collection("users/" +
              _firebaseAuth.currentUser!.uid +
              "/playerGameStatistics")
          .add(playerGameStatisticsToSave.toMapX01(stats, gameX01, gameId))
          .then((value) => {
                playerGameStatsIds.add(value.id),
              });
    }

    //set playerGameStatsIds for game
    await _firestore
        .collection("users/" + _firebaseAuth.currentUser!.uid + "/games")
        .doc(gameId)
        .update({"playerGameStatisticsIds": playerGameStatsIds});
  }
}
