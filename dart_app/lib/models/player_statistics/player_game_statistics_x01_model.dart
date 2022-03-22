import 'dart:collection';

import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/game_x01_model.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import 'player_game_statistics_model.dart';
import 'dart:developer';

class PlayerGameStatisticsX01 extends PlayerGameStatistics {
  int? _currentPoints;
  int _totalPoints = 0; //for average
  int _startingPoints = 0; //for input method -> three darts
  int _pointsSelectedCount =
      0; //for input method -> three darts (to prevent user from entering more than 3 darts when spaming the keyboard)

  num _firstNineAverage = 0.0;
  num _firstNineAverageCount = 0;

  int _currentThrownDartsInLeg = 0;
  List<int> _thrownDartsPerLeg = [];

  int _legsWon = 0;
  int _setsWon = 0;
  SplayTreeMap<String, List<num>> _allScoresPerLeg = new SplayTreeMap();
  //"Leg 1" : 120, 140, 100 -> to calc best, worst leg & avg. darts per leg
  List<int> _legsCount =
      []; //only relevant for set mode -> if player finished set, save current legs count of each player in this list -> in order to revert a set

  List<int> _checkouts = [];
  int _checkoutCount =
      0; //counts the checkout possibilities -> for calculating checkout quote
  List<Tuple3<String, num, num>> _checkoutCountAtThrownDarts =
      []; //to revert checkout count -> saves the current leg, amount of checkout counts + the thrown darts at this moment

  Map<int, int> _roundedScores = {
    0: 0,
    40: 0,
    60: 0,
    80: 0,
    100: 0,
    120: 0,
    140: 0,
    160: 0,
    180: 0
  }; //e.g. 140+ : 5 (0 -> for < 40)
  Map<int, int> _preciseScores = {}; //e.g. 140 : 3
  List<int> _allScores = []; //for input method round
  List<int> _allScoresPerDart =
      []; //for input method three darts -> to keep track of each thrown dart
  Map<String, int> _allScoresPerDartAsStringCount =
      {}; //for input method three darts, saves scores like T20, D20 and not 60, 40 like _allScoresPerDart (needed for stats)
  List<String> _allScoresPerDartAsString =
      []; //only needed for reverting _allScoresPerDartAsStringCount

  List<int> _allRemainingPoints =
      []; //all remainging points after each throw -> for reverting
  List<List<String>> _allRemainingScoresPerDart =
      []; //for reverting -> input method three darts (e.g. 20 D15, 20 10 D20, D10)

  get getCurrentPoints => this._currentPoints;
  set setCurrentPoints(int currentPoints) =>
      this._currentPoints = currentPoints;

  get getTotalPoints => this._totalPoints;
  set setTotalPoints(int totalPoints) => this._totalPoints = totalPoints;

  get getStartingPoints => this._startingPoints;
  set setStartingPoints(int startingPoints) =>
      this._startingPoints = startingPoints;

  get getPointsSelectedCount => this._pointsSelectedCount;
  set setPointsSelectedCount(int pointsSelectedCount) =>
      this._pointsSelectedCount = pointsSelectedCount;

  get getFirstNineAverage {
    if (this._firstNineAverageCount == 0) {
      return 0;
    }
    return this._firstNineAverage;
  }

  set setFirstNineAverage(num firstNineAverage) =>
      this._firstNineAverage = firstNineAverage;

  get getFirstNineAverageCount => this._firstNineAverageCount;
  set setFirstNineAverageCount(num firstNineAverageCount) =>
      this._firstNineAverageCount = firstNineAverageCount;

  get getLegsWon => this._legsWon;
  set setLegsWon(int legsWon) => this._legsWon = legsWon;

  get getSetsWon => this._setsWon;
  set setSetsWon(int setsWon) => this._setsWon = setsWon;

  get getPreciseScores => this._preciseScores;
  set setPreciesScores(Map<int, int> preciseScores) =>
      this._preciseScores = preciseScores;

