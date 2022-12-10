import 'package:dart_app/constants.dart';
import 'package:dart_app/models/bot.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_statistics_x01.dart';
import 'package:dart_app/models/team.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

import '../../player.dart';

class Revert {
  /************************************************************/
  /********              PUBLIC METHODS                ********/
  /************************************************************/

  static revertPoints(BuildContext context,
      [bool shouldRevertTeamStats = false]) {
    final GameX01 gameX01 = context.read<GameX01>();
    final GameSettingsX01 gameSettingsX01 = context.read<GameSettingsX01>();

    if (!_isRevertPossible(gameX01, gameSettingsX01) &&
        !shouldRevertTeamStats) {
      return;
    }

    final bool legSetOrGameReverted =
        _allPlayersTeamsHaveStartPoints(gameX01, gameSettingsX01);

    late PlayerOrTeamGameStatisticsX01 currentStats;
    if (shouldRevertTeamStats) {
      currentStats = gameX01.getCurrentTeamGameStats();
    } else {
      _setPreviousPlayerOrTeam(gameX01, gameSettingsX01, legSetOrGameReverted);
      currentStats = gameX01.getCurrentPlayerGameStats();
    }

    if (currentStats.getInputMethodForRounds.isNotEmpty) {
      final InputMethod lastInputMethod =
          currentStats.getInputMethodForRounds.removeLast();

      if (gameSettingsX01.getInputMethod != lastInputMethod) {
        gameSettingsX01.setInputMethod = lastInputMethod;
        gameSettingsX01.notify();
      }
    }

    if (currentStats.getPlayer is Bot &&
        currentStats.getPlayer.getIndexForGeneratedScores != 0) {
      currentStats.getPlayer.setIndexForGeneratedScores =
          currentStats.getPlayer.getIndexForGeneratedScores - 1;
    }

    final int lastPoints = gameSettingsX01.getInputMethod == InputMethod.Round
        ? currentStats.getAllScores.last
        : currentStats.getAllScoresPerDart.last;
    final bool isCompleteRound = _isCompleteRound(gameX01, gameSettingsX01,
        shouldRevertTeamStats); // in order to revert only 1 dart or full round
    bool alreadyReverted = false;

    // set current points selected count (prevent from entering more than 3 darts)
    if (isCompleteRound) {
      if (gameX01.getAmountOfDartsThrown() == 0 ||
          (shouldRevertTeamStats && gameX01.getAmountOfDartsThrown() == 2)) {
        currentStats.setPointsSelectedCount = 3;
      }
    }

    if (legSetOrGameReverted) {
      bool setReverted = false;

      if (currentStats.getLegsWon == 0) {
        setReverted = true;
      }

      for (PlayerOrTeamGameStatisticsX01 stats in (shouldRevertTeamStats
          ? gameX01.getTeamGameStatistics
          : gameX01.getPlayerGameStatistics)) {
        // set points for each player before leg/set was finished
        if (stats.getAllRemainingPoints.isNotEmpty) {
          stats.setCurrentPoints = stats.getAllRemainingPoints.last;
          stats.setStartingPoints = stats.getAllRemainingPoints.last;
          stats.getAllRemainingPoints.removeLast();
        }

        if (setReverted) {
          stats.setLegsWon = stats.getLegsCount.last;

          if (stats == currentStats) {
            stats.setSetsWon = stats.getSetsWon - 1;
            stats.setLegsWon = stats.getLegsCount.last - 1;
            stats.setLegsWonTotal = stats.getLegsWonTotal - 1;
          }
          stats.getLegsCount.removeLast();
        }

        // only revert stats for current selected player/team
        if (stats == currentStats) {
          if (gameSettingsX01.getInputMethod == InputMethod.ThreeDarts &&
              (gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Single ||
                  (gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Team &&
                      shouldRevertTeamStats))) {
            _setLastThrownDarts(
                stats.getAllRemainingScoresPerDart.last, gameX01);
            final int amountOfThrownDarts = gameX01.getAmountOfDartsThrown();

            stats.setCurrentPoints = gameX01.getValueOfSpecificDart(
                gameX01.getCurrentThreeDarts[amountOfThrownDarts - 1]);
            gameX01.getCurrentThreeDarts[amountOfThrownDarts - 1] =
                'Dart ' + amountOfThrownDarts.toString();

            // set also for players in team
            if (gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Team) {
              for (PlayerOrTeamGameStatisticsX01 playerStatsFromTeam
                  in gameX01.getPlayerStatsFromCurrentTeamToThrow(
                      gameX01, gameSettingsX01)) {
                playerStatsFromTeam.setCurrentPoints = stats.getCurrentPoints;
              }
            }
          }

          if (!setReverted) {
            stats.setLegsWon = stats.getLegsWon - 1;
            stats.setLegsWonTotal = stats.getLegsWonTotal - 1;
          }

          _revertStats(gameX01, gameSettingsX01, stats, lastPoints, true,
              isCompleteRound, shouldRevertTeamStats);
          alreadyReverted = true;
        } else {
          // set current thrown darts for each player before leg/set was finished
          final String lastKey = stats.getThrownDartsPerLeg.lastKey();

          stats.setCurrentThrownDartsInLeg =
              stats.getThrownDartsPerLeg[lastKey];

          if (stats.getThrownDartsPerLeg.isNotEmpty) {
            stats.getThrownDartsPerLeg.remove(lastKey);
          }
        }
      }
    }

    // revert stats for team
    if (shouldRevertTeamStats && !alreadyReverted) {
      _revertStats(gameX01, gameSettingsX01, currentStats, lastPoints, false,
          isCompleteRound, shouldRevertTeamStats);
    }

    if (!legSetOrGameReverted &&
        gameSettingsX01.getInputMethod == InputMethod.ThreeDarts) {
      final int amountOfThrownDarts = gameX01.getAmountOfDartsThrown();

      currentStats.setPointsSelectedCount =
          currentStats.getPointsSelectedCount - 1;

      // either for single player or for team in team mode
      if (amountOfThrownDarts == 0 &&
          (!shouldRevertTeamStats ||
              gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Single)) {
        _setLastThrownDarts(
            currentStats.getAllRemainingScoresPerDart.last, gameX01);
        gameX01.getCurrentThreeDarts[2] = 'Dart 3';
      } else {
        // otherwise this will be executed 2 times (for team and player)
        if (!shouldRevertTeamStats ||
            gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Single) {
          gameX01.getCurrentThreeDarts[amountOfThrownDarts - 1] =
              'Dart ' + amountOfThrownDarts.toString();
        }
      }
    }

    if (!legSetOrGameReverted) {
      if (shouldRevertTeamStats &&
          gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Team) {
        currentStats.setCurrentPoints =
            currentStats.getCurrentPoints + lastPoints;

        // revert current points for each player in team
        for (PlayerOrTeamGameStatisticsX01 stats in gameX01
            .getPlayerStatsFromCurrentTeamToThrow(gameX01, gameSettingsX01)) {
          stats.setCurrentPoints = stats.getCurrentPoints + lastPoints;
        }
      } else if (gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Single) {
        currentStats.setCurrentPoints =
            currentStats.getCurrentPoints + lastPoints;
      }
    }

    // update sets, legs for players from same team
    if (legSetOrGameReverted && shouldRevertTeamStats) {
      for (PlayerOrTeamGameStatisticsX01 stats in gameX01
          .getPlayerStatsFromCurrentTeamToThrow(gameX01, gameSettingsX01)) {
        stats.setLegsWon = currentStats.getLegsWon;
        stats.setLegsWonTotal = currentStats.getLegsWonTotal;
        stats.setSetsWon = currentStats.getSetsWon;
      }
    }

    if (!alreadyReverted && !shouldRevertTeamStats) {
      _revertStats(gameX01, gameSettingsX01, currentStats, lastPoints, false,
          isCompleteRound, shouldRevertTeamStats);
    }

    gameX01.setCurrentPointsSelected = 'Points';
    // if 1 score is left -> enters this if & removes last score -> without this call the revert btn is still highlighted
    _isRevertPossible(gameX01, gameSettingsX01);

    if (!shouldRevertTeamStats &&
        gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Team) {
      revertPoints(context, true);
    }
  }

