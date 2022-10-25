import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_statistics_x01.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class Revert {
  /************************************************************/
  /********              PUBLIC METHODS                ********/
  /************************************************************/

  static revertPoints(BuildContext context) {
    final GameX01 gameX01 = context.read<GameX01>();
    final GameSettingsX01 gameSettingsX01 = context.read<GameSettingsX01>();

    PlayerOrTeamGameStatisticsX01 currentStats =
        gameX01.getCurrentPlayerGameStats();

    if (!_checkIfRevertPossible(context)) {
      return;
    }

    bool alreadyReverted = false;
    int lastPoints = 0;
    bool legOrSetReverted = false;
    bool roundCompleted = false; //in order to revert only 1 dart or full round

    if (gameSettingsX01.getInputMethod == InputMethod.Round ||
        (gameSettingsX01.getInputMethod == InputMethod.ThreeDarts &&
            gameX01.getAmountOfDartsThrown() == 0)) {
      roundCompleted = true;

      //set previous player
      final int indexOfCurrentPlayer =
          gameSettingsX01.getPlayers.indexOf(gameX01.getCurrentPlayerToThrow);

      if ((indexOfCurrentPlayer - 1) < 0) {
        gameX01.setCurrentPlayerToThrow = gameSettingsX01.getPlayers.last;
      } else {
        gameX01.setCurrentPlayerToThrow =
            gameSettingsX01.getPlayers[indexOfCurrentPlayer - 1];
      }

      //start player index
      gameX01.setPlayerOrTeamLegStartIndex =
          gameSettingsX01.getPlayers.indexOf(gameX01.getCurrentPlayerToThrow);

      currentStats = gameX01.getCurrentPlayerGameStats();

      //get last points
      if (gameSettingsX01.getInputMethod == InputMethod.Round) {
        lastPoints = currentStats.getAllScores.last;
      } else {
        lastPoints = currentStats.getAllScoresPerDart.last;
      }

      //leg (or + set) reverted
      if ((START_POINT_POSSIBILITIES.contains(currentStats.getCurrentPoints) ||
              gameSettingsX01.getCustomPoints ==
                  currentStats.getCurrentPoints) &&
          lastPoints != 0) {
        legOrSetReverted = true;
        bool setReverted = false;

        if (currentStats.getLegsCount.isNotEmpty &&
            currentStats.getLegsCount.last == gameSettingsX01.getLegs) {
          setReverted = true;
        }

        for (PlayerOrTeamGameStatisticsX01 stats
            in gameX01.getPlayerGameStatistics) {
          if (stats.getAllRemainingPoints.isNotEmpty) {
            stats.setCurrentPoints = stats.getAllRemainingPoints.last;
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

          if (stats == currentStats) {
            //for input method three darts
            if (gameSettingsX01.getInputMethod == InputMethod.ThreeDarts) {
              _setLastThrownDarts(
                  stats.getAllRemainingScoresPerDart.last, gameX01);
              final int amountOfThrownDarts = gameX01.getAmountOfDartsThrown();
              stats.setCurrentPoints = gameX01.getValueOfSpecificDart(
                  gameX01.getCurrentThreeDarts[amountOfThrownDarts - 1]);
              gameX01.getCurrentThreeDarts[amountOfThrownDarts - 1] =
                  'Dart ' + amountOfThrownDarts.toString();
            }

            if (!setReverted) {
              stats.setLegsWon = stats.getLegsWon - 1;
              stats.setLegsWonTotal = stats.getLegsWonTotal - 1;
            }

            //revert only player that is currently selected
            int lastPoints1;
            if (gameSettingsX01.getInputMethod == InputMethod.Round) {
              lastPoints1 = stats.getAllScores.last;
            } else {
              lastPoints1 = stats.getAllScoresPerDart.last;
            }

            _revertStats(context, stats, lastPoints1, true, roundCompleted);
            alreadyReverted = true;
          } else {
            //current thrown darts in leg
            final String lastKey = stats.getThrownDartsPerLeg.lastKey();
            stats.setCurrentThrownDartsInLeg =
                stats.getThrownDartsPerLeg[lastKey];

            //thrown darts per leg
            if (stats.getThrownDartsPerLeg.isNotEmpty) {
              stats.getThrownDartsPerLeg.remove(lastKey);
            }
          }
        }
      }
    }

    if (!legOrSetReverted) {
      //get last points
      if (gameSettingsX01.getInputMethod == InputMethod.Round) {
        lastPoints = currentStats.getAllScores.last;
      } else {
        lastPoints = currentStats.getAllScoresPerDart.last;
      }

      if (gameSettingsX01.getInputMethod == InputMethod.ThreeDarts) {
        final int amountOfThrownDarts = gameX01.getAmountOfDartsThrown();
        if (amountOfThrownDarts == 0) {
          _setLastThrownDarts(
              currentStats.getAllRemainingScoresPerDart.last, gameX01);
          gameX01.getCurrentThreeDarts[2] = 'Dart 3';
        } else {
          gameX01.getCurrentThreeDarts[amountOfThrownDarts - 1] =
              'Dart ' + amountOfThrownDarts.toString();
        }
      }

      currentStats.setCurrentPoints =
          currentStats.getCurrentPoints + lastPoints;
    }

    if (alreadyReverted == false) {
      _revertStats(context, currentStats, lastPoints, false, roundCompleted);
    }

    gameX01.setCurrentPointsSelected = 'Points';
    _checkIfRevertPossible(
        context); //if 1 score is left -> enters this if & removes last score -> without this call the revert btn is still highlighted
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
  static bool _checkIfRevertPossible(BuildContext context) {
    final GameX01 gameX01 = context.read<GameX01>();
    final GameSettingsX01 gameSettingsX01 = context.read<GameSettingsX01>();

    bool result = false;
    for (PlayerOrTeamGameStatisticsX01 stats
        in gameX01.getPlayerGameStatistics) {
      if (gameSettingsX01.getInputMethod == InputMethod.Round) {
        if (stats.getAllScores.length > 0) result = true;
      } else {
        if (stats.getAllScoresPerDart.length > 0) result = true;
      }
    }

    gameX01.setRevertPossible = result;
    gameX01.notify();

    return result;
  }

  static _revertStats(BuildContext context, PlayerOrTeamGameStatisticsX01 stats,
      int points, bool legOrSetReverted, bool roundCompleted) {
    final GameX01 gameX01 = context.read<GameX01>();
    final GameSettingsX01 gameSettingsX01 = context.read<GameSettingsX01>();

    int currentThrownDartsInLeg = 0; //needed to revert checkout count

    //LEG OR SET REVERTED
    if (legOrSetReverted) {
      //checkout
      if (stats.getCheckouts.isNotEmpty) {
        stats.getCheckouts.remove(stats.getCheckouts.lastKey());
      }

      //starting points
      if (stats.getAllScoresPerDart.isNotEmpty) {
        int lastScore = stats.getAllScoresPerDart.last;
        stats.setStartingPoints =
            int.parse(gameX01.getCurrentThreeDartsCalculated()) + lastScore;
      }

      //thrown darts per leg
      if (stats.getThrownDartsPerLeg.isNotEmpty) {
        String lastKey = stats.getThrownDartsPerLeg.lastKey();
        currentThrownDartsInLeg = stats.getThrownDartsPerLeg[lastKey];
        int? amountOfFinishDarts =
            gameSettingsX01.getInputMethod == InputMethod.ThreeDarts
                ? 1
                : stats.getAmountOfFinishDarts[lastKey];

        if (amountOfFinishDarts != null) {
          stats.setCurrentThrownDartsInLeg =
              stats.getThrownDartsPerLeg[lastKey] - amountOfFinishDarts;
          stats.setAllThrownDarts =
              stats.getAllThrownDarts - amountOfFinishDarts;
          stats.setFirstNineAvgCount =
              stats.getFirstNineAvgCount - amountOfFinishDarts;
        } else {
          stats.setCurrentThrownDartsInLeg =
              stats.getThrownDartsPerLeg[lastKey] - 3;
        }

        stats.getThrownDartsPerLeg.remove(lastKey);
        stats.getAmountOfFinishDarts.remove(lastKey);
      }
    } else {
      //first nine avg count
      if (stats.getCurrentThrownDartsInLeg <= 9) {
        int amountOfDarts =
            gameSettingsX01.getInputMethod == InputMethod.Round ? 3 : 1;
        stats.setFirstNineAvgCount = stats.getFirstNineAvgCount - amountOfDarts;
      }

      currentThrownDartsInLeg = stats.getCurrentThrownDartsInLeg;
      //thrown darts per leg
      if (gameSettingsX01.getInputMethod == InputMethod.Round) {
        stats.setCurrentThrownDartsInLeg = stats.getCurrentThrownDartsInLeg - 3;
        stats.setAllThrownDarts = stats.getAllThrownDarts - 3;
      } else {
        stats.setCurrentThrownDartsInLeg = stats.getCurrentThrownDartsInLeg - 1;
        stats.setAllThrownDarts = stats.getAllThrownDarts - 1;
      }
    }

    //checkout count
    if (roundCompleted || legOrSetReverted) {
      if (stats.getCheckoutCountAtThrownDarts.isNotEmpty) {
        Tuple3<String, int, int> tuple =
            stats.getCheckoutCountAtThrownDarts.last;
        if (tuple.item1 ==
                gameX01.getCurrentLegSetAsString(gameX01, gameSettingsX01) &&
            tuple.item2 == currentThrownDartsInLeg) {
          stats.setCheckoutCount = stats.getCheckoutCount - tuple.item3;
          stats.getCheckoutCountAtThrownDarts.removeLast();
        }
      }
    }

    //all scores per dart
    if (stats.getAllScoresPerDart.isNotEmpty) {
      stats.getAllScoresPerDart.removeLast();
    }

    //set points selected count
    if (gameSettingsX01.getInputMethod == InputMethod.ThreeDarts) {
      stats.setPointsSelectedCount = gameX01.getAmountOfDartsThrown();
    }

    //total points
    stats.setTotalPoints = stats.getTotalPoints - points;

    //first nine avg points
    if (stats.getCurrentThrownDartsInLeg <= 9) {
      stats.setFirstNineAvgPoints = stats.getFirstNineAvgPoints - points;
    }

    //all scores per dart as string count
    if (stats.getAllScoresPerDartAsString.isNotEmpty) {
      String point = stats.getAllScoresPerDartAsString.last;

      stats.getAllScoresPerDartAsString.removeLast();
      if (stats.getAllScoresPerDartAsStringCount.containsKey(point)) {
        stats.getAllScoresPerDartAsStringCount[point] -= 1;
        //if amount of precise scores is 0 -> remove it from map
        if (stats.getAllScoresPerDartAsStringCount[point] == 0) {
          stats.getAllScoresPerDartAsStringCount
              .removeWhere((key, value) => key == point);
        }
      }
    }

    //ROUND COMPLETED
    if (roundCompleted) {
      if (gameSettingsX01.getInputMethod == InputMethod.ThreeDarts) {
        points += int.parse(gameX01.getCurrentThreeDartsCalculated());
      } else {
        stats.setAllScoresCountForRound = stats.getAllScoresCountForRound - 1;
      }

      //starting points
      if (!legOrSetReverted) {
        stats.setStartingPoints = stats.getStartingPoints + points;
      }

      //all scores
      if (stats.getAllScores.isNotEmpty) {
        stats.getAllScores.removeLast();
      }

      //precise scores
      if (stats.getPreciseScores.containsKey(points)) {
        stats.getPreciseScores[points] -= 1;
        //if amount of precise scores is 0 -> remove it from map
        if (stats.getPreciseScores[points] == 0) {
          stats.getPreciseScores.removeWhere((key, value) => key == points);
        }
      }

      //rounded scores even
      List<int> keys = stats.getRoundedScoresEven.keys.toList();
      if (points >= 170) {
        stats.getRoundedScoresEven[keys[keys.length - 1]] -= 1;
      }
      for (int i = 0; i < keys.length - 1; i++) {
        if (points >= keys[i] && points < keys[i + 1]) {
          stats.getRoundedScoresEven[keys[i]] -= 1;
        }
      }

      //rounded scores odd
      keys = stats.getRoundedScoresOdd.keys.toList();
      if (points >= 170) {
        stats.getRoundedScoresOdd[keys[keys.length - 1]] -= 1;
      } else {
        for (int i = 0; i < keys.length - 1; i++) {
          if (points >= keys[i] && points < keys[i + 1]) {
            stats.getRoundedScoresOdd[keys[i]] -= 1;
          }
        }
      }

      //all scores per leg
      String lastKey = stats.getAllScoresPerLeg.lastKey();
      stats.getAllScoresPerLeg[lastKey].removeLast();
      if (stats.getAllScoresPerLeg[lastKey].isEmpty) {
        stats.getAllScoresPerLeg.remove(lastKey);
      }

      //all remaining scores per dart
      if (stats.getAllRemainingScoresPerDart.isNotEmpty) {
        stats.getAllRemainingScoresPerDart.removeLast();
      }
    }
  }
}
