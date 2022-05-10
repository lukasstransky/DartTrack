import 'dart:collection';

import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/models/player_statistics/player_game_statistics_x01.dart';
import 'package:flutter/material.dart';

class Utils {
  static MaterialStateProperty<Color> getColor(
      Color color, Color colorPressed) {
    final getColor = (Set<MaterialState> states) {
      if (states.contains(MaterialState.pressed)) {
        return colorPressed;
      } else {
        return color;
      }
    };

    return MaterialStateProperty.resolveWith(getColor);
  }

  static Color darken(Color c, [int percent = 10]) {
    assert(1 <= percent && percent <= 100);
    var f = 1 - percent / 100;
    return Color.fromARGB(c.alpha, (c.red * f).round(), (c.green * f).round(),
        (c.blue * f).round());
  }

  static Map<int, int> sortMapIntInt(Map<dynamic, dynamic> mapToSort) {
    return new SplayTreeMap<int, int>.from(
        mapToSort, (a, b) => mapToSort[b] > mapToSort[a] ? 1 : -1);
  }

  static Map<String, int> sortMapStringInt(Map<dynamic, dynamic> mapToSort) {
    return new SplayTreeMap<String, int>.from(
        mapToSort, (a, b) => mapToSort[b] > mapToSort[a] ? 1 : -1);
  }

  static String getWinnerOfLeg(String setLegString, Game? game) {
    num currentPoints;
    for (PlayerGameStatisticsX01 playerGameStatistics
        in game!.getPlayerGameStatistics) {
      currentPoints = game.getGameSettings.getPointsOrCustom();
      for (num score in playerGameStatistics.getAllScoresPerLeg[setLegString]) {
        currentPoints -= score;
      }
      if (currentPoints == 0) {
        return playerGameStatistics.getPlayer.getName;
      }
    }

    return "";
  }

  static String getAverageForLeg(
      PlayerGameStatisticsX01 playerGameStatisticsX01, String setLegString) {
    num result = 0;
    for (num score
        in playerGameStatisticsX01.getAllScoresPerLeg[setLegString]) {
      result += score;
    }

    result /= (playerGameStatisticsX01.getThrownDartsPerLeg[setLegString] / 3);

    return result.toStringAsFixed(2);
  }

  static num getMostOccurringValue(Map<int, int> map) {
    num mostOccuringValue = 0;
    map.forEach((key, value) {
      if (value > mostOccuringValue) {
        mostOccuringValue = value;
      }
    });

    return mostOccuringValue;
  }
}
