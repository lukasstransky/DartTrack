import 'player_game_statistics_model.dart';

class PlayerGameStatisticsX01 extends PlayerGameStatistics {
  int? _currentPoints;
  int _totalPoints = 0; //for average
  double _firstNineAverage = 0.0;
  int _legsWon = 0;
  int _setsWon = 0;
  int _bestLeg = 0;
  int _worstLeg = 0;
  int _highestFinish = 0;
  int _highestScore = 0;
  int _thrownDartsPerLeg = 0;
  double _checkoutQuote = 0.0;
  List<int> _checkouts = [];
  Map<String, int> _roundedScores = {}; //e.g. 140+ : 5
  Map<int, int> _preciseScores = {}; //e.g. 140 : 3
  List<int> _allScores = [];
  List<int> _allRemainingPoints =
      []; //all remainging points after each throw -> for reverting
  List<int> _legsCount =
      []; //only relevant for set mode -> if player finished set, save current legs count of each player in this array -> in order to revert a set

  get getCurrentPoints => this._currentPoints;
  set setCurrentPoints(int currentPoints) =>
      this._currentPoints = currentPoints;

  get getTotalPoints => this._totalPoints;
  set setTotalPoints(int totalPoints) => this._totalPoints = totalPoints;

  get getFirstNineAverage => this._firstNineAverage;
  set setFirstNineAverage(double firstNineAverage) =>
      this._firstNineAverage = firstNineAverage;

  get getLegsWon => this._legsWon;
  set setLegsWon(int legsWon) => this._legsWon = legsWon;

  get getSetsWon => this._setsWon;
  set setSetsWon(int setsWon) => this._setsWon = setsWon;

  get getBestLeg => this._bestLeg;
  set setBestLeg(int bestLeg) => this._bestLeg = bestLeg;

  get getWorstLeg => this._worstLeg;
  set setWorstLeg(int worstLeg) => this._worstLeg = worstLeg;

  get getHighestFinish => this._highestFinish;
  set setHighestFinish(int highestFinish) =>
      this._highestFinish = highestFinish;

  get getHighestScore => this._highestScore;
  set setHighestScore(int highestScore) => this._highestScore = highestScore;

  get getThrownDartsPerLeg => this._thrownDartsPerLeg;
  set setThrownDartsPerLeg(int thrownDartsPerLeg) =>
      this._thrownDartsPerLeg = thrownDartsPerLeg;

  get getCheckoutQuote => this._checkoutQuote;
  set setCheckoutQuote(double checkoutQuote) =>
      this._checkoutQuote = checkoutQuote;

  get getCheckouts => this._checkouts;
  set setCheckouts(List<int> checkouts) => this._checkouts = checkouts;

  get getRoundedScores => this._roundedScores;
  set setRoundedScores(Map<String, int> roundedScores) =>
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
}
