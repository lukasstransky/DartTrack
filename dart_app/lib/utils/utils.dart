import 'dart:collection';

import 'package:dart_app/constants.dart';
import 'package:dart_app/models/firestore/stats_firestore_c.dart';
import 'package:dart_app/models/firestore/stats_firestore_s_t.dart';
import 'package:dart_app/models/firestore/stats_firestore_sc_t.dart';
import 'package:dart_app/models/firestore/stats_firestore_d_t.dart';
import 'package:dart_app/models/firestore/stats_firestore_x01_p.dart';
import 'package:dart_app/models/game_settings/game_settings_cricket_p.dart';
import 'package:dart_app/models/game_settings/game_settings_p.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/models/games/game_score_training_p.dart';
import 'package:dart_app/models/games/game_single_double_training_p.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats_x01.dart';
import 'package:dart_app/models/settings_p.dart';
import 'package:dart_app/models/team.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
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

  static Map<String, int> sortMapStringInt(Map<dynamic, dynamic> mapToSort) {
    mapToSort = Map.from(mapToSort);
    return new SplayTreeMap<String, int>.from(
        mapToSort, (a, b) => mapToSort[b] > mapToSort[a] ? 1 : -1);
  }

  static String getWinnerOfLeg(
      String setLegString, GameX01_P game, BuildContext context, int index) {
    final String playerOrTeam =
        game.getLegSetWithPlayerOrTeamWhoFinishedIt[index];
    if (Utils.playerStatsDisplayedInTeamMode(game, game.getGameSettings)) {
      for (PlayerOrTeamGameStatsX01 stats in game.getPlayerGameStatistics) {
        final Team team =
            game.getGameSettings.findTeamForPlayer(stats.getPlayer.getName);
        if (team.getName == playerOrTeam) {
          if (stats.getCheckouts.containsKey(setLegString)) {
            return stats.getPlayer.getName;
          }
        }
      }
      return '';
    } else {
      return playerOrTeam;
    }
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

  static dynamic getPlayersOrTeamStatsListStatsScreen(
      dynamic gameX01, dynamic gameSettingsX01) {
    if (gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Team &&
        gameX01.getAreTeamStatsDisplayed) {
      return gameX01.getTeamGameStatistics;
    }

    return gameX01.getPlayerGameStatistics;
  }

  static dynamic getPlayersOrTeamStatsList(Game_P game, bool isTeamMode) {
    if (isTeamMode) {
      return game.getTeamGameStatistics;
    }

    return game.getPlayerGameStatistics;
  }

  static bool teamStatsDisplayed(dynamic game, dynamic gameSettings) {
    return gameSettings.getSingleOrTeam == SingleOrTeamEnum.Team &&
        game.getAreTeamStatsDisplayed;
  }

  static bool playerStatsDisplayedInTeamMode(
      dynamic game, dynamic gameSettings) {
    return gameSettings.getSingleOrTeam == SingleOrTeamEnum.Team &&
        !game.getAreTeamStatsDisplayed;
  }

  static Row setLegStrings(GameX01_P gameX01, GameSettingsX01_P gameSettingsX01,
      BuildContext context, double width) {
    return Row(
      children: [
        SizedBox(
          width: width.w,
        ),
        for (String setLegString in gameX01.getAllLegSetStringsExceptCurrentOne(
            gameX01, gameSettingsX01))
          Container(
            width: gameSettingsX01.getSetsEnabled ? 25.w : 20.w,
            child: Padding(
              padding: EdgeInsets.only(
                top: 0.5.h,
                bottom: 0.5.h,
                left: 1.w,
                right: 1.w,
              ),
              child: Center(
                child: Text(
                  setLegString,
                  style: TextStyle(
                    color: getTextColorDarken(context),
                    fontWeight: FontWeight.bold,
                    fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                  ),
                ),
              ),
            ),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  width: 0.5.w,
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
      if (!dart.contains('Dart')) {
        result += getValueOfSpecificDart(dart);
      }
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

  static getBorder(BuildContext context, String value, GameMode mode,
      [bool autoSubmitPoints = false]) {
    return Border(
      right: [
        autoSubmitPoints ? '' : '0',
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
        mode == GameMode.Cricket ? '15' : '',
        '16',
        '17',
        '18',
        '19',
        '25',
        mode == GameMode.Cricket ? '' : 'Bull',
        'Bust',
      ].contains(value)
          ? BorderSide(
              color: Utils.getPrimaryColorDarken(context),
              width: GENERAL_BORDER_WIDTH.w,
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
              width: GENERAL_BORDER_WIDTH.w,
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
        mode == GameMode.Cricket ? '15' : '',
        mode == GameMode.Cricket ? '16' : '',
        mode == GameMode.Cricket ? '17' : '',
        mode == GameMode.Cricket ? '18' : '',
        mode == GameMode.Cricket ? '19' : '',
        mode == GameMode.Cricket ? '20' : '',
        'Bull',
        'Bust',
      ].contains(value)
          ? BorderSide(
              color: Utils.getPrimaryColorDarken(context),
              width: GENERAL_BORDER_WIDTH.w,
            )
          : BorderSide.none,
    );
  }

  static dynamic getPlayerOrTeamStatsDynamic(
      Game_P game_p, BuildContext context) {
    if (game_p is GameX01_P) {
      if (game_p.getIsGameFinished || game_p.getIsOpenGame) {
        return Utils.getPlayersOrTeamStatsListStatsScreen(
            (game_p), game_p.getGameSettings);
      }
      return Utils.getPlayersOrTeamStatsListStatsScreen(
          context.read<GameX01_P>(), context.read<GameSettingsX01_P>());
    } else if (game_p is GameScoreTraining_P) {
      if (game_p.getIsGameFinished || game_p.getIsOpenGame) {
        return game_p.getPlayerGameStatistics;
      }
      return context.read<GameScoreTraining_P>().getPlayerGameStatistics;
    }
  }

  // converts List<"value;value;value"> back to List<List<String>>
  static List<List<String>> convertSimpleListBackToDoubleList(dynamic list) {
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
  static List<String> convertDoubleListToSimpleList(List<List<String>> list) {
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
      GameMode mode, BuildContext context) {
    if (mode == GameMode.X01) {
      return context.read<StatsFirestoreX01_P>();
    } else if (mode == GameMode.SingleTraining) {
      return context.read<StatsFirestoreSingleTraining_P>();
    } else if (mode == GameMode.DoubleTraining) {
      return context.read<StatsFirestoreDoubleTraining_P>();
    } else if (mode == GameMode.ScoreTraining) {
      return context.read<StatsFirestoreScoreTraining_P>();
    } else if (mode == GameMode.Cricket) {
      return context.read<StatsFirestoreCricket_P>();
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

  static PlayerOrTeamGameStatsX01 getCurrentPlayerOrTeamStats(
      GameX01_P gameX01, GameSettingsX01_P gameSettingsX01) {
    return gameX01.getGameSettings.getSingleOrTeam == SingleOrTeamEnum.Single
        ? gameX01.getCurrentPlayerGameStats()
        : gameX01.getCurrentTeamGameStats();
  }

  static bool highlightRoundedScore(
      StatsFirestoreX01_P statisticsFirestore, int i, bool roundedScoresOdd) {
    return statisticsFirestore.countOfGames > 0 &&
        statisticsFirestore.countOfGames > 0 &&
        (!roundedScoresOdd
                ? statisticsFirestore.roundedScoresEven[i]
                : statisticsFirestore.roundedScoresOdd[i]) ==
            (!roundedScoresOdd
                ? getMostOccurringValue(statisticsFirestore.roundedScoresEven)
                : getMostOccurringValue(statisticsFirestore.roundedScoresOdd));
  }

  static bool shouldShrinkWidget(GameSettingsX01_P gameSettingsX01) {
    return gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Team &&
        (gameSettingsX01.getPlayers.length >= 4 ||
            gameSettingsX01.getTeams.length >= 3);
  }

  static String getBestOfOrFirstToString(dynamic gameSettings) {
    String result = '';

    if (gameSettings.getBestOfOrFirstTo == BestOfOrFirstToEnum.BestOf) {
      result += 'Best of ';
    } else {
      result += 'First to ';
    }

    if (gameSettings.getSetsEnabled) {
      if (gameSettings.getSets > 1) {
        result += '${gameSettings.getSets.toString()} sets - ';
      } else {
        result += '${gameSettings.getSets.toString()} set - ';
      }
    }
    if (gameSettings.getLegs > 1) {
      result += '${gameSettings.getLegs.toString()} legs';
    } else {
      result += '${gameSettings.getLegs.toString()} leg';
    }

    return result;
  }

  static Color getBackgroundColorForCurrentPlayerOrTeam(
      Game_P game,
      dynamic gameSettings,
      PlayerOrTeamGameStats playerOrTeamGameStats,
      BuildContext context) {
    if (gameSettings.getSingleOrTeam == SingleOrTeamEnum.Single) {
      if (playerOrTeamGameStats.getPlayer != null &&
          Player.samePlayer(
              game.getCurrentPlayerToThrow, playerOrTeamGameStats.getPlayer)) {
        return Utils.lighten(Theme.of(context).colorScheme.primary, 20);
      }
    } else {
      if (playerOrTeamGameStats.getTeam == null ||
          game.getCurrentTeamToThrow == null) {
        return Colors.transparent;
      }
      if (playerOrTeamGameStats.getTeam.getName ==
          game.getCurrentTeamToThrow.getName) {
        return Utils.lighten(Theme.of(context).colorScheme.primary, 20);
      }
    }

    return Colors.transparent;
  }

  // for x01 & cricket
  static void setPlayerTeamLegStartIndex(
      dynamic game, GameSettings_P gameSettings, bool isSingleMode) {
    if (isSingleMode &&
        game.getPlayerOrTeamLegStartIndex ==
            gameSettings.getPlayers.length - 1) {
      game.setPlayerOrTeamLegStartIndex = 0;
    } else if (!isSingleMode &&
        game.getPlayerOrTeamLegStartIndex == gameSettings.getTeams.length - 1) {
      game.setPlayerOrTeamLegStartIndex = 0;
    } else {
      game.setPlayerOrTeamLegStartIndex = game.getPlayerOrTeamLegStartIndex + 1;
    }
  }

  static bool gameWonFirstToWithSets(int setsWon, dynamic gameSettings) {
    return gameSettings.getBestOfOrFirstTo == BestOfOrFirstToEnum.FirstTo &&
        gameSettings.getSetsEnabled &&
        gameSettings.getSets == setsWon;
  }

  static bool gameWonFirstToWithLegs(int legsWon, dynamic gameSettings) {
    return gameSettings.getBestOfOrFirstTo == BestOfOrFirstToEnum.FirstTo &&
        legsWon >= gameSettings.getLegs;
  }

  static bool gameWonBestOfWithSets(int setsWon, dynamic gameSettings) {
    return gameSettings.getBestOfOrFirstTo == BestOfOrFirstToEnum.BestOf &&
        gameSettings.getSetsEnabled &&
        ((setsWon * 2) - 1) == gameSettings.getSets;
  }

  static bool gameWonBestOfWithLegs(int legsWon, dynamic gameSettings) {
    return gameSettings.getBestOfOrFirstTo == BestOfOrFirstToEnum.BestOf &&
        ((legsWon * 2) - 1) >= gameSettings.getLegs;
  }

  static bool showLeftBorderCricket(
      int i, GameSettingsCricket_P gameSettingsCricket) {
    final int playersLength = gameSettingsCricket.getPlayers.length;
    final int teamsLength = gameSettingsCricket.getTeams.length;
    final bool isSingleMode =
        gameSettingsCricket.getSingleOrTeam == SingleOrTeamEnum.Single;

    if (i == 0) {
      return false;
    } else if (((isSingleMode && playersLength == 4) ||
            (!isSingleMode && teamsLength == 4)) &&
        i == 2) {
      return false;
    } else if ((isSingleMode && playersLength == 2) ||
        (!isSingleMode && teamsLength == 2)) {
      return false;
    }
    return true;
  }

  //returns e.g. 'Leg 1' or 'Set 1 Leg 2'
  static String getCurrentSetLegAsString(dynamic game, dynamic settings) {
    final num currentLeg = _getCurrentLeg(game, settings);

    num currentSet = -1;
    String key = '';

    if (settings.getSetsEnabled) {
      currentSet = _getCurrentSet(game, settings);
      key += 'Set ' + currentSet.toString() + ' - ';
    }
    key += 'Leg ' + currentLeg.toString();

    return key;
  }

  static num _getCurrentLeg(dynamic game, dynamic settings) {
    num result = 1;

    if (settings.getSingleOrTeam == SingleOrTeamEnum.Single) {
      for (dynamic stats in game.getPlayerGameStatistics) {
        result += stats.getLegsWon;
      }
    } else {
      for (dynamic stats in game.getTeamGameStatistics) {
        result += stats.getLegsWon;
      }

      return result;
    }

    return result;
  }

  static num _getCurrentSet(dynamic game, dynamic settings) {
    num result = 1;

    for (dynamic stats in getPlayersOrTeamStatsList(
        game, settings.getSingleOrTeam == SingleOrTeamEnum.Team)) {
      result += stats.getSetsWon;
    }

    return result;
  }

  static Map<String, int> getMapWithStringKey(Map<int, int> sourceMap) {
    Map<String, int> result = {};
    for (var entry in sourceMap.entries) {
      result[entry.key.toString()] = entry.value;
    }
    return result;
  }

  static bool hasPlayerOrTeamWonTheGame(
      dynamic stats, dynamic game, dynamic settings,
      [bool isDraw = false]) {
    if (game is GameScoreTraining_P || game is GameSingleDoubleTraining_P) {
      if (!game.getIsGameFinished || isDraw) {
        return false;
      }
      final List<PlayerOrTeamGameStats> playerStats =
          List.from(game.getPlayerGameStatistics);
      playerStats.sort();
      return playerStats.indexOf(stats) == 0 ? true : false;
    }

    // win check for x01 & cricket
    if (playerStatsDisplayedInTeamMode(game, settings)) {
      return false;
    }

    // set mode
    if (settings.getSetsEnabled) {
      if (settings.getBestOfOrFirstTo == BestOfOrFirstToEnum.BestOf &&
          ((stats.getSetsWon * 2) - 1) == settings.getSets) {
        return true;
      } else if (settings.getBestOfOrFirstTo == BestOfOrFirstToEnum.FirstTo &&
          settings.getSets == stats.getSetsWon) {
        return true;
      } else if (settings.getBestOfOrFirstTo == BestOfOrFirstToEnum.BestOf &&
          stats.getSetsWon == (settings.getSets / 2) + 1) {
        return true;
      }
    } else {
      // win by two legs difference
      if (game is GameX01_P && settings.getWinByTwoLegsDifference) {
        if (settings.getSuddenDeath) {
          final int amountOfLegsForSuddenDeathWin = settings.getLegs +
              settings.getMaxExtraLegs +
              1; // + 1 = sudden death leg

          return stats.getLegsWon == amountOfLegsForSuddenDeathWin;
        } else {
          return game.isLegDifferenceAtLeastTwo(stats, game, settings);
        }
      } else {
        // leg mode
        if (settings.getBestOfOrFirstTo == BestOfOrFirstToEnum.BestOf &&
            ((stats.getLegsWonTotal * 2) - 1) == settings.getLegs) {
          return true;
        } else if (settings.getBestOfOrFirstTo == BestOfOrFirstToEnum.FirstTo &&
            stats.getLegsWon >= settings.getLegs) {
          return true;
        } else if (game is GameX01_P &&
            settings.getDrawMode &&
            settings.getBestOfOrFirstTo == BestOfOrFirstToEnum.BestOf &&
            stats.getLegsWonTotal == (settings.getLegs / 2) + 1) {
          return true;
        }
      }
    }

    return false;
  }

  static handleVibrationFeedback(BuildContext context) {
    if (context.read<Settings_P>().getVibrationFeedbackEnabled) {
      HapticFeedback.lightImpact();
    }
  }

  static double getResponsiveValue({
    required BuildContext context,
    required double mobileValue,
    required double tabletValue,
  }) {
    if (ResponsiveBreakpoints.of(context).isMobile) {
      return mobileValue;
    } else {
      return tabletValue;
    }
  }

  static double getSwitchScaleFactor(BuildContext context) {
    if (ResponsiveBreakpoints.of(context).isMobile) {
      return SWTICH_SCALE_FACTOR_MOBILE;
    }

    // tablet
    return SWTICH_SCALE_FACTOR_TABLET;
  }
}
