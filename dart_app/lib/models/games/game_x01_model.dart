import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01_model.dart';
import 'package:dart_app/models/games/game_model.dart';
import 'package:dart_app/models/player_model.dart';
import 'package:dart_app/models/player_statistics/player_game_statistics_model.dart';
import 'package:dart_app/models/player_statistics/player_game_statistics_x01_model.dart';
import 'dart:developer';
import 'package:intl/intl.dart';
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
            mode: "X01", player: player, currentPoints: points));
      }

      if (getGameSettings.getInputMethod == InputMethod.ThreeDarts)
        setCurrentPointType = PointType.Single;
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
    resetCurrentThreeDarts();
  }

  //to determine if points button should be disabled -> e.g current points are 80 -> shouldnt be possible to press any other points buttons -> invalid points
  bool checkIfPointBtnShouldBeDisabled(String btnValueToCheck) {
    PlayerGameStatisticsX01 playerGameStatisticsX01 =
        getCurrentPlayerGameStatistics();

    //for INPUT METHOD = ROUND
    if (getGameSettings.getInputMethod == InputMethod.Round) {
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
    } else {
      //for INPUT METHOD = THREE DARTS

      //disable 25 in double & tripple mode
      if (btnValueToCheck == "25" &&
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
          playerGameStatisticsX01.getCurrentPoints ==
              getGameSettings.getPointsOrCustom()) {
        if (getCurrentPointType == PointType.Double) {
          return true;
        } else {
          return false;
        }
      }

      //if double out -> only enable finsihes with D (e.g. 20 -> enable D10 but disable single 20)
      if (getGameSettings.getModeOut == SingleOrDouble.DoubleField) {
        if (playerGameStatisticsX01.getCurrentPoints - result == 0) {
          if (getCurrentPointType == PointType.Double) {
            return true;
          } else {
            return false;
          }
        }
      }

      if (result > playerGameStatisticsX01.getCurrentPoints ||
          noScoresPossible.contains(result) ||
          playerGameStatisticsX01.getCurrentPoints - result == 1) {
        return false;
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
    return getPlayerGameStatistics
        .firstWhere((stats) => stats.getPlayer == getCurrentPlayerToThrow);
  }

  //only for input method -> three darts
  void submitOnlyPoints(int points) {
    setRevertPossible = true;

    PlayerGameStatisticsX01 currentPlayerStats =
        getCurrentPlayerGameStatistics();

    //set points
    currentPlayerStats.setCurrentPoints =
        currentPlayerStats.getCurrentPoints - points;

    //set all scores per dart
    currentPlayerStats.getAllScoresPerDart.add(points);
  }

  bool shouldSubmit(String thrownPoints) {
    if (thrownPoints == "Bust" ||
        getGameSettings.getInputMethod == InputMethod.Round ||
        (getGameSettings.getInputMethod == InputMethod.ThreeDarts &&
            getAmountOfDartsThrown() == 3) ||
        finishedLegSetOrGame(getCurrentThreeDartsCalculated())) {
      return true;
    }
    return false;
  }

  //thrownDarts -> when selected from checkout dialog
  void submitPoints(String thrownPointsString, BuildContext context,
      [thrownDarts = 3]) {
    if (shouldSubmit(thrownPointsString)) {
      setRevertPossible = true;

      PlayerGameStatisticsX01 currentPlayerStats =
          getCurrentPlayerGameStatistics();

      num thrownPoints =
          thrownPointsString == "Bust" ? 0 : num.parse(thrownPointsString);

      currentPlayerStats.setCurrentPoints =
          currentPlayerStats.getCurrentPoints - thrownPoints;

      setCurrentPointsSelected = "Points";

      //set thrown darts
      currentPlayerStats.setThrownDartsPerLeg =
          currentPlayerStats.getThrownDartsPerLeg + thrownDarts;

      if (getGameSettings.getInputMethod == InputMethod.ThreeDarts) {
        thrownPoints = int.parse(getCurrentThreeDartsCalculated());
      }

      //add to total Points -> to calc avg.
      currentPlayerStats.setTotalPoints =
          currentPlayerStats.getTotalPoints + thrownPoints;

      //set first nine avg
      if (currentPlayerStats.getThrownDartsPerLeg <= 9) {
        currentPlayerStats.setFirstNineAverage =
            currentPlayerStats.getFirstNineAverage + thrownPoints;
        currentPlayerStats.setFirstNineAverageCount =
            currentPlayerStats.getFirstNineAverageCount + 1;
      }

      if (getGameSettings.getInputMethod == InputMethod.ThreeDarts) {
        //set score per dart
        currentPlayerStats.getAllScoresPerDart.add(thrownPoints);
      }

      num totalPoints = getGameSettings.getInputMethod == InputMethod.Round
          ? thrownPoints
          : num.parse(getCurrentThreeDartsCalculated());

      //set total score
      currentPlayerStats.setAllScores = [
        ...currentPlayerStats.getAllScores,
        totalPoints.toInt()
      ];

      //set precise scores
      if (currentPlayerStats.getPreciseScores.containsKey(totalPoints))
        currentPlayerStats.getPreciseScores[totalPoints] += 1;
      else
        currentPlayerStats.getPreciseScores[totalPoints] = 1;

      //set rounded score
      List<int> keys = currentPlayerStats.getRoundedScores.keys.toList();
      if (totalPoints == 180) {
        currentPlayerStats.getRoundedScores[keys[keys.length - 1]] += 1;
      }
      for (int i = 0; i < keys.length - 1; i++) {
        if (totalPoints >= keys[i] && totalPoints < keys[i + 1]) {
          currentPlayerStats.getRoundedScores[keys[i]] += 1;
        }
      }

      //set all scores per leg
      String key = getKeyForAllScoresPerLeg();
      if (currentPlayerStats.getAllScoresPerLeg.containsKey(key)) {
        //add to value list
        currentPlayerStats.getAllScoresPerLeg[key].add(totalPoints);
      } else {
        //create new pair in map
        currentPlayerStats.getAllScoresPerLeg[key] = [totalPoints];
      }

      //leg/set finished -> check also if game is finished
      if (currentPlayerStats.getCurrentPoints == 0) {
        //update won legs
        currentPlayerStats.setLegsWon = currentPlayerStats.getLegsWon + 1;

        if (getGameSettings.getSetsEnabled) {
          if (getGameSettings.getLegs == currentPlayerStats.getLegsWon) {
            //save leg count of each player -> in case a user wants to revert a set
            for (PlayerGameStatisticsX01 stats in getPlayerGameStatistics) {
              stats.setLegsCount = [...stats.getLegsCount, stats.getLegsWon];
              stats.setLegsWon = 0;
            }

            //update won sets
            currentPlayerStats.setSetsWon = currentPlayerStats.getSetsWon + 1;

            if (isGameWon(currentPlayerStats)) {
              sortPlayerStats();
              Navigator.of(context).pushNamed("/finishX01");
            }
          }
        } else {
          if (isGameWon(currentPlayerStats)) {
            sortPlayerStats();
            Navigator.of(context).pushNamed("/finishX01");
          }
        }

        //set player who will begin next leg
        if (getPlayerLegStartIndex == getGameSettings.getPlayers.length) {
          setPlayerLegStartIndex = 0;
        } else {
          setPlayerLegStartIndex = getPlayerLegStartIndex + 1;
        }

        //add checkout to list
        currentPlayerStats.setCheckouts = [
          ...currentPlayerStats.getCheckouts,
          thrownPoints.toInt()
        ];

        //reset points & thrown darts per leg
        for (PlayerGameStatisticsX01 stats in getPlayerGameStatistics) {
          //set remaining points  -> in order to revert points
          if (stats == currentPlayerStats) {
            currentPlayerStats.setAllRemainingPoints = [
              ...currentPlayerStats.getAllRemainingPoints,
              thrownPoints.toInt()
            ];
          } else {
            stats.setAllRemainingPoints = [
              ...stats.getAllRemainingPoints,
              stats.getCurrentPoints
            ];
          }

          stats.setCurrentPoints = getGameSettings.getPointsOrCustom();

          if (!isGameWon(currentPlayerStats)) {
            stats.setThrownDartsPerLeg = 0;
          }
        }
        if (getGameSettings.getInputMethod == InputMethod.ThreeDarts) {
          resetCurrentThreeDarts();
        }
      }

      //SET NEXT PLAYER
      //case 1 -> input method is round
      //case 2 -> input method is three darts -> 3 darts entered
      //case 3 -> input method is three darts -> 1 or 2 darts entered & finished leg/set/game
      if ((getGameSettings.getInputMethod == InputMethod.Round) ||
          (getGameSettings.getInputMethod == InputMethod.ThreeDarts &&
              (getCurrentThreeDarts[2] != "Dart 3" ||
                  currentPlayerStats.getCurrentPoints ==
                      getGameSettings.getPointsOrCustom()))) {
        int indexOfCurrentPlayer =
            getGameSettings.getPlayers.indexOf(getCurrentPlayerToThrow);
        if (indexOfCurrentPlayer + 1 == getGameSettings.getPlayers.length) {
          //round of all players finished -> restart from beginning
          setCurrentPlayerToThrow = getGameSettings.getPlayers[0];
        } else {
          setCurrentPlayerToThrow =
              getGameSettings.getPlayers[indexOfCurrentPlayer + 1];
        }
      }

      if (getCurrentThreeDarts[2] != "Dart 3") {
        resetCurrentThreeDarts();
      }

      notifyListeners();
    }
  }

  void bust(BuildContext context) {
    submitPoints("Bust", context);
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
            revertStats(stats, lastPoints1, true);
            alreadyReverted = true;
          }
        }
      } else {
        currentPlayerStats.setCurrentPoints =
            currentPlayerStats.getCurrentPoints + lastPoitns;
      }

      if (alreadyReverted == false) {
        revertStats(currentPlayerStats, lastPoitns, false);
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

  void revertStats(
      PlayerGameStatisticsX01 stats, int points, bool legOrSetReverted) {
    //all scores
    if (stats.getAllScores.isNotEmpty) {
      stats.getAllScores.removeLast();
    }

    //total points
    stats.setTotalPoints = stats.getTotalPoints - points;

    //precise scores
    if (stats.getPreciseScores.containsKey(points)) {
      stats.getPreciseScores[points] -= 1;
      //if amount of precise scores is 0 -> remove it from map
      stats.getPreciseScores.removeWhere((key, value) => key == points);
    }

    //first nine avg
    if (stats.getThrownDartsPerLeg <= 9) {
      stats.setFirstNineAverage = stats.getFirstNineAverage - points;
      stats.setFirstNineAverageCount = stats.getFirstNineAverageCount - 1;
    }

    //thrown darts per leg
    stats.setThrownDartsPerLeg = stats.getThrownDartsPerLeg - 3;

    //rounded scores
    List<int> keys = stats.getRoundedScores.keys.toList();
    if (points >= 170) {
      stats.getRoundedScores[keys[keys.length - 1]] -= 1;
    }
    for (int i = 0; i < keys.length - 1; i++) {
      if (points >= keys[i] && points < keys[i + 1]) {
        stats.getRoundedScores[keys[i]] -= 1;
      }
    }

    //leg or set reverted
    if (legOrSetReverted) {
      //checkout
      stats.getCheckouts.removeLast();
    }

    //all scores per leg
    String key = getKeyForAllScoresPerLeg();
    stats.getAllScoresPerLeg[key].removeLast();
  }

  bool checkoutPossible() {
    PlayerGameStatisticsX01 currentPlayerStats =
        getCurrentPlayerGameStatistics();

    int points = currentPlayerStats.getCurrentPoints;
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
    PlayerGameStatisticsX01 currentPlayerStats =
        getCurrentPlayerGameStatistics();

    int currentPoints = int.parse(getCurrentThreeDartsCalculated());
    //because last dart is not submitted yet
    if (getAmountOfDartsThrown() == 3) {
      int temp = currentPlayerStats.getCurrentPoints - thrownPoints;
      currentPoints += temp;
    }

    int doubleCount = 0;

    //check at which dart currentPoints were on a double field -> increment counter
    for (String point in getCurrentThreeDarts) {
      if (isDoubleField(currentPoints.toString())) {
        doubleCount++;
      }
      currentPoints = currentPoints - getValueOfSpecificDart(point);
    }

    if (doubleCount == 0) {
      return -1;
    }
    return doubleCount;
  }

  int getAmountOfCheckoutPossibilitiesForInputMethodRound(int thrownPoints) {
    PlayerGameStatisticsX01 currentPlayerStats =
        getCurrentPlayerGameStatistics();

    int currentPoints = currentPlayerStats.getCurrentPoints;
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

    int currentPoints = currentPlayerStats.getCurrentPoints;
    if (getGameSettings.getInputMethod == InputMethod.ThreeDarts) {
      currentPoints += int.parse(getCurrentThreeDartsCalculated());
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
      //when input method is three darts, current points will be updated after every throw -> recalculate it
      currentPoints += int.parse(thrownPointsString);
    }

    //99 = special case
    if ((thrownPoints > 100 || thrownPoints == 99) &&
        (currentPoints - thrownPoints == 0)) {
      if (getGameSettings.getEnableCheckoutCounting &&
          getGameSettings.getCheckoutCountingFinallyDisabled == false) {
        addToCheckoutCount(1);
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

  String getFormattedDateTime() {
    final DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm');
    return formatter.format(getDateTime);
  }

  bool isGameWon(PlayerGameStatisticsX01 stats) {
    if (!getReachedSuddenDeath) {
      if (getGameSettings.getMode == BestOfOrFirstTo.FirstTo &&
          getGameSettings.getSets == stats.getSetsWon) {
        //player won the game - set mode & first to
        return true;
      } else if (getGameSettings.getMode == BestOfOrFirstTo.BestOf &&
          getGameSettings.getSets == ((stats.getSetsWon * 2) - 1)) {
        //player won the game - set mode & best of
        return true;
      } else if (getGameSettings.getMode == BestOfOrFirstTo.FirstTo &&
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
      } else if (getGameSettings.getMode == BestOfOrFirstTo.BestOf &&
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
    num result = 0;
    for (PlayerGameStatisticsX01 stats in getPlayerGameStatistics)
      result += stats.getLegsWon;

    return result;
  }

  //needed to set all scores per leg
  num getCurrentSet() {
    num result = 0;
    for (PlayerGameStatisticsX01 stats in getPlayerGameStatistics)
      result += stats.getSetsWon;

    return result;
  }

  //needed for allScoresPerLeg
  //e.g. Leg 1 or Set 1 Leg 2
  String getKeyForAllScoresPerLeg() {
    num currentLeg = getCurrentLeg();
    num currentSet = -1;
    String key = "";

    if (getGameSettings.getSetsEnabled) {
      currentSet = getCurrentSet();
      key += "Set" + currentSet.toString() + " ";
    }
    key += "Leg" + currentLeg.toString();

    return key;
  }

  String getCurrentThreeDartsCalculated() {
    int result = 0;

    for (String dart in getCurrentThreeDarts) {
      if (dart != "Dart 1" && dart != "Dart 2" && dart != "Dart 3") {
        result += getValueOfSpecificDart(dart);
      }
    }

    return result.toString();
  }

  int getValueOfSpecificDart(String dart) {
    int result = 0;
    String temp;

    if (dart == "Bull") {
      result += 50;
    } else if (dart[0] == "D") {
      temp = dart.substring(2);
      result += (int.parse(temp) * 2);
    } else if (dart[0] == "T") {
      temp = dart.substring(2);
      result += (int.parse(temp) * 3);
    } else {
      result += int.parse(dart);
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
}
