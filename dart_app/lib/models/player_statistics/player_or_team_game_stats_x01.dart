import 'dart:math';

import 'package:dart_app/constants.dart';
import 'package:dart_app/models/bot.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats.dart';
import 'package:dart_app/models/team.dart';

import 'dart:collection';
import 'package:tuple/tuple.dart';

class PlayerOrTeamGameStatsX01 extends PlayerOrTeamGameStats
    implements Comparable<PlayerOrTeamGameStatsX01> {
  int _currentPoints = 0;
  int _totalPoints = 0; //for average
  int _pointsSelectedCount =
      0; //for input method -> three darts (to prevent user from entering more than 3 darts when spaming the keyboard)

  int _firstNineAvgPoints = 0;
  int _firstNineAvgCount = 0;

  int _currentThrownDartsInLeg = 0;
  int _allThrownDarts = 0; //for calculating averages
  SplayTreeMap<String, int> _thrownDartsPerLeg = new SplayTreeMap();
  int _dartsForWonLegCount =
      0; //for statistics screen -> average darts for leg needed (count only won legs)

  bool _gameDraw = false;
  bool _gameWon = false;
  int _legsWon = 0;
  int _legsWonTotal = 0; //for statistics screen (only for set mode)
  int _setsWon = 0;
  SplayTreeMap<String, List<int>> _allScoresPerLeg = new SplayTreeMap();
  //"Leg 1" : 120, 140, 100 -> to calc best, worst leg & avg. darts per leg
  List<int> _legsCount =
      []; //only relevant for set mode -> if player finished set, save current legs count of each player in this list -> in order to revert a set

  SplayTreeMap<String, int> _checkouts = new SplayTreeMap();
  int _checkoutCount =
      0; //counts the checkout possibilities -> for calculating checkout quote
  List<Tuple3<String, int, int>> _checkoutCountAtThrownDarts =
      []; //to revert checkout count -> saves the current leg, the thrown darts at this moment+  amount of checkout counts
  SplayTreeMap<String, int> _amountOfFinishDarts =
      new SplayTreeMap(); //saves for each leg the amount of finish darts (for reverting)
  List<int> _amountOfDartsForWonLegs = [];

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
  int _allScoresCountForRound =
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
  Map<String, String> _playersWithCheckoutInLeg =
      {}; // for team mode -> displaying checkouts of players
  Map<String, String> _setLegWithPlayerOrTeamWhoFinishedIt =
      {}; // for reverting -> to set correct previous player/team
  List<InputMethod> _inputMethodForRounds =
      []; // keep track which input method (round, 3-darts) was used for each score -> for reverting (enter score with round -> enter with 3-darts -> revert)
  int _threeDartModeRoundsCount = 0;
  int _totalRoundsCount = 0;

  PlayerOrTeamGameStatsX01.Firestore({
    required String gameId,
    required DateTime dateTime,
    required String mode,
    required Player? player,
    required Team? team,
    required int currentPoints,
    required int totalPoints,
    required int firstNineAvgPoints,
    required int firstNineAvgCount,
    required int currentThrownDartsInLeg,
    required int allThrownDarts,
    required SplayTreeMap<String, int> thrownDartsPerLeg,
    required int dartsForWonLegCount,
    required bool gameWon,
    required int legsWon,
    required int legsWonTotal,
    required int setsWon,
    required SplayTreeMap<String, List<dynamic>> allScoresPerLeg,
    required List<int> legsCount,
    required int checkoutCount,
    required List<Tuple3<String, int, int>> checkoutCountAtThrownDarts,
    required SplayTreeMap<String, int> checkouts,
    required List<int> amountOfDartsForWonLegs,
    required Map<String, int> roundedScoresEven,
    required Map<String, int> roundedScoresOdd,
    required Map<String, int> preciseScores,
    required List<int> allScores,
    required int allScoresCountForRound,
    required List<int> allScoresPerDart,
    required Map<String, int> allScoresPerDartAsStringCount,
    required List<String> allScoresPerDartAsString,
    required List<int> allRemainingPoints,
    required List<List<String>> allRemainingScoresPerDart,
    required bool gameDraw,
    required Map<String, String> playersWithCheckoutInLeg,
    required int threeDartModeRoundsCount,
    required int totalRoundsCount,
    required SplayTreeMap<String, int> amountOfFinishDarts,
    required Map<String, String> setLegWithPlayerOrTeamWhoFinishedIt,
    required List<InputMethod> inputMethodForRounds,
  }) : super(gameId: gameId, dateTime: dateTime, mode: mode) {
    this.setTeam = team;
    this.setPlayer = player;
    this._currentPoints = currentPoints;
    this._totalPoints = totalPoints;
    this._firstNineAvgPoints = firstNineAvgPoints;
    this._firstNineAvgCount = firstNineAvgCount;
    this._currentThrownDartsInLeg = currentThrownDartsInLeg;
    this._allThrownDarts = allThrownDarts;
    this._thrownDartsPerLeg = thrownDartsPerLeg;
    this._dartsForWonLegCount = dartsForWonLegCount;
    this._gameWon = gameWon;
    this._legsWon = legsWon;
    this._legsWonTotal = legsWonTotal;
    this._setsWon = setsWon;
    this._allScoresPerLeg = SplayTreeMap.from(
        allScoresPerLeg.map((key, value) => MapEntry(key, value.cast<int>())));
    this._legsCount = legsCount;
    this._checkoutCount = checkoutCount;
    this._checkoutCountAtThrownDarts = checkoutCountAtThrownDarts;
    this._checkouts = checkouts;
    this._amountOfDartsForWonLegs = amountOfDartsForWonLegs;
    this._roundedScoresEven =
        roundedScoresEven.map((key, value) => MapEntry(int.parse(key), value));
    this._roundedScoresOdd =
        roundedScoresOdd.map((key, value) => MapEntry(int.parse(key), value));
    this._preciseScores =
        preciseScores.map((key, value) => MapEntry(int.parse(key), value));
    this._allScores = allScores;
    this._allScoresCountForRound = allScoresCountForRound;
    this._allScoresPerDart = allScoresPerDart;
    this._allScoresPerDartAsStringCount = allScoresPerDartAsStringCount;
    this._allScoresPerDartAsString = allScoresPerDartAsString;
    this._allRemainingPoints = allRemainingPoints;
    this._allRemainingScoresPerDart = allRemainingScoresPerDart;
    this._gameDraw = gameDraw;
    this._playersWithCheckoutInLeg = playersWithCheckoutInLeg;
    this._threeDartModeRoundsCount = threeDartModeRoundsCount;
    this._totalRoundsCount = totalRoundsCount;
    this._amountOfFinishDarts = amountOfFinishDarts;
    this._setLegWithPlayerOrTeamWhoFinishedIt =
        setLegWithPlayerOrTeamWhoFinishedIt;
    this._inputMethodForRounds = inputMethodForRounds;
  }

  PlayerOrTeamGameStatsX01.Team(
      {required Team team,
      required String mode,
      required int currentPoints,
      required DateTime dateTime})
      : this._currentPoints = currentPoints,
        super.Team(
          gameId: '',
          team: team,
          mode: mode,
          dateTime: dateTime,
        );

  PlayerOrTeamGameStatsX01(
      {required Player player,
      required String mode,
      required int currentPoints,
      required DateTime dateTime})
      : this._currentPoints = currentPoints,
        super.Player(
          gameId: '',
          player: player,
          mode: mode,
          dateTime: dateTime,
        );

  int get getCurrentPoints => this._currentPoints;
  set setCurrentPoints(int currentPoints) =>
      this._currentPoints = currentPoints;

  int get getTotalPoints => this._totalPoints;
  set setTotalPoints(int totalPoints) => this._totalPoints = totalPoints;

  int get getPointsSelectedCount => this._pointsSelectedCount;
  set setPointsSelectedCount(int pointsSelectedCount) =>
      this._pointsSelectedCount = pointsSelectedCount;

  int get getFirstNineAvgPoints => this._firstNineAvgPoints;
  set setFirstNineAvgPoints(int firstNineAvgPoints) =>
      this._firstNineAvgPoints = firstNineAvgPoints;

  int get getFirstNineAvgCount => this._firstNineAvgCount;
  set setFirstNineAvgCount(int firstNineAvgCount) =>
      this._firstNineAvgCount = firstNineAvgCount;

  bool get getGameWon => this._gameWon;
  set setGameWon(bool gameWon) => this._gameWon = gameWon;

  bool get getGameDraw => this._gameDraw;
  set setGameDraw(bool gameDraw) => this._gameDraw = gameDraw;

  int get getLegsWon => this._legsWon;
  set setLegsWon(int legsWon) => this._legsWon = legsWon;

  int get getLegsWonTotal => this._legsWonTotal;
  set setLegsWonTotal(int legsWonTotal) => this._legsWonTotal = legsWonTotal;

  int get getSetsWon => this._setsWon;
  set setSetsWon(int setsWon) => this._setsWon = setsWon;

  get getPreciseScores => this._preciseScores;
  set setPreciesScores(Map<int, int> preciseScores) =>
      this._preciseScores = preciseScores;

  int get getCurrentThrownDartsInLeg => this._currentThrownDartsInLeg;
  set setCurrentThrownDartsInLeg(int currentThrownDartsInLeg) =>
      this._currentThrownDartsInLeg = currentThrownDartsInLeg;

  int get getAllThrownDarts => this._allThrownDarts;
  set setAllThrownDarts(int allThrownDarts) =>
      this._allThrownDarts = allThrownDarts;

  get getThrownDartsPerLeg => this._thrownDartsPerLeg;
  set setThrownDartsPerLeg(SplayTreeMap<String, int> thrownDartsPerLeg) =>
      this._thrownDartsPerLeg = thrownDartsPerLeg;

  int get getDartsForWonLegCount => this._dartsForWonLegCount;
  set setDartsForWonLegCount(int dartsForWonLegCount) =>
      this._dartsForWonLegCount = dartsForWonLegCount;

  int get getCheckoutCount => this._checkoutCount;
  set setCheckoutCount(int checkoutCount) =>
      this._checkoutCount = checkoutCount;

  get getCheckouts => this._checkouts;
  set setCheckouts(SplayTreeMap<String, int> checkouts) =>
      this._checkouts = checkouts;

  List<Tuple3<String, int, int>> get getCheckoutCountAtThrownDarts =>
      this._checkoutCountAtThrownDarts;
  set setCheckoutCountAtThrownDarts(
          List<Tuple3<String, int, int>> checkoutCountAtThrownDarts) =>
      this._checkoutCountAtThrownDarts = checkoutCountAtThrownDarts;

  get getRoundedScoresEven => this._roundedScoresEven;
  set setRoundedScoresEven(Map<int, int> roundedScoresEven) =>
      this._roundedScoresEven = roundedScoresEven;

  get getRoundedScoresOdd => this._roundedScoresOdd;
  set setRoundedScoresOdd(Map<int, int> roundedScoresOdd) =>
      this._roundedScoresOdd = roundedScoresOdd;

  get getAllScoresPerLeg => this._allScoresPerLeg;
  set setAllScoresPerLeg(SplayTreeMap<String, List<int>> allScoresPerLeg) =>
      this._allScoresPerLeg = allScoresPerLeg;

  List<int> get getAllScores => this._allScores;
  set setAllScores(List<int> allScores) => this._allScores = allScores;

  int get getAllScoresCountForRound => this._allScoresCountForRound;
  set setAllScoresCountForRound(int allScoresCountForRound) =>
      this._allScoresCountForRound = allScoresCountForRound;

  List<int> get getAllScoresPerDart => this._allScoresPerDart;
  set setAllScoresPerDart(List<int> allScoresPerDart) =>
      this._allScoresPerDart = allScoresPerDart;

  get getAllScoresPerDartAsStringCount => this._allScoresPerDartAsStringCount;
  set setAllScoresPerDartAsStringCount(
          Map<String, int> allScoresPerDartAsString) =>
      this._allScoresPerDartAsStringCount = allScoresPerDartAsString;

  List<String> get getAllScoresPerDartAsString =>
      this._allScoresPerDartAsString;
  set setAllScoresPerDartAsString(List<String> allScoresPerDartAsString) =>
      this._allScoresPerDartAsString = allScoresPerDartAsString;

  List<int> get getAllRemainingPoints => this._allRemainingPoints;
  set setAllRemainingPoints(List<int> allRemainingPoints) =>
      this._allRemainingPoints = allRemainingPoints;

  List<List<String>> get getAllRemainingScoresPerDart =>
      this._allRemainingScoresPerDart;
  set setAllRemainingScoresPerDart(
          List<List<String>> allRemainingScoresPerDart) =>
      this._allRemainingScoresPerDart = allRemainingScoresPerDart;

  List<int> get getLegsCount => this._legsCount;
  set setLegsCount(List<int> legsCount) => this._legsCount = legsCount;

  SplayTreeMap<String, int> get getAmountOfFinishDarts =>
      this._amountOfFinishDarts;
  set setAmountOfFinishDarts(SplayTreeMap<String, int> value) =>
      this._amountOfFinishDarts = value;

  List<int> get getAmountOfDartsForWonLegs => this._amountOfDartsForWonLegs;
  set setAmountOfDartsForWonLegs(List<int> value) =>
      this._amountOfDartsForWonLegs = value;

  Map<String, String> get getPlayersWithCheckoutInLeg =>
      this._playersWithCheckoutInLeg;
  set setPlayersWithCheckoutInLeg(Map<String, String> value) =>
      this._playersWithCheckoutInLeg = value;

  Map<String, String> get getLegSetWithPlayerOrTeamWhoFinishedIt =>
      this._setLegWithPlayerOrTeamWhoFinishedIt;
  set setLegSetWithPlayerOrTeamWhoFinishedIt(Map<String, String> value) =>
      this._setLegWithPlayerOrTeamWhoFinishedIt = value;

  List<InputMethod> get getInputMethodForRounds => this._inputMethodForRounds;
  set setInputMethodForRounds(List<InputMethod> value) =>
      this._inputMethodForRounds = value;

  int get getThreeDartModeRoundsCount => this._threeDartModeRoundsCount;
  set setThreeDartModeRoundsCount(int value) =>
      this._threeDartModeRoundsCount = value;

  int get getTotalRoundsCount => this._totalRoundsCount;
  set setTotalRoundsCount(int value) => this._totalRoundsCount = value;

  //calc average based on total points and all scores length
  String getAverage(GameSettingsX01_P gameSettingsX01_P) {
    if (getTotalPoints == 0 || getAllScores.length == 0) {
      return '-';
    }

    int totalPoints = getTotalPoints;
    // for avg bot bug caused by the delay in the submit
    if (((getTeam != null && getTeam.getCurrentPlayerToThrow is Bot) ||
            getPlayer is Bot) &&
        getInputMethodForRounds.length != getAllScores.length) {
      int temp = 0;
      for (int score in getAllScores) {
        temp += score;
      }
      totalPoints = temp;
    }

    final String result =
        ((totalPoints / getAllThrownDarts) * 3).toStringAsFixed(2);
    final String decimalPlaces = result.substring(result.length - 2);

    if (decimalPlaces == '00') {
      return result.substring(0, result.length - 3);
    }
    return result;
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
    if (getCheckouts.isEmpty) {
      return 0;
    }

    return getCheckouts.values.reduce((int a, int b) => a > b ? a : b);
  }

  String getWorstCheckout() {
    if (getCheckouts.isEmpty) {
      return '-';
    }

    return getCheckouts.values
        .reduce((int a, int b) => a < b ? a : b)
        .toString();
  }

  String getFirstNinveAvg() {
    if (getAllScores.length == 0 && getAllScoresPerDart.length == 0) {
      return '-';
    }

    return ((getFirstNineAvgPoints / getFirstNineAvgCount) * 3)
        .toStringAsFixed(2);
  }

  String getCheckoutQuoteInPercent() {
    if (getCheckoutCount == 0) {
      return '-';
    }

    final String result =
        ((getLegsWonTotal / getCheckoutCount) * 100).toStringAsFixed(2);
    final String decimalPlaces = result.substring(result.length - 2);

    if (decimalPlaces == '00') {
      return '${result.substring(0, result.length - 3)}%';
    }

    return '${result}%';
  }

  String getBestLeg() {
    if (getAmountOfDartsForWonLegs.isEmpty) {
      return '-';
    }

    int bestLeg = getAmountOfDartsForWonLegs.reduce(min);
    return bestLeg.toString();
  }

  String getWorstLeg() {
    if (getAmountOfDartsForWonLegs.isEmpty) {
      return '-';
    }

    int worstLeg = getAmountOfDartsForWonLegs.reduce(max);
    return worstLeg.toString();
  }

  @override
  int compareTo(PlayerOrTeamGameStatsX01 other) {
    int setsCompare = other.getSetsWon.compareTo(getSetsWon);

    if (setsCompare != 0) {
      // if the sets are not equal, return the comparison result
      return setsCompare;
    } else {
      // if the sets are equal, compare by the legs property
      return other.getLegsWon.compareTo(getLegsWon);
    }
  }
}
