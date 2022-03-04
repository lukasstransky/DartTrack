import 'dart:collection';

import 'package:dart_app/constants.dart';

import 'player_game_statistics_model.dart';
import 'dart:developer';

class PlayerGameStatisticsX01 extends PlayerGameStatistics {
  int? _currentPoints;
  int _totalPoints = 0; //for average
  num _firstNineAverage = 0.0;
  num _firstNineAverageCount = 0;
  int _legsWon = 0;
  int _setsWon = 0;
  int _bestLeg = 0;
  int _worstLeg = 0;
  int _thrownDartsPerLeg = 0;
  double _checkoutQuote = 0.0;
  int _checkoutCount =
      0; //counts the checkout possibilities -> for calculating checkout quote
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
  List<int> _allRemainingPoints =
      []; //all remainging points after each throw -> for reverting
  List<int> _legsCount =
      []; //only relevant for set mode -> if player finished set, save current legs count of each player in this list -> in order to revert a set

  get getCurrentPoints => this._currentPoints;
  set setCurrentPoints(int currentPoints) =>
      this._currentPoints = currentPoints;

  get getTotalPoints => this._totalPoints;
  set setTotalPoints(int totalPoints) => this._totalPoints = totalPoints;

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

  get getBestLeg => this._bestLeg;
  set setBestLeg(int bestLeg) => this._bestLeg = bestLeg;

  get getWorstLeg => this._worstLeg;
  set setWorstLeg(int worstLeg) => this._worstLeg = worstLeg;

  get getThrownDartsPerLeg => this._thrownDartsPerLeg;
  set setThrownDartsPerLeg(int thrownDartsPerLeg) =>
      this._thrownDartsPerLeg = thrownDartsPerLeg;

  get getCheckoutQuote => this._checkoutQuote;
  set setCheckoutQuote(double checkoutQuote) =>
      this._checkoutQuote = checkoutQuote;

  get getCheckoutCount => this._checkoutCount;
  set setCheckoutCount(int checkoutCount) =>
      this._checkoutCount = checkoutCount;

  get getCheckouts => this._checkouts;
  set setCheckouts(List<int> checkouts) => this._checkouts = checkouts;

  get getRoundedScores => this._roundedScores;
  set setRoundedScores(Map<int, int> roundedScores) =>
      this._roundedScores = roundedScores;

  get getPreciseScores => this._preciseScores;
  set setPreciesScores(Map<int, int> preciseScores) =>
      this._preciseScores = preciseScores;

  get getAllScores => this._allScores;
  set setAllScores(List<int> allScores) => this._allScores = allScores;

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
    if (getTotalPoints == 0 || getAllScores.length == 0) {
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
    return finishWays[getCurrentPoints]![0];
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
    if (getFirstNineAverage == 0.0) return "-";
    return (getFirstNineAverage / getFirstNineAverageCount).toStringAsFixed(2);
  }

  Map<int, int> getPreciseScoresSorted() {
    return new SplayTreeMap<int, int>.from(getPreciseScores,
        (a, b) => getPreciseScores[b] > getPreciseScores[a] ? 1 : -1);
  }
}
