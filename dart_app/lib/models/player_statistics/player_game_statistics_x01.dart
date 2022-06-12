import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/models/player_statistics/player_game_statistics.dart';

import 'dart:collection';
import 'package:dart_app/constants.dart';
import 'package:tuple/tuple.dart';
import 'dart:developer';

class PlayerGameStatisticsX01 extends PlayerGameStatistics {
  int? _currentPoints;
  int _totalPoints = 0; //for average
  int _startingPoints = 0; //for input method -> three darts
  int _pointsSelectedCount =
      0; //for input method -> three darts (to prevent user from entering more than 3 darts when spaming the keyboard)

  num _firstNineAverage = 0.0;
  num _firstNineAverageCountRound = 0;
  num _firstNineAverageCountThreeDarts = 0;

  int _currentThrownDartsInLeg = 0;
  Map<String, int> _thrownDartsPerLeg = {};
  num _dartsForWonLegCount =
      0; //for statistics screen -> average darts for leg needed (count only won legs)

  bool _gameWon = false;
  int _legsWon = 0;
  num _legsWonTotal = 0; //for statistics screen (only for set mode)
  int _setsWon = 0;
  SplayTreeMap<String, List<num>> _allScoresPerLeg = new SplayTreeMap();
  //"Leg 1" : 120, 140, 100 -> to calc best, worst leg & avg. darts per leg
  List<int> _legsCount =
      []; //only relevant for set mode -> if player finished set, save current legs count of each player in this list -> in order to revert a set

  Map<String, int> _checkouts = {};
  int _checkoutCount =
      0; //counts the checkout possibilities -> for calculating checkout quote
  List<Tuple3<String, num, num>> _checkoutCountAtThrownDarts =
      []; //to revert checkout count -> saves the current leg, amount of checkout counts + the thrown darts at this moment

  Map<int, int> _roundedScoresEven = {
    0: 0,
    20: 0,
    40: 0,
    60: 0,
    80: 0,
    100: 0,
    120: 0,
    140: 0,
    160: 0,
    180: 0
  }; //e.g. 140+ : 5 (0 -> for < 40)
  Map<int, int> _roundedScoresOdd = {
    10: 0,
    30: 0,
    50: 0,
    70: 0,
    90: 0,
    110: 0,
    130: 0,
    150: 0,
    170: 0
  };
  Map<int, int> _preciseScores = {}; //e.g. 140 : 3
  List<int> _allScores = []; //for input method round
  num _allScoresCountForRound =
      0; //for average (when switching between round & three darts)
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

  PlayerGameStatisticsX01.firestore({
    required String gameId,
    required DateTime dateTime,
    required String mode,
    required Player player,
    required num firstNineAvg,
    required int legsWon,
    required int setsWon,
    required bool gameWon,
    required Map<String, int> checkouts,
    required int checkoutCount,
    required Map<String, int> roundedScoresEven,
    required Map<String, int> roundedScoresOdd,
    required Map<String, int> preciseScores,
    required List<int> allScores,
    required List<int> allScoresPerDart,
    required Map<String, int> allScoresPerDartAsStringCount,
    required Map<String, int> thrownDartsPerLeg,
    required int allScoresCountForRound,
    required int totalPoints,
    required SplayTreeMap<String, List<dynamic>> allScoresPerLeg,
    required num legsWonTotal,
    required num dartsForWonLegCount,
  }) : super(gameId: gameId, dateTime: dateTime, mode: mode, player: player) {
    this._firstNineAverage = firstNineAvg;
    this._legsWon = legsWon;
    this._setsWon = setsWon;
    this._gameWon = gameWon;
    this._checkouts = checkouts;
    this._checkoutCount = checkoutCount;
    this._roundedScoresEven =
        roundedScoresEven.map((key, value) => MapEntry(int.parse(key), value));
    this._roundedScoresOdd =
        roundedScoresOdd.map((key, value) => MapEntry(int.parse(key), value));
    this._preciseScores =
        preciseScores.map((key, value) => MapEntry(int.parse(key), value));
    this._allScores = allScores;
    this._allScoresPerDart = allScoresPerDart;
    this._allScoresPerDartAsStringCount = allScoresPerDartAsStringCount;
    this._thrownDartsPerLeg = thrownDartsPerLeg;
    this._allScoresCountForRound = allScoresCountForRound;
    this._totalPoints = totalPoints;
    this._allScoresPerLeg = SplayTreeMap.from(
        allScoresPerLeg.map((key, value) => MapEntry(key, value.cast<num>())));
    this._legsWonTotal = legsWonTotal;
    this._dartsForWonLegCount = dartsForWonLegCount;
  }

