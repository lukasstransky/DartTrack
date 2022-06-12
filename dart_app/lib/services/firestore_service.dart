import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/models/games/game_x01.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_app/models/player_statistics/player_game_statistics.dart';
import 'package:dart_app/models/player_statistics/player_game_statistics_x01.dart';
import 'package:dart_app/models/statistics_firestore_x01.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

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

  Future<void> postOpenGame(GameX01 gameX01) async {
    Game gameToSave = Game.firestore(
        name: gameX01.getName,
        dateTime: gameX01.getDateTime,
        gameSettings: gameX01.getGameSettings,
        playerGameStatistics: gameX01.getPlayerGameStatistics);

    await _firestore
        .collection("users/" + _firebaseAuth.currentUser!.uid + "/openGames")
        .add(gameToSave.toMapX01());
  }

  Future<void> postPlayerGameStatistics(
      GameX01 gameX01, String gameId, BuildContext context) async {
    List<String> playerGameStatsIds = [];

    for (PlayerGameStatisticsX01 stats in gameX01.getPlayerGameStatistics) {
      PlayerGameStatistics playerGameStatisticsToSave = PlayerGameStatistics(
          gameId: "",
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
    }

    //set playerGameStatsIds + gameId for game
    await _firestore
        .collection("users/" + _firebaseAuth.currentUser!.uid + "/games")
        .doc(gameId)
        .update(
            {"playerGameStatisticsIds": playerGameStatsIds, "gameId": gameId});
  }

  Future<void> getStatistics(BuildContext context) async {
    //todo comment out
    final String currentPlayerName =
        //await context.read<AuthService>().getPlayer!.getName;
        "Strainski";
    final firestoreStats =
        Provider.of<StatisticsFirestoreX01>(context, listen: false);
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

    num countOfAllDarts = 0;
    num bestLeg = -1;
    num worstLeg = -1;
    num dartsForWonLegCount = 0;
    num legsWonTotal = 0;

    num countOf180 = 0;
    num countOfGamesWon = 0;

    Map<String, dynamic> _roundedScoresEven = {};
    Map<String, dynamic> _roundedScoresOdd = {};
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
                    for (num checkoutScore in element.get("checkouts").values)
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
                    for (int thrownDarts
                        in element.get("thrownDartsPerLeg").values)
                      {
                        countOfAllDarts += thrownDarts,
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
                if ((element.data() as Map<String, dynamic>)
                    .containsKey("dartsForWonLegCount"))
                  {
                    dartsForWonLegCount += element.get("dartsForWonLegCount"),
                  },
                if ((element.data() as Map<String, dynamic>)
                    .containsKey("legsWonTotal"))
                  {
                    legsWonTotal += element.get("legsWonTotal"),
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

                //180
                countOf180 += element.get("roundedScoresEven")["180"],

                //rounded scores even
                _roundedScoresEven = element.get("roundedScoresEven"),
                for (String key in _roundedScoresEven.keys)
                  {
                    firestoreStats.roundedScoresEven[int.parse(key)] +=
                        _roundedScoresEven[key]
                  },

                //rounded scores odd
                _roundedScoresOdd = element.get("roundedScoresOdd"),
                for (String key in _roundedScoresOdd.keys)
                  {
                    firestoreStats.roundedScoresOdd[int.parse(key)] +=
                        _roundedScoresOdd[key]
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
            if (legsWonTotal > 0)
              {
                firestoreStats.dartsPerLegAvg =
                    dartsForWonLegCount / legsWonTotal,
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
          },
        );
    firestoreStats.avgBestWorstStatsLoaded = true;
    firestoreStats.notify();
  }

  Future<PlayerGameStatistics?> getPlayerGameStatisticById(
      String playerGameStatsId, String mode) async {
    PlayerGameStatistics? result;
    CollectionReference collectionReference = _firestore.collection(
        "users/" + _firebaseAuth.currentUser!.uid + "/playerGameStatistics");

    await collectionReference.doc(playerGameStatsId).get().then((value) => {
          if (mode == "X01")
            {
              result = PlayerGameStatistics.fromMapX01(value.data()),
            },
        });
    return result;
  }

  Future<bool> getGames(String mode, BuildContext context) async {
    late dynamic firestoreStats;
    switch (mode) {
      case "X01":
        firestoreStats =
            Provider.of<StatisticsFirestoreX01>(context, listen: false);
      //add other modes
    }

    CollectionReference collectionReference = _firestore
        .collection("users/" + _firebaseAuth.currentUser!.uid + "/games");
    Query query = collectionReference.where("name", isEqualTo: mode);

    firestoreStats.resetGames();

    QuerySnapshot<Object?> test = await query.get();
    if (test.docs.isEmpty) {
      firestoreStats.noGamesPlayed = true;
    } else {
      firestoreStats.noGamesPlayed = false;
    }
    test.docs.forEach((element) async {
      Game game = Game.fromMap(element.data(), mode, element.id);

      for (String playerGameStatsId in element.get("playerGameStatisticsIds")) {
        PlayerGameStatistics? playerGameStatistics =
            await getPlayerGameStatisticById(playerGameStatsId, mode);

        game.getPlayerGameStatistics.add(playerGameStatistics);
      }

      firestoreStats.games.add(game);
      firestoreStats.notify();
    });

    return true;
  }

  Future<void> getFilteredPlayerGameStatistics(
      String orderField, bool ascendingOrder, BuildContext context) async {
    final firestoreStats =
        Provider.of<StatisticsFirestoreX01>(context, listen: false);
    final String currentPlayerName =
        //await context.read<AuthService>().getPlayer!.getName;
        "Strainski";

    CollectionReference collectionReference = _firestore.collection(
        "users/" + _firebaseAuth.currentUser!.uid + "/playerGameStatistics");
    Query query = collectionReference
        .where("player", isEqualTo: currentPlayerName)
        .orderBy(orderField, descending: ascendingOrder);

    List<Game> temp = [];
    firestoreStats.resetOverallStats();
    firestoreStats.resetFilteredGames();

    await query.get().then((value) => {
          value.docs.forEach((element) async {
            String gameId = element.get("gameId");

            //for overall values -> checkouts + thrown darts per leg
            if (orderField == 'highestFinish' || orderField == 'bestLeg') {
              Map<String, int> checkouts =
                  Map<String, int>.from(element.get("checkouts"));
              Map<String, int> thrownDartsPerLeg =
                  Map<String, int>.from(element.get("thrownDartsPerLeg"));

              checkouts.entries.forEach((element) {
                firestoreStats.checkoutWithGameId
                    .add(new Tuple2(element.value, gameId));
              });
              checkouts.entries.forEach((element) {
                firestoreStats.thrownDartsWithGameId
                    .add(new Tuple2(thrownDartsPerLeg[element.key], gameId));
              });
            }

            for (Game game in firestoreStats.games) {
              for (PlayerGameStatistics playerGameStatistics
                  in game.getPlayerGameStatistics) {
                if (playerGameStatistics.getGameId == gameId) {
                  temp.add(game);
                  break;
                }
              }
            }
          }),
        });
    firestoreStats.sortOverallStats(ascendingOrder);
    firestoreStats.filteredGames = temp;
    firestoreStats.notify();
  }
}