  //only for cancel button in add checkout count dialog
  static revertSomeStats(BuildContext context, int points) {
    final GameX01 gameX01 = context.read<GameX01>();
    final PlayerOrTeamGameStatisticsX01 stats =
        gameX01.getCurrentPlayerGameStats();

    stats.setCurrentPoints = stats.getCurrentPoints + points;
    stats.setTotalPoints = stats.getTotalPoints - points;
    stats.setCurrentThrownDartsInLeg = stats.getCurrentThrownDartsInLeg - 1;
    stats.setAllThrownDarts = stats.getAllThrownDarts - 1;
    stats.setPointsSelectedCount = stats.getPointsSelectedCount - 1;

    if (stats.getCurrentThrownDartsInLeg <= 9) {
      stats.setFirstNineAvgPoints = stats.getFirstNineAvgPoints - points;
      stats.setFirstNineAvgCount = stats.getFirstNineAvgCount - 1;
    }

    //all scores per dart as string + count
    final String lastScorePerDart = stats.getAllScoresPerDartAsString.last;
    stats.getAllScoresPerDartAsString.removeLast();

    if (!stats.getAllScoresPerDartAsStringCount.containsKey(lastScorePerDart)) {
      return;
    }

    stats.getAllScoresPerDartAsStringCount[lastScorePerDart] -= 1;
    if (stats.getAllScoresPerDartAsStringCount[lastScorePerDart] == 0) {
      stats.getAllScoresPerDartAsStringCount
          .removeWhere((key, value) => key == lastScorePerDart);
    }
  }

