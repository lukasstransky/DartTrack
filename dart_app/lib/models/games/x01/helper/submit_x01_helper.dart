import 'package:dart_app/constants.dart';
import 'package:dart_app/models/bot.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/game_settings/x01/helper/sudden_death_starter.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats_x01.dart';
import 'package:dart_app/models/team.dart';
import 'package:dart_app/screens/game_modes/shared/game/point_btns_three_darts/utils_point_btns_three_darts.dart';
import 'package:dart_app/utils/globals.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:sizer/sizer.dart';
import 'package:tuple/tuple.dart';

import '../../../settings_p.dart';

class SubmitX01Helper {
  /************************************************************/
  /********              PUBLIC METHODS                ********/
  /************************************************************/

  // thrownDarts -> selected from checkout dialog (only for input method -> round)
  // checkout count needed in order to revert checkout count
  // shouldSubmitTeamStats -> for team mode, to submit stats for team
  static submitPoints(String scoredPointsString, BuildContext context,
      [bool shouldSubmitTeamStats = false,
      int thrownDarts = 3,
      int checkoutCount = 0]) {
    final GameX01_P gameX01 = context.read<GameX01_P>();
    final GameSettingsX01_P gameSettingsX01 = context.read<GameSettingsX01_P>();

    bool isInputMethodThreeDarts =
        gameSettingsX01.getInputMethod == InputMethod.ThreeDarts ? true : false;
    if (gameX01.getCurrentPlayerToThrow is Bot) {
      isInputMethodThreeDarts = false;
    }

    if (!_shouldSubmit(scoredPointsString, gameSettingsX01, gameX01)) {
      return;
    }

    final bool isBust = scoredPointsString == 'Bust' ? true : false;
    final int scoredPoints =
        isBust ? 0 : Utils.getValueOfSpecificDart(scoredPointsString);

    late final PlayerOrTeamGameStatsX01 currentStats;
    if (shouldSubmitTeamStats) {
      currentStats = gameX01.getCurrentTeamGameStats();
    } else {
      currentStats = gameX01.getCurrentPlayerGameStats();
    }

    if (!isBotBeginning(currentStats, gameX01, gameSettingsX01)) {
      gameX01.setRevertPossible = true;
    }

    if (gameSettingsX01.getInputMethod == InputMethod.Round) {
      currentStats.getInputMethodForRounds.add(gameSettingsX01.getInputMethod);
    } else if (currentStats.getPlayer is Bot &&
        gameSettingsX01.getInputMethod == InputMethod.ThreeDarts) {
      currentStats.getInputMethodForRounds.add(InputMethod.Round);

      // add it also for team
      if (shouldSubmitTeamStats) {
        final PlayerOrTeamGameStatsX01 teamStats = gameX01.getTeamGameStatistics
            .where((PlayerOrTeamGameStats p) =>
                p.getTeam.getName == currentStats.getTeam.getName)
            .first as PlayerOrTeamGameStatsX01;
        teamStats.getInputMethodForRounds.add(InputMethod.Round);
      }
    }

    if (isInputMethodThreeDarts) {
      if (isBust) {
        _submitBusted(currentStats, gameX01);
      }

      _setAllRemainingScoresPerDart(currentStats, gameX01);
    } else {
      currentStats.setTotalPoints = currentStats.getTotalPoints + scoredPoints;

      // update current points for each player in team
      if (_shouldUpdateStatsForPlayersOfSameTeam(
          shouldSubmitTeamStats, gameSettingsX01)) {
        for (PlayerOrTeamGameStatsX01 stats in gameX01
            .getPlayerStatsFromCurrentTeamToThrow(gameX01, gameSettingsX01)) {
          stats.setCurrentPoints = stats.getCurrentPoints - scoredPoints;
        }
      } else {
        currentStats.setCurrentPoints =
            currentStats.getCurrentPoints - scoredPoints;
      }
    }

    //add delay for last dart for three darts input method
    int milliseconds =
        isInputMethodThreeDarts && gameSettingsX01.getAutomaticallySubmitPoints
            ? 800
            : 0;
    if (currentStats.getPlayer is Bot ||
        (currentStats.getTeam != null &&
            currentStats.getTeam.getCurrentPlayerToThrow is Bot)) {
      milliseconds = 400;
    }
    if (isBotBeginning(currentStats, gameX01, gameSettingsX01)) {
      milliseconds = 0;
    }

    Future.delayed(Duration(milliseconds: milliseconds), () {
      currentStats.setPointsSelectedCount = 0;
      gameX01.setCurrentPointsSelected = 'Points';

      late int totalPoints;
      if (isInputMethodThreeDarts) {
        gameX01.setCurrentPointType = PointType.Single;
        totalPoints = int.parse(
            Utils.getCurrentThreeDartsCalculated(gameX01.getCurrentThreeDarts));
      } else {
        // first nine avg
        if (currentStats.getCurrentThrownDartsInLeg < 9) {
          currentStats.setFirstNineAvgPoints =
              currentStats.getFirstNineAvgPoints + scoredPoints;
          currentStats.setFirstNineAvgCount =
              currentStats.getFirstNineAvgCount + thrownDarts;
        }

        // thrown darts
        currentStats.setCurrentThrownDartsInLeg =
            currentStats.getCurrentThrownDartsInLeg + thrownDarts;
        currentStats.setAllThrownDarts =
            currentStats.getAllThrownDarts + thrownDarts;

        currentStats.setAllScoresCountForRound =
            currentStats.getAllScoresCountForRound + 1;

        totalPoints = scoredPoints;
      }

      currentStats.getAllScores.add(totalPoints);

      _setCheckoutCountAtThrownDarts(
          currentStats, checkoutCount, gameX01, gameSettingsX01);
      _setScores(currentStats, totalPoints, gameX01, gameSettingsX01);
      final Tuple2<bool, bool> tuple = _legSetOrGameFinished(currentStats,
          context, totalPoints, thrownDarts, gameX01, shouldSubmitTeamStats);
      final bool legSetOrGameFinished = tuple.item1;
      final bool gameFinished = tuple.item2;

      if (!legSetOrGameFinished) {
        final bool shouldSetNextPlayerOrTeam =
            _shouldSetNextPlayerOrTeam(gameX01, gameSettingsX01, currentStats);
        if (shouldSubmitTeamStats) {
          gameSettingsX01.setNextTeamAndPlayer(
              gameX01, shouldSetNextPlayerOrTeam);
        } else if (gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Single) {
          gameSettingsX01.setNextPlayer(gameX01, shouldSetNextPlayerOrTeam);
        }
      }

      // reset current 3 darts for 3-darts-mode
      if (isInputMethodThreeDarts) {
        if (gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Team) {
          if ((gameX01.getCurrentThreeDarts[2] != 'Dart 3' ||
                  legSetOrGameFinished) &&
              shouldSubmitTeamStats) {
            UtilsPointBtnsThreeDarts.resetCurrentThreeDarts(
                gameX01.getCurrentThreeDarts);
          }
        } else {
          if (gameX01.getCurrentThreeDarts[2] != 'Dart 3' ||
              legSetOrGameFinished) {
            UtilsPointBtnsThreeDarts.resetCurrentThreeDarts(
                gameX01.getCurrentThreeDarts);
          }
        }
      }

      // reset current points & starting points IF leg, set, game won
      if (legSetOrGameFinished) {
        if (currentStats.getCurrentPoints != 0 ||
            (currentStats.getCurrentPoints == 0 &&
                currentStats.getPlayer != gameX01.getCurrentPlayerToThrow &&
                !shouldSubmitTeamStats)) {
          g_thrown_darts = '-';
        }

        for (PlayerOrTeamGameStatsX01 stats in shouldSubmitTeamStats
            ? gameX01.getTeamGameStatistics
            : gameX01.getPlayerGameStatistics) {
          stats.setCurrentPoints = gameSettingsX01.getPointsOrCustom();
        }
      }
      if (gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Team &&
          !gameFinished &&
          shouldSubmitTeamStats) {
        gameX01.notify();
      } else if (gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Single &&
          !gameFinished) {
        gameX01.notify();
      }
    });

    // submit team stats
    if (!shouldSubmitTeamStats &&
        gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Team) {
      submitPoints(
          scoredPointsString, context, true, thrownDarts, checkoutCount);
    }

    // update sets, legs for players from same team
    if (shouldSubmitTeamStats) {
      for (PlayerOrTeamGameStatsX01 stats in gameX01
          .getPlayerStatsFromCurrentTeamToThrow(gameX01, gameSettingsX01)) {
        stats.setLegsWon = currentStats.getLegsWon;
        stats.setSetsWon = currentStats.getSetsWon;
      }
    }
  }

