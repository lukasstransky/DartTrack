import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_statistics.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_statistics_x01.dart';
import 'package:dart_app/models/team.dart';
import 'package:dart_app/utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class Submit {
  /************************************************************/
  /********              PUBLIC METHODS                ********/
  /************************************************************/

  // thrownDarts -> selected from checkout dialog (only for input method -> round)
  // checkout count needed in order to revert checkout count
  // shouldSubmitTeamStats -> for team mode, to submit stats for team
  static submitPoints(String scoredFieldString, BuildContext context,
      [bool shouldSubmitTeamStats = false,
      int thrownDarts = 3,
      checkoutCount = 0]) {
    final GameX01 gameX01 = context.read<GameX01>();
    final GameSettingsX01 gameSettingsX01 = context.read<GameSettingsX01>();

    if (!_shouldSubmit(scoredFieldString, gameSettingsX01, gameX01)) return;

    final bool isBust = scoredFieldString == 'Bust' ? true : false;
    final int scoredPoints =
        isBust ? 0 : gameX01.getValueOfSpecificDart(scoredFieldString);

    late final PlayerOrTeamGameStatisticsX01 currentStats;
    if (shouldSubmitTeamStats)
      currentStats = gameX01.getCurrentTeamGameStats();
    else
      currentStats = gameX01.getCurrentPlayerGameStats();

    gameX01.setRevertPossible = true;

    if (gameSettingsX01.getInputMethod == InputMethod.ThreeDarts) {
      if (isBust) _submitBusted(currentStats, gameX01);

      _setAllRemainingScoresPerDart(currentStats, gameX01);
    } else {
      currentStats.setTotalPoints = currentStats.getTotalPoints + scoredPoints;

      // update current points for each player in team (to store e.g. finishes for specific player)
      if (_shouldUpdateStatsForPlayersOfSameTeam(
          shouldSubmitTeamStats, gameSettingsX01)) {
        for (PlayerOrTeamGameStatisticsX01 stats
            in _getPlayerStatsFromSameTeam(gameX01, gameSettingsX01)) {
          stats.setCurrentPoints = stats.getCurrentPoints - scoredPoints;
        }
      } else {
        currentStats.setCurrentPoints =
            currentStats.getCurrentPoints - scoredPoints;
      }
    }

    //add delay for last dart for three darts input method
    final int milliseconds =
        gameSettingsX01.getInputMethod == InputMethod.ThreeDarts &&
                gameSettingsX01.getAutomaticallySubmitPoints
            ? 800
            : 0;
    Future.delayed(Duration(milliseconds: milliseconds), () {
      currentStats.setPointsSelectedCount = 0;
      currentStats.setStartingPoints = currentStats.getCurrentPoints;
      gameX01.setCurrentPointsSelected = 'Points';

      if (gameSettingsX01.getInputMethod == InputMethod.ThreeDarts) {
        gameX01.setCurrentPointType = PointType.Single;
      } else {
        currentStats.setCurrentThrownDartsInLeg =
            currentStats.getCurrentThrownDartsInLeg + thrownDarts;
        currentStats.setAllThrownDarts =
            currentStats.getAllThrownDarts + thrownDarts;

        if (currentStats.getCurrentThrownDartsInLeg <= 9) {
          currentStats.setFirstNineAvgPoints =
              currentStats.getFirstNineAvgPoints + scoredPoints;
          currentStats.setFirstNineAvgCount =
              currentStats.getFirstNineAvgCount + thrownDarts;
        }
      }

      _setCheckoutCountAtThrownDarts(
          currentStats, checkoutCount, gameX01, gameSettingsX01);

      final int totalPoints =
          gameSettingsX01.getInputMethod == InputMethod.Round
              ? scoredPoints
              : int.parse(gameX01.getCurrentThreeDartsCalculated());

      currentStats.getAllScores.add(totalPoints);

      if (gameSettingsX01.getInputMethod == InputMethod.Round)
        currentStats.setAllScoresCountForRound =
            currentStats.getAllScoresCountForRound + 1;

      _setScores(currentStats, totalPoints, gameX01, gameSettingsX01);
      _legSetOrGameFinished(currentStats, context, totalPoints, thrownDarts,
          gameX01, shouldSubmitTeamStats);

      if (shouldSubmitTeamStats)
        _setNextTeamAndPlayer(currentStats, gameX01, gameSettingsX01);
      if (gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Single)
        _setNextPlayer(currentStats, gameX01, gameSettingsX01);

      if (gameX01.getCurrentThreeDarts[2] != 'Dart 3')
        gameX01.resetCurrentThreeDarts();

      gameX01.notify();
    });

    // submit team stats
    if (!shouldSubmitTeamStats &&
        gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Team)
      submitPoints(
          scoredFieldString, context, true, thrownDarts, checkoutCount);

    if (shouldSubmitTeamStats) {
      for (PlayerOrTeamGameStatisticsX01 stats
          in _getPlayerStatsFromSameTeam(gameX01, gameSettingsX01)) {
        stats.setLegsWon = currentStats.getLegsWon;
        stats.setLegsWonTotal = currentStats.getLegsWonTotal;
        stats.setSetsWon = currentStats.getSetsWon;
      }
    }
  }

  static bust(BuildContext context) {
    submitPoints('Bust', context);
  }

  static submitStatsForThreeDartsMode(
      BuildContext context, int scoredPoints, String scoredFieldWithPointType) {
    final GameX01 gameX01 = context.read<GameX01>();
    final PlayerOrTeamGameStatisticsX01 stats =
        gameX01.getCurrentPlayerGameStats();

    gameX01.setRevertPossible = true;

    //set points
    stats.setCurrentPoints = stats.getCurrentPoints - scoredPoints;

    //set all scores per dart
    stats.getAllScoresPerDart.add(scoredPoints);

    //add to total Points -> to calc avg.
    stats.setTotalPoints = stats.getTotalPoints + scoredPoints;

    //set thrown darts
    stats.setCurrentThrownDartsInLeg = stats.getCurrentThrownDartsInLeg + 1;
    stats.setAllThrownDarts = stats.getAllThrownDarts + 1;

    //set first nine avg
    if (stats.getCurrentThrownDartsInLeg <= 9) {
      stats.setFirstNineAvgPoints = stats.getFirstNineAvgPoints + scoredPoints;
      stats.setFirstNineAvgCount = stats.getFirstNineAvgCount + 1;
    }

    //all scores per dart as string + count
    if (stats.getAllScoresPerDartAsStringCount
        .containsKey(scoredFieldWithPointType))
      stats.getAllScoresPerDartAsStringCount[scoredFieldWithPointType] += 1;
    else
      stats.getAllScoresPerDartAsStringCount[scoredFieldWithPointType] = 1;

    stats.getAllScoresPerDartAsString.add(scoredFieldWithPointType);
  }

  /************************************************************/
  /********              PRIVATE METHODS                ********/
  /************************************************************/

  static _setScores(PlayerOrTeamGameStatisticsX01 stats, int totalPoints,
      GameX01 gameX01, GameSettingsX01 gameSettingsX01) {
    if (stats.getPreciseScores.containsKey(totalPoints))
      stats.getPreciseScores[totalPoints] += 1;
    else
      stats.getPreciseScores[totalPoints] = 1;

    //set rounded score even
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

    //set rounded scores odd
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

    //set all scores per leg
    final String key =
        gameX01.getCurrentLegSetAsString(gameX01, gameSettingsX01);
    if (stats.getAllScoresPerLeg.containsKey(key)) {
      //add to value list
      stats.getAllScoresPerLeg[key].add(totalPoints);
    } else {
      //create new pair in map
      stats.getAllScoresPerLeg[key] = [totalPoints];
    }
  }

  static dynamic _getPlayerStatsFromSameTeam(
      GameX01 gameX01, GameSettingsX01 gameSettingsX01) {
    List<PlayerOrTeamGameStatisticsX01> result = [];
    for (PlayerOrTeamGameStatisticsX01 stats
        in gameX01.getPlayerGameStatistics) {
      final Team teamOfPlayer = gameSettingsX01.findTeamForPlayer(
          stats.getPlayer.getName, gameSettingsX01);

      if (teamOfPlayer.getName == gameX01.getCurrentTeamToThrow.getName)
        result.add(stats);
    }

    return result;
  }

  static bool _shouldUpdateStatsForPlayersOfSameTeam(
      bool shouldSubmitTeamStats, GameSettingsX01 gameSettingsX01) {
    return !shouldSubmitTeamStats &&
        gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Team;
  }

  static _legSetOrGameFinished(
      PlayerOrTeamGameStatisticsX01 currentStats,
      BuildContext context,
      int totalPoints,
      int thrownDarts,
      GameX01 gameX01,
      bool shouldSubmitTeamStats) {
    if (currentStats.getCurrentPoints != 0) return;

    final GameSettingsX01 gameSettingsX01 = context.read<GameSettingsX01>();
    final String currentLeg =
        gameX01.getCurrentLegSetAsString(gameX01, gameSettingsX01);

    //set thrown darts per leg & reset points
    for (PlayerOrTeamGameStatisticsX01 stats in (shouldSubmitTeamStats
        ? gameX01.getTeamGameStatistics
        : gameX01.getPlayerGameStatistics)) {
      stats.getThrownDartsPerLeg[currentLeg] = stats.getCurrentThrownDartsInLeg;
      stats.getAmountOfFinishDarts[currentLeg] = thrownDarts;

      if (currentStats == stats) {
        stats.setDartsForWonLegCount =
            stats.getDartsForWonLegCount + stats.getCurrentThrownDartsInLeg;
        stats.getAllRemainingPoints.add(totalPoints);
      } else {
        stats.getAllRemainingPoints.add(stats.getCurrentPoints);
      }

      stats.setCurrentPoints = gameSettingsX01.getPointsOrCustom();
      stats.setStartingPoints = stats.getCurrentPoints;
    }

    //add checkout to list
    currentStats.getCheckouts[currentLeg] = totalPoints;

    if (shouldSubmitTeamStats) {
      currentStats.getPlayersWithCheckoutInLeg[
              gameX01.getCurrentLegSetAsString(gameX01, gameSettingsX01)] =
          currentStats.getTeam.getCurrPlayerToThrow.getName;
    }

    //update won legs
    currentStats.setLegsWon = currentStats.getLegsWon + 1;
    currentStats.setLegsWonTotal = currentStats.getLegsWonTotal + 1;

    bool isGameFinished = false;
    if (gameSettingsX01.getSetsEnabled) {
      if (gameSettingsX01.getLegs == currentStats.getLegsWon) {
        //save leg count of each player -> in case a user wants to revert a set
        for (PlayerOrTeamGameStatisticsX01 stats in gameX01
            .getPlayerGameStatistics) stats.getLegsCount.add(stats.getLegsWon);
        if (shouldSubmitTeamStats) {
          for (PlayerOrTeamGameStatisticsX01 stats in gameX01
              .getTeamGameStatistics) stats.getLegsCount.add(stats.getLegsWon);
        }

        //update won sets
        if (gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Single) {
          currentStats.setLegsWon = currentStats.getLegsWon + 1;
          currentStats.setSetsWon = currentStats.getSetsWon + 1;
        }
      }
    }

    if (_isGameWon(currentStats, gameX01, gameSettingsX01)) {
      _sortPlayerStats(gameX01, gameSettingsX01);
      currentStats.setGameWon = true;
      isGameFinished = true;
    } else if (_gameDraw(gameX01, gameSettingsX01)) {
      currentStats.setGameDraw = true;
      isGameFinished = true;
    }

    if (isGameFinished || currentStats.getGameDraw)
      Navigator.of(context).pushNamed('/finishX01');
    else {
      for (PlayerOrTeamGameStatisticsX01 stats in gameX01
          .getPlayerGameStatistics) stats.setCurrentThrownDartsInLeg = 0;
      if (shouldSubmitTeamStats) {
        for (PlayerOrTeamGameStatisticsX01 stats in gameX01
            .getTeamGameStatistics) stats.setCurrentThrownDartsInLeg = 0;
      }
    }

    // set player or team who will begin next leg (for icon)
    if (gameX01.getPlayerOrTeamLegStartIndex ==
        gameSettingsX01.getPlayers.length - 1)
      gameX01.setPlayerOrTeamLegStartIndex = 0;
    else
      gameX01.setPlayerOrTeamLegStartIndex =
          gameX01.getPlayerOrTeamLegStartIndex + 1;

    if (gameSettingsX01.getInputMethod == InputMethod.ThreeDarts)
      gameX01.resetCurrentThreeDarts();
  }

