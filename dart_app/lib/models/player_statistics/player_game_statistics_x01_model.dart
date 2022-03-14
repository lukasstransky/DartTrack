import 'dart:collection';

import 'package:dart_app/constants.dart';

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
  int _legsWon = 0;
  int _setsWon = 0;
  int _thrownDartsPerLeg = 0;
  int _checkoutCount =
      0; //counts the checkout possibilities -> for calculating checkout quote
  Map<String, List<num>> _allScoresPerLeg =
      {}; //"Leg 1" : 120, 140, 100 -> to calc best, worst leg & avg. darts per leg
  List<int> _checkouts = [];
  //0 -> for < 40
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
  }; //e.g. 140+ : 5
  Map<int, int> _preciseScores = {}; //e.g. 140 : 3
  List<int> _allScores = [];
  List<int> _allScoresPerDart =
      []; //for input method three darts -> to keep track of each thrown dart
  List<int> _allRemainingPoints =
      []; //all remainging points after each throw -> for reverting
  List<int> _legsCount =
      []; //only relevant for set mode -> if player finished set, save current legs count of each player in this list -> in order to revert a set

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

  get getThrownDartsPerLeg => this._thrownDartsPerLeg;
  set setThrownDartsPerLeg(int thrownDartsPerLeg) =>
      this._thrownDartsPerLeg = thrownDartsPerLeg;

  get getCheckoutCount => this._checkoutCount;
  set setCheckoutCount(int checkoutCount) =>
      this._checkoutCount = checkoutCount;

  get getCheckouts => this._checkouts;
  set setCheckouts(List<int> checkouts) => this._checkouts = checkouts;

  get getRoundedScores => this._roundedScores;
  set setRoundedScores(Map<int, int> roundedScores) =>
      this._roundedScores = roundedScores;

  get getAllScoresPerLeg => this._allScoresPerLeg;
  set setAllScoresPerLeg(Map<String, List<num>> allScoresPerLeg) =>
      this._allScoresPerLeg = allScoresPerLeg;

  get getAllScores => this._allScores;
  set setAllScores(List<int> allScores) => this._allScores = allScores;

  get getAllScoresPerDart => this._allScoresPerDart;
  set setAllScoresPerDart(List<int> allScoresPerDart) =>
      this._allScoresPerDart = allScoresPerDart;

  get getAllRemainingPoints => this._allRemainingPoints;
  set setAllRemainingPoints(List<int> allRemainingPoints) =>
      this._allRemainingPoints = allRemainingPoints;

  get getLegsCount => this._legsCount;
  set setLegsCount(List<int> legsCount) => this._legsCount = legsCount;

  PlayerGameStatisticsX01({
    player,
    mode,
    int? currentPoints,
  })  : this._currentPoints = currentPoints,
        super(player: player, mode: mode);

  //calc average based on total points and all scores length
  String getAverage() {
    if (getTotalPoints == 0 && getAllScores.length == 0) {
      return "-";
    }
    return (getTotalPoints / getAllScores.length).toStringAsFixed(2);
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
    if (getAllScores.length == 0) return "-";
    return (getFirstNineAverage / getFirstNineAverageCount).toStringAsFixed(2);
  }

  Map<int, int> getPreciseScoresSorted() {
    return new SplayTreeMap<int, int>.from(getPreciseScores,
        (a, b) => getPreciseScores[b] > getPreciseScores[a] ? 1 : -1);
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
