import 'dart:collection';

import 'package:dart_app/constants.dart';
import 'package:dart_app/models/bot.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/models/player_statistics/player_game_statistics.dart';
import 'package:dart_app/models/player_statistics/player_game_statistics_x01.dart';
import 'package:dart_app/utils/globals.dart';
import 'package:provider/provider.dart';

import 'dart:developer';
import 'package:tuple/tuple.dart';
import 'package:flutter/material.dart';

class GameX01 extends Game {
  GameX01({dateTime}) : super(dateTime: dateTime, name: "X01");

  String _currentPointsSelected = "Points";
  int _playerLegStartIndex =
      0; //to determine which player should begin next leg
  bool _revertPossible = false;
  bool _init = false;
  bool _reachedSuddenDeath = false;

  PointType _currentPointType =
      PointType.Single; //only for input type -> three darts
  List<String> _currentThreeDarts = [
    "Dart 1",
    "Dart 2",
    "Dart 3"
  ]; //only for input type -> three darts
  bool _canBePressed =
      true; //only for input type -> three darts + automatically submit points (to disable buttons when delay is active)

  /************************************************************/
  /********              GETTER & SETTER               ********/
  /************************************************************/

  get getCurrentPointsSelected => this._currentPointsSelected;
  set setCurrentPointsSelected(String currentPointsSelected) =>
      this._currentPointsSelected = currentPointsSelected;

  get getPlayerLegStartIndex => this._playerLegStartIndex;
  set setPlayerLegStartIndex(int playerLegStartIndex) =>
      this._playerLegStartIndex = playerLegStartIndex;

  get getRevertPossible => this._revertPossible;
  set setRevertPossible(bool revertPossible) =>
      this._revertPossible = revertPossible;

  get getInit => this._init;
  set setInit(bool init) => this._init = init;

  get getReachedSuddenDeath => this._reachedSuddenDeath;
  set setReachedSuddenDeath(bool reachedSuddenDeath) =>
      this._reachedSuddenDeath = reachedSuddenDeath;

  get getCurrentPointType => this._currentPointType;
  set setCurrentPointType(PointType currentPointType) => {
        this._currentPointType = currentPointType,
      };

  get getCurrentThreeDarts => this._currentThreeDarts;
  set setCurrentThreeDarts(List<String> currentThreeDarts) =>
      this._currentThreeDarts = currentThreeDarts;

  get getCanBePressed => this._canBePressed;
  set setCanBePressed(bool canBePressed) {
    this._canBePressed = canBePressed;
    notifyListeners();
  }

  /************************************************************/
  /********                 METHDODS                   ********/
  /************************************************************/

  //todo add support for teams
  void init(GameSettingsX01 gameSettingsX01) {
    this.setGameSettings = gameSettingsX01;
    this.setCurrentPlayerToThrow = gameSettingsX01.getPlayers[0];

    //if game is finished -> undo last throw -> will call init again
    if (getGameSettings.getPlayers.length != getPlayerGameStatistics.length) {
      this.setInit = true;
      int points = getGameSettings.getPointsOrCustom();

      for (Player player in gameSettingsX01.getPlayers) {
        this.getPlayerGameStatistics.add(new PlayerGameStatisticsX01(
            mode: "X01",
            player: player,
            currentPoints: points,
            dateTime: getDateTime));
      }

      if (getGameSettings.getInputMethod == InputMethod.ThreeDarts)
        setCurrentPointType = PointType.Single;
    }

    for (PlayerGameStatisticsX01 stats in getPlayerGameStatistics) {
      stats.setStartingPoints = stats.getCurrentPoints;
    }
  }

  //gets called when user goes back to settings from game screen
  void reset() {
    setCurrentPointsSelected = "Points";
    setPlayerLegStartIndex = 0;
    setRevertPossible = false;
    setPlayerGameStatistics = [];
    setInit = false;
    setReachedSuddenDeath = false;
    setCurrentPlayerToThrow = null;
    resetCurrentThreeDarts();
  }

  bool checkIfPointBtnShouldBeDisabledRound(
      String btnValueToCheck, PlayerGameStatisticsX01 stats) {
    //double in
    if (getGameSettings.getModeIn == SingleOrDouble.DoubleField &&
        stats.getCurrentPoints == getGameSettings.getPointsOrCustom()) {
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
    }

    if (getCurrentPointsSelected == "Points" ||
        getCurrentPointsSelected.isEmpty) {
      if (btnValueToCheck == "0" ||
          btnValueToCheck == "delete" ||
          int.parse(btnValueToCheck) > stats.getCurrentPoints) {
        return false;
      }
    } else {
      if (btnValueToCheck != "delete") {
        int result = int.parse(getCurrentPointsSelected + btnValueToCheck);
        if (result > 180 ||
            result > stats.getCurrentPoints ||
            noScoresPossible.contains(result) ||
            stats.getCurrentPoints - result == 1) {
          return false;
        }
      }
    }
    return true;
  }