  PlayerGameStatisticsX01({player, mode, int? currentPoints, dateTime})
      : this._currentPoints = currentPoints,
        super(gameId: "", player: player, mode: mode, dateTime: dateTime);

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

  get getFirstNineAverage => this._firstNineAverage;

  set setFirstNineAverage(num firstNineAverage) =>
      this._firstNineAverage = firstNineAverage;

  get getFirstNineAverageCountRound => this._firstNineAverageCountRound;
  set setFirstNineAverageCountRound(num firstNineAverageCountRound) =>
      this._firstNineAverageCountRound = firstNineAverageCountRound;

  get getFirstNineAverageCountThreeDarts =>
      this._firstNineAverageCountThreeDarts;
  set setFirstNineAverageCountThreeDarts(num firstNineAverageCountThreeDarts) =>
      this._firstNineAverageCountThreeDarts = firstNineAverageCountThreeDarts;

  get getGameWon => this._gameWon;
  set setGameWon(bool gameWon) => this._gameWon = gameWon;

  get getLegsWon => this._legsWon;
  set setLegsWon(int legsWon) => this._legsWon = legsWon;

  get getLegsWonTotal => this._legsWonTotal;
  set setLegsWonTotal(num legsWonTotal) => this._legsWonTotal = legsWonTotal;

  get getSetsWon => this._setsWon;
  set setSetsWon(int setsWon) => this._setsWon = setsWon;

  get getPreciseScores => this._preciseScores;
  set setPreciesScores(Map<int, int> preciseScores) =>
      this._preciseScores = preciseScores;

  get getCurrentThrownDartsInLeg => this._currentThrownDartsInLeg;
  set setCurrentThrownDartsInLeg(int thrownDartsPerLeg) =>
      this._currentThrownDartsInLeg = thrownDartsPerLeg;

  get getThrownDartsPerLeg => this._thrownDartsPerLeg;
  set setThrownDartsPerLeg(Map<String, int> thrownDartsPerLeg) =>
      this._thrownDartsPerLeg = thrownDartsPerLeg;

  get getDartsForWonLegCount => this._dartsForWonLegCount;
  set setDartsForWonLegCount(num dartsForWonLegCount) =>
      this._dartsForWonLegCount = dartsForWonLegCount;

  get getCheckoutCount => this._checkoutCount;
  set setCheckoutCount(int checkoutCount) =>
      this._checkoutCount = checkoutCount;

  get getCheckouts => this._checkouts;
  set setCheckouts(Map<String, int> checkouts) => this._checkouts = checkouts;

  get getCheckoutCountAtThrownDarts => this._checkoutCountAtThrownDarts;
  set setCheckoutCountAtThrownDarts(
          List<Tuple3<String, num, num>> checkoutCountAtThrownDarts) =>
      this._checkoutCountAtThrownDarts = checkoutCountAtThrownDarts;

  get getRoundedScoresEven => this._roundedScoresEven;
  set setRoundedScoresEven(Map<int, int> roundedScoresEven) =>
      this._roundedScoresEven = roundedScoresEven;

  get getRoundedScoresOdd => this._roundedScoresOdd;
  set setRoundedScoresOdd(Map<int, int> roundedScoresOdd) =>
      this._roundedScoresOdd = roundedScoresOdd;

