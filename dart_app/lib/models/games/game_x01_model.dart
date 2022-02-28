import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01_model.dart';
import 'package:dart_app/models/games/game_model.dart';
import 'package:dart_app/models/player_model.dart';
import 'package:dart_app/models/player_statistics/player_game_statistics_x01_model.dart';
import 'dart:developer';

import 'package:flutter/material.dart';

class GameX01 extends Game {
  GameX01({dateTime}) : super(dateTime: dateTime, name: "X01");

  String _currentPointsSelected = "Points";
  int _playerLegStartIndex =
      0; //to determine which player should begin next leg
  bool _revertPossible = false;

  get getCurrentPointsSelected => this._currentPointsSelected;
  set setCurrentPointsSelected(String currentPointsSelected) =>
      this._currentPointsSelected = currentPointsSelected;

  get getPlayerLegStartIndex => this._playerLegStartIndex;
  set setPlayerLegStartIndex(int playerLegStartIndex) =>
      this._playerLegStartIndex = playerLegStartIndex;

  get getRevertPossible => this._revertPossible;
  set setRevertPossible(bool revertPossible) =>
      this._revertPossible = revertPossible;

  //todo add support for teams
  void init(GameSettingsX01 gameSettingsX01) {
    this.setGameSettings = gameSettingsX01;
    int points = gameSettingsX01.getCustomPoints == -1
        ? gameSettingsX01.getPoints
        : gameSettingsX01.getCustomPoints;

    for (Player player in gameSettingsX01.getPlayers) {
      this.getPlayerGameStatistics.add(new PlayerGameStatisticsX01(
          mode: "X01", player: player, currentPoints: points));
    }

    this.setCurrentPlayerToThrow = gameSettingsX01.getPlayers[0];
  }

  //to determine if points button should be disabled -> e.g current points are 80 -> shouldnt be possible to press any other points buttons -> invalid points
  bool checkIfPointBtnShouldBeDisabled(String btnValueToCheck) {
    PlayerGameStatisticsX01 playerGameStatisticsX01 =
        getCurrentPlayerGameStatistics();
    if (_currentPointsSelected == "Points" || _currentPointsSelected.isEmpty) {
      if (btnValueToCheck == "0" ||
          btnValueToCheck == "delete" ||
          int.parse(btnValueToCheck) >
              playerGameStatisticsX01.getCurrentPoints) {
        return false;
      }
    } else {
      if (btnValueToCheck != "delete") {
        int result = int.parse(getCurrentPointsSelected + btnValueToCheck);
        if (result > 180) {
          return false;
        }

        if (result > playerGameStatisticsX01.getCurrentPoints) {
          return false;
        }

        if (noScoresPossible.contains(result)) {
          return false;
        }
      }
    }

    return true;
  }

  void updateCurrentPointsSelected(String newPoints) {
    if (_currentPointsSelected == "Points") {
      setCurrentPointsSelected = newPoints;
    } else {
      setCurrentPointsSelected = getCurrentPointsSelected + newPoints;
    }
    notifyListeners();
  }

  //deletes one char of the points
  void deleteCurrentPointsSelected() {
    setCurrentPointsSelected = getCurrentPointsSelected.substring(
        0, getCurrentPointsSelected.length - 1);
    notifyListeners();
  }

  PlayerGameStatisticsX01 getCurrentPlayerGameStatistics() {
    return getPlayerGameStatistics
        .firstWhere((stats) => stats.getPlayer == getCurrentPlayerToThrow);
  }