  /************************************************************/
  /********              PRIVATE METHODS               ********/
  /************************************************************/

  static _setLastThrownDarts(List<String> points, GameX01 gameX01) {
    for (int i = 0; i < points.length; i++) {
      gameX01.getCurrentThreeDarts[i] = points[i];
    }
  }

  //returns true if at least one player has a score left
  static bool _isRevertPossible(
      GameX01 gameX01, GameSettingsX01 gameSettingsX01) {
    bool result = false;
    for (PlayerOrTeamGameStatisticsX01 stats
        in gameX01.getPlayerGameStatistics) {
      if (gameSettingsX01.getInputMethod == InputMethod.Round) {
        if (stats.getAllScores.length > 0) {
          result = true;
        }
      } else {
        if (stats.getAllScoresPerDart.length > 0) {
          result = true;
        }
      }
    }

    gameX01.setRevertPossible = result;
    gameX01.notify();

    return result;
  }

  static _revertStats(
      GameX01 gameX01,
      GameSettingsX01 gameSettingsX01,
      PlayerOrTeamGameStatisticsX01 currentStats,
      int points,
      bool legOrSetReverted,
      bool roundCompleted,
      bool shouldRevertTeamStats) {
    int currentThrownDartsInLeg = 0; // needed to revert checkout count

    if (legOrSetReverted) {
      // checkout
      if (currentStats.getCheckouts.isNotEmpty) {
        currentStats.getCheckouts.remove(currentStats.getCheckouts.lastKey());
      }

      // player with checkout in leg
      if (shouldRevertTeamStats) {
        final String lastKey =
            currentStats.getPlayersWithCheckoutInLeg.keys.last;
        currentStats.getPlayersWithCheckoutInLeg
            .removeWhere((key, value) => key == lastKey);
      }

      // thrown darts per leg
      if (currentStats.getThrownDartsPerLeg.isNotEmpty) {
        final String lastKey = currentStats.getThrownDartsPerLeg.lastKey();

        currentThrownDartsInLeg = currentStats.getThrownDartsPerLeg[lastKey];
        final int? amountOfFinishDarts =
            gameSettingsX01.getInputMethod == InputMethod.ThreeDarts
                ? 1
                : currentStats.getAmountOfFinishDarts[lastKey];

        // set darts for won leg count
        if (!shouldRevertTeamStats) {
          for (PlayerOrTeamGameStatisticsX01 stats
              in gameX01.getPlayerGameStatistics) {
            final String playerName =
                stats.getLegSetWithPlayerOrTeamWhoFinishedIt.values.last;
            final String keyOfLastElement =
                stats.getLegSetWithPlayerOrTeamWhoFinishedIt.keys.last;
            stats.getLegSetWithPlayerOrTeamWhoFinishedIt
                .removeWhere((key, value) => key == keyOfLastElement);

            final bool isSingleMode =
                gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Single
                    ? true
                    : false;
            // only subtract if current player has won this leg
            if (playerName == stats.getPlayer.getName) {
              currentStats.setDartsForWonLegCount =
                  currentStats.getDartsForWonLegCount - currentThrownDartsInLeg;

              if (!isSingleMode) {
                final PlayerOrTeamGameStatisticsX01 teamStatsFromPlayer =
                    gameX01.getTeamStatsFromPlayer(playerName);
                final int thrownDartsFromTeam =
                    teamStatsFromPlayer.getThrownDartsPerLeg[lastKey];

                teamStatsFromPlayer.setDartsForWonLegCount =
                    teamStatsFromPlayer.getDartsForWonLegCount -
                        thrownDartsFromTeam;
              }
            }
          }
        }

        if (amountOfFinishDarts != null) {
          // thrown darts
          currentStats.setCurrentThrownDartsInLeg =
              currentStats.getThrownDartsPerLeg[lastKey];
          currentStats.setAllThrownDarts =
              currentStats.getAllThrownDarts - amountOfFinishDarts;

          // first nine avg count
          if (currentStats.getCurrentThrownDartsInLeg <= 9) {
            currentStats.setFirstNineAvgCount =
                currentStats.getFirstNineAvgCount - amountOfFinishDarts;

            currentStats.setFirstNineAvgPoints =
                currentStats.getFirstNineAvgPoints - points;
          }

          currentStats.setCurrentThrownDartsInLeg =
              currentStats.getCurrentThrownDartsInLeg - amountOfFinishDarts;
        } else {
          currentStats.setCurrentThrownDartsInLeg =
              currentStats.getThrownDartsPerLeg[lastKey] - 3;
        }

        currentStats.getThrownDartsPerLeg.remove(lastKey);
        currentStats.getAmountOfFinishDarts.remove(lastKey);
      }
    } else {
      currentThrownDartsInLeg = currentStats.getCurrentThrownDartsInLeg;

      final int amountOfDarts =
          gameSettingsX01.getInputMethod == InputMethod.Round ? 3 : 1;

      // first nine avg count & points
      if (currentStats.getCurrentThrownDartsInLeg <= 9) {
        currentStats.setFirstNineAvgCount =
            currentStats.getFirstNineAvgCount - amountOfDarts;

        currentStats.setFirstNineAvgPoints =
            currentStats.getFirstNineAvgPoints - points;
      }

      // thrown darts per leg
      currentStats.setCurrentThrownDartsInLeg =
          currentStats.getCurrentThrownDartsInLeg - amountOfDarts;
      currentStats.setAllThrownDarts =
          currentStats.getAllThrownDarts - amountOfDarts;
    }

    // checkout count
    if (currentStats.getCheckoutCountAtThrownDarts.isNotEmpty) {
      final Tuple3<String, int, int> tuple =
          currentStats.getCheckoutCountAtThrownDarts.last;

      if ((roundCompleted && !legOrSetReverted) || legOrSetReverted) {
        if (tuple.item2 == currentThrownDartsInLeg) {
          currentStats.setCheckoutCount =
              currentStats.getCheckoutCount - tuple.item3;
          currentStats.getCheckoutCountAtThrownDarts.removeLast();
        }
      }
    }

    // all scores per dart
    if (currentStats.getAllScoresPerDart.isNotEmpty &&
        gameSettingsX01.getInputMethod == InputMethod.ThreeDarts) {
      currentStats.getAllScoresPerDart.removeLast();
    }

    // total points
    currentStats.setTotalPoints = currentStats.getTotalPoints - points;

    // all scores per dart as string count
    if (currentStats.getAllScoresPerDartAsString.isNotEmpty &&
        gameSettingsX01.getInputMethod == InputMethod.ThreeDarts) {
      final String point = currentStats.getAllScoresPerDartAsString.last;

      currentStats.getAllScoresPerDartAsString.removeLast();
      if (currentStats.getAllScoresPerDartAsStringCount.containsKey(point)) {
        currentStats.getAllScoresPerDartAsStringCount[point] -= 1;
        // if amount of precise scores is 0 -> remove it from map
        if (currentStats.getAllScoresPerDartAsStringCount[point] == 0) {
          currentStats.getAllScoresPerDartAsStringCount
              .removeWhere((key, value) => key == point);
        }
      }
    }

    if (roundCompleted || legOrSetReverted) {
      if (gameSettingsX01.getInputMethod == InputMethod.ThreeDarts) {
        points += int.parse(gameX01.getCurrentThreeDartsCalculated());
      } else {
        currentStats.setAllScoresCountForRound =
            currentStats.getAllScoresCountForRound - 1;
      }

      // starting points
      if (!legOrSetReverted) {
        currentStats.setStartingPoints =
            currentStats.getStartingPoints + points;

        if (shouldRevertTeamStats) {
          // set also for players in this team
          for (PlayerOrTeamGameStatisticsX01 stats in gameX01
              .getPlayerStatsFromCurrentTeamToThrow(gameX01, gameSettingsX01)) {
            stats.setStartingPoints = currentStats.getStartingPoints;
          }
        }
      }

      // all scores
      if (currentStats.getAllScores.isNotEmpty) {
        currentStats.getAllScores.removeLast();
      }

      // precise scores
      int finish = 0;
      if (legOrSetReverted &&
          gameSettingsX01.getInputMethod == InputMethod.ThreeDarts) {
        for (String score in currentStats.getAllRemainingScoresPerDart.last) {
          finish += gameX01.getValueOfSpecificDart(score);
        }
      }

      final int preciseScore = finish != 0 ? finish : points;
      if (currentStats.getPreciseScores.containsKey(preciseScore)) {
        currentStats.getPreciseScores[preciseScore] -= 1;
        // if amount of precise scores is 0 -> remove it from map
        if (currentStats.getPreciseScores[preciseScore] == 0) {
          currentStats.getPreciseScores
              .removeWhere((key, value) => key == preciseScore);
        }
      }

      // rounded scores even
      List<int> keys = currentStats.getRoundedScoresEven.keys.toList();
      if (points == 180) {
        currentStats.getRoundedScoresEven[180] -= 1;
      } else {
        for (int i = 0; i < keys.length - 1; i++) {
          if (points >= keys[i] && points < keys[i + 1]) {
            currentStats.getRoundedScoresEven[keys[i]] -= 1;
          }
        }
      }

      // rounded scores odd
      keys = currentStats.getRoundedScoresOdd.keys.toList();
      if (points >= 170) {
        currentStats.getRoundedScoresOdd[170] -= 1;
      } else {
        for (int i = 0; i < keys.length - 1; i++) {
          if (points >= keys[i] && points < keys[i + 1]) {
            currentStats.getRoundedScoresOdd[keys[i]] -= 1;
          }
        }
      }

      // all scores per leg
      final String lastKey = currentStats.getAllScoresPerLeg.lastKey();
      currentStats.getAllScoresPerLeg[lastKey].removeLast();
      if (currentStats.getAllScoresPerLeg[lastKey].isEmpty) {
        currentStats.getAllScoresPerLeg.remove(lastKey);
      }

      // all remaining scores per dart
      if (currentStats.getAllRemainingScoresPerDart.isNotEmpty &&
          gameSettingsX01.getInputMethod == InputMethod.ThreeDarts) {
        currentStats.getAllRemainingScoresPerDart.removeLast();
      }
    }

    if (roundCompleted) {
      currentStats.setTotalRoundsCount = currentStats.getTotalRoundsCount - 1;
      if (gameSettingsX01.getInputMethod == InputMethod.ThreeDarts) {
        currentStats.setThreeDartModeRoundsCount =
            currentStats.getThreeDartModeRoundsCount - 1;
      }
    }
  }

