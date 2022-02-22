import 'player_game_statistics_model.dart';

class PlayerGameStatisticsX01 extends PlayerGameStatistics {
  double? _average;
  double? _firstNineAverage;
  int? _legsWon;
  int? _setsWon;
  int? _bestLeg;
  int? _worstLeg;
  int? _highestFinish;
  int? _highestScore;
  double? _checkoutQuote; //null or empty if not selected
  List<int>? _checkouts;
  Map<String, int>? _roundedScores; //e.g. 140+ : 5
  Map<int, int>? _preciseScores; //e.g. 140 : 3

  get getAverage => this._average;
  set setAverage(double? average) => this._average = average;

  get getFirstNineAverage => this._firstNineAverage;
  set setFirstNineAverage(double? firstNineAverage) =>
      this._firstNineAverage = firstNineAverage;

  get getLegsWon => this._legsWon;
  set setLegsWon(int? legsWon) => this._legsWon = legsWon;

  get getSetsWon => this._setsWon;
  set setSetsWon(int? setsWon) => this._setsWon = setsWon;

  get getBestLeg => this._bestLeg;
  set setBestLeg(int? bestLeg) => this._bestLeg = bestLeg;

  get getWorstLeg => this._worstLeg;
  set setWorstLeg(int? worstLeg) => this._worstLeg = worstLeg;

  get getHighestFinish => this._highestFinish;
  set setHighestFinish(int? highestFinish) =>
      this._highestFinish = highestFinish;

  get getHighestScore => this._highestScore;
  set setHighestScore(int highestScore) => this._highestScore = highestScore;

  get getCheckoutQuote => this._checkoutQuote;
  set setCheckoutQuote(double? checkoutQuote) =>
      this._checkoutQuote = checkoutQuote;

  get getCheckouts => this._checkouts;
  set setCheckouts(List<int>? checkouts) => this._checkouts = checkouts;

  get getRoundedScores => this._roundedScores;
  set setRoundedScores(Map<String, int>? roundedScores) =>
      this._roundedScores = roundedScores;

  get getPreciseScores => this._preciseScores;
  set setPreciesScores(Map<int, int>? preciseScores) =>
      this._preciseScores = preciseScores;

  PlayerGameStatisticsX01({
    player,
    gameId,
    mode,
  }) : super(player: player, gameId: gameId, mode: mode);
}
