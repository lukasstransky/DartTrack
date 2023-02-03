import 'dart:collection';

import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/models/player_statistics/player_game_stats_score_training.dart';
import 'package:dart_app/models/player_statistics/player_game_stats_single_double_training.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats_x01.dart';
import 'package:dart_app/models/team.dart';
import 'package:dart_app/utils/utils.dart';

class PlayerOrTeamGameStats {
  Player? _player;
  Team? _team;
  String? _gameId; // to reference the corresponding game -> calc stats
  final String _mode; // e.g. X01, Cricket.. -> calc stats
  final DateTime _dateTime;

  PlayerOrTeamGameStats(
      {required String gameId,
      required String mode,
      required DateTime dateTime})
      : _gameId = gameId,
        _mode = mode,
        _dateTime = dateTime;

  PlayerOrTeamGameStats.Player(
      {required String gameId,
      required Player player,
      required String mode,
      required DateTime dateTime})
      : _gameId = gameId,
        _player = player,
        _mode = mode,
        _dateTime = dateTime;

  PlayerOrTeamGameStats.Team(
      {required String gameId,
      required Team team,
      required String mode,
      required DateTime dateTime})
      : _gameId = gameId,
        _team = team,
        _mode = mode,
        _dateTime = dateTime;

  get getPlayer => this._player;
  set setPlayer(value) => this._player = value;

  get getTeam => this._team;

  set setTeam(value) => this._team = value;

  get getGameId => this._gameId;

  get getMode => this._mode;

  get getDateTime => this._dateTime;