  static bool _allPlayersTeamsHaveStartPoints(
      GameX01 gameX01, GameSettingsX01 gameSettingsX01) {
    if (gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Single) {
      for (PlayerOrTeamGameStatisticsX01 stats
          in gameX01.getPlayerGameStatistics) {
        if (stats.getCurrentPoints != gameSettingsX01.getPointsOrCustom()) {
          return false;
        }
      }
    } else {
      for (PlayerOrTeamGameStatisticsX01 stats
          in gameX01.getTeamGameStatistics) {
        if (stats.getCurrentPoints != gameSettingsX01.getPointsOrCustom()) {
          return false;
        }
      }
    }
    return true;
  }

  static _setPreviousPlayerOrTeam(GameX01 gameX01,
      GameSettingsX01 gameSettingsX01, bool legSetOrGameReverted) {
    if (!(gameSettingsX01.getInputMethod == InputMethod.Round ||
        (gameSettingsX01.getInputMethod == InputMethod.ThreeDarts &&
            gameX01.getAmountOfDartsThrown() == 0))) {
      return;
    }

    if (legSetOrGameReverted) {
      _setPreviousPlayerOrTeamLegSetReverted(gameX01, gameSettingsX01);
    } else {
      _setPreviousPlayerOrTeamNoLegSetReverted(gameX01, gameSettingsX01);
    }
  }

