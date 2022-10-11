import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/services/firestore/firestore_service_games.dart';
import 'package:dart_app/services/firestore/firestore_service_player_stats.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class StatisticsFirestoreX01 with ChangeNotifier {
  int _countOfGames = 0;
  int _countOfGamesWon = 0;

  bool _avgBestWorstStatsLoaded = false;

  double _avg = 0;
  double _bestAvg = -1;
  double _worstAvg = -1;
  double _firstNineAvg = 0;
  double _bestFirstNineAvg = -1;
  double _worstFirstNineAvg = -1;

  double _checkoutQuoteAvg = 0;
  double _bestCheckoutQuote = -1;
  double _worstCheckoutQuote = -1;

  double _checkoutScoreAvg = 0;
  int _bestCheckoutScore = -1;
  int _worstCheckoutScore = -1;

  double _dartsPerLegAvg = 0;
  int _bestLeg = -1;
  int _worstLeg = -1;

  int _countOf180 = 0;
  int _countOfAllDarts = 0;

  FilterValue _currentFilterValue = FilterValue.Overall;
  String _customDateFilterRange = '';

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
  Map<String, int> _allScoresPerDartAsStringCount = {};
  List<Game> _games = [];
  List<Game> _filteredGames = [];
  bool _noGamesPlayed = false;

  List<Tuple2<int?, String>> _checkoutWithGameId = [];
  List<Tuple2<int?, String>> _thrownDartsWithGameId = [];

  get countOfGamesWon => this._countOfGamesWon;

  set countOfGamesWon(value) => this._countOfGamesWon = value;

  get countOfGames => this._countOfGames;

  set countOfGames(value) => this._countOfGames = value;

  get avgBestWorstStatsLoaded => this._avgBestWorstStatsLoaded;

  set avgBestWorstStatsLoaded(value) => this._avgBestWorstStatsLoaded = value;

  get avg => this._avg;

  set avg(value) => this._avg = value;

  get bestAvg => this._bestAvg;

  set bestAvg(value) => this._bestAvg = value;

  get worstAvg => this._worstAvg;

  set worstAvg(value) => this._worstAvg = value;

  get firstNineAvg => this._firstNineAvg;

  set firstNineAvg(value) => this._firstNineAvg = value;

  get bestFirstNineAvg => this._bestFirstNineAvg;

  set bestFirstNineAvg(value) => this._bestFirstNineAvg = value;

  get worstFirstNineAvg => this._worstFirstNineAvg;

  set worstFirstNineAvg(value) => this._worstFirstNineAvg = value;

  get checkoutQuoteAvg => this._checkoutQuoteAvg;

  set checkoutQuoteAvg(value) => this._checkoutQuoteAvg = value;

  get bestCheckoutQuote => this._bestCheckoutQuote;

  set bestCheckoutQuote(value) => this._bestCheckoutQuote = value;

  get worstCheckoutQuote => this._worstCheckoutQuote;

  set worstCheckoutQuote(value) => this._worstCheckoutQuote = value;

  get bestCheckoutScore => this._bestCheckoutScore;

  set bestCheckoutScore(value) => this._bestCheckoutScore = value;

  get checkoutScoreAvg => this._checkoutScoreAvg;

  set checkoutScoreAvg(value) => this._checkoutScoreAvg = value;

  get worstCheckoutScore => this._worstCheckoutScore;

  set worstCheckoutScore(value) => this._worstCheckoutScore = value;

  get dartsPerLegAvg => this._dartsPerLegAvg;

  set dartsPerLegAvg(value) => this._dartsPerLegAvg = value;

  get bestLeg => this._bestLeg;

  set bestLeg(value) => this._bestLeg = value;

  get worstLeg => this._worstLeg;

  set worstLeg(value) => this._worstLeg = value;

  get countOf180 => this._countOf180;

  set countOf180(value) => this._countOf180 = value;

  get countOfAllDarts => this._countOfAllDarts;

  set countOfAllDarts(value) => this._countOfAllDarts = value;

  get currentFilterValue => this._currentFilterValue;

  set currentFilterValue(value) => this._currentFilterValue = value;

  get customDateFilterRange => this._customDateFilterRange;

  set customDateFilterRange(value) => this._customDateFilterRange = value;

  get roundedScoresEven => this._roundedScoresEven;

  set roundedScoresEven(value) => this._roundedScoresEven = value;

  get roundedScoresOdd => this._roundedScoresOdd;

  set roundedScoresOdd(value) => this._roundedScoresOdd = value;

  get preciseScores => this._preciseScores;

  set preciseScores(value) => this._preciseScores = value;

  get allScoresPerDartAsStringCount => this._allScoresPerDartAsStringCount;

  set allScoresPerDartAsStringCount(value) =>
      this._allScoresPerDartAsStringCount = value;

  get games => this._games;

  set games(value) => this._games = value;

  get filteredGames => this._filteredGames;

  set filteredGames(value) => this._filteredGames = value;

  get noGamesPlayed => this._noGamesPlayed;

  set noGamesPlayed(value) => this._noGamesPlayed = value;

  get checkoutWithGameId => this._checkoutWithGameId;

  set checkoutWithGameId(checkoutWithGameId) =>
      this._checkoutWithGameId = checkoutWithGameId;

  get thrownDartsWithGameId => this._thrownDartsWithGameId;

  set thrownDartsWithGameId(thrownDartsWithGameId) =>
      this._thrownDartsWithGameId = thrownDartsWithGameId;

  loadStatistics(BuildContext context, FilterValue newFilterValue) async {
    currentFilterValue = newFilterValue;
    await context.read<FirestoreServicePlayerStats>().getStatistics(context);
    await context.read<FirestoreServiceGames>().getGames('X01', context);
  }

  DateTime getDateTimeFromCurrentFilterValue() {
    DateTime now = new DateTime.now();
    DateTime result = new DateTime.now();

    switch (currentFilterValue) {
      case FilterValue.Month:
        {
          result = new DateTime(now.year, now.month - 1, now.day);
          break;
        }
      case FilterValue.Year:
        {
          result = new DateTime(now.year - 1, now.month, now.day);
          break;
        }
    }

    return result;
  }

  DateTime getCustomStartDate() {
    return DateFormat('dd-MM-yyyy')
        .parse(customDateFilterRange.split(';').first);
  }

  DateTime getCustomEndDate() {
    return DateFormat('dd-MM-yyyy')
        .parse(customDateFilterRange.split(';').last);
  }

  resetValues() {
    _countOfGames = 0;
    _countOfGamesWon = 0;

    _avgBestWorstStatsLoaded = false;

    _avg = 0;
    _bestAvg = -1;
    _worstAvg = -1;
    _firstNineAvg = 0;
    _bestFirstNineAvg = -1;
    _worstFirstNineAvg = -1;

    _checkoutQuoteAvg = 0;
    _bestCheckoutQuote = -1;
    _worstCheckoutQuote = -1;

    _dartsPerLegAvg = 0;
    _bestLeg = -1;
    _worstLeg = -1;
    _checkoutScoreAvg = 0;

    _countOf180 = 0;
    _countOfAllDarts = 0;

    _roundedScoresEven = {
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
    _roundedScoresOdd = {
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
    _preciseScores = {};
    _allScoresPerDartAsStringCount = {};
  }

  resetOverallStats() {
    _checkoutWithGameId = [];
    _thrownDartsWithGameId = [];
  }

  resetGames() {
    _games = [];
  }

  resetFilteredGames() {
    _filteredGames = [];
  }

  notify() {
    notifyListeners();
  }

  sortGames() {
    if (games.isNotEmpty) games.sort();
  }

  Game? getGameById(String gameId) {
    Game? result;
    for (Game game in _games) {
      if (game.getGameId == gameId) {
        result = game;
      }
    }
    return result;
  }

  sortOverallStats(bool descending) {
    List<int?> onlyCheckouts = [];
    List<int?> onlyBestLegs = [];

    for (Tuple2<int?, String> tuple in _checkoutWithGameId) {
      onlyCheckouts.add(tuple.item1);
    }
    for (Tuple2<int?, String> tuple in _thrownDartsWithGameId) {
      onlyBestLegs.add(tuple.item1);
    }

    if (descending) {
      onlyCheckouts.sort((b, a) => a!.compareTo(b as int));
      onlyBestLegs.sort((b, a) => a!.compareTo(b as int));
    } else {
      onlyCheckouts.sort((a, b) => a!.compareTo(b as int));
      onlyBestLegs.sort((a, b) => a!.compareTo(b as int));
    }

    List<Tuple2<int?, String>> checkoutWithGameId = [];
    List<Tuple2<int?, String>> thrownDartsWithGameId = [];
    for (int? checkout in onlyCheckouts) {
      String key = _getKeyForCheckout(checkout);
      checkoutWithGameId.add(new Tuple2(checkout, key));
    }
    for (int? bestLeg in onlyBestLegs) {
      String key = _getKeyForBestLeg(bestLeg);
      thrownDartsWithGameId.add(new Tuple2(bestLeg, key));
    }

    _checkoutWithGameId = checkoutWithGameId;
    _thrownDartsWithGameId = thrownDartsWithGameId;
  }

  String _getKeyForCheckout(int? checkout) {
    for (Tuple2<int?, String> tuple in _checkoutWithGameId) {
      if (tuple.item1 == checkout) {
        return tuple.item2;
      }
    }
    return '';
  }

  _getKeyForBestLeg(int? bestLeg) {
    for (Tuple2<int?, String> tuple in _thrownDartsWithGameId) {
      if (tuple.item1 == bestLeg) {
        return tuple.item2;
      }
    }
    return '';
  }
}
