import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats_x01.dart';
import 'package:dart_app/services/firestore/firestore_service_player_stats.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tuple/tuple.dart';

class StatsFirestoreX01_P with ChangeNotifier {
  int _countOfGames = 0;
  int _countOfGamesWon = 0;

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

  List<Tuple2<int?, String>> _checkoutWithGameId = [];
  List<Tuple2<int?, String>> _thrownDartsWithGameId = [];

  bool _noGamesPlayed = false;

  List<Game_P> _games = []; // allGames
  List<Game_P> _filteredGames = [];
  List<Game_P> _favouriteGames = [];
  List<PlayerOrTeamGameStatsX01> _playerOrTeamGameStats = [];
  List<PlayerOrTeamGameStatsX01> _filteredPlayerOrTeamGameStats = [];

  bool _showFavouriteGames = false;

  bool _loadGames = true;
  bool _gamesLoaded = false;
  bool _loadPlayerStats = true;
  bool _playerOrTeamGameStatsLoaded = false;

  String _customBtnDateRange = '';

  get getCountOfGamesWon => this._countOfGamesWon;

  set setCountOfGamesWon(value) => this._countOfGamesWon = value;

  get countOfGames => this._countOfGames;

  set countOfGames(value) => this._countOfGames = value;

  get playerOrTeamGameStatsLoaded => this._playerOrTeamGameStatsLoaded;

  set playerOrTeamGameStatsLoaded(value) =>
      this._playerOrTeamGameStatsLoaded = value;

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

  List<Game_P> get games => this._games;

  set games(List<Game_P> value) => this._games = value;

  List<Game_P> get filteredGames => this._filteredGames;

  set filteredGames(List<Game_P> value) => this._filteredGames = value;

  get noGamesPlayed => this._noGamesPlayed;

  set noGamesPlayed(value) => this._noGamesPlayed = value;

  get checkoutWithGameId => this._checkoutWithGameId;

  set checkoutWithGameId(checkoutWithGameId) =>
      this._checkoutWithGameId = checkoutWithGameId;

  get thrownDartsWithGameId => this._thrownDartsWithGameId;

  set thrownDartsWithGameId(thrownDartsWithGameId) =>
      this._thrownDartsWithGameId = thrownDartsWithGameId;

  bool get showFavouriteGames => this._showFavouriteGames;

  set showFavouriteGames(bool value) => this._showFavouriteGames = value;

  List<Game_P> get favouriteGames => this._favouriteGames;

  set favouriteGames(List<Game_P> value) => this._favouriteGames = value;

  List<PlayerOrTeamGameStatsX01> get getPlayerOrTeamGameStats =>
      this._playerOrTeamGameStats;
  set setPlayerOrTeamGameStats(List<PlayerOrTeamGameStatsX01> value) =>
      this._playerOrTeamGameStats = value;

  List<PlayerOrTeamGameStatsX01> get getFilteredPlayerOrTeamGameStats =>
      this._filteredPlayerOrTeamGameStats;
  set setFilteredPlayerOrTeamGameStats(List<PlayerOrTeamGameStatsX01> value) =>
      this._filteredPlayerOrTeamGameStats = value;

  bool get loadGames => this._loadGames;

  set loadGames(bool loadGames) => this._loadGames = loadGames;

  bool get gamesLoaded => this._gamesLoaded;

  set gamesLoaded(bool value) => this._gamesLoaded = value;

  bool get loadPlayerStats => this._loadPlayerStats;

  set loadPlayerStats(bool loadPlayerStats) =>
      this._loadPlayerStats = loadPlayerStats;

  String get customBtnDateRange => this._customBtnDateRange;

  set customBtnDateRange(String value) => this._customBtnDateRange = value;

