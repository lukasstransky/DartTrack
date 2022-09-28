import 'dart:collection';

import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/models/player_statistics/player_game_statistics_x01.dart';

class PlayerGameStatistics {
  final Player _player;
  String? _gameId; //to reference the corresponding game -> calc stats
  final String _mode; //e.g. X01, Cricket.. -> calc stats
  final DateTime _dateTime;

  PlayerGameStatistics(
      {required String gameId,
      required Player player,
      required String mode,
      required DateTime dateTime})
      : _gameId = gameId,
        _player = player,
        _mode = mode,
        _dateTime = dateTime;

  factory PlayerGameStatistics.fromMapX01(map) {
    return PlayerGameStatisticsX01.firestore(
        gameId: map['gameId'],
        dateTime: DateTime.parse(map['dateTime'].toDate().toString()),
        mode: map['mode'],
        player: Player.fromMap(map['player']),
        currentPoints: map['currentPoints'] == null ? 0 : map['currentPoints'],
        totalPoints: map['totalPoints'] == null ? 0 : map['totalPoints'],
        startingPoints:
            map['startingPoints'] == null ? 0 : map['startingPoints'],
        firstNineAvgPoints:
            map['firstNineAvgPoints'] == null ? 0 : map['firstNineAvgPoints'],
        firstNineAvgCount:
            map['firstNineAvgCount'] == null ? 0 : map['firstNineAvgCount'],
        currentThrownDartsInLeg: map['currentThrownDartsInLeg'] == null
            ? 0
            : map['currentThrownDartsInLeg'],
        allThrownDarts:
            map['allThrownDarts'] == null ? 0 : map['allThrownDarts'],
        thrownDartsPerLeg: map['thrownDartsPerLeg'] == null
            ? new SplayTreeMap()
            : SplayTreeMap<String, int>.from(map['thrownDartsPerLeg']),
        dartsForWonLegCount:
            map['dartsForWonLegCount'] == null ? 0 : map['dartsForWonLegCount'],
        gameWon: map['gameWon'] == null ? false : map['gameWon'],
        legsWon: map['legsWon'] == null ? 0 : map['legsWon'],
        legsWonTotal: map['legsWonTotal'] == null ? 0 : map['legsWonTotal'],
        setsWon: map['setsWon'] == null ? 0 : map['setsWon'],
        allScoresPerLeg: map['allScoresPerLeg'] == null
            ? new SplayTreeMap()
            : SplayTreeMap<String, List<dynamic>>.from(
                map['allScoresPerLeg'],
              ),
        legsCount: map['legsCount'] == null ? [] : map['legsCount'].cast<int>(),
        checkoutCount: map['checkoutDarts'] == null ? 0 : map['checkoutDarts'],
        checkouts: map['checkouts'] == null
            ? new SplayTreeMap()
            : SplayTreeMap<String, int>.from(map['checkouts']),
        roundedScoresEven: map['roundedScoresEven'] == null
            ? {}
            : Map<String, int>.from(map['roundedScoresEven']),
        roundedScoresOdd: map['roundedScoresOdd'] == null
            ? {}
            : Map<String, int>.from(map['roundedScoresOdd']),
        preciseScores: map['preciseScores'] == null
            ? {}
            : Map<String, int>.from(map['preciseScores']),
        allScores: map['allScores'] == null ? [] : map['allScores'].cast<int>(),
        allScoresCountForRound: map['allScoresCountForRound'] == null
            ? 0
            : map['allScoresCountForRound'],
        allScoresPerDart: map['allScoresPerDart'] == null
            ? []
            : map['allScoresPerDart'].cast<int>(),
        allScoresPerDartAsStringCount:
            map['allScoresPerDartAsStringCount'] == null
                ? {}
                : Map<String, int>.from(map['allScoresPerDartAsStringCount']),
        allScoresPerDartAsString: map['allScoresPerDartAsString'] == null
            ? []
            : map['allScoresPerDartAsString'].cast<String>(),
        allRemainingPoints: map['allRemainingPoints'] == null
            ? []
            : map['allRemainingPoints'].cast<int>(),
        allRemainingScoresPerDart: map['allRemainingScoresPerDart'] == null
            ? []
            : List<List<String>>.from(map['allRemainingScoresPerDart']),
        gameDraw: map['gameDraw'] == null ? false : true);
  }

