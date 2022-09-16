import 'dart:collection';

import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/models/player_statistics/player_game_statistics_x01.dart';
import 'package:flutter/material.dart';

class Utils {
  static MaterialStateProperty<Color> getDefaultOverlayColor(
      BuildContext context) {
    return Utils.getColorOrPressed(Theme.of(context).colorScheme.primary,
        Utils.darken(Theme.of(context).colorScheme.primary, 15));
  }

  static MaterialStateProperty<Color> getColor(Color color) {
    return MaterialStateProperty.all<Color>(color);
  }

  static MaterialStateProperty<Color> getColorOrPressed(
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
    mapToSort = Map.from(mapToSort);
    return new SplayTreeMap<int, int>.from(
        mapToSort, (a, b) => mapToSort[b] > mapToSort[a] ? 1 : -1);
  }

  static Map<int, int> sortMapIntIntByKey(Map<dynamic, dynamic> mapToSort) {
    Map<int, int> sortedMapByValues = Utils.sortMapIntInt(mapToSort);
    sortedMapByValues = Map.from(sortedMapByValues);

    Map<int, int> result = {};
    int currentValueToSkip = -1;
    for (int value in sortedMapByValues.values) {
      if (value != currentValueToSkip) {
        List<int> keysWithValue =
            getIntKeysWithValueSorted(sortedMapByValues, value);
        Map<int, int> sortedMap =
            getSortedMapIntInt(sortedMapByValues, keysWithValue);
        result.addAll(sortedMap);
      }
      currentValueToSkip = value;
    }

    return result;
  }

  static Map<String, int> sortMapStringIntByKey(
      Map<dynamic, dynamic> mapToSort) {
    Map<String, int> sortedMapByValues = Utils.sortMapStringInt(mapToSort);
    sortedMapByValues = Map.from(sortedMapByValues);

    Map<String, int> result = {};
    int currentValueToSkip = -1;
    for (int value in sortedMapByValues.values) {
      if (value != currentValueToSkip) {
        List<String> keysWithValue =
            getStringKeysWithValueSorted(sortedMapByValues, value);
        Map<String, int> sortedMap =
            getSortedMapStringInt(sortedMapByValues, keysWithValue);
        result.addAll(sortedMap);
      }
      currentValueToSkip = value;
    }

    return result;
  }

  static Map<int, int> sortMapIntIntByElement(Map<dynamic, dynamic> mapToSort) {
    return new SplayTreeMap<int, int>.from(
        mapToSort, (a, b) => mapToSort[b] > mapToSort[a] ? 1 : -1);
  }

  static Map<String, int> sortMapStringInt(Map<dynamic, dynamic> mapToSort) {
    mapToSort = Map.from(mapToSort);
    return new SplayTreeMap<String, int>.from(
        mapToSort, (a, b) => mapToSort[b] > mapToSort[a] ? 1 : -1);
  }

  static String getWinnerOfLeg(String setLegString, Game? game) {
    int currentPoints;
    for (PlayerGameStatisticsX01 playerGameStatistics
        in game!.getPlayerGameStatistics) {
      currentPoints = game.getGameSettings.getPointsOrCustom();
      for (int score in playerGameStatistics.getAllScoresPerLeg[setLegString]) {
        currentPoints -= score;
      }
      if (currentPoints == 0) {
        return playerGameStatistics.getPlayer.getName;
      }
    }

    return '';
  }

  static String getAverageForLeg(
      PlayerGameStatisticsX01 playerGameStatisticsX01, String setLegString) {
    double result = 0;
    for (int score
        in playerGameStatisticsX01.getAllScoresPerLeg[setLegString]) {
      result += score;
    }

    result /= (playerGameStatisticsX01.getThrownDartsPerLeg[setLegString] / 3);

    return result.toStringAsFixed(2);
  }