  static bust(BuildContext context) {
    submitPoints('Bust', context);
  }

  // stats that need to be submitted immediately after the first dart in order to show it properly in the ui
  static submitStatsForThreeDartsMode(
      GameX01_P gameX01,
      GameSettingsX01_P gameSettingsX01,
      int scoredPoints,
      String scoredFieldWithPointType,
      bool shouldSubmitTeamStats,
      PlayerOrTeamGameStatsX01 currentStats) {
    gameX01.setRevertPossible = true;

    currentStats.getInputMethodForRounds.add(InputMethod.ThreeDarts);

    // update current points
    if (_shouldUpdateStatsForPlayersOfSameTeam(
        shouldSubmitTeamStats, gameSettingsX01)) {
      for (PlayerOrTeamGameStatsX01 stats in gameX01
          .getPlayerStatsFromCurrentTeamToThrow(gameX01, gameSettingsX01)) {
        stats.setCurrentPoints = stats.getCurrentPoints - scoredPoints;
      }
    } else {
      currentStats.setCurrentPoints =
          currentStats.getCurrentPoints - scoredPoints;
    }

    // all scores per dart
    currentStats.getAllScoresPerDart.add(scoredPoints);

    if (currentStats.getAllScoresPerDartAsStringCount
        .containsKey(scoredFieldWithPointType)) {
      currentStats.getAllScoresPerDartAsStringCount[scoredFieldWithPointType] +=
          1;
    } else {
      currentStats.getAllScoresPerDartAsStringCount[scoredFieldWithPointType] =
          1;
    }

    currentStats.getAllScoresPerDartAsString.add(scoredFieldWithPointType);

    // total Points
    currentStats.setTotalPoints = currentStats.getTotalPoints + scoredPoints;

    // first nine avg
    if (currentStats.getCurrentThrownDartsInLeg < 9) {
      currentStats.setFirstNineAvgPoints =
          currentStats.getFirstNineAvgPoints + scoredPoints;
      currentStats.setFirstNineAvgCount = currentStats.getFirstNineAvgCount + 1;
    }

    // thrown darts
    currentStats.setCurrentThrownDartsInLeg =
        currentStats.getCurrentThrownDartsInLeg + 1;
    currentStats.setAllThrownDarts = currentStats.getAllThrownDarts + 1;

    // three darts mode round count
    if (gameX01.getAmountOfDartsThrown() == 3 ||
        gameX01.finishedLegSetOrGame(Utils.getCurrentThreeDartsCalculated(
            gameX01.getCurrentThreeDarts))) {
      currentStats.setThreeDartModeRoundsCount =
          currentStats.getThreeDartModeRoundsCount + 1;
    }
  }