  Map<String, dynamic> toMapX01(PlayerGameStatisticsX01 playerGameStatisticsX01,
      GameX01 gameX01, String gameId, bool openGame) {
    String checkoutQuote = playerGameStatisticsX01.getCheckoutQuoteInPercent();

    if (openGame) {
      return {
        'player': playerGameStatisticsX01.getPlayer
            .toMap(playerGameStatisticsX01.getPlayer),
        'mode': _mode,
        'gameId': gameId,
        'dateTime': _dateTime,
        if (playerGameStatisticsX01.getAllScores.isNotEmpty)
          'average': double.parse(playerGameStatisticsX01.getAverage()),
        if (playerGameStatisticsX01.getAllScores.isNotEmpty)
          'highestScore': playerGameStatisticsX01.getHighestScore(),
        if (gameX01.getGameSettings.getEnableCheckoutCounting &&
            playerGameStatisticsX01.getCheckouts.isNotEmpty)
          'checkoutInPercent': checkoutQuote == '-'
              ? 0
              : double.parse(
                  checkoutQuote.substring(0, checkoutQuote.length - 1)),
        if (playerGameStatisticsX01.getCheckouts.isNotEmpty)
          'highestFinish': playerGameStatisticsX01.getHighestCheckout(),
        if (playerGameStatisticsX01.getCheckouts.isNotEmpty)
          'bestLeg': int.parse(playerGameStatisticsX01.getBestLeg()),
        if (playerGameStatisticsX01.getCheckouts.isNotEmpty)
          'worstLeg': int.parse((playerGameStatisticsX01.getWorstLeg())),
        if (playerGameStatisticsX01.getAllScoresPerDartAsStringCount.isNotEmpty)
          'allScoresPerDartWithCount':
              playerGameStatisticsX01.getAllScoresPerDartAsStringCount,
        'currentPoints': playerGameStatisticsX01.getCurrentPoints,
        'totalPoints': playerGameStatisticsX01.getTotalPoints,
        'startingPoints': playerGameStatisticsX01.getStartingPoints,
        if (playerGameStatisticsX01.getAllScores.isNotEmpty)
          'firstNineAvgPoints': playerGameStatisticsX01.getFirstNineAvgPoints,
        'firstNineAvgCount': playerGameStatisticsX01.getFirstNineAvgCount,
        'currentThrownDartsInLeg':
            playerGameStatisticsX01.getCurrentThrownDartsInLeg,
        'allThrownDarts': playerGameStatisticsX01.getAllThrownDarts,
        if (playerGameStatisticsX01.getThrownDartsPerLeg.isNotEmpty)
          'thrownDartsPerLeg': playerGameStatisticsX01.getThrownDartsPerLeg,
        'dartsForWonLegCount': playerGameStatisticsX01.getDartsForWonLegCount,
        'gameWon': playerGameStatisticsX01.getGameWon,
        'legsWon': playerGameStatisticsX01.getLegsWon,
        'legsWonTotal': playerGameStatisticsX01.getLegsWonTotal,
        if (gameX01.getGameSettings.getSetsEnabled)
          'setsWon': playerGameStatisticsX01.getSetsWon,
        if (playerGameStatisticsX01.getAllScoresPerLeg.isNotEmpty)
          'allScoresPerLeg': playerGameStatisticsX01.getAllScoresPerLeg,
        if (playerGameStatisticsX01.getLegsCount.isNotEmpty)
          'legsCount': playerGameStatisticsX01.getLegsCount,
        if (playerGameStatisticsX01.getCheckouts.isNotEmpty)
          'checkouts': playerGameStatisticsX01.getCheckouts,
        if (playerGameStatisticsX01.getCheckoutCount > 0)
          'checkoutDarts': playerGameStatisticsX01.getCheckoutCount,
        //todo add _checkoutCountAtThrownDarts
        if (playerGameStatisticsX01.getRoundedScoresEven.isNotEmpty)
          'roundedScoresEven':
              _getRoundedScoresEvenWithStringKey(playerGameStatisticsX01),
        if (playerGameStatisticsX01.getRoundedScoresOdd.isNotEmpty)
          'roundedScoresOdd':
              _getRoundedScoresOddWithStringKey(playerGameStatisticsX01),
        if (playerGameStatisticsX01.getPreciseScores.isNotEmpty)
          'preciseScores':
              _getPreciseScoresWithStringKey(playerGameStatisticsX01),
        if (playerGameStatisticsX01.getAllScores.isNotEmpty)
          'allScores': playerGameStatisticsX01.getAllScores,
        'allScoresCountForRound':
            playerGameStatisticsX01.getAllScoresCountForRound,
        if (playerGameStatisticsX01.getAllScoresPerDart.isNotEmpty)
          'allScoresPerDart': playerGameStatisticsX01.getAllScoresPerDart,
        if (playerGameStatisticsX01.getAllScoresPerDartAsStringCount.isNotEmpty)
          'allScoresPerDartAsStringCount':
              playerGameStatisticsX01.getAllScoresPerDartAsStringCount,
        if (playerGameStatisticsX01.getAllScoresPerDartAsString.isNotEmpty)
          'allScoresPerDartAsString':
              playerGameStatisticsX01.getAllScoresPerDartAsString,
        if (playerGameStatisticsX01.getAllRemainingPoints.isNotEmpty)
          'allRemainingPoints': playerGameStatisticsX01.getAllRemainingPoints,
        if (playerGameStatisticsX01.getAllRemainingScoresPerDart.isNotEmpty)
          'allRemainingScoresPerDart':
              playerGameStatisticsX01.getAllRemainingScoresPerDart,
        if (playerGameStatisticsX01.getGameDraw) 'gameDraw': true,
      };
    }

    return {
      'player': playerGameStatisticsX01.getPlayer
          .toMap(playerGameStatisticsX01.getPlayer),
      'mode': _mode,
      'legsWon': playerGameStatisticsX01.getLegsWon,
      'gameId': gameId,
      'dateTime': _dateTime,
      'dateTimeForFiltering':
          DateTime(_dateTime.year, _dateTime.month, _dateTime.day),
      if (gameX01.getGameSettings.getSetsEnabled)
        'setsWon': playerGameStatisticsX01.getSetsWon,
      if (playerGameStatisticsX01.getAllScores.isNotEmpty)
        'average': double.parse(playerGameStatisticsX01.getAverage()),
      if (playerGameStatisticsX01.getAllScores.isNotEmpty)
        'firstNineAvgPoints': playerGameStatisticsX01.getFirstNineAvgPoints,
      if (playerGameStatisticsX01.getFirstNineAvgCount > 0)
        'firstNineAvgCount': playerGameStatisticsX01.getFirstNineAvgCount,
      if (playerGameStatisticsX01.getFirstNineAvgCount > 0)
        'firstNineAvg':
            double.parse(playerGameStatisticsX01.getFirstNinveAvg()),
      if (playerGameStatisticsX01.getAllScores.isNotEmpty)
        'highestScore': playerGameStatisticsX01.getHighestScore(),
      if (gameX01.getGameSettings.getEnableCheckoutCounting &&
          playerGameStatisticsX01.getCheckouts.isNotEmpty)
        'checkoutInPercent': checkoutQuote == '-'
            ? 0
            : double.parse(
                checkoutQuote.substring(0, checkoutQuote.length - 1)),
      if (playerGameStatisticsX01.getCheckoutCount > 0)
        'checkoutDarts': playerGameStatisticsX01.getCheckoutCount,
      if (playerGameStatisticsX01.getAllThrownDarts > 0)
        'allThrownDarts': playerGameStatisticsX01.getAllThrownDarts,
      if (playerGameStatisticsX01.getCheckouts.isNotEmpty)
        'highestFinish': playerGameStatisticsX01.getHighestCheckout(),
      if (playerGameStatisticsX01.getCheckouts.isNotEmpty)
        'checkouts': playerGameStatisticsX01.getCheckouts,
      if (playerGameStatisticsX01.getCheckouts.isNotEmpty)
        'bestLeg': int.parse(playerGameStatisticsX01.getBestLeg()),
      if (playerGameStatisticsX01.getCheckouts.isNotEmpty)
        'worstLeg': int.parse((playerGameStatisticsX01.getWorstLeg())),
      if (playerGameStatisticsX01.getAllScores.isNotEmpty)
        'allScores': playerGameStatisticsX01.getAllScores,
      if (playerGameStatisticsX01.getAllScoresPerDart.isNotEmpty)
        'allScoresPerDart': playerGameStatisticsX01.getAllScoresPerDart,
      if (playerGameStatisticsX01.getRoundedScoresEven.isNotEmpty)
        'roundedScoresEven':
            _getRoundedScoresEvenWithStringKey(playerGameStatisticsX01),
      if (playerGameStatisticsX01.getRoundedScoresOdd.isNotEmpty)
        'roundedScoresOdd':
            _getRoundedScoresOddWithStringKey(playerGameStatisticsX01),
      if (playerGameStatisticsX01.getPreciseScores.isNotEmpty)
        'preciseScores':
            _getPreciseScoresWithStringKey(playerGameStatisticsX01),
      if (playerGameStatisticsX01.getAllScoresPerDartAsStringCount.isNotEmpty)
        'allScoresPerDartWithCount':
            playerGameStatisticsX01.getAllScoresPerDartAsStringCount,
      if (playerGameStatisticsX01.getThrownDartsPerLeg.isNotEmpty)
        'thrownDartsPerLeg': playerGameStatisticsX01.getThrownDartsPerLeg,
      'legsWonTotal': playerGameStatisticsX01.getLegsWonTotal,
      if (playerGameStatisticsX01.getAllScoresPerLeg.isNotEmpty)
        'allScoresPerLeg': playerGameStatisticsX01.getAllScoresPerLeg,
      'gameWon': playerGameStatisticsX01.getGameWon,
      'allScoresCountForRound':
          playerGameStatisticsX01.getAllScoresCountForRound,
      'totalPoints': playerGameStatisticsX01.getTotalPoints,
      'dartsForWonLegCount': playerGameStatisticsX01.getDartsForWonLegCount,
      if (playerGameStatisticsX01.getGameDraw) 'gameDraw': true,
    };
  }

  get getPlayer => this._player;

  get getGameId => this._gameId;

  get getMode => this._mode;

  get getDateTime => this._dateTime;

  Map<String, int> _getRoundedScoresOddWithStringKey(
      PlayerGameStatisticsX01 stats) {
    Map<String, int> result = {};
    for (var entry in stats.getRoundedScoresOdd.entries) {
      result[entry.key.toString()] = entry.value;
    }

    return result;
  }

  Map<String, int> _getRoundedScoresEvenWithStringKey(
      PlayerGameStatisticsX01 stats) {
    Map<String, int> result = {};
    for (var entry in stats.getRoundedScoresEven.entries) {
      result[entry.key.toString()] = entry.value;
    }

    return result;
  }

  Map<String, int> _getPreciseScoresWithStringKey(
      PlayerGameStatisticsX01 stats) {
    Map<String, int> result = {};
    for (var entry in stats.getPreciseScores.entries) {
      result[entry.key.toString()] = entry.value;
    }

    return result;
  }
}