  get getAllScoresPerLeg => this._allScoresPerLeg;
  set setAllScoresPerLeg(SplayTreeMap<String, List<num>> allScoresPerLeg) =>
      this._allScoresPerLeg = allScoresPerLeg;

  get getAllScores => this._allScores;
  set setAllScores(List<int> allScores) => this._allScores = allScores;

  get getAllScoresCountForRound => this._allScoresCountForRound;
  set setAllScoresCountForRound(num allScoresCountForRound) =>
      this._allScoresCountForRound = allScoresCountForRound;

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

  //calc average based on total points and all scores length
  String getAverage(Game game, PlayerGameStatisticsX01 stats) {
    if (getTotalPoints == 0 && getAllScores.length == 0) {
      return "-";
    }

    num length, multiplicator;
    if (game.getGameSettings.getInputMethod == InputMethod.ThreeDarts) {
      length = stats.getAllScoresPerDart.length;
      if (getAllScoresCountForRound > 0) {
        length += getAllScoresCountForRound * 3;
      }
      multiplicator = 3;
    } else {
      if (getAllScoresCountForRound == 0 &&
          stats.getAllScoresPerDart.length == 0) {
        length = 1;
      } else {
        length = getAllScoresCountForRound;
      }
      if (stats.getAllScoresPerDart.length > 0) {
        length += stats.getAllScoresPerDart.length / 3;
      }

      multiplicator = 1;
    }

    return ((getTotalPoints / length) * multiplicator).toStringAsFixed(2);
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
    for (int checkOut in getCheckouts.values) {
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
      int value = getRoundedScoresEven[score];
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

  String getFirstNinveAvg(Game? gameX01) {
    if (getAllScores.length == 0 && getAllScoresPerDart.length == 0) {
      return "-";
    }

    num multiplicator, totalCount;
    num countRound = getFirstNineAverageCountRound;
    num countThreeDarts = getFirstNineAverageCountThreeDarts;
    if (gameX01!.getGameSettings.getInputMethod == InputMethod.Round) {
      multiplicator = 1;
      totalCount = countRound;
      if (countThreeDarts >= 3) {
        totalCount += countThreeDarts / 3;
      }
    } else {
      multiplicator = 3;
      totalCount = countThreeDarts;
      if (countRound >= 1) {
        totalCount += countRound * 3;
      }
    }

    return ((getFirstNineAverage / totalCount) * multiplicator)
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

  String getBestLeg() {
    if (getLegsWonTotal == 0) {
      return "-";
    }
    int bestLeg = -1;

    _thrownDartsPerLeg.values.forEach((element) {
      if (element > bestLeg) {
        bestLeg = element;
      }
    });

    return bestLeg.toString();
  }

  String getWorstLeg() {
    if (getLegsWonTotal == 0) {
      return "-";
    }
    int worstLeg = -1;

    _thrownDartsPerLeg.values.forEach((element) {
      if (element < worstLeg || worstLeg == -1) {
        worstLeg = element;
      }
    });

    return worstLeg.toString();
  }

  String getDartsPerLeg() {
    if (getLegsWonTotal == 0) {
      return "-";
    }

    int dartsPerLeg = 0;
    int games = 0;

    _checkouts.keys.forEach((key) {
      dartsPerLeg += _thrownDartsPerLeg[key] as int;
      games++;
    });

    return (dartsPerLeg / games).toString();
  }

  Map<String, int> getPreciseScoresWithStringKey() {
    Map<String, int> result = {};
    for (var entry in getPreciseScores.entries) {
      result[entry.key.toString()] = entry.value;
    }
    return result;
  }

  Map<String, int> getRoundedScoresEvenWithStringKey() {
    Map<String, int> result = {};
    for (var entry in getRoundedScoresEven.entries) {
      result[entry.key.toString()] = entry.value;
    }
    return result;
  }

  Map<String, int> getRoundedScoresOddWithStringKey() {
    Map<String, int> result = {};
    for (var entry in getRoundedScoresOdd.entries) {
      result[entry.key.toString()] = entry.value;
    }
    return result;
  }
}