  bool checkIfPointBtnShouldBeDisabledThreeDarts(
      String btnValueToCheck, PlayerGameStatisticsX01 stats) {
    //disable 25 in double & tripple mode
    if ((btnValueToCheck == "25" || btnValueToCheck == "Bull") &&
        (getCurrentPointType == PointType.Tripple ||
            getCurrentPointType == PointType.Double)) {
      return false;
    }

    //calculate points based on single, double or tripple
    int result = 0;
    if (btnValueToCheck == "Bull") {
      result += 50;
    } else {
      int points = int.parse(btnValueToCheck);
      if (getCurrentPointType == PointType.Double) {
        points = points * 2;
      } else if (getCurrentPointType == PointType.Tripple) {
        points = points * 3;
      }
      result += points;
    }

    //if double in -> only enable fields with D
    if (getGameSettings.getModeIn == SingleOrDouble.DoubleField &&
        stats.getCurrentPoints == getGameSettings.getPointsOrCustom()) {
      if (getCurrentPointType == PointType.Double) {
        return true;
      } else {
        return false;
      }
    }

    //if double out -> only enable finsihes with D (e.g. 20 -> enable D10 but disable single 20)
    if (getGameSettings.getModeOut == SingleOrDouble.DoubleField) {
      if (stats.getCurrentPoints - result == 0) {
        if (getCurrentPointType == PointType.Double) {
          return true;
        } else {
          return false;
        }
      }
    }

    if (result > stats.getCurrentPoints ||
        noScoresPossible.contains(result) ||
        stats.getCurrentPoints - result == 1) {
      return false;
    }
    return true;
  }

