import 'package:dart_app/constants.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats.dart';

class PlayerGameStatsScoreTraining extends PlayerOrTeamGameStats
    implements Comparable<PlayerGameStatsScoreTraining> {
  int _currentScore = 0;
  List<int> _allScores = [];
  List<int> _allScoresPerDart = [];
  Map<String, int> _allScoresPerDartAsStringCount = {};
  List<String> _allScoresPerDartAsString =
      []; // for reverting allScoresPerDartAsStringCount
  int _thrownDarts = 0;
  int _roundsOrPointsLeft = 0;
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
  };
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
  Map<int, int> _preciseScores = {};
  int _threeDartModeRoundsCount = 0;
  int _totalRoundsCount = 0;
  List<InputMethod> _inputMethodForRounds = [];
  List<List<String>> _allRemainingScoresPerDart = [];

  PlayerGameStatsScoreTraining.Firestore({
    required String gameId,
    required DateTime dateTime,
    required String mode,
    required Player? player,
    required Map<String, int> roundedScoresEven,
    required Map<String, int> roundedScoresOdd,
    required Map<String, int> preciseScores,
    required List<int> allScores,
    required List<int> allScoresPerDart,
    required Map<String, int> allScoresPerDartAsStringCount,
    required List<String> allScoresPerDartAsString,
    required List<List<String>> allRemainingScoresPerDart,
    required int threeDartModeRoundsCount,
    required int totalRoundsCount,
    required int thrownDarts,
    required int currentScore,
    required int roundsOrPointsLeft,
    required List<InputMethod> inputMethodForRounds,
  }) : super(gameId: gameId, dateTime: dateTime, mode: mode) {
    this.setPlayer = player;
    this.setRoundedScoresEven =
        roundedScoresEven.map((key, value) => MapEntry(int.parse(key), value));
    this.setRoundedScoresOdd =
        roundedScoresOdd.map((key, value) => MapEntry(int.parse(key), value));
    this._preciseScores =
        preciseScores.map((key, value) => MapEntry(int.parse(key), value));
    this.setAllScores = allScores;
    this.setAllScoresPerDart = allScoresPerDart;
    this.setAllScoresPerDartAsStringCount = allScoresPerDartAsStringCount;
    this.setAllScoresPerDartAsString = allScoresPerDartAsString;
    this.setAllRemainingScoresPerDart = allRemainingScoresPerDart;
    this.setThreeDartModeRoundsCount = threeDartModeRoundsCount;
    this.setTotalRoundsCount = totalRoundsCount;
    this.setThrownDarts = thrownDarts;
    this.setCurrentScore = currentScore;
    this.setRoundsOrPointsLeft = roundsOrPointsLeft;
    this.setInputMethodForRounds = inputMethodForRounds;
  }

  int get getCurrentScore => this._currentScore;
  set setCurrentScore(int value) => this._currentScore = value;

  List<int> get getAllScores => this._allScores;
  set setAllScores(List<int> value) => this._allScores = value;

  List<int> get getAllScoresPerDart => this._allScoresPerDart;
  set setAllScoresPerDart(List<int> value) => this._allScoresPerDart = value;

  Map<String, int> get getAllScoresPerDartAsStringCount =>
      this._allScoresPerDartAsStringCount;
  set setAllScoresPerDartAsStringCount(Map<String, int> value) =>
      this._allScoresPerDartAsStringCount = value;

  List<String> get getAllScoresPerDartAsString =>
      this._allScoresPerDartAsString;
  set setAllScoresPerDartAsString(List<String> allScoresPerDartAsString) =>
      this._allScoresPerDartAsString = allScoresPerDartAsString;

  int get getThrownDarts => this._thrownDarts;
  set setThrownDarts(int value) => this._thrownDarts = value;

  int get getRoundsOrPointsLeft => this._roundsOrPointsLeft;
  set setRoundsOrPointsLeft(int value) => this._roundsOrPointsLeft = value;

  Map<int, int> get getRoundedScoresEven => this._roundedScoresEven;
  set setRoundedScoresEven(Map<int, int> value) =>
      this._roundedScoresEven = value;

  Map<int, int> get getRoundedScoresOdd => this._roundedScoresOdd;
  set setRoundedScoresOdd(Map<int, int> value) =>
      this._roundedScoresOdd = value;

  Map<int, int> get getPreciseScores => this._preciseScores;
  set setPreciseScores(Map<int, int> value) => this._preciseScores = value;

  int get getThreeDartModeRoundsCount => this._threeDartModeRoundsCount;
  set setThreeDartModeRoundsCount(int value) =>
      this._threeDartModeRoundsCount = value;

  int get getTotalRoundsCount => this._totalRoundsCount;
  set setTotalRoundsCount(int value) => this._totalRoundsCount = value;

  List<InputMethod> get getInputMethodForRounds => this._inputMethodForRounds;
  set setInputMethodForRounds(List<InputMethod> value) =>
      this._inputMethodForRounds = value;

  List<List<String>> get getAllRemainingScoresPerDart =>
      this._allRemainingScoresPerDart;
  set setAllRemainingScoresPerDart(List<List<String>> value) =>
      this._allRemainingScoresPerDart = value;

  PlayerGameStatsScoreTraining({
    required Player player,
    required String mode,
    required DateTime dateTime,
    required int roundOrPointsLeft,
  })  : _roundsOrPointsLeft = roundOrPointsLeft,
        super.Player(
          gameId: '',
          player: player,
          mode: mode,
          dateTime: dateTime,
        );

  String getAverage() {
    if (getCurrentScore == 0 && getAllScores.length == 0) {
      return '0';
    }

    final String result =
        ((getCurrentScore / getThrownDarts) * 3).toStringAsFixed(2);
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

  @override
  int compareTo(PlayerGameStatsScoreTraining other) {
    if (!(getCurrentScore < other.getCurrentScore)) {
      return -1;
    } else if (getCurrentScore < other.getCurrentScore) {
      return 1;
    } else {
      return 0;
    }
  }

  String getRoundsOrPointsValue(bool isRoundMode) {
    if (isRoundMode) {
      if (getRoundsOrPointsLeft == 0) {
        return 'Finished';
      }
      return getRoundsOrPointsLeft.toString();
    }
    if (getRoundsOrPointsLeft <= 0) {
      return 'Finished';
    }
    return getRoundsOrPointsLeft.toString();
  }
}