//in order to show the right order in the finish screen
  static _sortPlayerStats(GameX01 gameX01, GameSettingsX01 gameSettingsX01) {
    //convert playerGameStatistics to playerOrTeamGameStatsX01 -> otherwise cant sort
    List<PlayerOrTeamGameStatisticsX01> temp = [];
    for (PlayerOrTeamGameStatistics stats in gameX01.getPlayerGameStatistics) {
      temp.add(stats as PlayerOrTeamGameStatisticsX01);
    }

    //if sets are enabled -> sort after sets, otherwise after legs
    if (gameSettingsX01.getSetsEnabled)
      temp.sort((a, b) => b.getSetsWon.compareTo(a.getSetsWon));
    else
      temp.sort((a, b) => b.getLegsWon.compareTo(a.getLegsWon));

    gameX01.setPlayerGameStatistics = temp;
  }

  static bool _gameDraw(GameX01 gameX01, GameSettingsX01 gameSettingsX01) {
    for (PlayerOrTeamGameStatisticsX01 stats
        in gameX01.getPlayerGameStatistics) {
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

  static _setNextTeamAndPlayer(PlayerOrTeamGameStatisticsX01 stats,
      GameX01 gameX01, GameSettingsX01 gameSettingsX01) {
    final List<Team> teams = gameSettingsX01.getTeams;
    final int indexOfCurrentTeam = teams.indexOf(gameX01.getCurrentTeamToThrow);

    final List<Player> players = gameX01.getCurrentTeamToThrow.getPlayers;
    final int indexOfCurrentPlayerInCurrentTeam =
        players.indexOf(gameX01.getCurrentPlayerToThrow);

    if (_shouldSetNextPlayerOrTeam(gameX01, gameSettingsX01, stats)) {
      // set next player of current team
      if (indexOfCurrentPlayerInCurrentTeam + 1 == players.length) {
        // round of all players finished -> restart from beginning
        gameX01.getCurrentTeamToThrow.setCurrPlayerToThrow = players[0];
      } else {
        gameX01.getCurrentTeamToThrow.setCurrPlayerToThrow =
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
          gameX01.getCurrentTeamToThrow.getCurrPlayerToThrow;

      if (scrollController.isAttached)
        scrollController.jumpTo(index: jumpToIndex);
    }
  }

  static _setNextPlayer(PlayerOrTeamGameStatisticsX01 stats, GameX01 gameX01,
      GameSettingsX01 gameSettingsX01) {
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

      if (scrollController.isAttached)
        scrollController.jumpTo(index: jumpToIndex);
    }
  }

  // case 1 -> input method is round
  // case 2 -> input method is three darts -> 3 darts entered
  // case 3 -> input method is three darts -> 1 or 2 darts entered & finished leg/set/game
  static bool _shouldSetNextPlayerOrTeam(GameX01 gameX01,
      GameSettingsX01 gameSettingsX01, PlayerOrTeamGameStatisticsX01 stats) {
    return (gameSettingsX01.getInputMethod == InputMethod.Round) ||
        (gameSettingsX01.getInputMethod == InputMethod.ThreeDarts &&
            (gameX01.getCurrentThreeDarts[2] != 'Dart 3' ||
                stats.getCurrentPoints == gameSettingsX01.getPointsOrCustom()));
  }

  static _setAllRemainingScoresPerDart(
      PlayerOrTeamGameStatisticsX01 stats, GameX01 gameX01) {
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

  static _setCheckoutCountAtThrownDarts(PlayerOrTeamGameStatisticsX01 stats,
      int checkoutCount, GameX01 gameX01, GameSettingsX01 gameSettingsX01) {
    if (checkoutCount == 0) {
      return;
    }

    final Tuple3<String, int, int> tuple = Tuple3<String, int, int>(
        gameX01.getCurrentLegSetAsString(gameX01, gameSettingsX01),
        stats.getCurrentThrownDartsInLeg,
        checkoutCount);

    stats.setCheckoutCount = stats.getCheckoutCount + checkoutCount;
    stats.getCheckoutCountAtThrownDarts.add(tuple);
  }

  static bool _shouldSubmit(
      String thrownPoints, GameSettingsX01 gameSettingsX01, GameX01 gameX01) {
    if (thrownPoints == 'Bust' ||
        gameSettingsX01.getInputMethod == InputMethod.Round ||
        (gameSettingsX01.getInputMethod == InputMethod.ThreeDarts &&
                (gameX01.getAmountOfDartsThrown() == 3) ||
            gameX01.finishedLegSetOrGame(
                gameX01.getCurrentThreeDartsCalculated()))) {
      return true;
    }

    return false;
  }

//if player clicks on bust in three darts mode
  static _submitBusted(PlayerOrTeamGameStatisticsX01 stats, GameX01 gameX01) {
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

        //if amount of precise scores is 0 -> remove it from map
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
      int setsWon, GameSettingsX01 gameSettingsX01) {
    return gameSettingsX01.getMode == BestOfOrFirstToEnum.FirstTo &&
        gameSettingsX01.getSetsEnabled &&
        gameSettingsX01.getSets == setsWon;
  }

  static bool _gameWonFirstToWithLegs(
      int legsWon, GameSettingsX01 gameSettingsX01) {
    return gameSettingsX01.getMode == BestOfOrFirstToEnum.FirstTo &&
        legsWon >= gameSettingsX01.getLegs;
  }

  static bool _gameWonBestOfWithSets(
      int setsWon, GameSettingsX01 gameSettingsX01) {
    return gameSettingsX01.getMode == BestOfOrFirstToEnum.BestOf &&
        gameSettingsX01.getSetsEnabled &&
        ((setsWon * 2) - 1) == gameSettingsX01.getSets;
  }

  static bool _gameWonBestOfWithLegs(
      int legsWon, GameSettingsX01 gameSettingsX01) {
    return gameSettingsX01.getMode == BestOfOrFirstToEnum.BestOf &&
        ((legsWon * 2) - 1) == gameSettingsX01.getLegs;
  }

  static bool _isGameWon(PlayerOrTeamGameStatisticsX01 stats, GameX01 gameX01,
      GameSettingsX01 gameSettingsX01) {
    if (gameX01.getReachedSuddenDeath) return true;

    if (_gameWonFirstToWithSets(stats.getSetsWon, gameSettingsX01) ||
        _gameWonBestOfWithSets(stats.getSetsWon, gameSettingsX01) ||
        _gameWonBestOfWithLegs(stats.getLegsWonTotal, gameSettingsX01)) {
      return true;
    } else if (_gameWonFirstToWithLegs(
        stats.getLegsWonTotal, gameSettingsX01)) {
      if (!gameSettingsX01.getWinByTwoLegsDifference) return true;

      //suddean death reached
      if (gameSettingsX01.getSuddenDeath &&
          _reachedSuddenDeath(gameX01, gameSettingsX01))
        gameX01.setReachedSuddenDeath = true;

      if (_isLegDifferenceAtLeastTwo(stats, gameX01)) return true;
    }

    return false;
  }

  //for win by two legs diff -> checks if leg won difference is at least 2 at each player -> return true (valid win)
  static bool _isLegDifferenceAtLeastTwo(
      PlayerOrTeamGameStatisticsX01 playerToCheck, GameX01 gameX01) {
    for (PlayerOrTeamGameStatisticsX01 stats
        in gameX01.getPlayerGameStatistics) {
      if (stats != playerToCheck &&
          (playerToCheck.getLegsWon - 2) < stats.getLegsWon) {
        return false;
      }
    }

    return true;
  }

  static bool _reachedSuddenDeath(
      GameX01 gameX01, GameSettingsX01 gameSettingsX01) {
    bool result = true;

    for (PlayerOrTeamGameStatisticsX01 stats
        in gameX01.getPlayerGameStatistics) {
      final int legs =
          gameSettingsX01.getLegs + gameSettingsX01.getMaxExtraLegs;
      if (stats.getLegsWon != legs) {
        result = false;
      }
    }

    return result;
  }
}
