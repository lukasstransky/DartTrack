import 'package:dart_app/models/player.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats.dart';
import 'package:dart_app/models/team.dart';

class PlayerOrTeamGameStatsCricket extends PlayerOrTeamGameStats
    implements Comparable<PlayerOrTeamGameStatsCricket> {
  int _currentPoints = 0;
  int _totalPoints = 0;
  List<int> _pointsPerLeg = [];
  Map<int, int> _scoresOfNumbers =
      {}; // to keep track of how often a player has scored a specific number
  Map<int, int> _pointsPerNumbers =
      {}; // to keep track of how many points for a specifc number were scored
  int _legsWon = 0;
  int _legsWonTotal = 0;
  int _setsWon = 0;
  int _thrownDarts = 0;
  int _totalMarks = 0;
  // FOR REVERTING
  int _thrownDartsInLeg = 0;
  List<int> _thrownDartsPerLeg = [];
  List<String> _allScoresPerDart = [];
  List<Map<int, int>> _scoresOfNumbersPerLeg = []; // for reverting sets, legs
  List<List<String>> _currentThreeDartsBeforeLegFinished =
      []; // for reverting legs (saves the current three darts when leg is finished)
  List<int> _amountOfLegsPerSet =
      []; // for reverting sets (saves the leg amount when set is finished)

  PlayerOrTeamGameStatsCricket({
    required Player player,
    required String mode,
    required DateTime dateTime,
  }) : super.Player(
          gameId: '',
          player: player,
          mode: mode,
          dateTime: dateTime,
        );

  PlayerOrTeamGameStatsCricket.Team(
      {required Team team, required String mode, required DateTime dateTime})
      : super.Team(
          gameId: '',
          team: team,
          mode: mode,
          dateTime: dateTime,
        );

  PlayerOrTeamGameStatsCricket.Firestore({
    required String gameId,
    required DateTime dateTime,
    required String mode,
    required Player? player,
    required Team? team,
    required int currentPoints,
    required int totalPoints,
    required List<int> pointsPerLeg,
    required Map<String, int> scoresOfNumbers,
    required Map<String, int> pointsPerNumbers,
    required int legsWon,
    required int legsWonTotal,
    required int setsWon,
    required int thrownDarts,
    required int thrownDartsInLeg,
    required List<int> thrownDartsPerLeg,
    required int totalMarks,
    required List<String> allScoresPerDart,
    required List<Map<int, int>> scoresOfNumbersPerLeg,
    required List<List<String>> currentThreeDartsBeforeLegFinished,
    required List<int> amountOfLegsPerSet,
  }) : super(gameId: gameId, dateTime: dateTime, mode: mode) {
    this.setPlayer = player;
    this.setTeam = team;
    this.setCurrentPoints = currentPoints;
    this.setTotalPoints = totalPoints;
    this.setPointsPerLeg = pointsPerLeg;
    this.setScoresOfNumbers =
        scoresOfNumbers.map((key, value) => MapEntry(int.parse(key), value));
    this.setPointsPerNumbers =
        pointsPerNumbers.map((key, value) => MapEntry(int.parse(key), value));
    this.setLegsWon = legsWon;
    this.setLegsWonTotal = legsWonTotal;
    this.setSetsWon = setsWon;
    this.setThrownDarts = thrownDarts;
    this.setThrownDartsInLeg = thrownDartsInLeg;
    this.setThrownDartsPerLeg = thrownDartsPerLeg;
    this.setTotalMarks = totalMarks;
    this.setAllScoresPerDart = allScoresPerDart;
    this.setScoresOfNumbersPerLeg = scoresOfNumbersPerLeg;
    this.setCurrentThreeDartsBeforeLegFinished =
        currentThreeDartsBeforeLegFinished;
    this.setAmountOfLegsPerSet = amountOfLegsPerSet;
  }

  PlayerOrTeamGameStatsCricket clone() {
    return PlayerOrTeamGameStatsCricket(
        player: Player.clone(this.getPlayer),
        mode: this.getMode,
        dateTime: this.getDateTime)
      .._currentPoints = this._currentPoints
      .._totalPoints = this._totalPoints
      .._pointsPerLeg = List.from(this._pointsPerLeg)
      .._scoresOfNumbers = Map<int, int>.from(this._scoresOfNumbers)
      .._pointsPerNumbers = Map<int, int>.from(this._pointsPerNumbers)
      .._legsWon = this._legsWon
      .._legsWonTotal = this._legsWonTotal
      .._setsWon = this._setsWon
      .._thrownDarts = this._thrownDarts
      .._totalMarks = this._totalMarks
      .._thrownDartsInLeg = this._thrownDartsInLeg
      .._thrownDartsPerLeg = List.from(this._thrownDartsPerLeg)
      .._allScoresPerDart = List.from(this._allScoresPerDart)
      .._scoresOfNumbersPerLeg = this
          ._scoresOfNumbersPerLeg
          .map((map) => Map<int, int>.from(map))
          .toList()
      .._currentThreeDartsBeforeLegFinished = this
          ._currentThreeDartsBeforeLegFinished
          .map((list) => List<String>.from(list))
          .toList()
      .._amountOfLegsPerSet = List.from(this._amountOfLegsPerSet);
  }

  int get getCurrentPoints => this._currentPoints;
  set setCurrentPoints(int value) => this._currentPoints = value;

  int get getTotalPoints => this._totalPoints;
  set setTotalPoints(int value) => this._totalPoints = value;

  List<int> get getPointsPerLeg => this._pointsPerLeg;
  set setPointsPerLeg(List<int> value) => this._pointsPerLeg = value;

  Map<int, int> get getScoresOfNumbers => this._scoresOfNumbers;
  set setScoresOfNumbers(Map<int, int> value) => this._scoresOfNumbers = value;

  Map<int, int> get getPointsPerNumbers => this._pointsPerNumbers;
  set setPointsPerNumbers(Map<int, int> value) =>
      this._pointsPerNumbers = value;

  int get getLegsWon => this._legsWon;
  set setLegsWon(int value) => this._legsWon = value;

  int get getLegsWonTotal => this._legsWonTotal;
  set setLegsWonTotal(int value) => this._legsWonTotal = value;

  int get getSetsWon => this._setsWon;
  set setSetsWon(int value) => this._setsWon = value;

  int get getThrownDarts => this._thrownDarts;
  set setThrownDarts(int value) => this._thrownDarts = value;

  int get getThrownDartsInLeg => this._thrownDartsInLeg;
  set setThrownDartsInLeg(int value) => this._thrownDartsInLeg = value;

  List<int> get getThrownDartsPerLeg => this._thrownDartsPerLeg;
  set setThrownDartsPerLeg(List<int> value) => this._thrownDartsPerLeg = value;

  int get getTotalMarks => this._totalMarks;
  set setTotalMarks(int value) => this._totalMarks = value;

  List<String> get getAllScoresPerDart => this._allScoresPerDart;
  set setAllScoresPerDart(List<String> value) => this._allScoresPerDart = value;

  List<Map<int, int>> get getScoresOfNumbersPerLeg =>
      this._scoresOfNumbersPerLeg;
  set setScoresOfNumbersPerLeg(List<Map<int, int>> value) =>
      this._scoresOfNumbersPerLeg = value;

  List<List<String>> get getCurrentThreeDartsBeforeLegFinished =>
      this._currentThreeDartsBeforeLegFinished;
  set setCurrentThreeDartsBeforeLegFinished(List<List<String>> value) =>
      this._currentThreeDartsBeforeLegFinished = value;

  List<int> get getAmountOfLegsPerSet => this._amountOfLegsPerSet;
  set setAmountOfLegsPerSet(List<int> value) =>
      this._amountOfLegsPerSet = value;

  @override
  int compareTo(PlayerOrTeamGameStatsCricket other) {
    if (getSetsWon == 0 &&
        other.getSetsWon == 0 &&
        getLegsWon == 0 &&
        other.getLegsWon == 0) {
      // compare by total points
      return other.getTotalPoints.compareTo(getTotalPoints);
    }

    int setsCompare = other.getSetsWon.compareTo(getSetsWon);

    if (setsCompare != 0) {
      // if the sets are not equal, return the comparison result
      return setsCompare;
    } else {
      // if the sets are equal, compare by the legs property
      return other.getLegsWon.compareTo(getLegsWon);
    }
  }

  String getMarksPerRound() {
    if (getThrownDarts == 0) {
      return '0.00';
    }

    return (getTotalMarks / getThrownDarts).toStringAsFixed(2);
  }
}