  get getCurrentThrownDartsInLeg => this._currentThrownDartsInLeg;
  set setCurrentThrownDartsInLeg(int thrownDartsPerLeg) =>
      this._currentThrownDartsInLeg = thrownDartsPerLeg;

  get getThrownDartsPerLeg => this._thrownDartsPerLeg;
  set setThrownDartsPerLeg(List<int> thrownDartsPerLeg) =>
      this._thrownDartsPerLeg = thrownDartsPerLeg;

  get getCheckoutCount => this._checkoutCount;
  set setCheckoutCount(int checkoutCount) =>
      this._checkoutCount = checkoutCount;

  get getCheckouts => this._checkouts;
  set setCheckouts(List<int> checkouts) => this._checkouts = checkouts;

  get getCheckoutCountAtThrownDarts => this._checkoutCountAtThrownDarts;
  set setCheckoutCountAtThrownDarts(
          List<Tuple3<String, num, num>> checkoutCountAtThrownDarts) =>
      this._checkoutCountAtThrownDarts = checkoutCountAtThrownDarts;

  get getRoundedScores => this._roundedScores;
  set setRoundedScores(Map<int, int> roundedScores) =>
      this._roundedScores = roundedScores;

  get getAllScoresPerLeg => this._allScoresPerLeg;
  set setAllScoresPerLeg(SplayTreeMap<String, List<num>> allScoresPerLeg) =>
      this._allScoresPerLeg = allScoresPerLeg;

  get getAllScores => this._allScores;
  set setAllScores(List<int> allScores) => this._allScores = allScores;

  get getAllScoresPerDart => this._allScoresPerDart;
  set setAllScoresPerDart(List<int> allScoresPerDart) =>
      this._allScoresPerDart = allScoresPerDart;

  get getAllScoresPerDartAsStringCount => this._allScoresPerDartAsStringCount;
  set setAllScoresPerDartAsStringCount(
          Map<String, int> allScoresPerDartAsString) =>
      this._allScoresPerDartAsStringCount = allScoresPerDartAsString;

  get getAllScoresPerDartAsString => this._allScoresPerDartAsString;
  set setAllScoresPerDartAsString(List<String> allScoresPerDartAsString) =>
      this._allScoresPerDartAsString = allScoresPerDartAsString;

  get getAllRemainingPoints => this._allRemainingPoints;
  set setAllRemainingPoints(List<int> allRemainingPoints) =>
      this._allRemainingPoints = allRemainingPoints;

  get getAllRemainingScoresPerDart => this._allRemainingScoresPerDart;
  set setAllRemainingScoresPerDart(
          List<List<String>> allRemainingScoresPerDart) =>
      this._allRemainingScoresPerDart = allRemainingScoresPerDart;

  get getLegsCount => this._legsCount;
  set setLegsCount(List<int> legsCount) => this._legsCount = legsCount;

  PlayerGameStatisticsX01({
    player,
    mode,
    int? currentPoints,
  })  : this._currentPoints = currentPoints,
        super(player: player, mode: mode);

  //calc average based on total points and all scores length
  String getAverage(GameX01 gameX01, PlayerGameStatisticsX01 stats) {
    int length =
        gameX01.getGameSettings.getInputMethod == InputMethod.ThreeDarts
            ? stats.getAllScoresPerDart.length
            : stats.getAllScores.length;

    if (getTotalPoints == 0 && length == 0) {
      return "-";
    }

    return ((getTotalPoints / length) * 3).toStringAsFixed(2);
  }

  String getLastThrow() {
    if (getAllScores.length == 0) {
      return "-";
    }
    return getAllScores[getAllScores.length - 1].toString();
  }

  int getHighestScore() {
    int result = 0;
    for (int score in getAllScores) {
      if (score > result) {
        result = score;
      }
    }
    return result;
  }

  int getHighestCheckout() {
    int result = 0;
    for (int checkOut in getCheckouts) {
      if (checkOut > result) {
        result = checkOut;
      }
    }
    return result;
  }