  void submitPoints(String points) {
    setCurrentPointsSelected = "Points";
    setRevertPossible = true;

    //get current player game statistics
    PlayerGameStatisticsX01 currentPlayerStats =
        getCurrentPlayerGameStatistics();

    //set points
    int parsedPoints = int.parse(points);
    currentPlayerStats.setCurrentPoints =
        currentPlayerStats.getCurrentPoints - parsedPoints;

    //set thrown darts
    currentPlayerStats.setThrownDartsPerLeg =
        currentPlayerStats.getThrownDartsPerLeg + 3;

    //add throw
    currentPlayerStats.setAllScores = [
      ...currentPlayerStats.getAllScores,
      parsedPoints
    ];

    //add to total Points
    currentPlayerStats.setTotalPoints =
        currentPlayerStats.getTotalPoints + parsedPoints;

    //set highest score
    if (parsedPoints > currentPlayerStats.getHighestScore) {
      currentPlayerStats.setHighestScore = parsedPoints;
    }
    //set precise scores
    if (currentPlayerStats.getPreciseScores.containsKey(parsedPoints)) {
      currentPlayerStats.getPreciseScores[parsedPoints] += 1;
    } else {
      currentPlayerStats.getPreciseScores[parsedPoints] = 1;
    }

    //leg/set finished -> check also if game is finished
    if (currentPlayerStats.getCurrentPoints == 0) {
      currentPlayerStats.setLegsWon = currentPlayerStats.getLegsWon + 1;
      if (getGameSettings.getSetsEnabled) {
        if (getGameSettings.getLegs == currentPlayerStats.getLegsWon) {
          //save leg count of each player -> in case a user wants to revert a set
          for (PlayerGameStatisticsX01 stats in getPlayerGameStatistics) {
            stats.setLegsCount = [...stats.getLegsCount, stats.getLegsWon];
            stats.setLegsWon = 0;
          }

          currentPlayerStats.setSetsWon = currentPlayerStats.getSetsWon + 1;

          if (getGameSettings.getMode == BestOfOrFirstTo.FirstTo &&
              getGameSettings.getSets == currentPlayerStats.getSetsWon) {
            //player won the game - set mode & first to

          } else if (getGameSettings.getMode == BestOfOrFirstTo.BestOf &&
              getGameSettings.getSets ==
                  ((currentPlayerStats.getSetsWon * 2) - 1)) {
            //player won the game - set mode & best of
          }
        }
      } else {
        if (getGameSettings.getMode == BestOfOrFirstTo.FirstTo &&
            getGameSettings.getLegs == currentPlayerStats.getLegsWon) {
          //player won the game - leg mode & first to

        } else if (getGameSettings.getMode == BestOfOrFirstTo.BestOf &&
            getGameSettings.getLegs ==
                ((currentPlayerStats.getLegsWon * 2) - 1)) {
          //player won the game - leg mode & best of
        }
      }

      //set player who will begin next leg
      if (getPlayerLegStartIndex == getGameSettings.getPlayers.length) {
        setPlayerLegStartIndex = 0;
      } else {
        setPlayerLegStartIndex = getPlayerLegStartIndex + 1;
      }

      //set best/worst leg
      if (currentPlayerStats.getThrownDartsPerLeg <
          currentPlayerStats.getBestLeg) {
        currentPlayerStats.setBestLeg = currentPlayerStats.getThrownDartsPerLeg;
      }
      if (currentPlayerStats.getThrownDartsPerLeg >
          currentPlayerStats.getWorstLeg) {
        currentPlayerStats.setWorstLeg =
            currentPlayerStats.getThrownDartsPerLeg;
      }

      //add checkout to list
      currentPlayerStats.setCheckouts = [
        ...currentPlayerStats.getCheckouts,
        parsedPoints
      ];

      //reset points & thrown darts per leg
      for (PlayerGameStatisticsX01 stats in getPlayerGameStatistics) {
        //set remaining points  -> in order to revert points
        if (stats == currentPlayerStats) {
          currentPlayerStats.setAllRemainingPoints = [
            ...currentPlayerStats.getAllRemainingPoints,
            parsedPoints
          ];
        } else {
          stats.setAllRemainingPoints = [
            ...stats.getAllRemainingPoints,
            stats.getCurrentPoints
          ];
        }

        stats.setCurrentPoints = getGameSettings.getCustomPoints == -1
            ? getGameSettings.getPoints
            : getGameSettings.getCustomPoints;

        stats.setThrownDartsPerLeg = 0;
      }
    }

    //set next player
    int indexOfCurrentPlayer =
        getGameSettings.getPlayers.indexOf(getCurrentPlayerToThrow);
    if (indexOfCurrentPlayer + 1 == getGameSettings.getPlayers.length) {
      //round of all players finished -> restart from beginning
      setCurrentPlayerToThrow = getGameSettings.getPlayers[0];
    } else {
      setCurrentPlayerToThrow =
          getGameSettings.getPlayers[indexOfCurrentPlayer + 1];
    }

    notifyListeners();
  }