  Map<String, dynamic> toMapX01(PlayerOrTeamGameStatsX01 stats, GameX01_P game,
      GameSettingsX01_P settings, String gameId, bool openGame) {
    String checkoutQuote = stats.getCheckoutQuoteInPercent();

    Map<String, dynamic> result = {
      'player': stats.getPlayer.toMap(stats.getPlayer),
      'mode': _mode,
      'gameId': gameId,
      'dateTime': _dateTime,
      'dateTimeForFiltering':
          DateTime(_dateTime.year, _dateTime.month, _dateTime.day),
      if (stats.getLegsWon != 0) 'legsWon': stats.getLegsWon,
      if (stats.getTeam != null) 'team': stats.getTeam.toMap(stats.getTeam),
      if (settings.getSetsEnabled) 'setsWon': stats.getSetsWon,
      if (stats.getAllScores.isNotEmpty)
        'average': double.parse(stats.getAverage()),
      if (stats.getAllScores.isNotEmpty)
        'firstNineAvgPoints': stats.getFirstNineAvgPoints,
      if (stats.getFirstNineAvgCount > 0)
        'firstNineAvgCount': stats.getFirstNineAvgCount,
      if (stats.getFirstNineAvgCount > 0)
        'firstNineAvg': double.parse(stats.getFirstNinveAvg()),
      if (stats.getAllScores.isNotEmpty)
        'highestScore': stats.getHighestScore(),
      if (settings.getEnableCheckoutCounting && stats.getCheckouts.isNotEmpty)
        'checkoutInPercent': checkoutQuote == '-'
            ? 0
            : double.parse(
                checkoutQuote.substring(0, checkoutQuote.length - 1)),
      if (stats.getCheckoutCount > 0) 'checkoutDarts': stats.getCheckoutCount,
      if (stats.getAllThrownDarts > 0)
        'allThrownDarts': stats.getAllThrownDarts,
      if (stats.getCheckouts.isNotEmpty)
        'highestFinish': stats.getHighestCheckout(),
      if (stats.getCheckouts.isNotEmpty) 'checkouts': stats.getCheckouts,
      if (stats.getCheckouts.isNotEmpty)
        'bestLeg': int.parse(stats.getBestLeg()),
      if (stats.getCheckouts.isNotEmpty)
        'worstLeg': int.parse((stats.getWorstLeg())),
      if (stats.getAllScores.isNotEmpty) 'allScores': stats.getAllScores,
      if (stats.getAllScoresPerDart.isNotEmpty)
        'allScoresPerDart': stats.getAllScoresPerDart,
      if (stats.getRoundedScoresEven.isNotEmpty)
        'roundedScoresEven': _getRoundedScoresEvenWithStringKey(stats),
      if (stats.getRoundedScoresOdd.isNotEmpty)
        'roundedScoresOdd': _getRoundedScoresOddWithStringKey(stats),
      if (stats.getPreciseScores.isNotEmpty)
        'preciseScores': _getPreciseScoresWithStringKey(stats),
      if (stats.getAllScoresPerDartAsStringCount.isNotEmpty)
        'allScoresPerDartAsStringCount': stats.getAllScoresPerDartAsStringCount,
      if (stats.getThrownDartsPerLeg.isNotEmpty)
        'thrownDartsPerLeg': stats.getThrownDartsPerLeg,
      if (stats.getLegsWonTotal != 0) 'legsWonTotal': stats.getLegsWonTotal,
      if (stats.getAllScoresPerLeg.isNotEmpty)
        'allScoresPerLeg': stats.getAllScoresPerLeg,
      if (stats.getGameWon) 'gameWon': stats.getGameWon,
      if (stats.getAllScoresCountForRound != 0)
        'allScoresCountForRound': stats.getAllScoresCountForRound,
      if (stats.getLegsWonTotal != 0) 'totalPoints': stats.getTotalPoints,
      if (stats.getDartsForWonLegCount != 0)
        'dartsForWonLegCount': stats.getDartsForWonLegCount,
      if (stats.getGameDraw) 'gameDraw': true,
      if (stats.getPlayersWithCheckoutInLeg.isNotEmpty)
        'playersWithCheckoutInLeg': stats.getPlayersWithCheckoutInLeg,
      if (stats.getThreeDartModeRoundsCount != 0)
        'threeDartModeRoundsCount': stats.getThreeDartModeRoundsCount,
      if (stats.getTotalRoundsCount != 0)
        'totalRoundsCount': stats.getTotalRoundsCount,
    };

    if (openGame) {
      if (stats.getLegsCount.isNotEmpty)
        result['legsCount'] = stats.getLegsCount;
      if (stats.getAmountOfFinishDarts.isNotEmpty)
        result['amountOfFinishDarts'] = stats.getAmountOfFinishDarts;
      if (stats.getAllScoresPerDartAsString.isNotEmpty)
        result['allScoresPerDartAsString'] = stats.getAllScoresPerDartAsString;
      if (stats.getAllRemainingPoints.isNotEmpty)
        result['allRemainingPoints'] = stats.getAllRemainingPoints;
      if (stats.getAllRemainingScoresPerDart.isNotEmpty)
        result['allRemainingScoresPerDart'] =
            Utils.convertAllRemainingScoresPerDartToSimpleList(
                stats.getAllRemainingScoresPerDart);
      if (stats.getLegSetWithPlayerOrTeamWhoFinishedIt.isNotEmpty)
        result['setLegWithPlayerOrTeamWhoFinishedIt'] =
            stats.getLegSetWithPlayerOrTeamWhoFinishedIt;
      if (stats.getInputMethodForRounds.isNotEmpty)
        result['inputMethodForRounds'] = stats.getInputMethodForRounds
            .map((e) => e.toString().split('.').last)
            .toList();
      //todo add _checkoutCountAtThrownDarts
    }

    return result;
  }

  Map<String, dynamic> toMapScoreTraining(
      PlayerGameStatsScoreTraining stats, String gameId, bool openGame) {
    Map<String, dynamic> result = {
      'player': stats.getPlayer.toMap(stats.getPlayer),
      'mode': getMode,
      'gameId': gameId,
      'dateTime': getDateTime,
      if (stats.getCurrentScore != 0) 'currentScore': stats.getCurrentScore,
      if (stats.getAllScoresPerDartAsStringCount.isNotEmpty)
        'allScoresPerDartAsStringCount': stats.getAllScoresPerDartAsStringCount,
      if (stats._getRoundedScoresEvenWithStringKey(stats).isNotEmpty)
        'roundedScoresEven': _getRoundedScoresEvenWithStringKey(stats),
      if (stats._getRoundedScoresOddWithStringKey(stats).isNotEmpty)
        'roundedScoresOdd': _getRoundedScoresOddWithStringKey(stats),
      if (stats._getPreciseScoresWithStringKey(stats).isNotEmpty)
        'preciseScores': _getPreciseScoresWithStringKey(stats),
      if (stats.getThrownDarts != 0) 'thrownDarts': stats.getThrownDarts,
      if (stats.getThreeDartModeRoundsCount != 0)
        'threeDartModeRoundsCount': stats.getThreeDartModeRoundsCount,
      if (stats.getTotalRoundsCount != 0)
        'totalRoundsCount': stats.getTotalRoundsCount,
      if (stats.getAllScores.isNotEmpty)
        'highestScore': stats.getHighestScore(),
      if (stats.getAllScores.isNotEmpty) 'allScores': stats.getAllScores,
    };

    if (openGame) {
      if (stats.getAllScoresPerDart.isNotEmpty)
        result['allScoresPerDart'] = stats.getAllScoresPerDart;
      if (stats.getRoundsOrPointsLeft != 0)
        result['roundsOrPointsLeft'] = stats.getRoundsOrPointsLeft;
      if (stats.getAllScoresPerDart.isNotEmpty)
        result['allScoresPerDart'] = stats.getAllScoresPerDart;
      if (stats.getInputMethodForRounds.isNotEmpty)
        result['inputMethodForRounds'] = stats.getInputMethodForRounds
            .map((e) => e.toString().split('.').last)
            .toList();
      if (stats.getAllRemainingScoresPerDart.isNotEmpty)
        result['allRemainingScoresPerDart'] =
            Utils.convertAllRemainingScoresPerDartToSimpleList(
                stats.getAllRemainingScoresPerDart);
    }

    return result;
  }

