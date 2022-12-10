import 'dart:collection';

import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_statistics_x01.dart';
import 'package:dart_app/models/team.dart';

class PlayerOrTeamGameStatistics {
  Player? _player;
  Team? _team;
  String? _gameId; //to reference the corresponding game -> calc stats
  final String _mode; //e.g. X01, Cricket.. -> calc stats
  final DateTime _dateTime;

  PlayerOrTeamGameStatistics(
      {required String gameId,
      required String mode,
      required DateTime dateTime})
      : _gameId = gameId,
        _mode = mode,
        _dateTime = dateTime;

  PlayerOrTeamGameStatistics.Player(
      {required String gameId,
      required Player player,
      required String mode,
      required DateTime dateTime})
      : _gameId = gameId,
        _player = player,
        _mode = mode,
        _dateTime = dateTime;

  PlayerOrTeamGameStatistics.Team(
      {required String gameId,
      required Team team,
      required String mode,
      required DateTime dateTime})
      : _gameId = gameId,
        _team = team,
        _mode = mode,
        _dateTime = dateTime;

  factory PlayerOrTeamGameStatistics.fromMapX01(map) {
    return PlayerOrTeamGameStatisticsX01.Firestore(
        gameId: map['gameId'],
        dateTime: DateTime.parse(map['dateTime'].toDate().toString()),
        mode: map['mode'],
        player: map['player'] == null ? null : Player.fromMap(map['player']),
        team: map['team'] == null ? null : Team.fromMap(map['team']),
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
        playersWithCheckoutInLeg: map['playersWithCheckoutInLeg'] == null
            ? {}
            : Map<String, String>.from(map['playersWithCheckoutInLeg']),
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
        gameDraw: map['gameDraw'] == null ? false : true,
        threeDartModeRoundsCount: map['threeDartModeRoundsCount'] == null
            ? 0
            : map['threeDartModeRoundsCount'],
        totalRoundsCount:
            map['totalRoundsCount'] == null ? 0 : map['totalRoundsCount']);
  }

