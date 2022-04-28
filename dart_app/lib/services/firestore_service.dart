import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/models/games/game_x01.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_app/models/player_statistics/player_game_statistics.dart';
import 'package:dart_app/models/player_statistics/player_game_statistics_x01.dart';
import 'package:dart_app/models/statistics_firestore.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  Future<void> postPlayerGameStatistics(
      GameX01 gameX01, String gameId, BuildContext context) async {
    List<String> playerGameStatsIds = [];

    for (PlayerGameStatisticsX01 stats in gameX01.getPlayerGameStatistics) {
      PlayerGameStatistics playerGameStatisticsToSave = PlayerGameStatistics(
          player: stats.getPlayer,
          mode: stats.getMode,
          dateTime: stats.getDateTime);

      //add playerGameStats
      await _firestore
          .collection("users/" +
              _firebaseAuth.currentUser!.uid +
              "/playerGameStatistics")
          .add(playerGameStatisticsToSave.toMapX01(stats, gameX01, gameId))
          .then((value) => {
                playerGameStatsIds.add(value.id),
              });
      /*
      //add/update 'statistics' collection
      final String currentPlayerName =
          await context.read<AuthService>().getPlayer!.getName;
      //only update 'statistics' of current logged in player
      if (stats.getPlayer.getName == currentPlayerName) {
        StatisticsFirestore statisticsFirestore;

        await _firestore
            .collection(
                "users/" + _firebaseAuth.currentUser!.uid + "/statistics")
            .get()
            .then(
              (result) => {
                //update
                if (result.size > 0)
                  {
                    //fetch statistics
                    _firestore
                        .collection("users/" +
                            _firebaseAuth.currentUser!.uid +
                            "/statistics")
                        .doc(result.docs.first.id)
                        .get()
                        .then(
                          (value) => {
                            //get 'statistics'
                            statisticsFirestore =
                                StatisticsFirestore.fromMap(value.data()),

                            //set count of games
                            statisticsFirestore.setCountOfGames =
                                statisticsFirestore.getCountOfGames + 1,
                            //set average
                            statisticsFirestore.setAverage = num.parse(
                                ((statisticsFirestore.getAverage +
                                            num.parse(stats.getAverage(
                                                gameX01, stats))) /
                                        statisticsFirestore.getCountOfGames)
                                    .toStringAsFixed(2)),

                            //update
                            _firestore
                                .collection("users/" +
                                    _firebaseAuth.currentUser!.uid +
                                    "/statistics")
                                .doc(result.docs.first.id)
                                .set(statisticsFirestore.toMap()),
                          },
                        ),
                  }
                //add
                else
                  {
                    statisticsFirestore = new StatisticsFirestore(
                        average: num.parse(stats.getAverage(gameX01, stats)),
                        countOfGames: 1),

                    //add to firestore
                    _firestore
                        .collection("users/" +
                            _firebaseAuth.currentUser!.uid +
                            "/statistics")
                        .add(statisticsFirestore.toMap()),
                  }
              },
            );
      }*/
    }

    //set playerGameStatsIds for game
    await _firestore
        .collection("users/" + _firebaseAuth.currentUser!.uid + "/games")
        .doc(gameId)
        .update({"playerGameStatisticsIds": playerGameStatsIds});
  }

  Future<void> getStatistics(BuildContext context) async {
    final String currentPlayerName =
        //await context.read<AuthService>().getPlayer!.getName;
        "Strainski";
    final firestoreStats =
        Provider.of<StatisticsFirestore>(context, listen: false);
    firestoreStats.resetValues();

    num avg = 0;
    num bestAvg = -1;
    num worstAvg = -1;

    num firstNineAvg = 0;
    num bestFirstNineAvg = -1;
    num worstFirstNineAvg = -1;
    num counter = 0;

    num checkoutQuoteAvg = 0;
    num bestCheckoutQuote = -1;
    num worstCheckoutQuote = -1;
    num checkoutQuoteCounter = 0;

    num checkoutScoreAvg = 0;
    num bestCheckoutScore = -1;
    num worstCheckoutScore = -1;
    num checkoutScoreCounter = 0;

    num dartsPerLeg = 0;
    num dartsPerLegCounter = 0;
    num countOfAllDarts = 0;
    List<int> thrownDartsPerLeg = [];
    num bestLeg = -1;
    num worstLeg = -1;

    num countOf180 = 0;
    num countOfGamesWon = 0;

    Map<String, dynamic> _roundedScores = {};
    Map<String, dynamic> _preciseScores = {};
    Map<String, dynamic> _allScoresPerDartWithCount = {};

    CollectionReference collectionReference = _firestore.collection(
        "users/" + _firebaseAuth.currentUser!.uid + "/playerGameStatistics");
    Query query =
        collectionReference.where("player", isEqualTo: currentPlayerName);

    if (firestoreStats.currentFilterValue == FilterValue.Year ||
        firestoreStats.currentFilterValue == FilterValue.Month) {
      query = query.where("dateTime",
          isGreaterThanOrEqualTo:
              firestoreStats.getDateTimeFromCurrentFilterValue());
    } else if (firestoreStats.currentFilterValue == FilterValue.Custom) {
      query = query.where("dateTime",
          isGreaterThanOrEqualTo: firestoreStats.getCustomStartDate());
      query = query.where("dateTime",
          isLessThanOrEqualTo: firestoreStats.getCustomEndDate());
    }

    await query.get().then(
          (value) => {
            value.docs.forEach(
              (element) => {
                //count of games
                firestoreStats.countOfGames = value.size,

                //count of games won
                if (element.get("gameWon") == true)
                  {
                    countOfGamesWon++,
                  },

                //checkout quote
                if ((element.data() as Map<String, dynamic>)
                    .containsKey("checkoutInPercent"))
                  {
                    checkoutQuoteAvg += element.get("checkoutInPercent"),
                    checkoutQuoteCounter++,
                    if (element.get("checkoutInPercent") > bestCheckoutQuote)
                      {
                        bestCheckoutQuote = element.get("checkoutInPercent"),
                      },
                    if (element.get("checkoutInPercent") < worstCheckoutQuote ||
                        worstCheckoutQuote == -1)
                      {
                        worstCheckoutQuote = element.get("checkoutInPercent"),
                      },
                  },

                //checkout score
                if ((element.data() as Map<String, dynamic>)
                    .containsKey("checkouts"))
                  {
                    for (num checkoutScore in element.get("checkouts"))
                      {
                        checkoutScoreAvg += checkoutScore,
                        checkoutScoreCounter++,
                        if (checkoutScore < worstCheckoutScore ||
                            worstCheckoutScore == -1)
                          {
                            worstCheckoutScore = checkoutScore,
                          }
                      }
                  },

                if ((element.data() as Map<String, dynamic>)
                    .containsKey("highestFinish"))
                  {
                    if (element.get("highestFinish") > bestCheckoutScore)
                      {
                        bestCheckoutScore = element.get("highestFinish"),
                      }
                  },

                //legs
                if ((element.data() as Map<String, dynamic>)
                    .containsKey("thrownDartsPerLeg"))
                  {
                    for (num thrownDarts in element.get("thrownDartsPerLeg"))
                      {
                        dartsPerLeg += thrownDarts,
                        dartsPerLegCounter++,
                      }
                  },
                if ((element.data() as Map<String, dynamic>)
                    .containsKey("bestLeg"))
                  {
                    if (element.get("bestLeg") < bestLeg || bestLeg == -1)
                      {
                        bestLeg = element.get("bestLeg"),
                      }
                  },
                if ((element.data() as Map<String, dynamic>)
                    .containsKey("worstLeg"))
                  {
                    if (element.get("worstLeg") > worstLeg)
                      {
                        worstLeg = element.get("worstLeg"),
                      }
                  },

                //avg
                avg += element.get("average"),
                if (element.get("average") > bestAvg)
                  {
                    bestAvg = element.get("average"),
                  },
                if (element.get("average") < worstAvg || worstAvg == -1)
                  {
                    worstAvg = element.get("average"),
                  },

                //first nine avg
                firstNineAvg += element.get("firstNineAverage"),
                if (element.get("firstNineAverage") > bestFirstNineAvg)
                  {
                    bestFirstNineAvg = element.get("firstNineAverage"),
                  },
                if (element.get("firstNineAverage") < worstFirstNineAvg ||
                    worstFirstNineAvg == -1)
                  {
                    worstFirstNineAvg = element.get("firstNineAverage"),
                  },
                counter++,

                //count of all darts thrown
                thrownDartsPerLeg =
                    List.castFrom(element.get("thrownDartsPerLeg") as List),
                thrownDartsPerLeg
                    .forEach((element) => {countOfAllDarts += element}),

                //180
                countOf180 += element.get("roundedScores")["180"],

                //rounded scores
                _roundedScores = element.get("roundedScores"),
                for (String key in _roundedScores.keys)
                  {
                    firestoreStats.roundedScores[int.parse(key)] +=
                        _roundedScores[key]
                  },

                //precise scores
                _preciseScores = element.get("preciseScores"),
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
                    .containsKey("allScoresPerDartWithCount"))
                  {
                    _allScoresPerDartWithCount =
                        element.get("allScoresPerDartWithCount"),
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
            if (avg > 0)
              {
                firestoreStats.avg = avg / counter,
              },
            if (firstNineAvg > 0)
              {
                firestoreStats.firstNineAvg = firstNineAvg / counter,
              },

            if (checkoutQuoteCounter > 0)
              {
                firestoreStats.checkoutQuoteAvg =
                    checkoutQuoteAvg / checkoutQuoteCounter,
              },
            if (checkoutScoreAvg > 0)
              {
                firestoreStats.checkoutScoreAvg =
                    checkoutScoreAvg / checkoutScoreCounter,
              },
            if (dartsPerLegCounter > 0)
              {
                firestoreStats.dartsPerLegAvg =
                    dartsPerLeg / dartsPerLegCounter,
              },
            if (countOf180 > 0)
              {
                firestoreStats.countOf180 = countOf180,
              },
            if (countOfGamesWon > 0)
              {
                firestoreStats.countOfGamesWon = countOfGamesWon,
              },
            if (countOfAllDarts > 0)
              {
                firestoreStats.countOfAllDarts = countOfAllDarts,
              },

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
            firestoreStats.setMostRoundedScores(),
          },
        );
    firestoreStats.notify();
  }

  Future<PlayerGameStatistics?> getPlayerGameStatistic(
      String playerGameStatsId) async {
    PlayerGameStatistics? result;
    CollectionReference collectionReference = _firestore.collection(
        "users/" + _firebaseAuth.currentUser!.uid + "/playerGameStatistics");

    await collectionReference.doc(playerGameStatsId).get().then((value) => {
          result = PlayerGameStatistics.fromMapX01(value.data()),
        });
    return result;
  }

  Future<void> getGames(String mode, BuildContext context) async {
    final firestoreStats =
        Provider.of<StatisticsFirestore>(context, listen: false);

    CollectionReference collectionReference = _firestore
        .collection("users/" + _firebaseAuth.currentUser!.uid + "/games");
    Query query = collectionReference
        .where("name", isEqualTo: mode)
        .orderBy("dateTime", descending: true);

    await query.get().then(
          (value) => {
            value.docs.forEach(
              (element) async {
                Game game = Game.fromMap(element.data());

                for (String playerGameStatsId
                    in element.get("playerGameStatisticsIds")) {
                  PlayerGameStatistics? playerGameStatistics =
                      await getPlayerGameStatistic(playerGameStatsId);
                  game.getPlayerGameStatistics.add(playerGameStatistics);
                }

                firestoreStats.games.add(game);
                firestoreStats.notify();
              },
            ),
          },
        );
  }
}