  /************************************************************/
  /********              PRIVATE METHODS                ********/
  /************************************************************/

  static _setScores(PlayerOrTeamGameStatsX01 stats, int totalPoints,
      GameX01_P gameX01, GameSettingsX01_P gameSettingsX01) {
    // precise scores
    if (stats.getPreciseScores.containsKey(totalPoints)) {
      stats.getPreciseScores[totalPoints] += 1;
    } else {
      stats.getPreciseScores[totalPoints] = 1;
    }

    // rounded score even
    List<int> keys = stats.getRoundedScoresEven.keys.toList();
    keys.sort();
    if (totalPoints == 180) {
      stats.getRoundedScoresEven[keys[keys.length - 1]] += 1;
    } else {
      for (int i = 0; i < keys.length - 1; i++) {
        if (totalPoints >= keys[i] && totalPoints < keys[i + 1]) {
          stats.getRoundedScoresEven[keys[i]] += 1;
        }
      }
    }

    // rounded scores odd
    keys = stats.getRoundedScoresOdd.keys.toList();
    keys.sort();
    if (totalPoints >= 170) {
      stats.getRoundedScoresOdd[keys[keys.length - 1]] += 1;
    } else {
      for (int i = 0; i < keys.length - 1; i++) {
        if (totalPoints >= keys[i] && totalPoints < keys[i + 1]) {
          stats.getRoundedScoresOdd[keys[i]] += 1;
        }
      }
    }

    // set all scores per leg
    final String key = Utils.getCurrentSetLegAsString(gameX01, gameSettingsX01);
    if (stats.getAllScoresPerLeg.containsKey(key)) {
      // add to value list
      stats.getAllScoresPerLeg[key].add(totalPoints);
    } else {
      //create new pair in map
      stats.getAllScoresPerLeg[key] = [totalPoints];
    }

    stats.setTotalRoundsCount = stats.getTotalRoundsCount + 1;
  }

  static bool _shouldUpdateStatsForPlayersOfSameTeam(
      bool shouldSubmitTeamStats, GameSettingsX01_P gameSettingsX01) {
    return !shouldSubmitTeamStats &&
        gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Team;
  }