  Map<String, dynamic> toMapSingleDoubleTraining(
      PlayerGameStatsSingleDoubleTraining stats, String gameId, bool openGame) {
    Map<String, dynamic> result = {
      'player': stats.getPlayer.toMap(stats.getPlayer),
      'mode': getMode,
      'gameId': gameId,
      'dateTime': getDateTime,
      'totalPoints': stats.getTotalPoints,
      'thrownDarts': stats.getThrownDarts,
      'singleHits': stats.getSingleHits,
      'doubleHits': stats.getDoubleHits,
      'trippleHits': stats.getTrippleHits,
      'missedHits': stats.getMissedHits,
      'fieldHits': convertFieldHitsMapForUploading(stats.getFieldHits),
    };

    if (openGame) {
      result['allHits'] = stats.getAllHits;
    }

    return result;
  }

  SplayTreeMap<String, String> convertFieldHitsMapForUploading(
      SplayTreeMap<int, String> toConvert) {
    SplayTreeMap<String, String> result = new SplayTreeMap();

    toConvert.forEach((key, value) {
      result[key.toString()] = value;
    });

    return result;
  }

  factory PlayerOrTeamGameStats.fromMapX01(map,
      [List<List<String>>? allRemainingScoresPerDart]) {
    List<InputMethod> inputMethodForRounds = [];
    if (map['inputMethodForRounds'] != null) {
      List<String> temp = map['inputMethodForRounds'].cast<String>();

      for (String value in temp) {
        if (value == 'Round') {
          inputMethodForRounds.add(InputMethod.Round);
        } else {
          inputMethodForRounds.add(InputMethod.ThreeDarts);
        }
      }
    }

    return PlayerOrTeamGameStatsX01.Firestore(
      gameId: map['gameId'],
      dateTime: DateTime.parse(map['dateTime'].toDate().toString()),
      mode: map['mode'],
      player: Player.fromMap(map['player']),
      team: map['team'] == null ? null : Team.fromMap(map['team']),
      currentPoints: map['currentPoints'] == null ? 0 : map['currentPoints'],
      totalPoints: map['totalPoints'] == null ? 0 : map['totalPoints'],
      startingPoints: map['startingPoints'] == null ? 0 : map['startingPoints'],
      firstNineAvgPoints:
          map['firstNineAvgPoints'] == null ? 0 : map['firstNineAvgPoints'],
      firstNineAvgCount:
          map['firstNineAvgCount'] == null ? 0 : map['firstNineAvgCount'],
      currentThrownDartsInLeg: map['currentThrownDartsInLeg'] == null
          ? 0
          : map['currentThrownDartsInLeg'],
      allThrownDarts: map['allThrownDarts'] == null ? 0 : map['allThrownDarts'],
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
      allRemainingScoresPerDart:
          allRemainingScoresPerDart == null ? [] : allRemainingScoresPerDart,
      gameDraw: map['gameDraw'] == null ? false : true,
      threeDartModeRoundsCount: map['threeDartModeRoundsCount'] == null
          ? 0
          : map['threeDartModeRoundsCount'],
      totalRoundsCount:
          map['totalRoundsCount'] == null ? 0 : map['totalRoundsCount'],
      amountOfFinishDarts: map['amountOfFinishDarts'] == null
          ? new SplayTreeMap()
          : SplayTreeMap<String, int>.from(map['amountOfFinishDarts']),
      setLegWithPlayerOrTeamWhoFinishedIt:
          map['setLegWithPlayerOrTeamWhoFinishedIt'] == null
              ? {}
              : Map<String, String>.from(
                  map['setLegWithPlayerOrTeamWhoFinishedIt']),
      inputMethodForRounds: map['inputMethodForRounds'] == null
          ? []
          : map['inputMethodForRounds'].cast<InputMethod>(),
    );
  }

