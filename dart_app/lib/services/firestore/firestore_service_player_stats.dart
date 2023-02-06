import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/models/player_statistics/player_game_stats_single_double_training.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats.dart';
import 'package:dart_app/models/player_statistics/player_game_stats_score_training.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats_x01.dart';
import 'package:dart_app/models/firestore/stats_firestore_x01_p.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class FirestoreServicePlayerStats {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;

  FirestoreServicePlayerStats(this._firestore, this._firebaseAuth);

  Future<void> postPlayerGameStatistics(
      Game_P game, String gameId, BuildContext context) async {
    final GameSettingsX01_P gameSettingsX01 = context.read<GameSettingsX01_P>();

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
        data = playerOrTeamStatsToSave.toMapX01(playerStats,
            GameX01_P.createGame(game), gameSettingsX01, gameId, false);
      } else if (playerStats is PlayerGameStatsScoreTraining) {
        data = playerOrTeamStatsToSave.toMapScoreTraining(
            playerStats, gameId, false);
      } else if (playerStats is PlayerGameStatsSingleDoubleTraining) {
        data = playerOrTeamStatsToSave.toMapSingleDoubleTraining(
            playerStats, gameId, false);
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
          data = playerOrTeamStatsToSave.toMapX01(teamStats,
              GameX01_P.createGame(game), gameSettingsX01, gameId, false);
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

  Future<void> getX01Statistics(BuildContext context) async {
    //todo comment out
    const String currentPlayerName =
        //await context.read<AuthService>().getPlayer!.getName;
        'Strainski';
    final firestoreStats = context.read<StatsFirestoreX01_P>();

    firestoreStats.resetValues();

    int counter = 0;

    double totalAvg = 0;
    double bestAvg = -1;
    double worstAvg = -1;

    double totalFirstNineAvg = 0;
    double bestFirstNineAvg = -1;
    double worstFirstNineAvg = -1;

    double totalCheckoutQuoteAvg = 0;
    double bestCheckoutQuote = -1;
    double worstCheckoutQuote = -1;
    int checkoutQuoteCounter = 0;

    double totalCheckoutScoreAvg = 0;
    int bestCheckoutScore = -1;
    int worstCheckoutScore = -1;
    int checkoutScoreCounter = 0;

    int countOfAllDarts = 0;
    int bestLeg = -1;
    int worstLeg = -1;
    int dartsForWonLegCount = 0;
    int legsWonTotal = 0;

    int countOf180 = 0;
    int countOfGamesWon = 0;

    Map<String, dynamic> _roundedScoresEven = {};
    Map<String, dynamic> _roundedScoresOdd = {};
    Map<String, dynamic> _preciseScores = {};
    Map<String, dynamic> _allScoresPerDartWithCount = {};

    final CollectionReference collectionReference =
        _firestore.collection(_getFirestorePlayerStatsPath());
    Query query = collectionReference
        .where('player.name', isEqualTo: currentPlayerName)
        .where('mode', isEqualTo: 'X01');

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

    await query.get().then(
          (value) => {
            value.docs.forEach(
              (element) => {
                //count of games
                firestoreStats.countOfGames = value.size,

                //count of games won
                if ((element.data() as Map<String, dynamic>)
                        .containsKey('checkoutInPercent') &&
                    element.get('gameWon') == true)
                  {
                    countOfGamesWon++,
                  },

                //checkout quote
                if ((element.data() as Map<String, dynamic>)
                    .containsKey('checkoutInPercent'))
                  {
                    totalCheckoutQuoteAvg += element.get('checkoutInPercent'),
                    checkoutQuoteCounter++,
                    if (element.get('checkoutInPercent') > bestCheckoutQuote)
                      {
                        bestCheckoutQuote = element.get('checkoutInPercent'),
                      },
                    if (element.get('checkoutInPercent') < worstCheckoutQuote ||
                        worstCheckoutQuote == -1)
                      {
                        worstCheckoutQuote = element.get('checkoutInPercent'),
                      },
                  },

                //checkout score
                if ((element.data() as Map<String, dynamic>)
                    .containsKey('checkouts'))
                  {
                    for (int checkoutScore in element.get('checkouts').values)
                      {
                        totalCheckoutScoreAvg += checkoutScore,
                        checkoutScoreCounter++,
                        if (checkoutScore < worstCheckoutScore ||
                            worstCheckoutScore == -1)
                          {
                            worstCheckoutScore = checkoutScore,
                          }
                      }
                  },

                //highest finish
                if ((element.data() as Map<String, dynamic>)
                    .containsKey('highestFinish'))
                  {
                    if (element.get('highestFinish') > bestCheckoutScore)
                      {
                        bestCheckoutScore = element.get('highestFinish'),
                      }
                  },

                //legs
                if ((element.data() as Map<String, dynamic>)
                    .containsKey('thrownDartsPerLeg'))
                  {
                    for (int thrownDarts
                        in element.get('thrownDartsPerLeg').values)
                      {
                        countOfAllDarts += thrownDarts,
                      }
                  },
                if ((element.data() as Map<String, dynamic>)
                    .containsKey('bestLeg'))
                  {
                    if (element.get('bestLeg') < bestLeg || bestLeg == -1)
                      {
                        bestLeg = element.get('bestLeg'),
                      }
                  },
                if ((element.data() as Map<String, dynamic>)
                    .containsKey('worstLeg'))
                  {
                    if (element.get('worstLeg') > worstLeg)
                      {
                        worstLeg = element.get('worstLeg'),
                      }
                  },
                if ((element.data() as Map<String, dynamic>)
                    .containsKey('dartsForWonLegCount'))
                  {
                    dartsForWonLegCount +=
                        element.get('dartsForWonLegCount') as int,
                  },
                if ((element.data() as Map<String, dynamic>)
                    .containsKey('legsWonTotal'))
                  {
                    legsWonTotal += element.get('legsWonTotal') as int,
                  },

                //avg
                totalAvg += element.get('average'),
                if (element.get('average') > bestAvg)
                  {
                    bestAvg = element.get('average'),
                  },
                if (element.get('average') < worstAvg || worstAvg == -1)
                  {
                    worstAvg = element.get('average'),
                  },

                //first nine avg
                totalFirstNineAvg += element.get('firstNineAvg'),
                if (element.get('firstNineAvg') > bestFirstNineAvg)
                  {
                    bestFirstNineAvg = element.get('firstNineAvg'),
                  },
                if (element.get('firstNineAvg') < worstFirstNineAvg ||
                    worstFirstNineAvg == -1)
                  {
                    worstFirstNineAvg = element.get('firstNineAvg'),
                  },
                counter++,

                //180
                countOf180 += element.get('roundedScoresEven')['180'] as int,

                //rounded scores even
                _roundedScoresEven = element.get('roundedScoresEven'),
                for (String key in _roundedScoresEven.keys)
                  {
                    firestoreStats.roundedScoresEven[int.parse(key)] +=
                        _roundedScoresEven[key]
                  },

                //rounded scores odd
                _roundedScoresOdd = element.get('roundedScoresOdd'),
                for (String key in _roundedScoresOdd.keys)
                  {
                    firestoreStats.roundedScoresOdd[int.parse(key)] +=
                        _roundedScoresOdd[key]
                  },

                //precise scores
                _preciseScores = element.get('preciseScores'),
                for (String key in _preciseScores.keys)
                  {
                    if (firestoreStats.preciseScores
                        .containsKey(int.parse(key)))
                      {
                        firestoreStats.preciseScores[int.parse(key)] +=
                            _preciseScores[key],
                      }
                    else
                      {
                        firestoreStats.preciseScores[int.parse(key)] =
                            _preciseScores[key],
                      }
                  },

                //all scores per dart with count
                if ((element.data() as Map<String, dynamic>)
                    .containsKey('allScoresPerDartAsStringCount'))
                  {
                    _allScoresPerDartWithCount =
                        element.get('allScoresPerDartAsStringCount'),
                    for (String key in _allScoresPerDartWithCount.keys)
                      {
                        if (firestoreStats.allScoresPerDartAsStringCount
                            .containsKey(key))
                          {
                            firestoreStats.allScoresPerDartAsStringCount[key] +=
                                _allScoresPerDartWithCount[key],
                          }
                        else
                          {
                            firestoreStats.allScoresPerDartAsStringCount[key] =
                                _allScoresPerDartWithCount[key],
                          }
                      }
                  }
              },
            ),

            //calc & set values
            if (totalAvg > 0) firestoreStats.avg = totalAvg / counter,

            if (totalFirstNineAvg > 0)
              firestoreStats.firstNineAvg = totalFirstNineAvg / counter,

            if (checkoutQuoteCounter > 0)
              firestoreStats.checkoutQuoteAvg =
                  totalCheckoutQuoteAvg / checkoutQuoteCounter,

            if (totalCheckoutScoreAvg > 0)
              firestoreStats.checkoutScoreAvg =
                  totalCheckoutScoreAvg / checkoutScoreCounter,

            if (countOf180 > 0) firestoreStats.countOf180 = countOf180,

            if (countOfGamesWon > 0)
              firestoreStats.countOfGamesWon = countOfGamesWon,

            if (countOfAllDarts > 0)
              firestoreStats.countOfAllDarts = countOfAllDarts,

            if (legsWonTotal > 0)
              firestoreStats.dartsPerLegAvg =
                  dartsForWonLegCount / legsWonTotal,

            firestoreStats.bestAvg = bestAvg,
            firestoreStats.worstAvg = worstAvg,
            firestoreStats.bestFirstNineAvg = bestFirstNineAvg,
            firestoreStats.worstFirstNineAvg = worstFirstNineAvg,
            firestoreStats.bestCheckoutQuote = bestCheckoutQuote,
            firestoreStats.worstCheckoutQuote = worstCheckoutQuote,
            firestoreStats.bestCheckoutScore = bestCheckoutScore,
            firestoreStats.worstCheckoutScore = worstCheckoutScore,
            firestoreStats.bestLeg = bestLeg,
            firestoreStats.worstLeg = worstLeg,
            firestoreStats.countOf180 = countOf180,
            firestoreStats.countOfGamesWon = countOfGamesWon,
            firestoreStats.preciseScores =
                Utils.sortMapIntInt(firestoreStats.preciseScores),
            firestoreStats.allScoresPerDartAsStringCount =
                Utils.sortMapStringInt(
                    firestoreStats.allScoresPerDartAsStringCount),
          },
        );

    firestoreStats.avgBestWorstStatsLoaded = true;
    firestoreStats.notify();
  }

  Future<PlayerOrTeamGameStats?> getPlayerOrTeamGameStatisticById(
      String playerOrTeamGameStatsId,
      String mode,
      bool loadTeamGameStats) async {
    final CollectionReference collectionReference = _firestore.collection(
        loadTeamGameStats
            ? _getFirestoreTeamStatsPath()
            : _getFirestorePlayerStatsPath());
    PlayerOrTeamGameStats? result;

    await collectionReference
        .doc(playerOrTeamGameStatsId)
        .get()
        .then((value) => {
              if (mode == 'X01')
                {
                  result = PlayerOrTeamGameStats.fromMapX01(value.data()),
                }
              else if (mode == 'Cricket')
                {}
              else if (mode == 'Single training' || mode == 'Double training')
                {
                  result = PlayerOrTeamGameStats.fromMapSingleDoubleTraining(
                      value.data()),
                }
              else if (mode == 'Score training')
                {
                  result =
                      PlayerOrTeamGameStats.fromMapScoreTraining(value.data()),
                }
            });

    return result;
  }

  Future<void> getFilteredPlayerGameStatistics(
      String orderField, bool ascendingOrder, BuildContext context) async {
    const String currentPlayerName =
        //todo change
        //await context.read<AuthService>().getPlayer!.getName;
        'Strainski';
    final firestoreStats = context.read<StatsFirestoreX01_P>();
    final CollectionReference collectionReference =
        _firestore.collection(this._getFirestorePlayerStatsPath());
    final Query query = collectionReference
        .where('player.name', isEqualTo: currentPlayerName)
        .orderBy(orderField, descending: ascendingOrder);

    List<Game_P> temp = [];

    firestoreStats.resetOverallStats();
    firestoreStats.resetFilteredGames();

    await query.get().then((value) => {
          value.docs.forEach((element) async {
            final String currentGameId = element.get('gameId');

            //for overall values -> checkouts + thrown darts per leg
            if (orderField == 'highestFinish' || orderField == 'bestLeg') {
              final SplayTreeMap<String, int> checkouts =
                  SplayTreeMap<String, int>.from(element.get('checkouts'));
              final SplayTreeMap<String, int> thrownDartsPerLeg =
                  SplayTreeMap<String, int>.from(
                      element.get('thrownDartsPerLeg'));

              checkouts.entries.forEach((element) {
                firestoreStats.checkoutWithGameId
                    .add(new Tuple2(element.value, currentGameId));
              });
              checkouts.entries.forEach((element) {
                firestoreStats.thrownDartsWithGameId.add(
                    new Tuple2(thrownDartsPerLeg[element.key], currentGameId));
              });
            }

            for (Game_P game in firestoreStats.games) {
              if (game.getGameId == currentGameId) {
                temp.add(game);
                break;
              }
            }
          }),
        });

    firestoreStats.sortOverallStats(ascendingOrder);
    firestoreStats.filteredGames = temp;
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
    return 'users/' + _firebaseAuth.currentUser!.uid + '/playerGameStatistics';
  }

  String _getFirestoreTeamStatsPath() {
    return 'users/' + _firebaseAuth.currentUser!.uid + '/teamGameStatistics';
  }

  String _getFirestoreGamesPath() {
    return 'users/' + _firebaseAuth.currentUser!.uid + '/games';
  }
}
