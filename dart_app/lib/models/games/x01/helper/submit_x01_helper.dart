import 'package:dart_app/constants.dart';
import 'package:dart_app/models/bot.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats_x01.dart';
import 'package:dart_app/models/team.dart';
import 'package:dart_app/screens/game_modes/shared/game/point_btns_three_darts/utils_point_btns_three_darts.dart';
import 'package:dart_app/utils/globals.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

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

    gameX01.setRevertPossible = true;

    if (gameSettingsX01.getInputMethod == InputMethod.Round) {
      currentStats.getInputMethodForRounds.add(gameSettingsX01.getInputMethod);
    } else if (currentStats.getPlayer is Bot &&
        gameSettingsX01.getInputMethod == InputMethod.ThreeDarts) {
      currentStats.getInputMethodForRounds.add(InputMethod.Round);
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

    // set starting points (3-darts-mode)
    if (isInputMethodThreeDarts) {
      if (_shouldUpdateStatsForPlayersOfSameTeam(
          shouldSubmitTeamStats, gameSettingsX01)) {
        for (PlayerOrTeamGameStatsX01 stats in gameX01
            .getPlayerStatsFromCurrentTeamToThrow(gameX01, gameSettingsX01)) {
          stats.setStartingPoints = currentStats.getCurrentPoints;
        }
      }
    } else {
      currentStats.setStartingPoints = currentStats.getCurrentPoints;
    }

    //add delay for last dart for three darts input method
    final int milliseconds =
        isInputMethodThreeDarts && gameSettingsX01.getAutomaticallySubmitPoints
            ? 800
            : 0;

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
      final bool legSetOrGameFinsihed = _legSetOrGameFinished(currentStats,
          context, totalPoints, thrownDarts, gameX01, shouldSubmitTeamStats);

      if (!legSetOrGameFinsihed) {
        if (shouldSubmitTeamStats) {
          _setNextTeamAndPlayer(currentStats, gameX01, gameSettingsX01);
        } else if (gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Single) {
          _setNextPlayer(currentStats, gameX01, gameSettingsX01);
        }
      }

      // reset current 3 darts for 3-darts-mode
      if (isInputMethodThreeDarts) {
        if (gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Team) {
          if ((gameX01.getCurrentThreeDarts[2] != 'Dart 3' ||
                  legSetOrGameFinsihed) &&
              shouldSubmitTeamStats) {
            UtilsPointBtnsThreeDarts.resetCurrentThreeDarts(
                gameX01.getCurrentThreeDarts);
          }
        } else {
          if (gameX01.getCurrentThreeDarts[2] != 'Dart 3' ||
              legSetOrGameFinsihed) {
            UtilsPointBtnsThreeDarts.resetCurrentThreeDarts(
                gameX01.getCurrentThreeDarts);
          }
        }
      }

      // reset current points & starting points, if leg, set, game won
      if (legSetOrGameFinsihed) {
        if (shouldSubmitTeamStats) {
          for (PlayerOrTeamGameStatsX01 stats
              in gameX01.getTeamGameStatistics) {
            stats.setCurrentPoints = gameSettingsX01.getPointsOrCustom();
            stats.setStartingPoints = gameSettingsX01.getPointsOrCustom();
          }
        }

        if (!shouldSubmitTeamStats) {
          for (PlayerOrTeamGameStatsX01 stats
              in gameX01.getPlayerGameStatistics) {
            stats.setCurrentPoints = gameSettingsX01.getPointsOrCustom();
            stats.setStartingPoints = gameSettingsX01.getPointsOrCustom();
          }
        }
      }
      if (!legSetOrGameFinsihed) {
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
        stats.setLegsWonTotal = currentStats.getLegsWonTotal;
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
    final String key =
        gameX01.getCurrentSetLegAsString(gameX01, gameSettingsX01);
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

  static bool _legSetOrGameFinished(
      PlayerOrTeamGameStatsX01 currentStats,
      BuildContext context,
      int totalPoints,
      int thrownDarts,
      GameX01_P gameX01,
      bool shouldSubmitTeamStats) {
    if (currentStats.getCurrentPoints != 0) {
      return false;
    }

    final GameSettingsX01_P gameSettingsX01 = context.read<GameSettingsX01_P>();
    final String currentSetLeg =
        gameX01.getCurrentSetLegAsString(gameX01, gameSettingsX01);
    final bool isSingleMode =
        gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Single
            ? true
            : false;

    // set amount of finish darts
    currentStats.getAmountOfFinishDarts[currentSetLeg] = thrownDarts;

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
      gameX01.getLegSetWithPlayerOrTeamWhoFinishedIt[currentSetLeg] =
          playerOrTeamName;
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
      gameX01.getCurrentPlayerOfTeamsBeforeLegFinish[currentSetLeg] = players;
    }

    _updateLegsSets(
        currentStats, gameSettingsX01, gameX01, shouldSubmitTeamStats);

    bool isGameFinished = false;
    if (_isGameWon(currentStats, gameX01, gameSettingsX01, context)) {
      _sortPlayerStats(gameX01, gameSettingsX01);
      currentStats.setGameWon = true;
      isGameFinished = true;

      // set game won also for other players in team -> for correct stats
      if (shouldSubmitTeamStats) {
        for (Player player in currentStats.getTeam.getPlayers) {
          _getPlayerStatsByName(player.getName, gameX01).setGameWon = true;
        }
      }
    } else if (_isGameDraw(gameX01, gameSettingsX01, shouldSubmitTeamStats)) {
      currentStats.setGameDraw = true;
      isGameFinished = true;

      // set game draw also for other players in team -> for correct stats
      if (shouldSubmitTeamStats) {
        for (Player player in currentStats.getTeam.getPlayers) {
          _getPlayerStatsByName(player.getName, gameX01).setGameDraw = true;
        }
      }
    }

    if ((isGameFinished || currentStats.getGameDraw)) {
      if (gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Single ||
          shouldSubmitTeamStats) Navigator.of(context).pushNamed('/finishX01');
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

    // set player or team who will begin next leg
    if (shouldSubmitTeamStats) {
      return true;
    }

    // set player leg start index
    if (isSingleMode &&
        gameX01.getPlayerOrTeamLegStartIndex ==
            gameSettingsX01.getPlayers.length - 1) {
      gameX01.setPlayerOrTeamLegStartIndex = 0;
    } else if (!isSingleMode &&
        gameX01.getPlayerOrTeamLegStartIndex ==
            gameSettingsX01.getTeams.length - 1) {
      gameX01.setPlayerOrTeamLegStartIndex = 0;
    } else {
      gameX01.setPlayerOrTeamLegStartIndex =
          gameX01.getPlayerOrTeamLegStartIndex + 1;
    }

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

    return true;
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

    // update won sets
    if (gameSettingsX01.getLegs == currentStats.getLegsWon) {
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

  // to show the right order in the finish screen
  static _sortPlayerStats(
      GameX01_P gameX01, GameSettingsX01_P gameSettingsX01) {
    //convert playerGameStatistics to playerOrTeamGameStatsX01 -> otherwise cant sort
    List<PlayerOrTeamGameStatsX01> temp = [];
    for (PlayerOrTeamGameStats stats in gameX01.getPlayerGameStatistics) {
      temp.add(stats as PlayerOrTeamGameStatsX01);
    }

    //if sets are enabled -> sort after sets, otherwise after legs
    if (gameSettingsX01.getSetsEnabled)
      temp.sort((a, b) => b.getSetsWon.compareTo(a.getSetsWon));
    else
      temp.sort((a, b) => b.getLegsWon.compareTo(a.getLegsWon));

    gameX01.setPlayerGameStatistics = temp;
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

  static _setNextTeamAndPlayer(PlayerOrTeamGameStatsX01 stats,
      GameX01_P gameX01, GameSettingsX01_P gameSettingsX01) {
    final List<Team> teams = gameSettingsX01.getTeams;
    int indexOfCurrentTeam = -1;
    for (int i = 0; i < teams.length; i++) {
      if (teams[i].getName == gameX01.getCurrentTeamToThrow.getName) {
        indexOfCurrentTeam = i;
      }
    }

    final List<Player> players = gameX01.getCurrentTeamToThrow.getPlayers;
    int indexOfCurrentPlayerInCurrentTeam = -1;
    for (int i = 0; i < players.length; i++) {
      if (players[i].getName == gameX01.getCurrentPlayerToThrow.getName) {
        indexOfCurrentPlayerInCurrentTeam = i;
      }
    }

    if (_shouldSetNextPlayerOrTeam(gameX01, gameSettingsX01, stats)) {
      // set next player of current team
      if (indexOfCurrentPlayerInCurrentTeam + 1 == players.length) {
        // round of all players finished -> restart from beginning
        gameX01.getCurrentTeamToThrow.setCurrentPlayerToThrow = players[0];
      } else {
        gameX01.getCurrentTeamToThrow.setCurrentPlayerToThrow =
            players[indexOfCurrentPlayerInCurrentTeam + 1];
      }

      // set next team
      int jumpToIndex = 0;
      if (indexOfCurrentTeam + 1 == teams.length) {
        // round of all teams finished -> restart from beginning
        gameX01.setCurrentTeamToThrow = teams[0];
      } else {
        gameX01.setCurrentTeamToThrow = teams[indexOfCurrentTeam + 1];
        jumpToIndex = indexOfCurrentTeam + 1;
      }

      // set next player of next team
      gameX01.setCurrentPlayerToThrow =
          gameX01.getCurrentTeamToThrow.getCurrentPlayerToThrow;

      if (gameX01.getCurrentPlayerToThrow is Bot) {
        gameX01.setBotSubmittedPoints = false;
      }

      if (scrollController.isAttached) {
        scrollController.jumpTo(index: jumpToIndex);
      }
    }
  }

  static _setNextPlayer(PlayerOrTeamGameStatsX01 stats, GameX01_P gameX01,
      GameSettingsX01_P gameSettingsX01) {
    final List<Player> players = gameSettingsX01.getPlayers;

    if (_shouldSetNextPlayerOrTeam(gameX01, gameSettingsX01, stats)) {
      final int indexOfCurrentPlayer =
          players.indexOf(gameX01.getCurrentPlayerToThrow);

      int jumpToIndex = 0;
      if (indexOfCurrentPlayer + 1 == players.length) {
        //round of all players finished -> restart from beginning
        gameX01.setCurrentPlayerToThrow = players[0];
      } else {
        gameX01.setCurrentPlayerToThrow = players[indexOfCurrentPlayer + 1];
        jumpToIndex = indexOfCurrentPlayer + 1;
      }

      if (gameX01.getCurrentPlayerToThrow is Bot) {
        gameX01.setBotSubmittedPoints = false;
      }

      if (scrollController.isAttached) {
        scrollController.jumpTo(index: jumpToIndex);
      }
    }
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
        gameX01.getCurrentSetLegAsString(gameX01, gameSettingsX01),
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
    final int amountOfThrownDarts = gameX01.getAmountOfDartsThrown();

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
    for (int i = 0; i < diffTo3 - 1; i++) {
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

    if (stats.getAllScoresPerDartAsStringCount.containsKey('0'))
      stats.getAllScoresPerDartAsStringCount['0'] += 3;
    else
      stats.getAllScoresPerDartAsStringCount['0'] = 3;
  }

  static bool _gameWonFirstToWithSets(
      int setsWon, GameSettingsX01_P gameSettingsX01) {
    return gameSettingsX01.getMode == BestOfOrFirstToEnum.FirstTo &&
        gameSettingsX01.getSetsEnabled &&
        gameSettingsX01.getSets == setsWon;
  }

  static bool _gameWonFirstToWithLegs(
      int legsWon, GameSettingsX01_P gameSettingsX01) {
    return gameSettingsX01.getMode == BestOfOrFirstToEnum.FirstTo &&
        legsWon >= gameSettingsX01.getLegs;
  }

  static bool _gameWonBestOfWithSets(
      int setsWon, GameSettingsX01_P gameSettingsX01) {
    return gameSettingsX01.getMode == BestOfOrFirstToEnum.BestOf &&
        gameSettingsX01.getSetsEnabled &&
        ((setsWon * 2) - 1) == gameSettingsX01.getSets;
  }

  static bool _gameWonBestOfWithLegs(
      int legsWon, GameSettingsX01_P gameSettingsX01) {
    return gameSettingsX01.getMode == BestOfOrFirstToEnum.BestOf &&
        ((legsWon * 2) - 1) == gameSettingsX01.getLegs;
  }

  static _showDialogForSuddenDeath(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.primary,
        contentPadding: EdgeInsets.only(
            bottom: DIALOG_CONTENT_PADDING_BOTTOM,
            top: DIALOG_CONTENT_PADDING_TOP,
            left: DIALOG_CONTENT_PADDING_LEFT,
            right: DIALOG_CONTENT_PADDING_RIGHT),
        title: Text(
          'Sudden Death',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          "The 'Sudden Death' leg is reached. The player who wins this leg also wins the game.",
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
        ],
      ),
    );
  }

  static bool _isGameWon(PlayerOrTeamGameStatsX01 stats, GameX01_P gameX01,
      GameSettingsX01_P gameSettingsX01, BuildContext context) {
    if (gameX01.getReachedSuddenDeath) {
      return true;
    }

    if (_gameWonFirstToWithSets(stats.getSetsWon, gameSettingsX01) ||
        _gameWonBestOfWithSets(stats.getSetsWon, gameSettingsX01) ||
        _gameWonBestOfWithLegs(stats.getLegsWonTotal, gameSettingsX01)) {
      return true;
    } else if (!gameSettingsX01.getSetsEnabled &&
        _gameWonFirstToWithLegs(stats.getLegsWonTotal, gameSettingsX01)) {
      if (!gameSettingsX01.getWinByTwoLegsDifference) {
        return true;
      }

      // suddean death reached
      if (gameSettingsX01.getSuddenDeath &&
          _reachedSuddenDeath(gameX01, gameSettingsX01)) {
        _showDialogForSuddenDeath(context);
        gameX01.setReachedSuddenDeath = true;
      }

      if (_isLegDifferenceAtLeastTwo(stats, gameX01)) {
        return true;
      }
    }

    return false;
  }

  //for win by two legs diff -> checks if leg won difference is at least 2 at each player -> return true (valid win)
  static bool _isLegDifferenceAtLeastTwo(
      PlayerOrTeamGameStatsX01 playerToCheck, GameX01_P gameX01) {
    for (PlayerOrTeamGameStatsX01 stats in gameX01.getPlayerGameStatistics) {
      if (stats != playerToCheck &&
          (playerToCheck.getLegsWon - 2) < stats.getLegsWon) {
        return false;
      }
    }

    return true;
  }

  static bool _reachedSuddenDeath(
      GameX01_P gameX01, GameSettingsX01_P gameSettingsX01) {
    bool result = true;

    for (PlayerOrTeamGameStatsX01 stats in gameX01.getPlayerGameStatistics) {
      final int legs =
          gameSettingsX01.getLegs + gameSettingsX01.getMaxExtraLegs;

      if (stats.getLegsWon != legs) {
        result = false;
      }
    }

    return result;
  }
}