  void bust() {
    submitPoints("0");
  }

  void revertPoints() {
    if (checkIfRevertPossible()) {
      //set previous player
      int indexOfCurrentPlayer =
          getGameSettings.getPlayers.indexOf(getCurrentPlayerToThrow);

      if (indexOfCurrentPlayer - 1 < 0) {
        setCurrentPlayerToThrow = getGameSettings.getPlayers.last;
      } else {
        setCurrentPlayerToThrow =
            getGameSettings.getPlayers[indexOfCurrentPlayer - 1];
      }

      PlayerGameStatisticsX01 currentPlayerStats =
          getCurrentPlayerGameStatistics();

      //get last points
      int lastPoitns = currentPlayerStats.getAllScores.last;

      //leg (or + set) reverted
      bool alreadyReverted = false;
      if ((startPointsPossibilities
                  .contains(currentPlayerStats.getCurrentPoints) ||
              getGameSettings.getCustomPoints ==
                  currentPlayerStats.getCurrentPoints) &&
          lastPoitns != 0) {
        bool setReverted = false;
        if (currentPlayerStats.getLegsCount.isNotEmpty &&
            currentPlayerStats.getLegsCount.last == getGameSettings.getLegs) {
          setReverted = true;
        }

        for (PlayerGameStatisticsX01 stats in getPlayerGameStatistics) {
          if (stats.getAllRemainingPoints.isNotEmpty) {
            stats.setCurrentPoints = stats.getAllRemainingPoints.last;
            stats.getAllRemainingPoints.removeLast();
          }

          if (setReverted) {
            stats.setLegsWon = stats.getLegsCount.last;
            if (currentPlayerStats == stats) {
              stats.setSetsWon = stats.getSetsWon - 1;
              stats.setLegsWon = stats.getLegsCount.last - 1;
            }
            stats.getLegsCount.removeLast();
          }

          if (stats == currentPlayerStats) {
            if (!setReverted) {
              stats.setLegsWon = stats.getLegsWon - 1;
            }
            //revert only player that is currently selected
            int lastPoints1 = stats.getAllScores.last;
            revertStats(stats, lastPoints1);
            alreadyReverted = true;
          }
        }
      } else {
        currentPlayerStats.setCurrentPoints =
            currentPlayerStats.getCurrentPoints + lastPoitns;
      }

      if (alreadyReverted == false) {
        revertStats(currentPlayerStats, lastPoitns);
      }

      checkIfRevertPossible(); //if 1 score is left -> enters this if & removes last score -> without this call the revert btn is still highlighted
    }
  }

  //returns true if at least one player has a score left
  bool checkIfRevertPossible() {
    bool result = false;
    for (PlayerGameStatisticsX01 stats in getPlayerGameStatistics) {
      if (stats.getAllScores.length > 0) {
        result = true;
      }
    }
    setRevertPossible = result;
    notifyListeners();

    return result;
  }

  void revertStats(PlayerGameStatisticsX01 stats, int points) {
    if (stats.getAllScores.isNotEmpty) {
      stats.getAllScores.removeLast();
    }

    stats.setTotalPoints = stats.getTotalPoints - points;
    if (stats.getPreciseScores.containsKey(points)) {
      stats.getPreciseScores[points] -= 1;
    }
    stats.setThrownDartsPerLeg = stats.getThrownDartsPerLeg - 3;
    //todo check if highest finish is last points -> list for highest finish...
    //todo remove from rounded scores
  }
}