  factory PlayerOrTeamGameStats.fromMapScoreTraining(map,
      [List<List<String>>? allRemainingScoresPerDart]) {
    List<InputMethod> inputMethodForRounds = [];
    if (map['inputMethodForRounds'] != null) {
      List<String> temp = map['inputMethodForRounds'].cast<String>();

      for (String value in temp) {
        if (value == 'Round') {
          inputMethodForRounds.add(InputMethod.Round);
        } else {
          inputMethodForRounds.add(InputMethod.ThreeDarts);
        }
      }
    }

    return PlayerGameStatsScoreTraining.Firestore(
      gameId: map['gameId'],
      dateTime: DateTime.parse(map['dateTime'].toDate().toString()),
      mode: map['mode'],
      player: Player.fromMap(map['player']),
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
      allScoresPerDart: map['allScoresPerDart'] == null
          ? []
          : map['allScoresPerDart'].cast<int>(),
      allScoresPerDartAsStringCount:
          map['allScoresPerDartAsStringCount'] == null
              ? {}
              : Map<String, int>.from(map['allScoresPerDartAsStringCount']),
      allRemainingScoresPerDart:
          allRemainingScoresPerDart != null ? allRemainingScoresPerDart : [],
      threeDartModeRoundsCount: map['threeDartModeRoundsCount'] == null
          ? 0
          : map['threeDartModeRoundsCount'],
      totalRoundsCount:
          map['totalRoundsCount'] == null ? 0 : map['totalRoundsCount'],
      thrownDarts: map['thrownDarts'] == null ? 0 : map['thrownDarts'],
      currentScore: map['currentScore'] == null ? 0 : map['currentScore'],
      roundsOrPointsLeft:
          map['roundsOrPointsLeft'] == null ? 0 : map['roundsOrPointsLeft'],
      inputMethodForRounds: inputMethodForRounds,
    );
  }

  factory PlayerOrTeamGameStats.fromMapSingleDoubleTraining(map) {
    SplayTreeMap<int, String> fieldHits = new SplayTreeMap();

    map['fieldHits'].forEach((key, value) {
      fieldHits[int.parse(key)] = value;
    });

    return PlayerGameStatsSingleDoubleTraining.Firestore(
      gameId: map['gameId'],
      dateTime: DateTime.parse(map['dateTime'].toDate().toString()),
      mode: map['mode'],
      player: Player.fromMap(map['player']),
      totalPoints: map['totalPoints'],
      thrownDarts: map['thrownDarts'],
      singleHits: map['singleHits'] != null ? map['singleHits'] : 0,
      doubleHits: map['doubleHits'],
      trippleHits: map['trippleHits'] != null ? map['trippleHits'] : 0,
      missedHits: map['missedHits'],
      fieldHits: fieldHits,
      allHits: map['allHits'] != null ? map['allHits'].cast<String>() : [],
    );
  }

  Map<String, int> _getRoundedScoresOddWithStringKey(dynamic stats) {
    Map<String, int> result = {};
    for (var entry in stats.getRoundedScoresOdd.entries) {
      result[entry.key.toString()] = entry.value;
    }

    return result;
  }

  Map<String, int> _getRoundedScoresEvenWithStringKey(dynamic stats) {
    Map<String, int> result = {};
    for (var entry in stats.getRoundedScoresEven.entries) {
      result[entry.key.toString()] = entry.value;
    }

    return result;
  }

  Map<String, int> _getPreciseScoresWithStringKey(dynamic stats) {
    Map<String, int> result = {};
    for (var entry in stats.getPreciseScores.entries) {
      result[entry.key.toString()] = entry.value;
    }

    return result;
  }
}