  DateTime getDateTimeFromCurrentFilterValue() {
    final DateTime now = new DateTime.now();
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

  resetValues() {
    _countOfGames = 0;
    _countOfGamesWon = 0;

    _avg = 0;
    _bestAvg = -1;
    _worstAvg = -1;
    _firstNineAvg = 0;
    _bestFirstNineAvg = -1;
    _worstFirstNineAvg = -1;

    _checkoutQuoteAvg = 0;
    _bestCheckoutQuote = -1;
    _worstCheckoutQuote = -1;

    _checkoutScoreAvg = 0;
    _bestCheckoutScore = -1;
    _worstCheckoutScore = -1;

    _dartsPerLegAvg = 0;
    _bestLeg = -1;
    _worstLeg = -1;

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
    _favouriteGames = [];
  }

  resetFilteredGames() {
    _filteredGames = [];
  }

  resetFilteredPlayerOrTeamStats() {
    _filteredPlayerOrTeamGameStats = [];
  }

  resetPlayerOrTeamStats() {
    _playerOrTeamGameStats = [];
  }

  resetAll() {
    resetOverallStats();
    resetGames();
    resetFilteredGames();
    resetPlayerOrTeamStats();
    resetFilteredPlayerOrTeamStats();
    resetValues();
    resetLoadingFields();
  }

  resetLoadingFields() {
    _loadGames = true;
    _gamesLoaded = false;
    _loadPlayerStats = true;
    _playerOrTeamGameStatsLoaded = false;
  }

  resetForResettingStats() {
    resetAll();
    _loadGames = false;
    _gamesLoaded = true;
    _loadPlayerStats = false;
    _playerOrTeamGameStatsLoaded = true;
    _noGamesPlayed = true;
  }

  notify() {
    notifyListeners();
  }

  Game_P? getGameById(String gameId) {
    Game_P? result;
    for (Game_P game in _games) {
      if (game.getGameId == gameId) {
        result = game;
      }
    }
    return result;
  }

  sortCheckoutsAndBestLegsStats(bool descending) {
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

  String _getKeyForBestLeg(int? bestLeg) {
    for (Tuple2<int?, String> tuple in _thrownDartsWithGameId) {
      if (tuple.item1 == bestLeg) {
        return tuple.item2;
      }
    }
    return '';
  }

  DateTime getCustomStartDate() {
    if (customDateFilterRange == '') {
      DateTime now = new DateTime.now();
      return new DateTime(now.year, now.month, now.day);
    }

    return DateFormat('dd-MM-yyyy')
        .parse(customDateFilterRange.split(';').first);
  }

  DateTime getCustomEndDate(bool addDay) {
    if (customDateFilterRange == '') {
      DateTime now = new DateTime.now();
      return new DateTime(now.year, now.month, now.day);
    }

    DateTime dateTime =
        DateFormat('dd-MM-yyyy').parse(customDateFilterRange.split(';').last);

    if (addDay) {
      dateTime = dateTime.add(Duration(days: 1));
    }

    return dateTime;
  }

  filterGamesAndPlayerOrTeamStatsByDate(
      FilterValue newFilterValue,
      BuildContext context,
      StatsFirestoreX01_P statsFirestoreX01,
      FirestoreServicePlayerStats firestoreServicePlayerStats) {
    currentFilterValue = newFilterValue;
    resetFilteredGames();
    resetFilteredPlayerOrTeamStats();
    favouriteGames = [];

    DateTime comparisonDate = DateTime.now();
    switch (currentFilterValue) {
      case FilterValue.Month:
        comparisonDate = DateTime.now().subtract(Duration(days: 30));
        break;
      case FilterValue.Year:
        comparisonDate = DateTime.now().subtract(Duration(days: 365));
        break;
      case FilterValue.Custom:
        comparisonDate = getCustomStartDate();
        break;
      case FilterValue.Overall:
        comparisonDate = DateTime.fromMillisecondsSinceEpoch(0);
        break;
    }

    if (this.currentFilterValue == FilterValue.Custom) {
      final DateTime customEndDate = getCustomEndDate(true);
      filteredGames = games
          .where((game) =>
              game.getDateTime.isSameDate(comparisonDate, customEndDate) ||
              (game.getDateTime.isAfter(comparisonDate) &&
                  game.getDateTime.isBefore(customEndDate)))
          .toList();
      setFilteredPlayerOrTeamGameStats = getPlayerOrTeamGameStats
          .where((stats) =>
              (stats.getDateTime as DateTime)
                  .isSameDate(comparisonDate, customEndDate) ||
              (stats.getDateTime.isAfter(comparisonDate) &&
                  stats.getDateTime.isBefore(customEndDate)))
          .toList();
    } else {
      filteredGames = games
          .where((game) => game.getDateTime.isAfter(comparisonDate))
          .toList();
      setFilteredPlayerOrTeamGameStats = getPlayerOrTeamGameStats
          .where((stats) => stats.getDateTime.isAfter(comparisonDate))
          .toList();
    }

    favouriteGames =
        filteredGames.where((game) => game.getIsFavouriteGame).toList();

    noGamesPlayed = filteredGames.isEmpty;
    notify();
  }

  sortGames() {
    if (games.isNotEmpty) {
      games.sort();
    }
  }

  calculateX01Stats() {
    resetValues();

    int _counter = 0;
    double _totalAvg = 0;
    double _totalFirstNineAvg = 0;
    double _totalCheckoutQuoteAvg = 0;
    int _checkoutQuoteCounter = 0;
    double _totalCheckoutScoreAvg = 0;
    int _checkoutScoreCounter = 0;
    int _dartsForWonLegCount = 0;
    int _legsWonTotal = 0;

    countOfGames = getFilteredPlayerOrTeamGameStats.length;

    getFilteredPlayerOrTeamGameStats.forEach((stats) {
      //count of games won
      if (stats.getGameWon) {
        setCountOfGamesWon = getCountOfGamesWon + 1;
      }

      //checkout quote
      final String _checkoutQuoteInPercentString =
          stats.getCheckoutQuoteInPercent();
      if (_checkoutQuoteInPercentString != '-') {
        final double _checkoutQuoteInPercent = double.parse(
            _checkoutQuoteInPercentString.substring(
                0, _checkoutQuoteInPercentString.length - 1));

        _checkoutQuoteCounter++;
        _totalCheckoutQuoteAvg += _checkoutQuoteInPercent;
        if (_checkoutQuoteInPercent > bestCheckoutQuote) {
          bestCheckoutQuote = _checkoutQuoteInPercent;
        }
        if (_checkoutQuoteInPercent < worstCheckoutQuote ||
            worstCheckoutQuote == -1) {
          worstCheckoutQuote = _checkoutQuoteInPercent;
        }
      }

      //checkout score
      stats.getCheckouts.values.forEach((int _checkoutScore) {
        _totalCheckoutScoreAvg += _checkoutScore;
        _checkoutScoreCounter++;
        if (_checkoutScore < worstCheckoutScore || worstCheckoutScore == -1) {
          worstCheckoutScore = _checkoutScore;
        }
        if (_checkoutScore > bestCheckoutScore || bestCheckoutScore == -1) {
          bestCheckoutScore = _checkoutScore;
        }
      });

      //legs
      stats.getThrownDartsPerLeg.values.forEach((int _thrownDarts) {
        countOfAllDarts += _thrownDarts;
      });

      final String _bestLegString = stats.getBestLeg();
      if (_bestLegString != '-') {
        final int _bestLeg = int.parse(_bestLegString);
        if (_bestLeg < bestLeg || bestLeg == -1) {
          bestLeg = _bestLeg;
        }
      }

      final String _worstLegString = stats.getWorstLeg();
      if (_worstLegString != '-') {
        final int _worstLeg = int.parse(stats.getWorstLeg());
        if (_worstLeg > worstLeg) {
          worstLeg = _worstLeg;
        }
      }

      _dartsForWonLegCount += stats.getDartsForWonLegCount;
      _legsWonTotal += stats.getLegsWonTotal;

      //avg
      final String _avgString = stats.getAverage();
      final double _avg = _avgString == '-' ? 0 : double.parse(_avgString);
      _totalAvg += _avg;
      if (_avg > bestAvg) {
        bestAvg = _avg;
      }
      if (_avg < worstAvg || worstAvg == -1) {
        worstAvg = _avg;
      }

      //first nine avg
      final String _firstNineAvgString = stats.getFirstNinveAvg();
      final double _firstNineAvg =
          _firstNineAvgString == '-' ? 0 : double.parse(_firstNineAvgString);
      _totalFirstNineAvg += _firstNineAvg;
      if (_firstNineAvg > bestFirstNineAvg) {
        bestFirstNineAvg = _firstNineAvg;
      }
      if (_firstNineAvg < worstFirstNineAvg || worstFirstNineAvg == -1) {
        worstFirstNineAvg = _firstNineAvg;
      }
      _counter++;

      //180
      countOf180 += stats.getRoundedScoresEven[180] as int;

      //rounded scores even
      final Map<int, int> _roundedScoresEven = stats.getRoundedScoresEven;
      for (int key in _roundedScoresEven.keys) {
        roundedScoresEven[key] += _roundedScoresEven[key];
      }

      //rounded scores odd
      final Map<int, int> _roundedScoresOdd = stats.getRoundedScoresOdd;
      for (int key in _roundedScoresOdd.keys) {
        roundedScoresOdd[key] += _roundedScoresOdd[key];
      }

      //precise scores
      final Map<int, int> _preciseScores = stats.getPreciseScores;
      for (int key in _preciseScores.keys) {
        if (preciseScores.containsKey(key)) {
          preciseScores[key] += _preciseScores[key];
        } else {
          preciseScores[key] = _preciseScores[key];
        }
      }

      //all scores per dart with count
      final Map<String, int> _allScoresPerDartAsStringCount =
          stats.getAllScoresPerDartAsStringCount;
      for (String key in _allScoresPerDartAsStringCount.keys) {
        if (allScoresPerDartAsStringCount.containsKey(key)) {
          allScoresPerDartAsStringCount[key] +=
              _allScoresPerDartAsStringCount[key];
        } else {
          allScoresPerDartAsStringCount[key] =
              _allScoresPerDartAsStringCount[key];
        }
      }
    });

    //calc & set values
    if (_totalAvg > 0) {
      avg = _totalAvg / _counter;
    }

    if (_totalFirstNineAvg > 0) {
      firstNineAvg = _totalFirstNineAvg / _counter;
    }

    if (_checkoutQuoteCounter > 0) {
      checkoutQuoteAvg = _totalCheckoutQuoteAvg / _checkoutQuoteCounter;
    }

    if (_totalCheckoutScoreAvg > 0) {
      checkoutScoreAvg = _totalCheckoutScoreAvg / _checkoutScoreCounter;
    }

    if (_legsWonTotal > 0) {
      dartsPerLegAvg = _dartsForWonLegCount / _legsWonTotal;
    }

    preciseScores = Utils.sortMapIntInt(preciseScores);
    allScoresPerDartAsStringCount =
        Utils.sortMapStringInt(allScoresPerDartAsStringCount);

    notify();
  }
}

extension DateOnlyCompare on DateTime {
  bool isSameDate(DateTime first, DateTime second) {
    return year == first.year &&
        month == first.month &&
        day == first.day &&
        year == second.year &&
        month == second.month &&
        day == second.day;
  }
}