  static Tuple2<bool, bool> _legSetOrGameFinished(
      PlayerOrTeamGameStatsX01 currentStats,
      BuildContext context,
      int totalPoints,
      int thrownDarts,
      GameX01_P gameX01,
      bool shouldSubmitTeamStats) {
    if (currentStats.getCurrentPoints != 0) {
      return new Tuple2(false, false);
    }

    final GameSettingsX01_P gameSettingsX01 = context.read<GameSettingsX01_P>();
    final String currentSetLeg =
        Utils.getCurrentSetLegAsString(gameX01, gameSettingsX01);
    final bool isSingleMode =
        gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Single
            ? true
            : false;

    // set amount of finish darts
    currentStats.getAmountOfFinishDarts[currentSetLeg] = thrownDarts;

    // add to amount of darts for won legs
    currentStats.getAmountOfDartsForWonLegs
        .add(currentStats.getCurrentThrownDartsInLeg);

    // set thrown darts per leg & reset points
    for (PlayerOrTeamGameStatsX01 stats in (shouldSubmitTeamStats
        ? gameX01.getTeamGameStatistics
        : gameX01.getPlayerGameStatistics)) {
      stats.getThrownDartsPerLeg[currentSetLeg] =
          stats.getCurrentThrownDartsInLeg;

      if (currentStats == stats) {
        stats.setDartsForWonLegCount =
            stats.getDartsForWonLegCount + stats.getCurrentThrownDartsInLeg;
        stats.getAllRemainingPoints.add(totalPoints);
      } else {
        if (!isSingleMode && stats.getCurrentPoints == 0) {
          stats.getAllRemainingPoints.add(totalPoints);
        } else {
          stats.getAllRemainingPoints.add(stats.getCurrentPoints);
        }
      }

      if (stats.getPlayer is Bot) {
        stats.getPlayer.setStarterDoubleAlreadySet = false;
      }

      // set player or team who finished current leg
      if (!shouldSubmitTeamStats) {
        stats.getLegSetWithPlayerOrTeamWhoFinishedIt[currentSetLeg] =
            gameX01.getCurrentPlayerToThrow.getName;
      }
    }

    // set player or team who finished current leg (on game level)
    if (!shouldSubmitTeamStats) {
      String playerOrTeamName = gameX01.getCurrentPlayerToThrow.getName;
      if (!isSingleMode) {
        playerOrTeamName = gameX01.getCurrentTeamToThrow.getName;
      }
      gameX01.getLegSetWithPlayerOrTeamWhoFinishedIt.add(playerOrTeamName);
    }

    // add checkout to list
    currentStats.getCheckouts[currentSetLeg] = totalPoints;

    // set player of team who finished leg
    if (!isSingleMode && !shouldSubmitTeamStats) {
      final String currentPlayerName = gameX01.getCurrentPlayerToThrow.getName;
      final PlayerOrTeamGameStatsX01 teamStats =
          gameX01.getTeamStatsFromPlayer(currentPlayerName);
      teamStats.getPlayersWithCheckoutInLeg[currentSetLeg] = currentPlayerName;
    }

    // set current player of teams before leg finish
    if (!shouldSubmitTeamStats && !isSingleMode) {
      List<String> players = [];
      for (Team team in gameSettingsX01.getTeams) {
        players.add(team.getCurrentPlayerToThrow.getName);
      }
      gameX01.getCurrentPlayerOfTeamsBeforeLegFinish.add(players);
    }

    _updateLegsSets(
        currentStats, gameSettingsX01, gameX01, shouldSubmitTeamStats);

    bool isGameFinished = false;
    if (_isGameWon(currentStats, gameX01, gameSettingsX01, context,
        shouldSubmitTeamStats)) {
      currentStats.setGameWon = true;
      isGameFinished = true;

      // set game won also for other players in team -> for correct stats
      if (shouldSubmitTeamStats) {
        for (Player player in currentStats.getTeam.getPlayers) {
          _getPlayerStatsByName(player.getName, gameX01).setGameWon = true;
        }
      }
    } else if (_isGameDraw(gameX01, gameSettingsX01, shouldSubmitTeamStats)) {
      // set game draw for all players
      for (PlayerOrTeamGameStatsX01 stats in Utils.getPlayersOrTeamStatsList(
          gameX01, gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Team)) {
        stats.setGameDraw = true;
      }

      isGameFinished = true;

      // set game draw also for other players in team -> for correct stats
      if (shouldSubmitTeamStats) {
        for (Player player in currentStats.getTeam.getPlayers) {
          _getPlayerStatsByName(player.getName, gameX01).setGameDraw = true;
        }
      }
    }

    if (isGameFinished) {
      gameX01.setIsGameFinished = true;
    }

    if ((isGameFinished || currentStats.getGameDraw)) {
      if (gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Single ||
          shouldSubmitTeamStats) {
        Navigator.of(context).pushNamed('/finishX01');
      }
    } else {
      for (PlayerOrTeamGameStatsX01 stats in gameX01.getPlayerGameStatistics) {
        stats.setCurrentThrownDartsInLeg = 0;
      }
      if (shouldSubmitTeamStats) {
        for (PlayerOrTeamGameStatsX01 stats in gameX01.getTeamGameStatistics) {
          stats.setCurrentThrownDartsInLeg = 0;
        }
      }
    }

    final bool isTeamMode =
        gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Team;
    if (isTeamMode &&
        shouldSubmitTeamStats &&
        !gameSettingsX01.getSuddenDeath) {
      return new Tuple2(true, isGameFinished);
    }

    // for sudden death
    if ((gameSettingsX01.getSuddenDeath &&
            !gameX01.getReachedSuddenDeath &&
            shouldSubmitTeamStats &&
            isTeamMode) ||
        (!isTeamMode &&
            gameSettingsX01.getSuddenDeath &&
            gameX01.getReachedSuddenDeath)) {
      return new Tuple2(true, isGameFinished);
    }

    Utils.setPlayerTeamLegStartIndex(gameX01, gameSettingsX01, isSingleMode);

    // set team/player
    if (!isSingleMode) {
      gameX01.setCurrentTeamToThrow = gameSettingsX01.getTeams
          .elementAt(gameX01.getPlayerOrTeamLegStartIndex);
      for (Team team in gameSettingsX01.getTeams) {
        team.setCurrentPlayerToThrow = team.getPlayers.first;
      }
      gameX01.setCurrentPlayerToThrow =
          gameX01.getCurrentTeamToThrow.getPlayers.first;
    } else {
      gameX01.setCurrentPlayerToThrow = gameSettingsX01.getPlayers
          .elementAt(gameX01.getPlayerOrTeamLegStartIndex);
    }

    if (gameX01.getCurrentPlayerToThrow is Bot) {
      gameX01.botSubmittedPoints = false;
    }

    return new Tuple2(true, isGameFinished);
  }

