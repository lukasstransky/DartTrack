import 'dart:collection';

import 'package:dart_app/constants.dart';
import 'package:dart_app/models/firestore/stats_firestore_score_training_p.dart';
import 'package:dart_app/models/firestore/stats_firestore_x01_p.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/models/games/game_score_training_p.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats_x01.dart';
import 'package:dart_app/services/firestore/firestore_service_games.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

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

  static Color lighten(Color c, [int percent = 10]) {
    assert(1 <= percent && percent <= 100);
    var p = percent / 100;
    return Color.fromARGB(
        c.alpha,
        c.red + ((255 - c.red) * p).round(),
        c.green + ((255 - c.green) * p).round(),
        c.blue + ((255 - c.blue) * p).round());
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
        final List<String> keysWithValue =
            getStringKeysWithValueSorted(sortedMapByValues, value);
        final Map<String, int> sortedMap =
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

  static String getWinnerOfLeg(
      String setLegString, Game_P? game, BuildContext context) {
    final bool isSingleMode =
        game!.getGameSettings.getSingleOrTeam == SingleOrTeamEnum.Single;

    int currentPoints;
    for (PlayerOrTeamGameStatsX01 playerOrTeamStats
        in Utils.getPlayersOrTeamStatsList(
            game as GameX01_P, game.getGameSettings)) {
      if (Utils.playerStatsDisplayedInTeamMode(game, game.getGameSettings)) {
        PlayerOrTeamGameStatsX01 teamStats =
            (game).getTeamStatsFromPlayer(playerOrTeamStats.getPlayer.getName);
        if (teamStats.getPlayersWithCheckoutInLeg.containsKey(setLegString))
          return teamStats.getPlayersWithCheckoutInLeg[setLegString] as String;
      }

      currentPoints = game.getGameSettings.getPointsOrCustom();

      if (!playerOrTeamStats.getAllScoresPerLeg.containsKey(setLegString)) {
        return '';
      }

      for (int score in playerOrTeamStats.getAllScoresPerLeg[setLegString]) {
        currentPoints -= score;
      }

      if (currentPoints == 0) {
        if (isSingleMode) {
          return playerOrTeamStats.getPlayer.getName;
        } else {
          return playerOrTeamStats.getTeam.getName;
        }
      }
    }

    return '';
  }

  static String getAverageForLeg(
      PlayerOrTeamGameStatsX01 playerOrTeamGameStatsX01, String setLegString) {
    if (playerOrTeamGameStatsX01.getAllScoresPerLeg.isEmpty ||
        !playerOrTeamGameStatsX01.getAllScoresPerLeg.containsKey(setLegString))
      return '0';

    double result = 0;
    for (int score
        in playerOrTeamGameStatsX01.getAllScoresPerLeg[setLegString]) {
      result += score;
    }

    result /= (playerOrTeamGameStatsX01.getThrownDartsPerLeg[setLegString] / 3);

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
      } else if (key == 'Bull') {
        singles.add(50);
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
      if (single == 50) {
        temp.add('Bull');
      } else {
        temp.add(single.toString());
      }
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

  static double getHeightForWidget(GameSettingsX01_P gameSettingsX01) {
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

  static dynamic getPlayersOrTeamStatsList(
      GameX01_P gameX01, GameSettingsX01_P gameSettingsX01) {
    if (gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Team &&
        gameX01.getAreTeamStatsDisplayed) {
      return gameX01.getTeamGameStatistics;
    }

    return gameX01.getPlayerGameStatistics;
  }

  static bool teamStatsDisplayed(
      GameX01_P gameX01, GameSettingsX01_P gameSettingsX01) {
    return gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Team &&
        gameX01.getAreTeamStatsDisplayed;
  }

  static bool playerStatsDisplayedInTeamMode(
      GameX01_P gameX01, GameSettingsX01_P gameSettingsX01) {
    return gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Team &&
        !gameX01.getAreTeamStatsDisplayed;
  }

  static Row setLegStrings(GameX01_P gameX01, GameSettingsX01_P gameSettingsX01,
      BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 20.w,
        ),
        for (String setLegString in gameX01.getAllLegSetStringsExceptCurrentOne(
            gameX01, gameSettingsX01))
          Container(
            width: 25.w,
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Center(
                child: Text(
                  setLegString,
                  style: TextStyle(
                    color: getTextColorDarken(context),
                    fontWeight: FontWeight.bold,
                    fontSize: 10.sp,
                  ),
                ),
              ),
            ),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  width: 1.5,
                  color: getTextColorDarken(context),
                ),
              ),
            ),
          ),
      ],
    );
  }

  static Color getPrimaryColorDarken(BuildContext context) {
    return darken(Theme.of(context).colorScheme.primary, 35);
  }

  static MaterialStateProperty<Color> getPrimaryMaterialStateColorDarken(
      BuildContext context) {
    return getColor(darken(Theme.of(context).colorScheme.primary, 35));
  }

  static Color getTextColorForGameSettingsBtn(
      bool value, BuildContext context) {
    return value ? Theme.of(context).colorScheme.secondary : Colors.white;
  }

  static Color getColorForClickBtns() {
    return Color.fromARGB(255, 222, 176, 134);
  }

  static Color getTextColorForGameSettingsPage() {
    return Colors.white;
  }

  static Color getTextColorDarken(BuildContext context) {
    return darken(Theme.of(context).colorScheme.primary, 55);
  }

  static String getCurrentThreeDartsCalculated(List<String> currentThreeDarts) {
    int result = 0;

    for (String dart in currentThreeDarts) {
      result += getValueOfSpecificDart(dart);
    }

    return result.toString();
  }

  static int getValueOfSpecificDart(String dart) {
    int result = 0;
    String temp;

    if (dart == 'Dart 1' || dart == 'Dart 2' || dart == 'Dart 3') {
      return result;
    }

    if (dart == 'Bull') {
      result += 50;
    } else if (dart[0] == 'D') {
      temp = dart.substring(1);
      result += (int.parse(temp) * 2);
    } else if (dart[0] == 'T') {
      temp = dart.substring(1);
      result += (int.parse(temp) * 3);
    } else {
      result += int.parse(dart);
    }

    return result;
  }

  static String appendTrippleOrDouble(
      PointType currentPointType, String value) {
    String text = '';
    if (value != 'Bull' && value != '25' && value != '0') {
      if (currentPointType == PointType.Double) {
        text = 'D';
      } else if (currentPointType == PointType.Tripple) {
        text = 'T';
      }
    }
    text += value;

    return text;
  }

  static getBorder(BuildContext context, String value) {
    const double borderWidth = 3;

    return Border(
      right: [
        '1',
        '2',
        '3',
        '4',
        '6',
        '7',
        '8',
        '9',
        '11',
        '12',
        '13',
        '14',
        '16',
        '17',
        '18',
        '19',
        '25',
        'Bull',
        'Bust',
      ].contains(value)
          ? BorderSide(
              color: Utils.getPrimaryColorDarken(context),
              width: borderWidth,
            )
          : BorderSide.none,
      bottom: [
        '1',
        '2',
        '3',
        '4',
        '5',
        '6',
        '7',
        '8',
        '9',
        '10',
        '11',
        '12',
        '13',
        '14',
        '15',
        '16',
        '17',
        '18',
        '19',
        '20'
      ].contains(value)
          ? BorderSide(
              color: Utils.getPrimaryColorDarken(context),
              width: borderWidth,
            )
          : BorderSide.none,
      top: [
        '0',
        '1',
        '2',
        '3',
        '4',
        '5',
        '25',
        'Bull',
        'Bust',
      ].contains(value)
          ? BorderSide(
              color: Utils.getPrimaryColorDarken(context),
              width: borderWidth,
            )
          : BorderSide.none,
    );
  }

  static dynamic getPlayerOrTeamStatsDynamic(
      Game_P game_p, BuildContext context) {
    if (game_p is GameX01_P) {
      if (game_p.getIsGameFinished || game_p.getIsOpenGame) {
        return Utils.getPlayersOrTeamStatsList(
            (game_p), game_p.getGameSettings);
      }
      return Utils.getPlayersOrTeamStatsList(
          context.read<GameX01_P>(), context.read<GameSettingsX01_P>());
    } else if (game_p is GameScoreTraining_P) {
      if (game_p.getIsGameFinished || game_p.getIsOpenGame) {
        return game_p.getPlayerGameStatistics;
      }
      return context.read<GameScoreTraining_P>().getPlayerGameStatistics;
    }
  }

  static showDialogForSavingGame(BuildContext context, Game_P game_p) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context1) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.primary,
        contentPadding: EdgeInsets.only(
            bottom: DIALOG_CONTENT_PADDING_BOTTOM,
            top: DIALOG_CONTENT_PADDING_TOP,
            left: DIALOG_CONTENT_PADDING_LEFT,
            right: DIALOG_CONTENT_PADDING_RIGHT),
        title: const Text(
          'End game',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Would you like to save the game for finishing it later or end it completely?',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Continue',
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
            style: ButtonStyle(
              backgroundColor:
                  Utils.getPrimaryMaterialStateColorDarken(context),
            ),
          ),
          TextButton(
            onPressed: () => {
              Navigator.of(context).pop(),
              _resetValuesAndNavigateToHome(context, game_p)
            },
            child: Text(
              'End',
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
            style: ButtonStyle(
              backgroundColor:
                  Utils.getPrimaryMaterialStateColorDarken(context),
            ),
          ),
          TextButton(
            onPressed: () async => {
              Navigator.of(context, rootNavigator: true).pop(),
              await context
                  .read<FirestoreServiceGames>()
                  .postOpenGame(game_p, context),
              _resetValuesAndNavigateToHome(context, game_p),
            },
            child: Text(
              'Save',
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
            style: ButtonStyle(
              backgroundColor:
                  Utils.getPrimaryMaterialStateColorDarken(context),
            ),
          ),
        ],
      ),
    );
  }

  static _resetValuesAndNavigateToHome(BuildContext context, dynamic game_p) {
    game_p.reset();
    Navigator.of(context).pushNamed('/home');
  }

  // converts List<"value;value;value"> back to List<List<String>>
  static List<List<String>> convertSimpleListToAllRemainingScoresPerDart(
      dynamic list) {
    List<List<String>> result = [];

    for (String value in list) {
      List<String> temp = [];
      List<String> parts = value.split(';');
      for (String part in parts) {
        temp.add(part);
      }
      result.add(temp);
    }

    return result;
  }

  // List<List<String>> can't be stored on firebase
  // converts to List<"value;value;value">
  static List<String> convertAllRemainingScoresPerDartToSimpleList(
      List<List<String>> list) {
    List<String> result = [];

    for (List<String> item in list) {
      String temp = '';
      for (String value in item) {
        temp += (value + ';');
      }
      // removes last ;
      temp = temp.substring(0, temp.length - 1);
      result.add(temp);
    }

    return result;
  }

  static dynamic getFirestoreStatsProviderBasedOnMode(
      String mode, BuildContext context) {
    if (mode == 'X01') {
      return context.read<StatsFirestoreX01_P>();
    } else {
      return context.read<StatsFirestore_sdt_sct_P>();
    }
  }

  static getBackgroundColorForPlayer(
      BuildContext context, Game_P game, PlayerOrTeamGameStats playerStats) {
    if (Player.samePlayer(
        game.getCurrentPlayerToThrow, playerStats.getPlayer)) {
      return Utils.lighten(Theme.of(context).colorScheme.primary, 20);
    }

    return Colors.transparent;
  }
}