  static _setPreviousPlayerOrTeamLegSetReverted(
      GameX01 gameX01, GameSettingsX01 gameSettingsX01) {
    // set start player/team index
    if (gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Single &&
        gameX01.getPlayerOrTeamLegStartIndex == 0) {
      gameX01.setPlayerOrTeamLegStartIndex =
          gameSettingsX01.getPlayers.length - 1;
    } else if (gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Team &&
        gameX01.getPlayerOrTeamLegStartIndex == 0) {
      gameX01.setPlayerOrTeamLegStartIndex =
          gameSettingsX01.getTeams.length - 1;
    } else {
      gameX01.setPlayerOrTeamLegStartIndex =
          gameX01.getPlayerOrTeamLegStartIndex - 1;
    }

    // set current player/team to throw
    final String playerOrTeamNameToFind =
        gameX01.getLegSetWithPlayerOrTeamWhoFinishedIt.values.last;
    final String keyOfLastElement =
        gameX01.getLegSetWithPlayerOrTeamWhoFinishedIt.keys.last;
    gameX01.getLegSetWithPlayerOrTeamWhoFinishedIt
        .removeWhere((key, value) => key == keyOfLastElement);

    if (gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Single) {
      for (Player player in gameSettingsX01.getPlayers) {
        if (player.getName == playerOrTeamNameToFind) {
          gameX01.setCurrentPlayerToThrow = player;
          break;
        }
      }
    } else {
      for (Team team in gameSettingsX01.getTeams) {
        if (team.getName == playerOrTeamNameToFind) {
          gameX01.setCurrentTeamToThrow = team;
          break;
        }
      }

      _setPreviousPlayerOfAllTeams(gameX01, true);
    }
  }