  Map<String, dynamic> toMapX01(
      PlayerOrTeamGameStatisticsX01 playerOrTeamGameStatsX01,
      GameX01 gameX01,
      GameSettingsX01 gameSettingsX01,
      String gameId,
      bool openGame) {
    String checkoutQuote = playerOrTeamGameStatsX01.getCheckoutQuoteInPercent();

    if (openGame) {
      return {
        if (playerOrTeamGameStatsX01.getPlayer != null)
          'player': playerOrTeamGameStatsX01.getPlayer
              .toMap(playerOrTeamGameStatsX01.getPlayer),
        if (playerOrTeamGameStatsX01.getTeam != null)
          'team': playerOrTeamGameStatsX01.getTeam
              .toMap(playerOrTeamGameStatsX01.getTeam),
        'mode': _mode,
        'gameId': gameId,
        'dateTime': _dateTime,
        if (playerOrTeamGameStatsX01.getAllScores.isNotEmpty)
          'average': double.parse(playerOrTeamGameStatsX01.getAverage()),
        if (playerOrTeamGameStatsX01.getAllScores.isNotEmpty)
          'highestScore': playerOrTeamGameStatsX01.getHighestScore(),
        if (gameSettingsX01.getEnableCheckoutCounting &&
            playerOrTeamGameStatsX01.getCheckouts.isNotEmpty)
          'checkoutInPercent': checkoutQuote == '-'
              ? 0
              : double.parse(
                  checkoutQuote.substring(0, checkoutQuote.length - 1)),
        if (playerOrTeamGameStatsX01.getCheckouts.isNotEmpty)
          'highestFinish': playerOrTeamGameStatsX01.getHighestCheckout(),
        if (playerOrTeamGameStatsX01.getCheckouts.isNotEmpty)
          'bestLeg': int.parse(playerOrTeamGameStatsX01.getBestLeg()),
        if (playerOrTeamGameStatsX01.getCheckouts.isNotEmpty)
          'worstLeg': int.parse((playerOrTeamGameStatsX01.getWorstLeg())),
        if (playerOrTeamGameStatsX01
            .getAllScoresPerDartAsStringCount.isNotEmpty)
          'allScoresPerDartWithCount':
              playerOrTeamGameStatsX01.getAllScoresPerDartAsStringCount,
        'currentPoints': playerOrTeamGameStatsX01.getCurrentPoints,
        'totalPoints': playerOrTeamGameStatsX01.getTotalPoints,
        'startingPoints': playerOrTeamGameStatsX01.getStartingPoints,
        if (playerOrTeamGameStatsX01.getAllScores.isNotEmpty)
          'firstNineAvgPoints': playerOrTeamGameStatsX01.getFirstNineAvgPoints,
        'firstNineAvgCount': playerOrTeamGameStatsX01.getFirstNineAvgCount,
        'currentThrownDartsInLeg':
            playerOrTeamGameStatsX01.getCurrentThrownDartsInLeg,
        'allThrownDarts': playerOrTeamGameStatsX01.getAllThrownDarts,
        if (playerOrTeamGameStatsX01.getThrownDartsPerLeg.isNotEmpty)
          'thrownDartsPerLeg': playerOrTeamGameStatsX01.getThrownDartsPerLeg,
        'dartsForWonLegCount': playerOrTeamGameStatsX01.getDartsForWonLegCount,
        'gameWon': playerOrTeamGameStatsX01.getGameWon,
        'legsWon': playerOrTeamGameStatsX01.getLegsWon,
        'legsWonTotal': playerOrTeamGameStatsX01.getLegsWonTotal,
        if (gameSettingsX01.getSetsEnabled)
          'setsWon': playerOrTeamGameStatsX01.getSetsWon,
        if (playerOrTeamGameStatsX01.getAllScoresPerLeg.isNotEmpty)
          'allScoresPerLeg': playerOrTeamGameStatsX01.getAllScoresPerLeg,
        if (playerOrTeamGameStatsX01.getLegsCount.isNotEmpty)
          'legsCount': playerOrTeamGameStatsX01.getLegsCount,
        if (playerOrTeamGameStatsX01.getCheckouts.isNotEmpty)
          'checkouts': playerOrTeamGameStatsX01.getCheckouts,
        if (playerOrTeamGameStatsX01.getCheckoutCount > 0)
          'checkoutDarts': playerOrTeamGameStatsX01.getCheckoutCount,
        //todo add _checkoutCountAtThrownDarts
        if (playerOrTeamGameStatsX01.getRoundedScoresEven.isNotEmpty)
          'roundedScoresEven':
              _getRoundedScoresEvenWithStringKey(playerOrTeamGameStatsX01),
        if (playerOrTeamGameStatsX01.getRoundedScoresOdd.isNotEmpty)
          'roundedScoresOdd':
              _getRoundedScoresOddWithStringKey(playerOrTeamGameStatsX01),
        if (playerOrTeamGameStatsX01.getPreciseScores.isNotEmpty)
          'preciseScores':
              _getPreciseScoresWithStringKey(playerOrTeamGameStatsX01),
        if (playerOrTeamGameStatsX01.getAllScores.isNotEmpty)
          'allScores': playerOrTeamGameStatsX01.getAllScores,
        'allScoresCountForRound':
            playerOrTeamGameStatsX01.getAllScoresCountForRound,
        if (playerOrTeamGameStatsX01.getAllScoresPerDart.isNotEmpty)
          'allScoresPerDart': playerOrTeamGameStatsX01.getAllScoresPerDart,
        if (playerOrTeamGameStatsX01
            .getAllScoresPerDartAsStringCount.isNotEmpty)
          'allScoresPerDartAsStringCount':
              playerOrTeamGameStatsX01.getAllScoresPerDartAsStringCount,
        if (playerOrTeamGameStatsX01.getAllScoresPerDartAsString.isNotEmpty)
          'allScoresPerDartAsString':
              playerOrTeamGameStatsX01.getAllScoresPerDartAsString,
        if (playerOrTeamGameStatsX01.getAllRemainingPoints.isNotEmpty)
          'allRemainingPoints': playerOrTeamGameStatsX01.getAllRemainingPoints,
        if (playerOrTeamGameStatsX01.getAllRemainingScoresPerDart.isNotEmpty)
          'allRemainingScoresPerDart':
              playerOrTeamGameStatsX01.getAllRemainingScoresPerDart,
        if (playerOrTeamGameStatsX01.getGameDraw) 'gameDraw': true,
        if (playerOrTeamGameStatsX01.getPlayersWithCheckoutInLeg.isNotEmpty)
          'playersWithCheckoutInLeg':
              playerOrTeamGameStatsX01.getPlayersWithCheckoutInLeg,
        'threeDartModeRoundsCount':
            playerOrTeamGameStatsX01.getThreeDartModeRoundsCount,
        'totalRoundsCount': playerOrTeamGameStatsX01.getTotalRoundsCount,
      };
    }

    return {
      if (playerOrTeamGameStatsX01.getPlayer != null)
        'player': playerOrTeamGameStatsX01.getPlayer
            .toMap(playerOrTeamGameStatsX01.getPlayer),
      if (playerOrTeamGameStatsX01.getTeam != null)
        'team': playerOrTeamGameStatsX01.getTeam
            .toMap(playerOrTeamGameStatsX01.getTeam),
      'mode': _mode,
      'legsWon': playerOrTeamGameStatsX01.getLegsWon,
      'gameId': gameId,
      'dateTime': _dateTime,
      'dateTimeForFiltering':
          DateTime(_dateTime.year, _dateTime.month, _dateTime.day),
      if (gameSettingsX01.getSetsEnabled)
        'setsWon': playerOrTeamGameStatsX01.getSetsWon,
      if (playerOrTeamGameStatsX01.getAllScores.isNotEmpty)
        'average': double.parse(playerOrTeamGameStatsX01.getAverage()),
      if (playerOrTeamGameStatsX01.getAllScores.isNotEmpty)
        'firstNineAvgPoints': playerOrTeamGameStatsX01.getFirstNineAvgPoints,
      if (playerOrTeamGameStatsX01.getFirstNineAvgCount > 0)
        'firstNineAvgCount': playerOrTeamGameStatsX01.getFirstNineAvgCount,
      if (playerOrTeamGameStatsX01.getFirstNineAvgCount > 0)
        'firstNineAvg':
            double.parse(playerOrTeamGameStatsX01.getFirstNinveAvg()),
      if (playerOrTeamGameStatsX01.getAllScores.isNotEmpty)
        'highestScore': playerOrTeamGameStatsX01.getHighestScore(),
      if (gameSettingsX01.getEnableCheckoutCounting &&
          playerOrTeamGameStatsX01.getCheckouts.isNotEmpty)
        'checkoutInPercent': checkoutQuote == '-'
            ? 0
            : double.parse(
                checkoutQuote.substring(0, checkoutQuote.length - 1)),
      if (playerOrTeamGameStatsX01.getCheckoutCount > 0)
        'checkoutDarts': playerOrTeamGameStatsX01.getCheckoutCount,
      if (playerOrTeamGameStatsX01.getAllThrownDarts > 0)
        'allThrownDarts': playerOrTeamGameStatsX01.getAllThrownDarts,
      if (playerOrTeamGameStatsX01.getCheckouts.isNotEmpty)
        'highestFinish': playerOrTeamGameStatsX01.getHighestCheckout(),
      if (playerOrTeamGameStatsX01.getCheckouts.isNotEmpty)
        'checkouts': playerOrTeamGameStatsX01.getCheckouts,
      if (playerOrTeamGameStatsX01.getCheckouts.isNotEmpty)
        'bestLeg': int.parse(playerOrTeamGameStatsX01.getBestLeg()),
      if (playerOrTeamGameStatsX01.getCheckouts.isNotEmpty)
        'worstLeg': int.parse((playerOrTeamGameStatsX01.getWorstLeg())),
      if (playerOrTeamGameStatsX01.getAllScores.isNotEmpty)
        'allScores': playerOrTeamGameStatsX01.getAllScores,
      if (playerOrTeamGameStatsX01.getAllScoresPerDart.isNotEmpty)
        'allScoresPerDart': playerOrTeamGameStatsX01.getAllScoresPerDart,
      if (playerOrTeamGameStatsX01.getRoundedScoresEven.isNotEmpty)
        'roundedScoresEven':
            _getRoundedScoresEvenWithStringKey(playerOrTeamGameStatsX01),
      if (playerOrTeamGameStatsX01.getRoundedScoresOdd.isNotEmpty)
        'roundedScoresOdd':
            _getRoundedScoresOddWithStringKey(playerOrTeamGameStatsX01),
      if (playerOrTeamGameStatsX01.getPreciseScores.isNotEmpty)
        'preciseScores':
            _getPreciseScoresWithStringKey(playerOrTeamGameStatsX01),
      if (playerOrTeamGameStatsX01.getAllScoresPerDartAsStringCount.isNotEmpty)
        'allScoresPerDartAsStringCount':
            playerOrTeamGameStatsX01.getAllScoresPerDartAsStringCount,
      if (playerOrTeamGameStatsX01.getAllScoresPerDartAsString.isNotEmpty)
        'allScoresPerDartAsString':
            playerOrTeamGameStatsX01.getAllScoresPerDartAsString,
      if (playerOrTeamGameStatsX01.getThrownDartsPerLeg.isNotEmpty)
        'thrownDartsPerLeg': playerOrTeamGameStatsX01.getThrownDartsPerLeg,
      'legsWonTotal': playerOrTeamGameStatsX01.getLegsWonTotal,
      if (playerOrTeamGameStatsX01.getAllScoresPerLeg.isNotEmpty)
        'allScoresPerLeg': playerOrTeamGameStatsX01.getAllScoresPerLeg,
      'gameWon': playerOrTeamGameStatsX01.getGameWon,
      'allScoresCountForRound':
          playerOrTeamGameStatsX01.getAllScoresCountForRound,
      'totalPoints': playerOrTeamGameStatsX01.getTotalPoints,
      'dartsForWonLegCount': playerOrTeamGameStatsX01.getDartsForWonLegCount,
      if (playerOrTeamGameStatsX01.getGameDraw) 'gameDraw': true,
      if (playerOrTeamGameStatsX01.getPlayersWithCheckoutInLeg.isNotEmpty)
        'playersWithCheckoutInLeg':
            playerOrTeamGameStatsX01.getPlayersWithCheckoutInLeg,
      'threeDartModeRoundsCount':
          playerOrTeamGameStatsX01.getThreeDartModeRoundsCount,
      'totalRoundsCount': playerOrTeamGameStatsX01.getTotalRoundsCount,
    };
  }

  get getPlayer => this._player;
  set setPlayer(value) => this._player = value;

  get getTeam => this._team;

  set setTeam(value) => this._team = value;

  get getGameId => this._gameId;

  get getMode => this._mode;

  get getDateTime => this._dateTime;

  Map<String, int> _getRoundedScoresOddWithStringKey(
      PlayerOrTeamGameStatisticsX01 stats) {
    Map<String, int> result = {};
    for (var entry in stats.getRoundedScoresOdd.entries) {
      result[entry.key.toString()] = entry.value;
    }

    return result;
  }

  Map<String, int> _getRoundedScoresEvenWithStringKey(
      PlayerOrTeamGameStatisticsX01 stats) {
    Map<String, int> result = {};
    for (var entry in stats.getRoundedScoresEven.entries) {
      result[entry.key.toString()] = entry.value;
    }

    return result;
  }

  Map<String, int> _getPreciseScoresWithStringKey(
      PlayerOrTeamGameStatisticsX01 stats) {
    Map<String, int> result = {};
    for (var entry in stats.getPreciseScores.entries) {
      result[entry.key.toString()] = entry.value;
    }

    return result;
  }
}