  static _updateLegsSets(
      PlayerOrTeamGameStatsX01 currentStats,
      GameSettingsX01_P gameSettingsX01,
      GameX01_P gameX01,
      bool shouldSubmitTeamStats) {
    // update won legs
    currentStats.setLegsWon = currentStats.getLegsWon + 1;
    currentStats.setLegsWonTotal = currentStats.getLegsWonTotal + 1;

    if (!gameSettingsX01.getSetsEnabled) {
      return;
    }

    if (gameSettingsX01.getWinByTwoLegsDifference &&
        _isLastSet(gameX01, gameSettingsX01)) {
      return;
    }

    _updateSets(currentStats, gameSettingsX01, gameX01, shouldSubmitTeamStats);
  }

  static _updateSets(
      PlayerOrTeamGameStatsX01 currentStats,
      GameSettingsX01_P gameSettingsX01,
      GameX01_P gameX01,
      bool shouldSubmitTeamStats) {
    if ((gameSettingsX01.getBestOfOrFirstTo == BestOfOrFirstToEnum.FirstTo &&
            currentStats.getLegsWon >= gameSettingsX01.getLegs) ||
        (gameSettingsX01.getBestOfOrFirstTo == BestOfOrFirstToEnum.BestOf &&
            currentStats.getLegsWon >= ((gameSettingsX01.getLegs + 1) / 2))) {
      // save leg count of each player -> in case a user wants to revert a set
      if (shouldSubmitTeamStats) {
        for (PlayerOrTeamGameStatsX01 stats in gameX01.getTeamGameStatistics) {
          stats.getLegsCount.add(stats.getLegsWon);
          stats.setLegsWon = 0;
        }
      } else {
        for (PlayerOrTeamGameStatsX01 stats
            in gameX01.getPlayerGameStatistics) {
          stats.getLegsCount.add(stats.getLegsWon);
          stats.setLegsWon = 0;
        }
      }

      currentStats.setSetsWon = currentStats.getSetsWon + 1;
    }
  }

  static PlayerOrTeamGameStatsX01 _getPlayerStatsByName(
      String name, GameX01_P gameX01) {
    late PlayerOrTeamGameStatsX01 result;

    for (PlayerOrTeamGameStatsX01 playerStats
        in gameX01.getPlayerGameStatistics) {
      if (playerStats.getPlayer.getName == name) {
        result = playerStats;
        break;
      }
    }

    return result;
  }

  static bool _isGameDraw(GameX01_P gameX01, GameSettingsX01_P gameSettingsX01,
      bool shouldSubmitTeamStats) {
    if (!gameSettingsX01.getDrawMode) {
      return false;
    }

    for (PlayerOrTeamGameStatsX01 stats in (shouldSubmitTeamStats
        ? gameX01.getTeamGameStatistics
        : gameX01.getPlayerGameStatistics)) {
      if (gameSettingsX01.getSetsEnabled &&
          !(stats.getSetsWon == (gameSettingsX01.getSets / 2))) {
        return false;
      } else if (!gameSettingsX01.getSetsEnabled &&
          !(stats.getLegsWon == (gameSettingsX01.getLegs / 2))) {
        return false;
      }
    }

    return true;
  }

  // case 1 -> input method is round
  // case 2 -> input method is three darts -> 3 darts entered
  // case 3 -> input method is three darts -> 1 or 2 darts entered & finished leg/set/game
  static bool _shouldSetNextPlayerOrTeam(GameX01_P gameX01,
      GameSettingsX01_P gameSettingsX01, PlayerOrTeamGameStatsX01 stats) {
    if (gameSettingsX01.getInputMethod == InputMethod.Round) {
      return true;
    } else if (gameSettingsX01.getInputMethod == InputMethod.ThreeDarts) {
      if (gameX01.getCurrentThreeDarts[2] != 'Dart 3' ||
          stats.getCurrentPoints == 0 ||
          gameX01.getCurrentPlayerToThrow is Bot) {
        return true;
      }
    }

    return false;
  }

  static _setAllRemainingScoresPerDart(
      PlayerOrTeamGameStatsX01 stats, GameX01_P gameX01) {
    final List<String> currentThreeDarts = gameX01.getCurrentThreeDarts;

    List<String> dartsPerRound = [];
    if (currentThreeDarts[0] != 'Dart 1') {
      dartsPerRound.add(currentThreeDarts[0]);
    }
    if (currentThreeDarts[1] != 'Dart 2') {
      dartsPerRound.add(currentThreeDarts[1]);
    }
    if (currentThreeDarts[2] != 'Dart 3') {
      dartsPerRound.add(currentThreeDarts[2]);
    }

    stats.getAllRemainingScoresPerDart.add(dartsPerRound);
  }

  static _setCheckoutCountAtThrownDarts(PlayerOrTeamGameStatsX01 stats,
      int checkoutCount, GameX01_P gameX01, GameSettingsX01_P gameSettingsX01) {
    if (checkoutCount == 0) {
      return;
    }

    final Tuple3<String, int, int> tuple = Tuple3<String, int, int>(
        Utils.getCurrentSetLegAsString(gameX01, gameSettingsX01),
        stats.getCurrentThrownDartsInLeg,
        checkoutCount);

    stats.setCheckoutCount = stats.getCheckoutCount + checkoutCount;
    stats.getCheckoutCountAtThrownDarts.add(tuple);
  }

