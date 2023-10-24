import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_cricket_p.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/models/player_statistics/player_game_stats_single_double_training.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats.dart';
import 'package:dart_app/models/player_statistics/player_game_stats_score_training.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats_cricket.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats_x01.dart';
import 'package:dart_app/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FirestoreServicePlayerStats {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  FirestoreServicePlayerStats(this._firestore, this._firebaseAuth);

  Future<void> postPlayerGameStatistics(
      Game_P game, String gameId, BuildContext context) async {
    final GameSettingsX01_P gameSettingsX01 = context.read<GameSettingsX01_P>();
    final String currentUserUid = context.read<AuthService>().getCurrentUserUid;
    final String currentUsername =
        context.read<AuthService>().getUsernameFromSharedPreferences() ?? '';

    List<String> playerGameStatsIds = [];
    List<String> teamGameStatsIds = [];
    PlayerOrTeamGameStats playerOrTeamStatsToSave;
    Map<String, dynamic> data = {};

    for (PlayerOrTeamGameStats playerStats in game.getPlayerGameStatistics) {
      playerOrTeamStatsToSave = PlayerOrTeamGameStats.Player(
          gameId: '',
          player: playerStats.getPlayer,
          mode: playerStats.getMode,
          dateTime: playerStats.getDateTime);

      if (playerStats is PlayerOrTeamGameStatsX01) {
        data = playerOrTeamStatsToSave.toMapX01(
          playerStats,
          GameX01_P.createGame(game),
          gameSettingsX01,
          gameId,
          false,
          currentUserUid,
          currentUsername,
        );
      } else if (playerStats is PlayerGameStatsScoreTraining) {
        data = playerOrTeamStatsToSave.toMapScoreTraining(
          playerStats,
          gameId,
          false,
        );
      } else if (playerStats is PlayerGameStatsSingleDoubleTraining) {
        data = playerOrTeamStatsToSave.toMapSingleDoubleTraining(
          playerStats,
          gameId,
          false,
        );
      } else if (playerStats is PlayerOrTeamGameStatsCricket) {
        data = playerOrTeamStatsToSave.toMapCricket(
          playerStats,
          context.read<GameSettingsCricket_P>(),
          gameId,
          false,
        );
      }

      // save playerGameStats to firestore
      await _firestore
          .collection(_getFirestorePlayerStatsPath())
          .add(data)
          .then((value) => {
                playerGameStatsIds.add(value.id),
              });
    }

    if (game.getTeamGameStatistics.isNotEmpty) {
      for (PlayerOrTeamGameStats teamStats in game.getTeamGameStatistics) {
        playerOrTeamStatsToSave = PlayerOrTeamGameStats.Team(
            gameId: '',
            team: teamStats.getTeam,
            mode: teamStats.getMode,
            dateTime: teamStats.getDateTime);

        if (teamStats is PlayerOrTeamGameStatsX01) {
          data = playerOrTeamStatsToSave.toMapX01(
            teamStats,
            GameX01_P.createGame(game),
            gameSettingsX01,
            gameId,
            false,
            currentUserUid,
            currentUsername,
          );
        } else if (teamStats is PlayerOrTeamGameStatsCricket) {
          data = playerOrTeamStatsToSave.toMapCricket(
            teamStats,
            context.read<GameSettingsCricket_P>(),
            gameId,
            false,
          );
        }

        await _firestore
            .collection(this._getFirestoreTeamStatsPath())
            .add(data)
            .then((value) => {
                  teamGameStatsIds.add(value.id),
                });
      }
    }

    // set playerGameStatsIds + gameId for game
    Map<String, dynamic> firestoreMap = {
      'gameId': gameId,
    };
    if (playerGameStatsIds.isNotEmpty) {
      firestoreMap['playerGameStatsIds'] = playerGameStatsIds;
    }
    if (teamGameStatsIds.isNotEmpty) {
      firestoreMap['teamGameStatsIds'] = teamGameStatsIds;
    }
    await _firestore
        .collection(this._getFirestoreGamesPath())
        .doc(gameId)
        .update(firestoreMap);
  }

  Future<void> getAllPlayerGameStats(dynamic firestoreStats, GameMode mode,
      [String currentUsername = '']) async {
    if (!firestoreStats.loadPlayerGameStats) {
      return;
    }

    firestoreStats.resetPlayerGameStats();

    final CollectionReference collectionReference =
        _firestore.collection(_getFirestorePlayerStatsPath());
    final Query query = collectionReference.where('mode', isEqualTo: mode.name);
    final QuerySnapshot<Object?> playerGameStats = await query.get();

    await Future.forEach(playerGameStats.docs,
        (QueryDocumentSnapshot element) async {
      late PlayerOrTeamGameStats playerGameStats;
      if (mode == GameMode.X01) {
        playerGameStats = PlayerOrTeamGameStatsX01.fromMapX01(element.data());
      } else if (mode == GameMode.Cricket) {
        playerGameStats = PlayerOrTeamGameStats.fromMapCricket(element.data());
      } else if (mode == GameMode.SingleTraining) {
        playerGameStats =
            PlayerOrTeamGameStats.fromMapSingleDoubleTraining(element.data());
      } else if (mode == GameMode.DoubleTraining) {
        playerGameStats =
            PlayerOrTeamGameStats.fromMapSingleDoubleTraining(element.data());
      } else if (mode == GameMode.ScoreTraining) {
        playerGameStats =
            PlayerOrTeamGameStats.fromMapScoreTraining(element.data());
      }

      firestoreStats.allPlayerGameStats.add(playerGameStats);
      if (mode == GameMode.X01) {
        if (playerGameStats.getPlayer.getName == currentUsername) {
          firestoreStats.getUserPlayerGameStats.add(playerGameStats);
          firestoreStats.getUserFilteredPlayerGameStats.add(playerGameStats);
        }
      }
    });

    firestoreStats.playerGameStatsLoaded = true;
    firestoreStats.notify();
  }

  Future<void> getAllTeamGameStats(dynamic firestoreStats, GameMode mode,
      [String currentUsername = '']) async {
    if (!firestoreStats.loadTeamGameStats) {
      return;
    }

    firestoreStats.resetTeamGameStats();

    final CollectionReference collectionReference =
        _firestore.collection(_getFirestoreTeamStatsPath());
    final Query query = collectionReference.where('mode', isEqualTo: mode.name);
    final QuerySnapshot<Object?> teamGameStats = await query.get();

    await Future.forEach(teamGameStats.docs,
        (QueryDocumentSnapshot element) async {
      late PlayerOrTeamGameStats teamGameStats;
      if (mode == GameMode.X01) {
        teamGameStats = PlayerOrTeamGameStatsX01.fromMapX01(element.data());
      } else if (mode == GameMode.Cricket) {
        teamGameStats = PlayerOrTeamGameStats.fromMapCricket(element.data());
      }

      firestoreStats.allTeamGameStats.add(teamGameStats);
      if (mode == GameMode.X01) {
        firestoreStats.filteredTeamGameStats.add(teamGameStats);
      }
    });

    firestoreStats.teamGameStatsLoaded = true;
    firestoreStats.notify();
  }

  Future<void> deletePlayerOrTeamStats(
      String gameId, bool shouldDeleteTeamStats) async {
    final String path = shouldDeleteTeamStats
        ? _getFirestoreTeamStatsPath()
        : _getFirestorePlayerStatsPath();

    await _firestore
        .collection(path)
        .where('gameId', isEqualTo: gameId)
        .get()
        .then((stats) => {
              stats.docs.forEach((stats) {
                _firestore.collection(path).doc(stats.id).delete();
              })
            });
  }

  String _getFirestorePlayerStatsPath() {
    return 'users/${_firebaseAuth.currentUser!.uid}/playerGameStatistics';
  }

  String _getFirestoreTeamStatsPath() {
    return 'users/${_firebaseAuth.currentUser!.uid}/teamGameStatistics';
  }

  String _getFirestoreGamesPath() {
    return 'users/${_firebaseAuth.currentUser!.uid}/games';
  }
}
