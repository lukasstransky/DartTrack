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

    //double in
    if (getGameSettings.getModeIn == SingleOrDouble.DoubleField &&
        playerGameStatisticsX01.getCurrentPoints ==
            getGameSettings.getPointsOrCustom()) {
      if (btnValueToCheck == "delete") {
        return true;
      }
      if (getCurrentPointsSelected == "Points" ||
          getCurrentPointsSelected.isEmpty) {
        if (btnValueToCheck == "7" ||
            btnValueToCheck == "9" ||
            btnValueToCheck == "0") {
          return false;
        }
      } else {
        int result = int.parse(getCurrentPointsSelected + btnValueToCheck);
        return isDoubleField(result.toString());
      }
      return true;
    }

    if (getCurrentPointsSelected == "Points" ||
        getCurrentPointsSelected.isEmpty) {
      if (btnValueToCheck == "0" ||
          btnValueToCheck == "delete" ||
          int.parse(btnValueToCheck) >
              playerGameStatisticsX01.getCurrentPoints) {
        return false;
      }
    } else {
      if (btnValueToCheck != "delete") {
        int result = int.parse(getCurrentPointsSelected + btnValueToCheck);
        if (result > 180 ||
            result > playerGameStatisticsX01.getCurrentPoints ||
            noScoresPossible.contains(result) ||
            playerGameStatisticsX01.getCurrentPoints - result == 1) {
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

    //set first nine avg
    if (currentPlayerStats.getThrownDartsPerLeg <= 9)
      currentPlayerStats.setFirstNineAverage =
          currentPlayerStats.getFirstNineAverage + parsedPoints;

    //add throw
    currentPlayerStats.setAllScores = [
      ...currentPlayerStats.getAllScores,
      parsedPoints
    ];

    //add to total Points
    currentPlayerStats.setTotalPoints =
        currentPlayerStats.getTotalPoints + parsedPoints;

    //set precise scores
    if (currentPlayerStats.getPreciseScores.containsKey(parsedPoints))
      currentPlayerStats.getPreciseScores[parsedPoints] += 1;
    else
      currentPlayerStats.getPreciseScores[parsedPoints] = 1;

    //set rounded score
    List<int> keys = currentPlayerStats.getRoundedScores.keys.toList();
    if (parsedPoints >= 170) {
      currentPlayerStats.getRoundedScores[keys[keys.length - 1]] += 1;
    }
    for (int i = 0; i < keys.length - 1; i++) {
      if (parsedPoints >= keys[i] && parsedPoints < keys[i + 1]) {
        currentPlayerStats.getRoundedScores[keys[i]] += 1;
      }
    }

    //leg/set finished -> check also if game is finished
    if (currentPlayerStats.getCurrentPoints == 0) {
      currentPlayerStats.setLegsWon = currentPlayerStats.getLegsWon + 1;
      //update checkout quote
      currentPlayerStats.setCheckoutQuote =
          currentPlayerStats.getLegsWon / currentPlayerStats.getCheckoutCount;
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
      setCurrentPointsSelected = "Points";
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
    List<int> keys = stats.getRoundedScores.keys.toList();
    if (points >= 170) {
      stats.getRoundedScores[keys[keys.length - 1]] -= 1;
    }
    for (int i = 0; i < keys.length - 1; i++) {
      if (points >= keys[i] && points < keys[i + 1]) {
        stats.getRoundedScores[keys[i]] -= 1;
      }
    }
  }

  bool checkoutPossible() {
    PlayerGameStatisticsX01 currentPlayerStats =
        getCurrentPlayerGameStatistics();
    if (currentPlayerStats.getCurrentPoints <= 170 &&
        !bogeyNumbers.contains(currentPlayerStats.getCurrentPoints)) {
      return true;
    }
    return false;
  }

  //returns 0, 1, 2, 3 or -1
  int getAmountOfCheckoutPossibilities(String thrownPointsString) {
    PlayerGameStatisticsX01 currentPlayerStats =
        getCurrentPlayerGameStatistics();
    int currentPoints = currentPlayerStats.getCurrentPoints;

    //current points = double field
    if (isDoubleField(currentPoints.toString())) {
      return 3;
    }

    int thrownPoints = int.parse(thrownPointsString);
    int result = currentPoints - thrownPoints;
    if (result <= 50 && thrownPoints <= 60) {
      return 2;
    }

    if (result <= 50 && thrownPoints > 60) {
      if (possibleTwoDartFinish(thrownPoints)) {
        return 2;
      }
      return 1;
    }

    return -1;
  }

  //determine if its possible to score with 1 dart in order to leave a double field -> 2 darts on double instead of 1
  bool possibleTwoDartFinish(int thrownPoints) {
    for (int i = 20; i > 0; i--) {
      int tripple = i * 3;
      int temp = thrownPoints - tripple;
      if (isDoubleField(temp.toString())) {
        return true;
      }
    }
    return false;
  }

  void addToCheckoutCount(int checkoutCount) {
    PlayerGameStatisticsX01 currentPlayerStats =
        getCurrentPlayerGameStatistics();
    currentPlayerStats.setCheckoutCount =
        currentPlayerStats.getCheckoutCount + checkoutCount;
  }

  void notify() {
    notifyListeners();
  }

  //for checkout counting dialog -> to show the amount of darts for finising the leg, set or game -> in order to calc average correctly
  bool finishedLegSetOrGame(String points) {
    PlayerGameStatisticsX01 currentPlayerStats =
        getCurrentPlayerGameStatistics();
    if (currentPlayerStats.getCurrentPoints - int.parse(points) == 0) {
      return true;
    }
    return false;
  }

  //checks if the finish is possible with ONLY 3 darts
  bool finishedWithThreeDarts(String thrownPoints) {
    //no need to check for <= 170 or bogey numbers -> this method is only called after checkoutPossible()
    int points = int.parse(thrownPoints);
    if (threeDartFinishesWithBull.contains(points)) {
      return false;
    }
    //99 = special case
    if (points > 100 || points == 99) {
      //add 1 checkout count
      addToCheckoutCount(1);
      return true;
    }
    return false;
  }

  //for showing finish ways -> if one player is in finish area and the other one not -> text widget not centered
  bool onePlayerInFinishArea() {
    for (PlayerGameStatisticsX01 stats in getPlayerGameStatistics) {
      if (stats.getCurrentPoints <= 170) {
        return true;
      }
    }
    return false;
  }

  bool isDoubleField(String pointsString) {
    int points = int.parse(pointsString);
    if ((points <= 40 && points % 2 == 0) || points == 50) {
      return true;
    }
    return false;
  }

  //checks if 1,3 or 5 is submitted -> invalid for double in (cant disable e.g. 1 because 10 is valid -> D5)
  bool checkIfInvalidDoubleInPointsSubmitted(String pointsSelected) {
    PlayerGameStatisticsX01 currentPlayerStats =
        getCurrentPlayerGameStatistics();

    if (getGameSettings.getModeIn == SingleOrDouble.DoubleField &&
        currentPlayerStats.getCurrentPoints ==
            getGameSettings.getPointsOrCustom()) {
      if (pointsSelected == "1" ||
          pointsSelected == "3" ||
          pointsSelected == "5") {
        return true;
      }
    }
    return false;
  }
}