  static int getMostOccurringValue(Map<int, int> map) {
    int mostOccuringValue = 0;
    map.forEach((key, value) {
      if (value > mostOccuringValue) {
        mostOccuringValue = value;
      }
    });

    return mostOccuringValue;
  }

  /* HELPER METHODS FOR SORTING MAPS*/
  static List<int> getIntKeysWithValueSorted(Map<int, int> map, int value) {
    List<int> result = [];
    map.forEach((key, _value) {
      if (_value == value) {
        result.add(key);
      }
    });
    result.sort();
    result = result.reversed.toList();
    return result;
  }

  static List<String> getStringKeysWithValueSorted(
      Map<String, int> map, int value) {
    List<String> result = [];
    map.forEach((key, _value) {
      if (_value == value) {
        result.add(key);
      }
    });
    result.sort();
    result = result.reversed.toList();

    return sortTrippleDoubleKeys(result);
  }

  static List<String> sortTrippleDoubleKeys(List<String> keys) {
    List<int> tripples = [];
    List<int> doubles = [];
    List<int> singles = [];
    List<String> result = [];

    for (String key in keys) {
      if (key[0] == 'T') {
        tripples.add(int.parse(key.substring(1)));
      } else if (key[0] == 'D') {
        doubles.add(int.parse(key.substring(1)));
      } else {
        singles.add(int.parse(key));
      }
    }

    tripples.sort();
    tripples = tripples.reversed.toList();
    doubles.sort();
    doubles = doubles.reversed.toList();
    singles.sort();
    singles = singles.reversed.toList();

    List<String> temp = [];
    for (int tripple in tripples) {
      temp.add('T' + tripple.toString());
    }
    result.addAll(temp);
    temp = [];
    for (int double in doubles) {
      temp.add('D' + double.toString());
    }
    result.addAll(temp);
    temp = [];
    for (int single in singles) {
      temp.add(single.toString());
    }
    result.addAll(temp);

    return result;
  }

  static Map<int, int> getSortedMapIntInt(Map<int, int> map, List<int> keys) {
    Map<int, int> result = {};

    for (int key in keys) {
      if (map.containsKey(key)) {
        result[key] = map[key] as int;
      }
    }

    return result;
  }

  static Map<String, int> getSortedMapStringInt(
      Map<String, int> map, List<String> keys) {
    Map<String, int> result = {};

    for (String key in keys) {
      if (map.containsKey(key)) {
        result[key] = map[key] as int;
      }
    }

    return result;
  }

  static String getLevelForBot(int selectedBotAvgValue) {
    switch (selectedBotAvgValue) {
      case 22:
        return '1';
      case 26:
        return '2';
      case 30:
        return '3';
      case 34:
        return '4';
      case 38:
        return '5';
      case 42:
        return '6';
      case 46:
        return '7';
      case 50:
        return '8';
      case 54:
        return '9';
      case 58:
        return '10';
      case 62:
        return '11';
      case 66:
        return '12';
      case 70:
        return '13';
      case 74:
        return '14';
      case 78:
        return '15';
      case 82:
        return '16';
      case 86:
        return '17';
      case 90:
        return '18';
      case 94:
        return '19';
      case 98:
        return '20';
      case 102:
        return '21';
      case 106:
        return '22';
      case 110:
        return '23';
      case 114:
        return '24';
      case 118:
        return '25';
    }
    return '';
  }

  static double getHeightForWidget(GameSettingsX01 gameSettingsX01) {
    if (gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Team &&
        gameSettingsX01.getPlayers.length >= 4 &&
        !gameSettingsX01.getSetsEnabled &&
        gameSettingsX01.getLegs > 1 &&
        !gameSettingsX01.getWinByTwoLegsDifference &&
        !gameSettingsX01.getDrawMode &&
        gameSettingsX01.getModeOut == ModeOutIn.Double) {
      return WIDGET_HEIGHT_GAMESETTINGS_TEAM;
    }
    return WIDGET_HEIGHT_GAMESETTINGS;
  }
}
