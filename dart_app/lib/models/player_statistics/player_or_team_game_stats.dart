import 'dart:collection';

import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_cricket_p.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/models/player_statistics/player_game_stats_score_training.dart';
import 'package:dart_app/models/player_statistics/player_game_stats_single_double_training.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats_cricket.dart';
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
      required Player? player,
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

  PlayerOrTeamGameStats clone() {
    throw UnimplementedError(
        'clone() not implemented for PlayerOrTeamGameStats');
  }

  get getPlayer => this._player;
  set setPlayer(value) => this._player = value;

  get getTeam => this._team;

  set setTeam(value) => this._team = value;

  get getGameId => this._gameId;
  set setGameId(gameId) => this._gameId = gameId;

  get getMode => this._mode;

  get getDateTime => this._dateTime;

  Map<String, dynamic> toMapX01(
    PlayerOrTeamGameStatsX01 stats,
    GameX01_P game,
    GameSettingsX01_P settings,
    String gameId,
    bool openGame,
    String? currentUserUid,
    String? currentUsername,
  ) {
    final String checkoutQuote = stats.getCheckoutQuoteInPercent();
    final Map<String, int> roundedScoresEven =
        Utils.getMapWithStringKey(stats.getRoundedScoresEven);
    final Map<String, int> roundedScoresOdd =
        Utils.getMapWithStringKey(stats.getRoundedScoresOdd);
    final Map<String, int> preciseScores =
        Utils.getMapWithStringKey(stats.getPreciseScores);

    Map<String, dynamic> result = {
      'mode': _mode,
      'gameId': gameId,
      'dateTime': _dateTime,
      'dateTimeForFiltering':
          DateTime(_dateTime.year, _dateTime.month, _dateTime.day),
      'currentPoints': stats.getCurrentPoints,
      if (stats.getPlayer != null && stats.getPlayer.getName == currentUsername)
        'userId': currentUserUid,
      if (stats.getPlayer != null)
        'player': stats.getPlayer.toMap(stats.getPlayer),
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
      if (settings.getEnableCheckoutCounting && stats.getCheckoutCount > 0)
        'checkoutDarts': stats.getCheckoutCount,
      if (stats.getAllThrownDarts > 0)
        'allThrownDarts': stats.getAllThrownDarts,
      if (stats.getCheckouts.isNotEmpty)
        'highestFinish': stats.getHighestCheckout(),
      if (stats.getCheckouts.isNotEmpty)
        'worstFinish': stats.getWorstCheckout(),
      if (stats.getCheckouts.isNotEmpty)
        'checkouts': stats.getCheckouts.entries
            .map((entry) => '${entry.key};${entry.value}')
            .toList(),
      if (stats.getAmountOfDartsForWonLegs.isNotEmpty)
        'amountOfDartsForWonLegs': stats.getAmountOfDartsForWonLegs,
      if (stats.getAmountOfDartsForWonLegs.isNotEmpty)
        'bestLeg': int.parse(stats.getBestLeg()),
      if (stats.getAmountOfDartsForWonLegs.isNotEmpty)
        'worstLeg': int.parse(stats.getWorstLeg()),
      if (stats.getAllScores.isNotEmpty) 'allScores': stats.getAllScores,
      if (stats.getAllScoresPerDart.isNotEmpty)
        'allScoresPerDart': stats.getAllScoresPerDart,
      if (roundedScoresEven.isNotEmpty) 'roundedScoresEven': roundedScoresEven,
      if (roundedScoresOdd.isNotEmpty) 'roundedScoresOdd': roundedScoresOdd,
      if (preciseScores.isNotEmpty) 'preciseScores': preciseScores,
      if (stats.getAllScoresPerDartAsStringCount.isNotEmpty)
        'allScoresPerDartAsStringCount': stats.getAllScoresPerDartAsStringCount,
      if (stats.getThrownDartsPerLeg.isNotEmpty)
        'thrownDartsPerLeg': stats.getThrownDartsPerLeg.entries
            .map((entry) => '${entry.key};${entry.value}')
            .toList(),
      if (stats.getLegsWonTotal != 0) 'legsWonTotal': stats.getLegsWonTotal,
      if (stats.getAllScoresPerLeg.isNotEmpty)
        'allScoresPerLeg': stats.getAllScoresPerLeg.entries
            .map((entry) => "${entry.key};${entry.value.join(',')}")
            .toList(),
      if (stats.getGameWon) 'gameWon': stats.getGameWon,
      if (stats.getAllScoresCountForRound != 0)
        'allScoresCountForRound': stats.getAllScoresCountForRound,
      if (stats.getTotalPoints != 0) 'totalPoints': stats.getTotalPoints,
      if (stats.getDartsForWonLegCount != 0)
        'dartsForWonLegCount': stats.getDartsForWonLegCount,
      if (stats.getGameDraw) 'gameDraw': true,
      if (stats.getPlayersWithCheckoutInLeg.isNotEmpty)
        'playersWithCheckoutInLeg': stats.getPlayersWithCheckoutInLeg.entries
            .map((entry) => '${entry.key};${entry.value}')
            .toList(),
      if (stats.getThreeDartModeRoundsCount != 0)
        'threeDartModeRoundsCount': stats.getThreeDartModeRoundsCount,
      if (stats.getTotalRoundsCount != 0)
        'totalRoundsCount': stats.getTotalRoundsCount,
    };

    if (openGame) {
      if (stats.getLegsCount.isNotEmpty)
        result['legsCount'] = stats.getLegsCount;
      if (stats.getAmountOfFinishDarts.isNotEmpty)
        result['amountOfFinishDarts'] = stats.getAmountOfFinishDarts.entries
            .map((entry) => '${entry.key};${entry.value}')
            .toList();
      if (stats.getAllScoresPerDartAsString.isNotEmpty)
        result['allScoresPerDartAsString'] = stats.getAllScoresPerDartAsString;
      if (stats.getAllRemainingPoints.isNotEmpty)
        result['allRemainingPoints'] = stats.getAllRemainingPoints;
      if (stats.getAllRemainingScoresPerDart.isNotEmpty)
        result['allRemainingScoresPerDart'] =
            Utils.convertDoubleListToSimpleList(
                stats.getAllRemainingScoresPerDart);
      if (stats.getLegSetWithPlayerOrTeamWhoFinishedIt.isNotEmpty)
        result['setLegWithPlayerOrTeamWhoFinishedIt'] = stats
            .getLegSetWithPlayerOrTeamWhoFinishedIt.entries
            .map((entry) => '${entry.key};${entry.value}')
            .toList();
      if (stats.getInputMethodForRounds.isNotEmpty)
        result['inputMethodForRounds'] = stats.getInputMethodForRounds
            .map((e) => e.toString().split('.').last)
            .toList();
      result['currentThrownDartsInLeg'] = stats.getCurrentThrownDartsInLeg;
      result['checkoutCountAtThrownDarts'] =
          stats.getCheckoutCountAtThrownDarts.map((tuple) {
        return '${tuple.item1};${tuple.item2};${tuple.item3}';
      }).toList();
    }

    return result;
  }

  Map<String, dynamic> toMapScoreTraining(
      PlayerGameStatsScoreTraining stats, String gameId, bool openGame) {
    final Map<String, int> roundedScoresEven =
        Utils.getMapWithStringKey(stats.getRoundedScoresEven);
    final Map<String, int> roundedScoresOdd =
        Utils.getMapWithStringKey(stats.getRoundedScoresOdd);
    final Map<String, int> preciseScores =
        Utils.getMapWithStringKey(stats.getPreciseScores);

    Map<String, dynamic> result = {
      'player': stats.getPlayer.toMap(stats.getPlayer),
      'mode': getMode,
      'gameId': gameId,
      'dateTime': getDateTime,
      if (stats.getCurrentScore != 0) 'currentScore': stats.getCurrentScore,
      if (stats.getAllScoresPerDartAsStringCount.isNotEmpty)
        'allScoresPerDartAsStringCount': stats.getAllScoresPerDartAsStringCount,
      if (roundedScoresEven.isNotEmpty) 'roundedScoresEven': roundedScoresEven,
      if (roundedScoresOdd.isNotEmpty) 'roundedScoresOdd': roundedScoresOdd,
      if (preciseScores.isNotEmpty) 'preciseScores': preciseScores,
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
            Utils.convertDoubleListToSimpleList(
                stats.getAllRemainingScoresPerDart);
      if (stats.getAllScoresPerDartAsString.isNotEmpty)
        result['allScoresPerDartAsString'] = stats.getAllScoresPerDartAsString;
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
      'highestPoints': stats.getHighestPoints,
    };

    if (openGame) {
      result['allHits'] = stats.getAllHits;
    }

    return result;
  }

  Map<String, dynamic> toMapCricket(PlayerOrTeamGameStatsCricket stats,
      GameSettingsCricket_P settings, String gameId, bool openGame) {
    Map<String, dynamic> result = {
      if (stats.getPlayer != null)
        'player': stats.getPlayer.toMap(stats.getPlayer),
      'mode': getMode,
      'gameId': gameId,
      'dateTime': getDateTime,
      if (stats.getPlayer != null)
        'player': stats.getPlayer.toMap(stats.getPlayer),
      if (stats.getTeam != null) 'team': stats.getTeam.toMap(stats.getTeam),
      if (stats.getCurrentPoints != 0) 'currentPoints': stats.getCurrentPoints,
      if (stats.getTotalPoints != 0) 'totalPoints': stats.getTotalPoints,
      if (stats.getPointsPerLeg.isNotEmpty)
        'pointsPerLeg': stats.getPointsPerLeg,
      if (stats.getScoresOfNumbers.isNotEmpty)
        'scoresOfNumbers': Utils.getMapWithStringKey(stats.getScoresOfNumbers),
      if (stats.getPointsPerNumbers.isNotEmpty)
        'pointsPerNumbers':
            Utils.getMapWithStringKey(stats.getPointsPerNumbers),
      if (stats.getLegsWon != 0) 'legsWon': stats.getLegsWon,
      if (settings.getSetsEnabled) 'setsWon': stats.getSetsWon,
      if (settings.getSetsEnabled) 'legsWonTotal': stats.getLegsWonTotal,
      if (stats.getThrownDarts != 0) 'thrownDarts': stats.getThrownDarts,
      if (stats.getTotalMarks != 0) 'totalMarks': stats.getTotalMarks,
    };

    if (openGame) {
      if (stats.getThrownDartsInLeg != 0)
        result['thrownDartsInLeg'] = stats.getThrownDartsInLeg;
      if (stats.getThrownDartsPerLeg.isNotEmpty)
        result['thrownDartsPerLeg'] = stats.getThrownDartsPerLeg;

      if (stats.getAllScoresPerDart.isNotEmpty)
        result['allScoresPerDart'] = stats.getAllScoresPerDart;
      if (stats.getScoresOfNumbersPerLeg.isNotEmpty)
        result['scoresOfNumbersPerLeg'] =
            stats.getScoresOfNumbersPerLeg.map((map) {
          return map.map((key, value) => MapEntry(key.toString(), value));
        }).toList();
      if (stats.getCurrentThreeDartsBeforeLegFinished.isNotEmpty)
        result['currentThreeDartsBeforeLegFinished'] =
            Utils.convertDoubleListToSimpleList(
                stats.getCurrentThreeDartsBeforeLegFinished);
      if (stats.getAmountOfLegsPerSet.isNotEmpty)
        result['amountOfLegsPerSet'] = stats.getAmountOfLegsPerSet;
    }

    return result;
  }

  LinkedHashMap<String, String> convertFieldHitsMapForUploading(
      LinkedHashMap<int, String> toConvert) {
    LinkedHashMap<String, String> result = new LinkedHashMap();

    toConvert.forEach((key, value) {
      result[key.toString()] = value;
    });

    return result;
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
      allScoresPerDartAsString: map['allScoresPerDartAsString'] == null
          ? []
          : map['allScoresPerDartAsString'].cast<String>(),
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
    LinkedHashMap<int, String> fieldHits = new LinkedHashMap();

    map['fieldHits'].forEach((key, value) {
      fieldHits[int.parse(key)] = value;
    });

    return PlayerGameStatsSingleDoubleTraining.Firestore(
      gameId: map['gameId'],
      dateTime: DateTime.parse(map['dateTime'].toDate().toString()),
      mode: map['mode'],
      player: Player.fromMap(map['player']),
      totalPoints: map['totalPoints'] != null ? map['totalPoints'] : 0,
      thrownDarts: map['thrownDarts'] != null ? map['thrownDarts'] : 0,
      singleHits: map['singleHits'] != null ? map['singleHits'] : 0,
      doubleHits: map['doubleHits'] != null ? map['doubleHits'] : 0,
      trippleHits: map['trippleHits'] != null ? map['trippleHits'] : 0,
      missedHits: map['missedHits'] != null ? map['missedHits'] : 0,
      fieldHits: fieldHits,
      allHits: map['allHits'] != null ? map['allHits'].cast<String>() : [],
      highestPoints: map['highestPoints'] != null ? map['highestPoints'] : 0,
    );
  }

  factory PlayerOrTeamGameStats.fromMapCricket(map) {
    return PlayerOrTeamGameStatsCricket.Firestore(
      gameId: map['gameId'],
      dateTime: DateTime.parse(map['dateTime'].toDate().toString()),
      mode: map['mode'],
      player: map['player'] == null ? null : Player.fromMap(map['player']),
      team: map['team'] == null ? null : Team.fromMap(map['team']),
      allScoresPerDart: map['allScoresPerDart'] != null
          ? map['allScoresPerDart'].cast<String>()
          : [],
      amountOfLegsPerSet: map['amountOfLegsPerSet'] != null
          ? map['amountOfLegsPerSet'].cast<int>()
          : [],
      currentPoints: map['currentPoints'] != null ? map['currentPoints'] : 0,
      totalPoints: map['totalPoints'] != null ? map['totalPoints'] : 0,
      legsWon: map['legsWon'] != null ? map['legsWon'] : 0,
      legsWonTotal: map['legsWonTotal'] != null ? map['legsWonTotal'] : 0,
      pointsPerLeg:
          map['pointsPerLeg'] != null ? map['pointsPerLeg'].cast<int>() : [],
      pointsPerNumbers: map['pointsPerNumbers'] != null
          ? Map<String, int>.from(map['pointsPerNumbers'])
          : {},
      scoresOfNumbers: map['scoresOfNumbers'] != null
          ? Map<String, int>.from(map['scoresOfNumbers'])
          : {},
      setsWon: map['setsWon'] != null ? map['setsWon'] : 0,
      thrownDarts: map['thrownDarts'] != null ? map['thrownDarts'] : 0,
      totalMarks: map['totalMarks'] != null ? map['totalMarks'] : 0,
      thrownDartsInLeg:
          map['thrownDartsInLeg'] != null ? map['thrownDartsInLeg'] : 0,
      thrownDartsPerLeg: map['thrownDartsPerLeg'] != null
          ? map['thrownDartsPerLeg'].cast<int>()
          : [],
      scoresOfNumbersPerLeg: map['scoresOfNumbersPerLeg'] != null
          ? (map['scoresOfNumbersPerLeg'] as List<dynamic>).map((leg) {
              return Map<int, int>.from(
                  leg.map((k, v) => MapEntry(int.parse(k), v)));
            }).toList()
          : [],
      currentThreeDartsBeforeLegFinished:
          map['currentThreeDartsBeforeLegFinished'] != null
              ? Utils.convertSimpleListBackToDoubleList(
                  map['currentThreeDartsBeforeLegFinished'])
              : [],
    );
  }
}