  //returns only those rounded scores (140+: 4) that are included in the list
  Map<int, int> getSpecificRoundedScores(List<int> specificRoundedScores) {
    Map<int, int> result = {};
    for (int score in specificRoundedScores) {
      int value = getRoundedScores[score];
      result[score] = value;
    }
    return result;
  }

  String getFinishWay() {
    if (getCurrentPoints != 0) {
      return finishWays[getCurrentPoints]![0];
    }
    return "";
  }

  bool checkoutPossible() {
    if (getCurrentPoints <= 170 && !bogeyNumbers.contains(getCurrentPoints)) {
      return true;
    }
    return false;
  }

  bool isBogeyNumber() {
    if (bogeyNumbers.contains(getCurrentPoints)) {
      return true;
    }
    return false;
  }

  String getFirstNinveAvg() {
    if (getAllScoresPerDart.length == 0) return "-";
    return ((getFirstNineAverage / getFirstNineAverageCount) * 3)
        .toStringAsFixed(2);
  }

  Map<int, int> getPreciseScoresSorted() {
    return new SplayTreeMap<int, int>.from(getPreciseScores,
        (a, b) => getPreciseScores[b] > getPreciseScores[a] ? 1 : -1);
  }

  Map<String, int> getAllScoresPerDartAsStringCountSorted() {
    return new SplayTreeMap<String, int>.from(
        getAllScoresPerDartAsStringCount,
        (a, b) => getAllScoresPerDartAsStringCount[b] >
                getAllScoresPerDartAsStringCount[a]
            ? 1
            : -1);
  }

  String getCheckoutQuoteInPercent() {
    if (getCheckoutCount == 0) {
      return "-";
    }
    return ((getLegsWon / getCheckoutCount) * 100).toStringAsFixed(2) + "%";
  }

  String getBestLeg(num pointsToWinLeg) {
    num bestLeg = 0;
    num currentPoints = 0;
    num countOfDarts = 0;
    getAllScoresPerLeg.values.forEach((scores) => {
          scores.forEach((score) => {
                currentPoints += score,
                countOfDarts += 3,
              }),
          //if leg is won by player -> otherwise best leg or worst leg should not be set
          if (currentPoints == pointsToWinLeg)
            {
              if (countOfDarts < bestLeg || bestLeg == 0)
                {
                  bestLeg = countOfDarts,
                }
            },
          currentPoints = 0,
          countOfDarts = 0,
        });

    if (bestLeg == 0) {
      return "-";
    }
    return bestLeg.toString();
  }

  String getWorstLeg(num pointsToWinLeg) {
    num worstLeg = 0;
    num currentPoints = 0;
    num countOfDarts = 0;
    getAllScoresPerLeg.values.forEach((scores) => {
          scores.forEach((score) => {
                currentPoints += score,
                countOfDarts += 3,
              }),
          //if leg is won by player -> otherwise best leg or worst leg should not be set
          if (currentPoints == pointsToWinLeg)
            {
              if (countOfDarts > worstLeg)
                {
                  worstLeg = countOfDarts,
                }
            },
          currentPoints = 0,
          countOfDarts = 0,
        });
    if (worstLeg == 0) {
      return "-";
    }
    return worstLeg.toString();
  }

  String getDartsPerLeg(num pointsToWinLeg) {
    num totalCountOfDarts = 0;
    num wonLegs = 0;
    num currentPoints = 0;
    num currentCountOfDarts = 0;

    getAllScoresPerLeg.values.forEach((scores) => {
          scores.forEach((score) => {
                currentPoints += score,
                currentCountOfDarts += 3,
              }),
          if (currentPoints == pointsToWinLeg)
            {
              totalCountOfDarts += currentCountOfDarts,
              wonLegs += 1,
            },
          currentPoints = 0,
          currentCountOfDarts = 0,
        });
    if (wonLegs == 0) {
      return "-";
    }
    return (totalCountOfDarts / wonLegs).toString();
  }
}
