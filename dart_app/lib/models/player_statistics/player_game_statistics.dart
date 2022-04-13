import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/models/player_statistics/player_game_statistics_x01.dart';

class PlayerGameStatistics {
  final Player _player;
  String? _gameId; //to reference the corresponding game -> calc stats
  final String _mode; //e.g. X01, Cricket.. -> calc stats
  final DateTime _dateTime;

  PlayerGameStatistics(
      {required Player player,
      required String mode,
      required DateTime dateTime})
      : _player = player,
        _mode = mode,
        _dateTime = dateTime;

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
        "checkoutInPercent":
            double.parse(checkoutQuote.substring(0, checkoutQuote.length - 1)),
      if (playerGameStatisticsX01.getCheckoutCount > 0)
        "checkoutDarts": playerGameStatisticsX01.getCheckoutCount,
      if (playerGameStatisticsX01.getCheckouts.isNotEmpty)
        "highestFinish": playerGameStatisticsX01.getHighestCheckout(),
      if (playerGameStatisticsX01.getCheckouts.isNotEmpty)
        "checkouts": playerGameStatisticsX01.getCheckouts,
      if (playerGameStatisticsX01.getCheckouts.isNotEmpty)
        "bestLeg": int.parse(playerGameStatisticsX01
            .getBestLeg(gameX01.getGameSettings.getPointsOrCustom())),
      if (playerGameStatisticsX01.getCheckouts.isNotEmpty)
        "worstLeg": int.parse((playerGameStatisticsX01
            .getWorstLeg(gameX01.getGameSettings.getPointsOrCustom()))),
      if (playerGameStatisticsX01.getAllScores.isNotEmpty)
        "allScores": playerGameStatisticsX01.getAllScores,
      if (playerGameStatisticsX01.getAllScoresPerDart.isNotEmpty)
        "allScoresPerDart": playerGameStatisticsX01.getAllScoresPerDart,
      if (playerGameStatisticsX01.getRoundedScores.isNotEmpty)
        "roundedScores":
            playerGameStatisticsX01.getRoundedScoresWithStringKey(),
      if (playerGameStatisticsX01.getPreciseScores.isNotEmpty)
        "preciseScores":
            playerGameStatisticsX01.getPreciseScoresWithStringKey(),
      if (playerGameStatisticsX01.getAllScoresPerDartAsStringCount.isNotEmpty)
        "allScoresPerDartWithCount":
            playerGameStatisticsX01.getAllScoresPerDartAsStringCount,
      if (playerGameStatisticsX01.getThrownDartsPerLeg.isNotEmpty)
        "thrownDartsPerLeg": playerGameStatisticsX01.getThrownDartsPerLeg,
      "gameWon": playerGameStatisticsX01.getGameWon,
    };
  }

  get getPlayer => this._player;

  get getGameId => this._gameId;

  get getMode => this._mode;

  get getDateTime => this._dateTime;
}