  static _setPreviousPlayerOrTeamNoLegSetReverted(
      GameX01 gameX01, GameSettingsX01 gameSettingsX01) {
    final int indexOfCurrentPlayer = gameSettingsX01.getPlayers.indexOf(
        gameSettingsX01.getPlayers
            .where((p) => p.getName == gameX01.getCurrentPlayerToThrow.getName)
            .first);
    int indexOfCurrentTeam = 0;
    if (gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Team) {
      indexOfCurrentTeam =
          gameSettingsX01.getTeams.indexOf(gameX01.getCurrentTeamToThrow);
    }

    if (gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Single) {
      // set previous player
      if ((indexOfCurrentPlayer - 1) < 0) {
        gameX01.setCurrentPlayerToThrow = gameSettingsX01.getPlayers.last;
      } else {
        gameX01.setCurrentPlayerToThrow =
            gameSettingsX01.getPlayers[indexOfCurrentPlayer - 1];
      }
    } else {
      // set previous team
      if ((indexOfCurrentTeam - 1) < 0) {
        gameX01.setCurrentTeamToThrow = gameSettingsX01.getTeams.last;
      } else {
        gameX01.setCurrentTeamToThrow =
            gameSettingsX01.getTeams[indexOfCurrentTeam - 1];
      }

      _setPreviousPlayerOfAllTeams(gameX01, false);
    }
  }