  //to determine if points button should be disabled -> e.g current points are 80 -> shouldnt be possible to press any other points buttons -> invalid points
  bool checkIfPointBtnShouldBeDisabled(String btnValueToCheck) {
    //todo weird bug -> if solves it -> maybe have a look on it (starting game -> end it with cross -> click any button)
    if (getPlayerGameStatistics.isNotEmpty) {
      PlayerGameStatisticsX01 stats = getCurrentPlayerGameStatistics();

      if (getGameSettings.getInputMethod == InputMethod.Round) {
        return checkIfPointBtnShouldBeDisabledRound(btnValueToCheck, stats);
      } else {
        return checkIfPointBtnShouldBeDisabledThreeDarts(
            btnValueToCheck, stats);
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

  void updateCurrentThreeDarts(String points) {
    if (getCurrentThreeDarts[0] == "Dart 1") {
      getCurrentThreeDarts[0] = points;
    } else if (getCurrentThreeDarts[1] == "Dart 2") {
      getCurrentThreeDarts[1] = points;
    } else if (getCurrentThreeDarts[2] == "Dart 3") {
      getCurrentThreeDarts[2] = points;
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
    if (getCurrentPlayerToThrow is Bot) {
      return getPlayerGameStatistics.firstWhere((stats) =>
          stats.getPlayer is Bot &&
          stats.getPlayer.getName == getCurrentPlayerToThrow.getName &&
          stats.getPlayer.getPreDefinedAverage ==
              getCurrentPlayerToThrow.getPreDefinedAverage);
    }
    return getPlayerGameStatistics.firstWhere(
        (stats) => stats.getPlayer.getName == getCurrentPlayerToThrow.getName);
  }

  //only for cancel button in add checkout count dialog
  void revertSomeStats(int points) {
    PlayerGameStatisticsX01 stats = getCurrentPlayerGameStatistics();

    //total Points
    stats.setTotalPoints = stats.getTotalPoints - points;

    //thrown darts
    stats.setCurrentThrownDartsInLeg = stats.getCurrentThrownDartsInLeg - 1;

    //first nine avg
    if (stats.getCurrentThrownDartsInLeg <= 9) {
      stats.setFirstNineAverage = stats.getFirstNineAverage - points;
      if (getGameSettings.getInputMethod == InputMethod.Round) {
        stats.setFirstNineAverageCountRound =
            stats.getFirstNineAverageCountRound - 1;
      } else {
        stats.setFirstNineAverageCountThreeDarts =
            stats.getFirstNineAverageCountThreeDarts - 1;
      }
    }

    //all scores per dart as string + count
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

    //points selected count
    stats.setPointsSelectedCount = stats.getPointsSelectedCount - 1;
  }

  //these stats need to be submitted immediately after input of dart -> to show avg e.g. (only for input method three darts)
  void submitSomeStats(int points, String pointsAsString) {
    PlayerGameStatisticsX01 stats = getCurrentPlayerGameStatistics();

    //add to total Points -> to calc avg.
    stats.setTotalPoints = stats.getTotalPoints + points;

    //set thrown darts
    stats.setCurrentThrownDartsInLeg = stats.getCurrentThrownDartsInLeg + 1;

    //set first nine avg
    if (stats.getCurrentThrownDartsInLeg <= 9) {
      stats.setFirstNineAverage = stats.getFirstNineAverage + points;
      if (getGameSettings.getInputMethod == InputMethod.Round) {
        stats.setFirstNineAverageCountRound =
            stats.getFirstNineAverageCountRound + 1;
      } else {
        stats.setFirstNineAverageCountThreeDarts =
            stats.getFirstNineAverageCountThreeDarts + 1;
      }
    }

    //all scores per dart as string + count
    if (stats.getAllScoresPerDartAsStringCount.containsKey(pointsAsString))
      stats.getAllScoresPerDartAsStringCount[pointsAsString] += 1;
    else
      stats.getAllScoresPerDartAsStringCount[pointsAsString] = 1;

    stats.setAllScoresPerDartAsString = [
      ...stats.getAllScoresPerDartAsString,
      pointsAsString
    ];
  }

  //to show the thrown dart immediately in ui (only for input method -> three darts)
  void submitOnlyPoints(int points, String pointsAsString) {
    setRevertPossible = true;

    PlayerGameStatisticsX01 stats = getCurrentPlayerGameStatistics();

    //set points
    stats.setCurrentPoints = stats.getCurrentPoints - points;

    //set all scores per dart
    stats.setAllScoresPerDart = [...stats.getAllScoresPerDart, points];

    submitSomeStats(points, pointsAsString);
  }

  //thrownDarts -> selected from checkout dialog (only for input method -> round)
  //checkout count needed in order to revert checkout count
  void submitPoints(String thrownPointsString, BuildContext context,
      [thrownDarts = 3, checkoutCount = 0]) {
    if (shouldSubmit(thrownPointsString)) {
      setRevertPossible = true;
      PlayerGameStatisticsX01 currentStats = getCurrentPlayerGameStatistics();
      num thrownPoints =
          thrownPointsString == "Bust" ? 0 : num.parse(thrownPointsString);

      if (getGameSettings.getInputMethod == InputMethod.ThreeDarts) {
        if (thrownPointsString == "Bust") {
          submitBusted(currentStats);
        }

        //set score per dart
        currentStats.getAllScoresPerDart.add(thrownPoints);

        setAllRemainingScoresPerDart(currentStats);
      } else {
        //set total points
        currentStats.setTotalPoints =
            currentStats.getTotalPoints + thrownPoints;
      }

      //set current points
      currentStats.setCurrentPoints =
          currentStats.getCurrentPoints - thrownPoints;

      //add delay for last dart for three darts input method
      int milliseconds =
          getGameSettings.getInputMethod == InputMethod.ThreeDarts ? 800 : 0;
      Future.delayed(Duration(milliseconds: milliseconds), () {
        //set current amount of points selected
        currentStats.setPointsSelectedCount = 0;

        //set starting points
        currentStats.setStartingPoints = currentStats.getCurrentPoints;

        setCurrentPointsSelected = "Points";

        if (getGameSettings.getInputMethod == InputMethod.ThreeDarts) {
          setCurrentPointType = PointType.Single;
        } else {
          //set thrown darts
          currentStats.setCurrentThrownDartsInLeg =
              currentStats.getCurrentThrownDartsInLeg + thrownDarts;

          //set first nine avg
          if (currentStats.getCurrentThrownDartsInLeg <= 9) {
            currentStats.setFirstNineAverage =
                currentStats.getFirstNineAverage + thrownPoints;
            if (getGameSettings.getInputMethod == InputMethod.Round) {
              currentStats.setFirstNineAverageCountRound =
                  currentStats.getFirstNineAverageCountRound + 1;
            } else {
              currentStats.setFirstNineAverageCountThreeDarts =
                  currentStats.getFirstNineAverageCountThreeDarts + 1;
            }
          }
        }

        setCheckoutCountAtThrownDarts(currentStats, checkoutCount);

        num totalPoints = getGameSettings.getInputMethod == InputMethod.Round
            ? thrownPoints
            : num.parse(getCurrentThreeDartsCalculated());

        //set total score
        currentStats.setAllScores = [
          ...currentStats.getAllScores,
          totalPoints.toInt()
        ];
        if (getGameSettings.getInputMethod == InputMethod.Round) {
          currentStats.setAllScoresCountForRound =
              currentStats.getAllScoresCountForRound + 1;
        }

        setScores(currentStats, totalPoints);
        legSetOrGameFinished(currentStats, context, totalPoints);
        setNextPlayer(currentStats);

        if (getCurrentThreeDarts[2] != "Dart 3") {
          resetCurrentThreeDarts();
        }

        notifyListeners();
      });
    }
  }

  bool shouldSubmit(String thrownPoints) {
    if (thrownPoints == "Bust" ||
        getGameSettings.getInputMethod == InputMethod.Round ||
        (getGameSettings.getInputMethod == InputMethod.ThreeDarts &&
                (getAmountOfDartsThrown() == 3) ||
            finishedLegSetOrGame(getCurrentThreeDartsCalculated()))) {
      return true;
    }
    return false;
  }

  //if player clicks on bust in three darts mode
  void submitBusted(PlayerGameStatisticsX01 currentStats) {
    int amountOfThrownDarts = getAmountOfDartsThrown();
    //set all completed throws in this round to 0
    for (int i = currentStats.getAllScoresPerDart.length - 1;
        i > currentStats.getAllScoresPerDart.length - 1 - amountOfThrownDarts;
        i--) {
      int points = currentStats.getAllScoresPerDart[i];
      //also reset total points, first nine, current points
      currentStats.setCurrentPoints = currentStats.getCurrentPoints + points;
      currentStats.setTotalPoints = currentStats.getTotalPoints - points;
      if (currentStats.getCurrentThrownDartsInLeg <= 9) {
        currentStats.setFirstNineAverage =
            currentStats.getFirstNineAverage - points;
      }
      currentStats.getAllScoresPerDart[i] = 0;
      currentStats.getAllScoresPerDartAsString[i] = "0";

      String pointsAsString = points.toString();
      if (currentStats.getAllScoresPerDartAsStringCount
          .containsKey(pointsAsString)) {
        currentStats.getAllScoresPerDartAsStringCount[pointsAsString] -= 1;
        //if amount of precise scores is 0 -> remove it from map
        if (currentStats.getAllScoresPerDartAsStringCount[pointsAsString] ==
            0) {
          currentStats.getAllScoresPerDartAsStringCount
              .removeWhere((key, value) => key == pointsAsString);
        }
      }
    }

    int diffTo3 = 3 - amountOfThrownDarts;
    //set remaining throws to 0 (e.g. 20 left -> with first dart T20 -> set 2nd & 3rd throw also to 0)
    for (int i = 0; i < diffTo3 - 1; i++) {
      currentStats.setAllScoresPerDart = [
        ...currentStats.getAllScoresPerDart,
        0
      ];
      currentStats.setAllScoresPerDartAsString = [
        ...currentStats.getAllScoresPerDartAsString,
        "0"
      ];
    }

    //reset amount of thrown darts
    currentStats.setCurrentThrownDartsInLeg =
        currentStats.getCurrentThrownDartsInLeg + diffTo3;

    if (getGameSettings.getInputMethod == InputMethod.Round) {
      currentStats.setFirstNineAverageCountRound =
          currentStats.getFirstNineAverageCountRound + diffTo3;
    } else {
      currentStats.setFirstNineAverageCountThreeDarts =
          currentStats.getFirstNineAverageCountThreeDarts + diffTo3;
    }

    getCurrentThreeDarts[0] = "0";
    getCurrentThreeDarts[1] = "0";
    getCurrentThreeDarts[2] = "0";
  }

  void setAllRemainingScoresPerDart(PlayerGameStatisticsX01 currentStats) {
    List<String> temp = [];
    if (getCurrentThreeDarts[0] != "Dart 1") {
      temp.add(getCurrentThreeDarts[0]);
    }
    if (getCurrentThreeDarts[1] != "Dart 2") {
      temp.add(getCurrentThreeDarts[1]);
    }
    if (getCurrentThreeDarts[2] != "Dart 3") {
      temp.add(getCurrentThreeDarts[2]);
    }
    currentStats.setAllRemainingScoresPerDart = [
      ...currentStats.getAllRemainingScoresPerDart,
      temp
    ];
  }

  void setCheckoutCountAtThrownDarts(
      PlayerGameStatisticsX01 currentStats, int checkoutCount) {
    if (checkoutCount != 0) {
      currentStats.setCheckoutCount =
          currentStats.getCheckoutCount + checkoutCount;

      currentStats.setCheckoutCountAtThrownDarts = [
        ...currentStats.getCheckoutCountAtThrownDarts,
        Tuple3<String, num, num>(getCurrentLegSetAsString(),
            currentStats.getCurrentThrownDartsInLeg, checkoutCount),
      ];
    }
  }

  void setScores(PlayerGameStatisticsX01 currentStats, num totalPoints) {
    //set precise scores
    if (currentStats.getPreciseScores.containsKey(totalPoints))
      currentStats.getPreciseScores[totalPoints] += 1;
    else
      currentStats.getPreciseScores[totalPoints] = 1;

    //set rounded score even
    List<int> keys = currentStats.getRoundedScoresEven.keys.toList();
    if (totalPoints == 180) {
      currentStats.getRoundedScoresEven[keys[keys.length - 1]] += 1;
    } else {
      for (int i = 0; i < keys.length - 1; i++) {
        if (totalPoints >= keys[i] && totalPoints < keys[i + 1]) {
          currentStats.getRoundedScoresEven[keys[i]] += 1;
        }
      }
    }

    //set rounded scores odd
    keys = currentStats.getRoundedScoresOdd.keys.toList();
    if (totalPoints >= 170) {
      currentStats.getRoundedScoresOdd[keys[keys.length - 1]] += 1;
    } else {
      for (int i = 0; i < keys.length - 1; i++) {
        if (totalPoints >= keys[i] && totalPoints < keys[i + 1]) {
          currentStats.getRoundedScoresOdd[keys[i]] += 1;
        }
      }
    }

    //set all scores per leg
    String key = getCurrentLegSetAsString();
    if (currentStats.getAllScoresPerLeg.containsKey(key)) {
      //add to value list
      currentStats.getAllScoresPerLeg[key].add(totalPoints);
    } else {
      //create new pair in map
      currentStats.getAllScoresPerLeg[key] = [totalPoints];
    }
  }

  void legSetOrGameFinished(PlayerGameStatisticsX01 currentStats,
      BuildContext context, num totalPoints) {
    if (currentStats.getCurrentPoints == 0) {
      //set thrown darts per leg & reset points
      for (PlayerGameStatisticsX01 stats in getPlayerGameStatistics) {
        //thrown darts per leg
        stats.getThrownDartsPerLeg[getCurrentLegSetAsString()] =
            stats.getCurrentThrownDartsInLeg;

        if (currentStats == stats) {
          stats.setDartsForWonLegCount =
              stats.getDartsForWonLegCount + stats.getCurrentThrownDartsInLeg;

          //set remaining points  -> in order to revert points
          stats.setAllRemainingPoints = [
            ...stats.getAllRemainingPoints,
            totalPoints.toInt()
          ];
        } else {
          stats.setAllRemainingPoints = [
            ...stats.getAllRemainingPoints,
            stats.getCurrentPoints
          ];
        }

        stats.setCurrentPoints = getGameSettings.getPointsOrCustom();
        stats.setStartingPoints = stats.getCurrentPoints;

        if (!isGameWon(stats)) {
          stats.setCurrentThrownDartsInLeg = 0;
        }
      }

      //add checkout to list
      currentStats.getCheckouts[getCurrentLegSetAsString()] =
          totalPoints.toInt();

      //update won legs
      currentStats.setLegsWon = currentStats.getLegsWon + 1;
      currentStats.setLegsWonTotal = currentStats.getLegsWonTotal + 1;

      if (getGameSettings.getSetsEnabled) {
        if (getGameSettings.getLegs == currentStats.getLegsWon) {
          //save leg count of each player -> in case a user wants to revert a set
          for (PlayerGameStatisticsX01 stats in getPlayerGameStatistics) {
            stats.setLegsCount = [...stats.getLegsCount, stats.getLegsWon];
            stats.setLegsWon = 0;
          }

          //update won sets
          currentStats.setSetsWon = currentStats.getSetsWon + 1;

          if (isGameWon(currentStats)) {
            sortPlayerStats();
            currentStats.setGameWon = true;
            Navigator.of(context).pushNamed("/finishX01");
          }
        }
      } else {
        if (isGameWon(currentStats)) {
          sortPlayerStats();
          currentStats.setGameWon = true;
          Navigator.of(context).pushNamed("/finishX01");
        }
      }

      //set player who will begin next leg
      if (getPlayerLegStartIndex == getGameSettings.getPlayers.length - 1) {
        setPlayerLegStartIndex = 0;
      } else {
        setPlayerLegStartIndex = getPlayerLegStartIndex + 1;
      }

      if (getGameSettings.getInputMethod == InputMethod.ThreeDarts) {
        resetCurrentThreeDarts();
      }
    }
  }

  setNextPlayer(PlayerGameStatisticsX01 currentStats) {
    //case 1 -> input method is round
    //case 2 -> input method is three darts -> 3 darts entered
    //case 3 -> input method is three darts -> 1 or 2 darts entered & finished leg/set/game
    if ((getGameSettings.getInputMethod == InputMethod.Round) ||
        (getGameSettings.getInputMethod == InputMethod.ThreeDarts &&
            (getCurrentThreeDarts[2] != "Dart 3" ||
                currentStats.getCurrentPoints ==
                    getGameSettings.getPointsOrCustom()))) {
      int indexOfCurrentPlayer =
          getGameSettings.getPlayers.indexOf(getCurrentPlayerToThrow);

      if (indexOfCurrentPlayer + 1 == getGameSettings.getPlayers.length) {
        //round of all players finished -> restart from beginning

        setCurrentPlayerToThrow = getGameSettings.getPlayers[0];
        if (scrollController.isAttached) scrollController.jumpTo(index: 0);
      } else {
        setCurrentPlayerToThrow =
            getGameSettings.getPlayers[indexOfCurrentPlayer + 1];

        if (scrollController.isAttached)
          scrollController.jumpTo(index: indexOfCurrentPlayer + 1);
      }
    }
  }

  void bust(BuildContext context) {
    submitPoints("Bust", context);
  }

  void revertPoints() {
    if (checkIfRevertPossible()) {
      PlayerGameStatisticsX01 currentStats = getCurrentPlayerGameStatistics();
      bool alreadyReverted = false;
      int lastPoints = 0;
      bool legOrSetReverted = false;
      bool roundCompleted =
          false; //in order to revert only 1 dart or full round

      if (getGameSettings.getInputMethod == InputMethod.Round ||
          (getGameSettings.getInputMethod == InputMethod.ThreeDarts &&
              getAmountOfDartsThrown() == 0)) {
        roundCompleted = true;

        //set previous player
        int indexOfCurrentPlayer =
            getGameSettings.getPlayers.indexOf(getCurrentPlayerToThrow);

        if (indexOfCurrentPlayer - 1 < 0) {
          setCurrentPlayerToThrow = getGameSettings.getPlayers.last;
        } else {
          setCurrentPlayerToThrow =
              getGameSettings.getPlayers[indexOfCurrentPlayer - 1];
        }

        currentStats = getCurrentPlayerGameStatistics();

        //get last points
        if (getGameSettings.getInputMethod == InputMethod.Round) {
          lastPoints = currentStats.getAllScores.last;
        } else {
          lastPoints = currentStats.getAllScoresPerDart.last;
        }

        //leg (or + set) reverted
        if ((startPointsPossibilities.contains(currentStats.getCurrentPoints) ||
                getGameSettings.getCustomPoints ==
                    currentStats.getCurrentPoints) &&
            lastPoints != 0) {
          legOrSetReverted = true;
          bool setReverted = false;
          if (currentStats.getLegsCount.isNotEmpty &&
              currentStats.getLegsCount.last == getGameSettings.getLegs) {
            setReverted = true;
          }

          for (PlayerGameStatisticsX01 stats in getPlayerGameStatistics) {
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
              if (getGameSettings.getInputMethod == InputMethod.ThreeDarts) {
                setLastThrownDarts(stats.getAllRemainingScoresPerDart.last);
                int amountOfThrownDarts = getAmountOfDartsThrown();
                stats.setCurrentPoints = getValueOfSpecificDart(
                    getCurrentThreeDarts[amountOfThrownDarts - 1]);
                getCurrentThreeDarts[amountOfThrownDarts - 1] =
                    "Dart " + amountOfThrownDarts.toString();
              }
              if (!setReverted) {
                stats.setLegsWon = stats.getLegsWon - 1;
                stats.setLegsWonTotal = stats.getLegsWonTotal - 1;
              }
              //revert only player that is currently selected
              int lastPoints1;
              if (getGameSettings.getInputMethod == InputMethod.Round) {
                lastPoints1 = stats.getAllScores.last;
              } else {
                lastPoints1 = stats.getAllScoresPerDart.last;
              }
              revertStats(stats, lastPoints1, true, roundCompleted);
              alreadyReverted = true;
            }
          }
        }
      }

      if (!legOrSetReverted) {
        //get last points
        if (getGameSettings.getInputMethod == InputMethod.Round) {
          lastPoints = currentStats.getAllScores.last;
        } else {
          lastPoints = currentStats.getAllScoresPerDart.last;
        }

        if (getGameSettings.getInputMethod == InputMethod.ThreeDarts) {
          int amountOfThrownDarts = getAmountOfDartsThrown();
          if (amountOfThrownDarts == 0) {
            setLastThrownDarts(currentStats.getAllRemainingScoresPerDart.last);
            getCurrentThreeDarts[2] = "Dart 3";
          } else {
            getCurrentThreeDarts[amountOfThrownDarts - 1] =
                "Dart " + amountOfThrownDarts.toString();
          }
        }
        currentStats.setCurrentPoints =
            currentStats.getCurrentPoints + lastPoints;
      }

      if (alreadyReverted == false) {
        revertStats(currentStats, lastPoints, false, roundCompleted);
      }

      setCurrentPointsSelected = "Points";
      checkIfRevertPossible(); //if 1 score is left -> enters this if & removes last score -> without this call the revert btn is still highlighted
    }
  }

  //returns true if at least one player has a score left
  bool checkIfRevertPossible() {
    bool result = false;
    for (PlayerGameStatisticsX01 stats in getPlayerGameStatistics) {
      if (getGameSettings.getInputMethod == InputMethod.Round) {
        if (stats.getAllScores.length > 0) {
          result = true;
        }
      } else {
        if (stats.getAllScoresPerDart.length > 0) {
          result = true;
        }
      }
    }

    setRevertPossible = result;
    notifyListeners();

    return result;
  }

  void revertStats(PlayerGameStatisticsX01 stats, int points,
      bool legOrSetReverted, bool roundCompleted) {
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
            int.parse(getCurrentThreeDartsCalculated()) + lastScore;
      }

      //thrown darts per leg
      if (stats.getThrownDartsPerLeg.isNotEmpty) {
        String lastKey = stats.getThrownDartsPerLeg.lastKey();
        stats.setCurrentThrownDartsInLeg = stats.getThrownDartsPerLeg[lastKey];
        stats.getThrownDartsPerLeg.remove(stats.getThrownDartsPerLeg.lastKey());
      }
    }

    //all scores per dart
    if (stats.getAllScoresPerDart.isNotEmpty) {
      stats.getAllScoresPerDart.removeLast();
    }

    //set points selected count
    if (getGameSettings.getInputMethod == InputMethod.ThreeDarts) {
      stats.setPointsSelectedCount = getAmountOfDartsThrown();
    }

    //total points
    stats.setTotalPoints = stats.getTotalPoints - points;

    //first nine avg
    if (stats.getCurrentThrownDartsInLeg <= 9) {
      stats.setFirstNineAverage = stats.getFirstNineAverage - points;
      if (getGameSettings.getInputMethod == InputMethod.Round) {
        stats.setFirstNineAverageCountRound =
            stats.getFirstNineAverageCountRound - 1;
      } else {
        stats.setFirstNineAverageCountThreeDarts =
            stats.getFirstNineAverageCountThreeDarts - 1;
      }
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
      if (getGameSettings.getInputMethod == InputMethod.ThreeDarts) {
        points += int.parse(getCurrentThreeDartsCalculated());
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
      stats.getAllScoresPerLeg.remove(stats.getAllScoresPerLeg.lastKey());

      //all remaining scores per dart
      if (stats.getAllRemainingScoresPerDart.isNotEmpty) {
        stats.getAllRemainingScoresPerDart.removeLast();
      }
    }

    if (roundCompleted || legOrSetReverted) {
      //checkout count
      if (stats.getCheckoutCountAtThrownDarts.isNotEmpty) {
        Tuple3<String, num, num> tuple =
            stats.getCheckoutCountAtThrownDarts.last;
        if (tuple.item1 == getCurrentLegSetAsString() &&
            tuple.item2 == stats.getCurrentThrownDartsInLeg) {
          stats.setCheckoutCount = stats.getCheckoutCount - tuple.item3;
          stats.getCheckoutCountAtThrownDarts.removeLast();
        }
      }
    }

    //thrown darts
    stats.setCurrentThrownDartsInLeg = stats.getCurrentThrownDartsInLeg - 1;
  }

  bool checkoutPossible() {
    PlayerGameStatisticsX01 stats = getCurrentPlayerGameStatistics();

    int points = stats.getCurrentPoints;
    if (getGameSettings.getInputMethod == InputMethod.ThreeDarts) {
      points += int.parse(getCurrentThreeDartsCalculated());
    }

    if (points <= 170 && !bogeyNumbers.contains(points)) {
      return true;
    }

    return false;
  }

  //returns 0, 1, 2, 3 or -1
  int getAmountOfCheckoutPossibilities(String thrownPointsString) {
    int thrownPoints = int.parse(thrownPointsString);

    if (getGameSettings.getInputMethod == InputMethod.ThreeDarts) {
      return getAmountOfCheckoutPossibilitiesForInputMethodThreeDarts(
          thrownPoints);
    }
    return getAmountOfCheckoutPossibilitiesForInputMethodRound(thrownPoints);
  }

  //differs to round mode
  //e.g. 60 points remaining -> S20, D20 -> only 1 dart on double possible -> dont show 2 as with round mode
  int getAmountOfCheckoutPossibilitiesForInputMethodThreeDarts(
      int thrownPoints) {
    PlayerGameStatisticsX01 stats = getCurrentPlayerGameStatistics();

    int currentPoints = stats.getStartingPoints;
    int doubleCount = 0;

    //check at which dart currentPoints were on a double field -> increment counter
    for (String point in getCurrentThreeDarts) {
      if (isDoubleField(currentPoints.toString())) {
        doubleCount++;
      }
      currentPoints -= getValueOfSpecificDart(point);
    }

    if (doubleCount == 0) {
      return -1;
    }
    return doubleCount;
  }

  int getAmountOfCheckoutPossibilitiesForInputMethodRound(int thrownPoints) {
    PlayerGameStatisticsX01 stats = getCurrentPlayerGameStatistics();

    int currentPoints = stats.getCurrentPoints;
    //current points = double field
    if (isDoubleField(currentPoints.toString())) {
      return 3;
    }

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
    PlayerGameStatisticsX01 stats = getCurrentPlayerGameStatistics();
    stats.setCheckoutCount = stats.getCheckoutCount + checkoutCount;
  }

  void notify() {
    notifyListeners();
  }

  //for checkout counting dialog -> to show the amount of darts for finising the leg, set or game -> in order to calc average correctly
  bool finishedLegSetOrGame(String points) {
    PlayerGameStatisticsX01 stats = getCurrentPlayerGameStatistics();

    int currentPoints = stats.getCurrentPoints;
    if (getGameSettings.getInputMethod == InputMethod.ThreeDarts) {
      currentPoints = stats.getStartingPoints;
    }

    if ((currentPoints - int.parse(points)) == 0) {
      return true;
    }

    return false;
  }

  //checks if the finish is possible with ONLY 3 darts
  bool finishedWithThreeDarts(String thrownPointsString) {
    //no need to check for <= 170 or bogey numbers -> this method is only called after checkoutPossible()
    int thrownPoints = int.parse(thrownPointsString);
    if (threeDartFinishesWithBull.contains(thrownPoints)) {
      return false;
    }

    PlayerGameStatisticsX01 stats = getCurrentPlayerGameStatistics();
    int currentPoints = stats.getCurrentPoints;
    if (getGameSettings.getInputMethod == InputMethod.ThreeDarts) {
      currentPoints = stats.getStartingPoints;
    }

    //99 = special case
    if ((thrownPoints > 100 || thrownPoints == 99) &&
        (currentPoints - thrownPoints == 0)) {
      if (getGameSettings.getEnableCheckoutCounting &&
          getGameSettings.getCheckoutCountingFinallyDisabled == false) {
        //addToCheckoutCount(1);
      }

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
    if (((points <= 40 && points % 2 == 0) || points == 50) && points != 0) {
      return true;
    }

    return false;
  }

  //checks if 1,3 or 5 is submitted -> invalid for double in (cant disable e.g. 1 because 10 is valid -> D5)
  bool checkIfInvalidDoubleInPointsSubmitted(String pointsSelected) {
    PlayerGameStatisticsX01 stats = getCurrentPlayerGameStatistics();

    if (getGameSettings.getModeIn == SingleOrDouble.DoubleField &&
        stats.getCurrentPoints == getGameSettings.getPointsOrCustom()) {
      if (pointsSelected == "1" ||
          pointsSelected == "3" ||
          pointsSelected == "5") {
        return true;
      }
    }
    return false;
  }

  bool isGameWon(PlayerGameStatisticsX01 stats) {
    if (!getReachedSuddenDeath) {
      if (getGameSettings.getMode == BestOfOrFirstToEnum.FirstTo &&
          getGameSettings.getSets == stats.getSetsWon) {
        //player won the game - set mode & first to
        return true;
      } else if (getGameSettings.getMode == BestOfOrFirstToEnum.BestOf &&
          getGameSettings.getSets == ((stats.getSetsWon * 2) - 1)) {
        //player won the game - set mode & best of
        return true;
      } else if (getGameSettings.getMode == BestOfOrFirstToEnum.FirstTo &&
          stats.getLegsWon >= getGameSettings.getLegs) {
        //check if win by two legs is enabled
        if (getGameSettings.getWinByTwoLegsDifference) {
          //suddean death reached
          if (getGameSettings.getSuddenDeath && reachedSuddenDeath()) {
            setReachedSuddenDeath = true;
          }

          //check if leg diff is at least 2
          if (!checkLegDifference(stats)) {
            return false;
          }
        }
        //player won the game - leg mode & first to
        return true;
      } else if (getGameSettings.getMode == BestOfOrFirstToEnum.BestOf &&
          getGameSettings.getLegs == ((stats.getLegsWon * 2) - 1)) {
        //player won the game - leg mode & best of
        return true;
      }
      return false;
    }
    return true;
  }

  //for win by two legs diff -> checks if leg won difference is at least 2 at each player -> return true (valid win)
  bool checkLegDifference(PlayerGameStatisticsX01 playerToCheck) {
    for (PlayerGameStatisticsX01 stats in getPlayerGameStatistics) {
      if (stats != playerToCheck &&
          (playerToCheck.getLegsWon - 2) < stats.getLegsWon) {
        return false;
      }
    }
    return true;
  }

  bool reachedSuddenDeath() {
    bool result = true;
    for (PlayerGameStatisticsX01 stats in getPlayerGameStatistics) {
      if (stats.getLegsWon !=
          (getGameSettings.getLegs + getGameSettings.getMaxExtraLegs)) {
        result = false;
      }
    }

    return result;
  }

  //in order to show the right order in the finish screen
  void sortPlayerStats() {
    //convert playerGameStatistics to playerGameStatisticsX01 -> otherwise cant sort
    List<PlayerGameStatisticsX01> temp = [];
    for (PlayerGameStatistics playerGameStatistics in getPlayerGameStatistics) {
      temp.add(playerGameStatistics as PlayerGameStatisticsX01);
    }

    //if sets are enabled -> sort after sets, otherwise after legs
    if (getGameSettings.getSetsEnabled)
      temp.sort((a, b) => b.getSetsWon.compareTo(a.getSetsWon));
    else
      temp.sort((a, b) => b.getLegsWon.compareTo(a.getLegsWon));

    setPlayerGameStatistics = temp;
  }

  //needed to set all scores per leg
  num getCurrentLeg() {
    num result = 1;
    for (PlayerGameStatisticsX01 stats in getPlayerGameStatistics)
      result += stats.getLegsWon;

    return result;
  }

  //needed to set all scores per leg
  num getCurrentSet() {
    num result = 1;
    for (PlayerGameStatisticsX01 stats in getPlayerGameStatistics)
      result += stats.getSetsWon;

    return result;
  }

  //needed for allScoresPerLeg + CheckoutCountAtThrownDarts
  //returns e.g. 'Leg 1' or 'Set 1 Leg 2'
  String getCurrentLegSetAsString() {
    num currentLeg = getCurrentLeg();
    num currentSet = -1;
    String key = "";

    if (getGameSettings.getSetsEnabled) {
      currentSet = getCurrentSet();
      key += "Set " + currentSet.toString() + " - ";
    }
    key += "Leg " + currentLeg.toString();

    return key;
  }

  String getCurrentThreeDartsCalculated() {
    int result = 0;

    for (String dart in getCurrentThreeDarts) {
      result += getValueOfSpecificDart(dart);
    }

    return result.toString();
  }

  int getValueOfSpecificDart(String dart) {
    int result = 0;
    String temp;

    if (dart != "Dart 1" && dart != "Dart 2" && dart != "Dart 3") {
      if (dart == "Bull") {
        result += 50;
      } else if (dart[0] == "D") {
        temp = dart.substring(1);
        result += (int.parse(temp) * 2);
      } else if (dart[0] == "T") {
        temp = dart.substring(1);
        result += (int.parse(temp) * 3);
      } else {
        result += int.parse(dart);
      }
    }

    return result;
  }

  void resetCurrentThreeDarts() {
    getCurrentThreeDarts[0] = "Dart 1";
    getCurrentThreeDarts[1] = "Dart 2";
    getCurrentThreeDarts[2] = "Dart 3";
  }

  int getAmountOfDartsThrown() {
    int count = 0;

    if (getCurrentThreeDarts[0] != "Dart 1") {
      count++;
    }
    if (getCurrentThreeDarts[1] != "Dart 2") {
      count++;
    }
    if (getCurrentThreeDarts[2] != "Dart 3") {
      count++;
    }

    return count;
  }

  bool isCheckoutCountingEnabled() {
    if (getGameSettings.getEnableCheckoutCounting &&
        getGameSettings.getCheckoutCountingFinallyDisabled == false) {
      return true;
    }
    return false;
  }

  void setLastThrownDarts(List<String> points) {
    for (int i = 0; i < points.length; i++) {
      getCurrentThreeDarts[i] = points[i];
    }
  }

  void setNewGameValuesFromOpenGame(Game game, BuildContext context) {
    Provider.of<GameSettingsX01>(context, listen: false)
        .setNewGameSettingsFromOpenGame(
            game.getGameSettings as GameSettingsX01);

    setPlayerGameStatistics = game.getPlayerGameStatistics;
    setDateTime = game.getDateTime;
    setGameId = game.getGameId;
    setName = game.getName;
    setGameSettings = game.getGameSettings;
    setCurrentPlayerToThrow = game.getCurrentPlayerToThrow;
  }
}