  static bool _shouldSubmit(String thrownPoints,
      GameSettingsX01_P gameSettingsX01, GameX01_P gameX01) {
    if (thrownPoints == 'Bust' ||
        gameSettingsX01.getInputMethod == InputMethod.Round) {
      return true;
    }

    if (gameSettingsX01.getInputMethod == InputMethod.ThreeDarts &&
        (gameX01.getAmountOfDartsThrown() == 3 ||
            gameX01.finishedLegSetOrGame(Utils.getCurrentThreeDartsCalculated(
                gameX01.getCurrentThreeDarts)) ||
            gameX01.getCurrentPlayerToThrow is Bot)) {
      return true;
    }

    return false;
  }

//if player clicks on bust in three darts mode
  static _submitBusted(PlayerOrTeamGameStatsX01 stats, GameX01_P gameX01) {
    int amountOfThrownDarts = gameX01.getAmountOfDartsThrown();

    if (stats.getTeam != null) {
      amountOfThrownDarts = 0;
    }

    //set all completed throws in this round to 0
    for (int i = stats.getAllScoresPerDart.length - 1;
        i > stats.getAllScoresPerDart.length - 1 - amountOfThrownDarts;
        i--) {
      final int scorePerDart = stats.getAllScoresPerDart[i];

      //also reset total points, first nine, current points
      stats.setCurrentPoints = stats.getCurrentPoints + scorePerDart;
      stats.setTotalPoints = stats.getTotalPoints - scorePerDart;
      stats.getAllScoresPerDart[i] = 0;
      stats.getAllScoresPerDartAsString[i] = '0';

      if (stats.getCurrentThrownDartsInLeg <= 9) {
        stats.setFirstNineAvgPoints =
            stats.getFirstNineAvgPoints - scorePerDart;
      }

      final String scorePerDartString = scorePerDart.toString();

      if (stats.getAllScoresPerDartAsStringCount
          .containsKey(scorePerDartString)) {
        stats.getAllScoresPerDartAsStringCount[scorePerDartString] -= 1;

        if (stats.getAllScoresPerDartAsStringCount[scorePerDartString] == 0) {
          stats.getAllScoresPerDartAsStringCount
              .removeWhere((key, value) => key == scorePerDartString);
        }
      }
    }

    int diffTo3 = 3 - amountOfThrownDarts;
    //set remaining throws to 0 (e.g. 20 left -> with first dart T20 -> set 2nd & 3rd throw also to 0)
    for (int i = 0; i < diffTo3; i++) {
      stats.getAllScoresPerDart.add(0);
      stats.getAllScoresPerDartAsString.add('0');
    }

    //reset amount of thrown darts
    stats.setCurrentThrownDartsInLeg =
        stats.getCurrentThrownDartsInLeg + diffTo3;
    stats.setAllThrownDarts = stats.getAllThrownDarts + diffTo3;

    //first nine avg count
    stats.setFirstNineAvgCount = stats.getFirstNineAvgCount + diffTo3;

    gameX01.getCurrentThreeDarts[0] = '0';
    gameX01.getCurrentThreeDarts[1] = '0';
    gameX01.getCurrentThreeDarts[2] = '0';

    if (stats.getAllScoresPerDartAsStringCount.containsKey('0')) {
      stats.getAllScoresPerDartAsStringCount['0'] += 3;
    } else {
      stats.getAllScoresPerDartAsStringCount['0'] = 3;
    }
  }

  static bool _gameWonBestOfWithLegsWithDrawMode(
      int legsWon, GameSettingsX01_P gameSettingsX01) {
    return gameSettingsX01.getBestOfOrFirstTo == BestOfOrFirstToEnum.BestOf &&
        legsWon == (gameSettingsX01.getLegs / 2) + 1;
  }

  static bool _gameWonBestOfWithSetsWithDrawMode(
      int setsWon, GameSettingsX01_P gameSettingsX01) {
    return gameSettingsX01.getBestOfOrFirstTo == BestOfOrFirstToEnum.BestOf &&
        setsWon == (gameSettingsX01.getSets / 2) + 1;
  }

