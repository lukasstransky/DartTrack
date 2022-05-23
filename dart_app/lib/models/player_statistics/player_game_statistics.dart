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
      mode: map['mode'],
      dateTime: DateTime.parse(map['dateTime'].toDate().toString()),
      player: new Player(name: map['player']),
      firstNineAvg:
          map['firstNineAverage'] == null ? 0 : map['firstNineAverage'],
      legsWon: map['legsWon'],
      setsWon: map['setsWon'] == null ? 0 : map['setsWon'],
      gameWon: map['gameWon'],
      checkouts: map['checkouts'] == null
          ? {}
          : Map<String, int>.from(map['checkouts']),
      checkoutCount: map['checkoutDarts'] == null ? 0 : map['checkoutDarts'],
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
      allScoresPerDartAsStringCount: map['allScoresPerDartWithCount'] == null
          ? {}
          : Map<String, int>.from(map['allScoresPerDartWithCount']),
      thrownDartsPerLeg: map['thrownDartsPerLeg'] == null
          ? {}
          : Map<String, int>.from(map['thrownDartsPerLeg']),
      allScoresCountForRound: map['allScoresCountForRound'],
      totalPoints: map['totalPoints'],
      allScoresPerLeg: map['allScoresPerLeg'] == null
          ? new SplayTreeMap()
          : SplayTreeMap<String, List<dynamic>>.from(
              map['allScoresPerLeg'],
            ),
      legsWonTotal: map['legsWonTotal'] == null ? 0 : map['legsWonTotal'],
      dartsForWonLegCount: map['dartsForWonLegCount'],
    );
  }

  Map<String, dynamic> toMapX01(PlayerGameStatisticsX01 playerGameStatisticsX01,
      GameX01 gameX01, String gameId) {
    String checkoutQuote = playerGameStatisticsX01.getCheckoutQuoteInPercent();
    return {
      "player": _player.getName,
      "mode": _mode,
      "legsWon": playerGameStatisticsX01.getLegsWon,
      "gameId": gameId,
      "dateTime": _dateTime,
      if (gameX01.getGameSettings.getSetsEnabled)
        "setsWon": playerGameStatisticsX01.getSetsWon,
      if (playerGameStatisticsX01.getAllScores.isNotEmpty)
        "average": double.parse(playerGameStatisticsX01.getAverage(
            gameX01, playerGameStatisticsX01)),
      if (playerGameStatisticsX01.getAllScores.isNotEmpty)
        "firstNineAverage":
            double.parse(playerGameStatisticsX01.getFirstNinveAvg(gameX01)),
      if (playerGameStatisticsX01.getAllScores.isNotEmpty)
        "highestScore": playerGameStatisticsX01.getHighestScore(),
      if (gameX01.getGameSettings.getEnableCheckoutCounting &&
          playerGameStatisticsX01.getCheckouts.isNotEmpty)
        "checkoutInPercent": checkoutQuote == "-"
            ? 0
            : double.parse(
                checkoutQuote.substring(0, checkoutQuote.length - 1)),
      if (playerGameStatisticsX01.getCheckoutCount > 0)
        "checkoutDarts": playerGameStatisticsX01.getCheckoutCount,
      if (playerGameStatisticsX01.getCheckouts.isNotEmpty)
        "highestFinish": playerGameStatisticsX01.getHighestCheckout(),
      if (playerGameStatisticsX01.getCheckouts.isNotEmpty)
        "checkouts": playerGameStatisticsX01.getCheckouts,
      if (playerGameStatisticsX01.getCheckouts.isNotEmpty)
        "bestLeg": int.parse(playerGameStatisticsX01.getBestLeg()),
      if (playerGameStatisticsX01.getCheckouts.isNotEmpty)
        "worstLeg": int.parse((playerGameStatisticsX01.getWorstLeg())),
      if (playerGameStatisticsX01.getAllScores.isNotEmpty)
        "allScores": playerGameStatisticsX01.getAllScores,
      if (playerGameStatisticsX01.getAllScoresPerDart.isNotEmpty)
        "allScoresPerDart": playerGameStatisticsX01.getAllScoresPerDart,
      if (playerGameStatisticsX01.getRoundedScoresEven.isNotEmpty)
        "roundedScoresEven":
            playerGameStatisticsX01.getRoundedScoresEvenWithStringKey(),
      if (playerGameStatisticsX01.getRoundedScoresOdd.isNotEmpty)
        "roundedScoresOdd":
            playerGameStatisticsX01.getRoundedScoresOddWithStringKey(),
      if (playerGameStatisticsX01.getPreciseScores.isNotEmpty)
        "preciseScores":
            playerGameStatisticsX01.getPreciseScoresWithStringKey(),
      if (playerGameStatisticsX01.getAllScoresPerDartAsStringCount.isNotEmpty)
        "allScoresPerDartWithCount":
            playerGameStatisticsX01.getAllScoresPerDartAsStringCount,
      if (playerGameStatisticsX01.getThrownDartsPerLeg.isNotEmpty)
        "thrownDartsPerLeg": playerGameStatisticsX01.getThrownDartsPerLeg,
      "legsWonTotal": playerGameStatisticsX01.getLegsWonTotal,
      if (playerGameStatisticsX01.getAllScoresPerLeg.isNotEmpty)
        "allScoresPerLeg": playerGameStatisticsX01.getAllScoresPerLeg,
      "gameWon": playerGameStatisticsX01.getGameWon,
      "allScoresCountForRound":
          playerGameStatisticsX01.getAllScoresCountForRound,
      "totalPoints": playerGameStatisticsX01.getTotalPoints,
      "dartsForWonLegCount": playerGameStatisticsX01.getDartsForWonLegCount,
    };
  }

  get getPlayer => this._player;

  get getGameId => this._gameId;

  get getMode => this._mode;

  get getDateTime => this._dateTime;
}