  static _setPreviousPlayerOfAllTeams(GameX01 gameX01, bool setForAllTeams) {
    if (setForAllTeams) {
      final List<String> playerNames =
          gameX01.getCurrentPlayerOfTeamsBeforeLegFinish.entries.last.value;
      final String lastKey =
          gameX01.getCurrentPlayerOfTeamsBeforeLegFinish.keys.last;

      gameX01.getCurrentPlayerOfTeamsBeforeLegFinish
          .removeWhere((key, value) => key == lastKey);

      // set previous player for each team, based on which player was the current player when leg was finished
      gameX01.getGameSettings.getTeams.asMap().forEach((index, value) => {
            value.setCurrentPlayerToThrow =
                gameX01.getGameSettings.getPlayerFromTeam(playerNames[index])
          });
    } else {
      _setPreviousPlayerForTeam(gameX01.getCurrentTeamToThrow);
    }

    // set previous player overall
    gameX01.setCurrentPlayerToThrow =
        gameX01.getCurrentTeamToThrow.getCurrentPlayerToThrow;
  }

  static _setPreviousPlayerForTeam(Team team) {
    // get index of current player in team
    final List<Player> players = team.getPlayers;
    int indexOfCurrentPlayerInCurrentTeam = -1;
    for (int i = 0; i < players.length; i++) {
      if (players[i].getName == team.getCurrentPlayerToThrow.getName) {
        indexOfCurrentPlayerInCurrentTeam = i;
        break;
      }
    }

    // set previous player of team
    if ((indexOfCurrentPlayerInCurrentTeam - 1) < 0) {
      team.setCurrentPlayerToThrow = players.last;
    } else {
      team.setCurrentPlayerToThrow =
          players[indexOfCurrentPlayerInCurrentTeam - 1];
    }
  }

  static bool _isCompleteRound(GameX01 gameX01, GameSettingsX01 gameSettingsX01,
      bool shouldRevertTeamStats) {
    if (gameSettingsX01.getInputMethod == InputMethod.Round) {
      return true;
    } else if (gameSettingsX01.getInputMethod == InputMethod.ThreeDarts &&
        gameX01.getAmountOfDartsThrown() == 0 &&
        !shouldRevertTeamStats) {
      return true;
    } else if (gameSettingsX01.getInputMethod == InputMethod.ThreeDarts &&
        shouldRevertTeamStats &&
        gameX01.getAmountOfDartsThrown() == 2) {
      // player gets reverted first -> 3rd dart is reverted -> therefore equal check for 2
      return true;
    }
    return false;
  }
}