  static _showDialogForSuddenDeath(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DIALOG_SHAPE_ROUNDING),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        contentPadding: ResponsiveBreakpoints.of(context).isMobile
            ? DIALOG_CONTENT_PADDING_MOBILE
            : null,
        title: Text(
          'Sudden death',
          style: TextStyle(
            color: Colors.white,
            fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
          ),
        ),
        content: Container(
          width: DIALOG_NORMAL_WIDTH.w,
          child: RichText(
            text: TextSpan(
              text: 'The ',
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: 'Sudden death',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text:
                      ' leg is reached. The player who wins this leg also wins the game.',
                )
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (context.read<Settings_P>().getVibrationFeedbackEnabled) {
                HapticFeedback.lightImpact();
              }
              Navigator.of(context).pop();
              _showDialogForSuddenDeathBeginner(context);
            },
            child: Text(
              'Continue',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
              ),
            ),
            style: ButtonStyle(
              splashFactory: NoSplash.splashFactory,
              shadowColor: MaterialStateProperty.all(Colors.transparent),
              overlayColor: MaterialStateProperty.all(Colors.transparent),
              backgroundColor:
                  Utils.getPrimaryMaterialStateColorDarken(context),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(DIALOG_BTN_SHAPE_ROUNDING),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static _showDialogForSuddenDeathBeginner(BuildContext context) {
    final GameSettingsX01_P gameSettingsX01 = context.read<GameSettingsX01_P>();
    final GameX01_P gameX01 = context.read<GameX01_P>();
    final bool isSingleMode =
        gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Single;

    final List<Player> players = gameSettingsX01.getPlayers;
    Player? selectedPlayer = gameSettingsX01.getPlayers[0];

    final List<Team> teams = gameSettingsX01.getTeams;
    Team? selectedTeam = gameSettingsX01.getTeams[0];

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DIALOG_SHAPE_ROUNDING),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        contentPadding: ResponsiveBreakpoints.of(context).isMobile
            ? DIALOG_CONTENT_PADDING_MOBILE
            : null,
        title: Text(
          'Who will begin?',
          style: TextStyle(
            color: Colors.white,
            fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
          ),
        ),
        content: Container(
          width: DIALOG_NORMAL_WIDTH.w,
          child: StatefulBuilder(
            builder: ((context, setState) {
              if (isSingleMode) {
                return Container(
                  width: double.maxFinite,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: players.length,
                    itemBuilder: (BuildContext context, int index) {
                      final player = players[index];

                      return Theme(
                        data: ThemeData(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                        ),
                        child: ListTile(
                          title: player is Bot
                              ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Bot - lvl. ${player.getLevel}',
                                      style: TextStyle(
                                        fontSize: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .fontSize,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Container(
                                      transform: Matrix4.translationValues(
                                          0.0, -0.5.w, 0.0),
                                      child: Text(
                                        ' (${player.getPreDefinedAverage.round() - BOT_AVG_SLIDER_VALUE_RANGE} - ${player.getPreDefinedAverage.round() + BOT_AVG_SLIDER_VALUE_RANGE} avg.)',
                                        style: TextStyle(
                                          fontSize: 8.sp,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Text(
                                  player.getName,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .fontSize,
                                  ),
                                ),
                          leading: Theme(
                            data: Theme.of(context).copyWith(
                                unselectedWidgetColor:
                                    Utils.getPrimaryColorDarken(context)),
                            child: Radio<Player>(
                              activeColor:
                                  Theme.of(context).colorScheme.secondary,
                              value: player,
                              groupValue: selectedPlayer,
                              onChanged: (value) {
                                Utils.handleVibrationFeedback(context);
                                setState(
                                  () {
                                    Utils.handleVibrationFeedback(context);
                                    setState(() => selectedPlayer = value);
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }

              return Container(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: teams.length,
                  itemBuilder: (BuildContext context, int index) {
                    final Team team = teams[index];

                    return Theme(
                      data: ThemeData(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                      ),
                      child: ListTile(
                        title: Text(
                          team.getName,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .fontSize,
                          ),
                        ),
                        leading: Theme(
                          data: Theme.of(context).copyWith(
                              unselectedWidgetColor:
                                  Utils.getPrimaryColorDarken(context)),
                          child: Radio<Team>(
                            activeColor:
                                Theme.of(context).colorScheme.secondary,
                            value: team,
                            groupValue: selectedTeam,
                            onChanged: (value) {
                              Utils.handleVibrationFeedback(context);
                              setState(
                                () {
                                  Utils.handleVibrationFeedback(context);
                                  setState(() => selectedTeam = value);
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Utils.handleVibrationFeedback(context);
              _setSuddenDeathStartingPlayer(selectedPlayer, selectedTeam,
                  isSingleMode, gameX01, gameSettingsX01);
              Navigator.of(context).pop();
            },
            child: Text(
              'Continue',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
              ),
            ),
            style: ButtonStyle(
              splashFactory: NoSplash.splashFactory,
              shadowColor: MaterialStateProperty.all(Colors.transparent),
              overlayColor: MaterialStateProperty.all(Colors.transparent),
              backgroundColor:
                  Utils.getPrimaryMaterialStateColorDarken(context),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(DIALOG_BTN_SHAPE_ROUNDING),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static void _setSuddenDeathStartingPlayer(
      Player? playerToStart,
      Team? teamToStart,
      bool isSingleMode,
      GameX01_P gameX01,
      GameSettingsX01_P gameSettingsX01) {
    if (isSingleMode && playerToStart != null) {
      gameX01.setSuddenDeathStarter = new SuddenDeathStarter(
          player: playerToStart, prevPlayer: gameX01.getCurrentPlayerToThrow);
      gameX01.setCurrentPlayerToThrow = playerToStart;
      gameX01.setPlayerOrTeamLegStartIndex =
          gameSettingsX01.getPlayers.indexOf(playerToStart);
    } else if (!isSingleMode && teamToStart != null) {
      gameX01.setSuddenDeathStarter = new SuddenDeathStarter(
          team: teamToStart, prevTeam: gameX01.getCurrentTeamToThrow);
      gameX01.setCurrentTeamToThrow = teamToStart;
      gameX01.setCurrentPlayerToThrow = teamToStart.getCurrentPlayerToThrow;
      gameX01.setPlayerOrTeamLegStartIndex =
          gameSettingsX01.getTeams.indexOf(teamToStart);
    }
    gameX01.notify();
  }

  static bool _isGameWon(
      PlayerOrTeamGameStatsX01 stats,
      GameX01_P gameX01,
      GameSettingsX01_P gameSettingsX01,
      BuildContext context,
      bool shouldSubmitTeamStats) {
    if (gameX01.getReachedSuddenDeath) {
      if (gameSettingsX01.getSetsEnabled) {
        _updateSets(stats, gameSettingsX01, gameX01, shouldSubmitTeamStats);
      }
      return true;
    }

    // draw mode
    if (gameSettingsX01.getDrawMode) {
      return _gameWonBestOfWithLegsWithDrawMode(
              stats.getLegsWonTotal, gameSettingsX01) ||
          _gameWonBestOfWithSetsWithDrawMode(stats.getSetsWon, gameSettingsX01);
    } else if (gameSettingsX01.getSetsEnabled) {
      // set mode
      if (gameSettingsX01.getWinByTwoLegsDifference &&
          _isLastSet(gameX01, gameSettingsX01)) {
        // suddean death reached
        if (gameSettingsX01.getSuddenDeath &&
            reachedSuddenDeath(gameX01, gameSettingsX01)) {
          _showDialogForSuddenDeath(context);
          gameX01.setReachedSuddenDeath = true;
        }

        if (gameX01.isLegDifferenceAtLeastTwo(
            stats, gameX01, gameSettingsX01)) {
          _updateSets(stats, gameSettingsX01, gameX01, shouldSubmitTeamStats);
          return true;
        }
      }

      return Utils.gameWonFirstToWithSets(stats.getSetsWon, gameSettingsX01) ||
          Utils.gameWonBestOfWithSets(stats.getSetsWon, gameSettingsX01);
    } else if (!gameSettingsX01.getSetsEnabled) {
      // leg mode
      if (Utils.gameWonFirstToWithLegs(
              stats.getLegsWonTotal, gameSettingsX01) ||
          Utils.gameWonBestOfWithLegs(stats.getLegsWonTotal, gameSettingsX01)) {
        if (!gameSettingsX01.getWinByTwoLegsDifference) {
          return true;
        }

        // suddean death reached
        if (gameSettingsX01.getSuddenDeath &&
            reachedSuddenDeath(gameX01, gameSettingsX01)) {
          _showDialogForSuddenDeath(context);
          gameX01.setReachedSuddenDeath = true;
        }

        if (gameX01.isLegDifferenceAtLeastTwo(
            stats, gameX01, gameSettingsX01)) {
          return true;
        }
      }
    }

    return false;
  }

  static bool reachedSuddenDeath(
      GameX01_P gameX01, GameSettingsX01_P gameSettingsX01) {
    bool result = true;

    for (PlayerOrTeamGameStatsX01 stats in Utils.getPlayersOrTeamStatsList(
        gameX01, gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Team)) {
      late double legsForSuddenDeath;
      if (gameSettingsX01.getBestOfOrFirstTo == BestOfOrFirstToEnum.FirstTo) {
        legsForSuddenDeath =
            (gameSettingsX01.getLegs + gameSettingsX01.getMaxExtraLegs)
                .toDouble();
      } else {
        legsForSuddenDeath = ((gameSettingsX01.getLegs + 1) / 2) +
            gameSettingsX01.getMaxExtraLegs;
      }

      if (stats.getLegsWon != legsForSuddenDeath) {
        result = false;
      }
    }

    return result;
  }

  static bool isBotBeginning(PlayerOrTeamGameStatsX01 currentStats,
      GameX01_P gameX01_P, GameSettingsX01_P gameSettingsX01_P) {
    if (gameSettingsX01_P.getSingleOrTeam == SingleOrTeamEnum.Single) {
      return currentStats.getPlayer == null ||
          (currentStats.getPlayer is Bot &&
              currentStats.getAllThrownDarts == 0 &&
              gameSettingsX01_P.getPlayers.first == currentStats.getPlayer);
    }

    // team
    return currentStats.getTeam == null ||
        (currentStats.getTeam.getPlayers.first is Bot &&
            currentStats.getAllThrownDarts == 0 &&
            Player.samePlayer(gameSettingsX01_P.getTeams.first.getPlayers.first,
                currentStats.getTeam.getPlayers.first));
  }

  static bool _isLastSet(
      GameX01_P gameX01_P, GameSettingsX01_P gameSettingsX01_P) {
    bool isLastSet = true;
    final int lastSetFirstTo = gameSettingsX01_P.getSets - 1;
    final double lastSetBestOf = ((gameSettingsX01_P.getSets + 1) / 2) - 1;

    for (PlayerOrTeamGameStatsX01 stats in Utils.getPlayersOrTeamStatsList(
        gameX01_P,
        gameSettingsX01_P.getSingleOrTeam == SingleOrTeamEnum.Team)) {
      if ((gameSettingsX01_P.getBestOfOrFirstTo ==
                  BestOfOrFirstToEnum.FirstTo &&
              lastSetFirstTo != stats.getSetsWon) ||
          (gameSettingsX01_P.getBestOfOrFirstTo == BestOfOrFirstToEnum.BestOf &&
              lastSetBestOf != stats.getSetsWon)) {
        isLastSet = false;
      }
    }
    return isLastSet;
  }
}
