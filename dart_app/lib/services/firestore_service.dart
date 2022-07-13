import 'dart:collection';

import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/models/games/game_x01.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_app/models/open_games_firestore.dart';
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
        gameSettings: gameX01.getGameSettings,
        playerGameStatistics: []);

    String gameId = "";
    await _firestore
        .collection("users/" + _firebaseAuth.currentUser!.uid + "/games")
        .add(gameToSave.toMapX01(gameX01, false))
        .then((value) => {
              gameId = value.id,
            });
    return gameId;
  }

  Future<void> postOpenGame(GameX01 gameX01, BuildContext context) async {
    Game gameToSave = Game.firestore(
        gameId: gameX01.getGameId,
        name: gameX01.getName,
        dateTime: gameX01.getDateTime,
        gameSettings: gameX01.getGameSettings,
        playerGameStatistics: gameX01.getPlayerGameStatistics,
        currentPlayerToThrow: gameX01.getCurrentPlayerToThrow);

    final openGamesFirestore =
        Provider.of<OpenGamesFirestore>(context, listen: false);
    for (Game openGame in openGamesFirestore.openGames) {
      if (openGame.getGameId == gameX01.getGameId) {
        await deleteOpenGame(gameX01.getGameId, context);
      }
    }

    await _firestore
        .collection("users/" + _firebaseAuth.currentUser!.uid + "/openGames")
        .add(gameToSave.toMapX01(gameX01, true))
        .then((value) async => {
              await _firestore
                  .collection(
                      "users/" + _firebaseAuth.currentUser!.uid + "/openGames")
                  .doc(value.id)
                  .update({"gameId": value.id})
            });
  }

  Future<void> deleteOpenGame(String gameId, BuildContext context) async {
    await _firestore
        .collection("users/" + _firebaseAuth.currentUser!.uid + "/openGames")
        .doc(gameId)
        .delete()
        .then((value) async => {
              await getOpenGames(context),
            });
  }

  Future<void> getOpenGames(BuildContext context) async {
    CollectionReference collectionReference = _firestore
        .collection("users/" + _firebaseAuth.currentUser!.uid + "/openGames");
    final openGamesFirestore =
        Provider.of<OpenGamesFirestore>(context, listen: false);
    openGamesFirestore.reset();

    await collectionReference.get().then((openGames) => {
          openGames.docs.forEach((openGame) {
            String mode = "";
            if ((openGame.data() as Map<String, dynamic>)
                .containsValue("X01")) {
              mode = "X01";
            } else if ((openGame.data() as Map<String, dynamic>)
                .containsValue("Cricket")) {
              mode = "Cricket";
            }

            Game game = Game.fromMap(openGame.data(), mode, openGame.id, true);

            openGamesFirestore.openGames.add(game);
            openGamesFirestore.notify();
          })
        });
    openGamesFirestore.init = true;
    openGamesFirestore.notify();
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
          .add(playerGameStatisticsToSave.toMapX01(
              stats, gameX01, gameId, false))
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
        "test";
    final firestoreStats =
        Provider.of<StatisticsFirestoreX01>(context, listen: false);
    firestoreStats.resetValues();

    double avg = 0;
    double bestAvg = -1;
    double worstAvg = -1;

    double firstNineAvg = 0;
    double bestFirstNineAvg = -1;
    double worstFirstNineAvg = -1;
    int counter = 0;

    double checkoutQuoteAvg = 0;
    double bestCheckoutQuote = -1;
    double worstCheckoutQuote = -1;
    int checkoutQuoteCounter = 0;

    double checkoutScoreAvg = 0;
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

    CollectionReference collectionReference = _firestore.collection(
        "users/" + _firebaseAuth.currentUser!.uid + "/playerGameStatistics");
    Query query =
        collectionReference.where("player.name", isEqualTo: currentPlayerName);

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
                    for (int checkoutScore in element.get("checkouts").values)
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
                    dartsForWonLegCount +=
                        element.get("dartsForWonLegCount") as int,
                  },
                if ((element.data() as Map<String, dynamic>)
                    .containsKey("legsWonTotal"))
                  {
                    legsWonTotal += element.get("legsWonTotal") as int,
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
                countOf180 += element.get("roundedScoresEven")["180"] as int,

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

  Future<void> getGames(String mode, BuildContext context) async {
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

    QuerySnapshot<Object?> games = await query.get();
    if (games.docs.isEmpty) {
      firestoreStats.noGamesPlayed = true;
      firestoreStats.notify();
    } else {
      firestoreStats.noGamesPlayed = false;
      games.docs.forEach((element) async {
        Game game = Game.fromMap(element.data(), mode, element.id, false);

        for (String playerGameStatsId
            in element.get("playerGameStatisticsIds")) {
          PlayerGameStatistics? playerGameStatistics =
              await getPlayerGameStatisticById(playerGameStatsId, mode);

          game.getPlayerGameStatistics.add(playerGameStatistics);
        }

        firestoreStats.games.add(game);
        firestoreStats.notify();
      });
    }
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
        .where("player.name", isEqualTo: currentPlayerName)
        .orderBy(orderField, descending: ascendingOrder);

    List<Game> temp = [];
    firestoreStats.resetOverallStats();
    firestoreStats.resetFilteredGames();

    await query.get().then((value) => {
          value.docs.forEach((element) async {
            String gameId = element.get("gameId");

            //for overall values -> checkouts + thrown darts per leg
            if (orderField == 'highestFinish' || orderField == 'bestLeg') {
              SplayTreeMap<String, int> checkouts =
                  SplayTreeMap<String, int>.from(element.get("checkouts"));
              SplayTreeMap<String, int> thrownDartsPerLeg =
                  SplayTreeMap<String, int>.from(
                      element.get("thrownDartsPerLeg"));

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
