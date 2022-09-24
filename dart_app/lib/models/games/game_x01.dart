import 'package:dart_app/constants.dart';
import 'package:dart_app/models/bot.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/models/player_statistics/player_game_statistics.dart';
import 'package:dart_app/models/player_statistics/player_game_statistics_x01.dart';
import 'package:dart_app/utils/globals.dart';
import 'package:provider/provider.dart';

import 'package:tuple/tuple.dart';
import 'package:flutter/material.dart';

class GameX01 extends Game {
  GameX01() : super(dateTime: DateTime.now(), name: 'X01');

  String _currentPointsSelected = 'Points';
  int _playerLegStartIndex =
      0; //to determine which player should begin next leg
  bool _revertPossible = false;
  bool _init = false;
  bool _reachedSuddenDeath = false;

  PointType _currentPointType =
      PointType.Single; //only for input type -> three darts
  List<String> _currentThreeDarts = [
    'Dart 1',
    'Dart 2',
    'Dart 3'
  ]; //only for input type -> three darts
  bool _canBePressed =
      true; //only for input type -> three darts + automatically submit points (to disable buttons when delay is active)

  factory GameX01.createGameX01(Game? game) {
    GameX01 gameX01 = new GameX01();
    gameX01.setDateTime = game!.getDateTime;
    gameX01.setGameId = game.getGameId;
    gameX01.setGameSettings = game.getGameSettings;
    gameX01.setPlayerGameStatistics = game.getPlayerGameStatistics;
    gameX01.setCurrentPlayerToThrow = game.getCurrentPlayerToThrow;

    return gameX01;
  }

  /************************************************************/
  /********              GETTER & SETTER               ********/
  /************************************************************/

  String get getCurrentPointsSelected => this._currentPointsSelected;
  set setCurrentPointsSelected(String currentPointsSelected) =>
      this._currentPointsSelected = currentPointsSelected;

  int get getPlayerLegStartIndex => this._playerLegStartIndex;
  set setPlayerLegStartIndex(int playerLegStartIndex) =>
      this._playerLegStartIndex = playerLegStartIndex;

  bool get getRevertPossible => this._revertPossible;
  set setRevertPossible(bool revertPossible) =>
      this._revertPossible = revertPossible;

  bool get getInit => this._init;
  set setInit(bool init) => this._init = init;

  bool get getReachedSuddenDeath => this._reachedSuddenDeath;
  set setReachedSuddenDeath(bool reachedSuddenDeath) =>
      this._reachedSuddenDeath = reachedSuddenDeath;

  PointType get getCurrentPointType => this._currentPointType;
  set setCurrentPointType(PointType currentPointType) => {
        this._currentPointType = currentPointType,
      };

  List<String> get getCurrentThreeDarts => this._currentThreeDarts;
  set setCurrentThreeDarts(List<String> currentThreeDarts) =>
      this._currentThreeDarts = currentThreeDarts;

  bool get getCanBePressed => this._canBePressed;
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
    this.setPlayerGameStatistics = [];

    //if game is finished -> undo last throw -> will call init again
    if (getGameSettings.getPlayers.length != getPlayerGameStatistics.length) {
      this.setInit = true;
      int points = getGameSettings.getPointsOrCustom();

      for (Player player in gameSettingsX01.getPlayers) {
        this.getPlayerGameStatistics.add(new PlayerGameStatisticsX01(
            mode: 'X01',
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
    setCurrentPointsSelected = 'Points';
    setPlayerLegStartIndex = 0;
    setRevertPossible = false;
    setPlayerGameStatistics = [];
    setInit = false;
    setReachedSuddenDeath = false;
    setCurrentPlayerToThrow = null;
    resetCurrentThreeDarts();
  }

  bool shouldPointBtnBeDisabledRound(
      String btnValueToCheck, PlayerGameStatisticsX01 stats) {
    //DOUBLE IN
    if (stats.getCurrentPoints == getGameSettings.getPointsOrCustom() &&
        (getGameSettings.getModeIn == ModeOutIn.Double ||
            getGameSettings.getModeIn == ModeOutIn.Master)) {
      if (getCurrentPointsSelected == 'Points') {
        if (btnValueToCheck == '7' ||
            btnValueToCheck == '9' ||
            btnValueToCheck == '0') {
          return true;
        }
      } else {
        final int result =
            int.parse(getCurrentPointsSelected + btnValueToCheck);

        if (getGameSettings.getModeIn == ModeOutIn.Double) {
          return !isDoubleField(result.toString());
        }

        return !(isDoubleField(result.toString()) || isTrippleField(result));
      }
    }

    if (getCurrentPointsSelected == 'Points') {
      if (btnValueToCheck == '0' ||
          int.parse(btnValueToCheck) > stats.getCurrentPoints) {
        return true;
      }
    } else {
      final int result = int.parse(getCurrentPointsSelected + btnValueToCheck);

      if (result > 180 ||
          result > stats.getCurrentPoints ||
          noScoresPossible.contains(result) ||
          stats.getCurrentPoints - result == 1) {
        return true;
      }
    }

    return false;
  }

  bool shouldPointBtnBeDisabledThreeDarts(
      String btnValueToCheck, PlayerGameStatisticsX01 stats) {
    if (stats.getCurrentPoints == 0) return true;

    //disable 25 in double & tripple mode
    if ((btnValueToCheck == '25' || btnValueToCheck == 'Bull') &&
        (getCurrentPointType == PointType.Tripple ||
            getCurrentPointType == PointType.Double)) {
      return true;
    }

    //calculate points based on single, double or tripple
    int result = 0;
    if (btnValueToCheck == 'Bull') {
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

    //if double or master in
    if ((getGameSettings.getModeIn == ModeOutIn.Double ||
            getGameSettings.getModeIn == ModeOutIn.Master) &&
        stats.getCurrentPoints == getGameSettings.getPointsOrCustom()) {
      if (btnValueToCheck == '0') {
        return true;
      }

      if (getGameSettings.getModeIn == ModeOutIn.Double) {
        //only enable fields with D
        return getCurrentPointType == PointType.Double ? false : true;
      }

      //only enable fields with D or T
      return getCurrentPointType == PointType.Double ||
              getCurrentPointType == PointType.Tripple
          ? false
          : true;
    }

    //if double or master out
    if ((getGameSettings.getModeOut == ModeOutIn.Double ||
            getGameSettings.getModeOut == ModeOutIn.Master) &&
        (stats.getCurrentPoints - result == 0)) {
      if (getGameSettings.getModeOut == ModeOutIn.Double) {
        //only enable fields with D
        return getCurrentPointType == PointType.Double ? false : true;
      }
      //only enable fields with D or T
      return getCurrentPointType == PointType.Double ||
              getCurrentPointType == PointType.Tripple
          ? false
          : true;
    }

    if (result > stats.getCurrentPoints ||
        noScoresPossible.contains(result) ||
        (stats.getCurrentPoints - result) == 1) {
      return true;
    }

    return false;
  }

  //to determine if points button should be disabled -> e.g current points are 80 -> shouldnt be possible to press any other points buttons -> invalid points
  bool shouldPointBtnBeDisabled(String btnValueToCheck) {
    //todo weird bug -> if solves it -> maybe have a look on it (starting game -> end it with cross -> click any button)
    if (getPlayerGameStatistics.isNotEmpty) {
      PlayerGameStatisticsX01 stats = getCurrentPlayerGameStatistics();

      if (getGameSettings.getInputMethod == InputMethod.Round) {
        return shouldPointBtnBeDisabledRound(btnValueToCheck, stats);
      } else {
        return shouldPointBtnBeDisabledThreeDarts(btnValueToCheck, stats);
      }
    }

    return true;
  }

  void updateCurrentPointsSelected(String newPoints) {
    if (_currentPointsSelected == 'Points') {
      setCurrentPointsSelected = newPoints;
    } else {
      setCurrentPointsSelected = getCurrentPointsSelected + newPoints;
    }
    notifyListeners();
  }

  void updateCurrentThreeDarts(String points) {
    if (getCurrentThreeDarts[0] == 'Dart 1') {
      getCurrentThreeDarts[0] = points;
    } else if (getCurrentThreeDarts[1] == 'Dart 2') {
      getCurrentThreeDarts[1] = points;
    } else if (getCurrentThreeDarts[2] == 'Dart 3') {
      getCurrentThreeDarts[2] = points;
    }
    notifyListeners();
  }

  //deletes one char of the points
  void deleteCurrentPointsSelected() {
    setCurrentPointsSelected = getCurrentPointsSelected.substring(
        0, getCurrentPointsSelected.length - 1);

    if (getCurrentPointsSelected.isEmpty) {
      setCurrentPointsSelected = 'Points';
    }

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
    final PlayerGameStatisticsX01 stats = getCurrentPlayerGameStatistics();

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

  //these stats need to be submitted immediately after input of dart -> to show avg e.g. (only for input method three darts)
  void submitStatsForThreeDartsMode(
      int scoredPoints, String scoredFieldWithPointType) {
    final PlayerGameStatisticsX01 stats = getCurrentPlayerGameStatistics();

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

  //to show the thrown dart immediately in ui (only for input method -> three darts)
  void submitOnlyPointsForThreeDartsMode(
      int scoredPoints, String scoredFieldWithPointType) {
    final PlayerGameStatisticsX01 stats = getCurrentPlayerGameStatistics();

    setRevertPossible = true;

    //set points
    stats.setCurrentPoints = stats.getCurrentPoints - scoredPoints;

    //set all scores per dart
    stats.getAllScoresPerDart.add(scoredPoints);

    submitStatsForThreeDartsMode(scoredPoints, scoredFieldWithPointType);
  }

  //thrownDarts -> selected from checkout dialog (only for input method -> round)
  //checkout count needed in order to revert checkout count
  void submitPoints(String scoredFieldString, BuildContext context,
      [int thrownDarts = 3, checkoutCount = 0]) {
    if (!shouldSubmit(scoredFieldString)) {
      return;
    }

    final PlayerGameStatisticsX01 stats = getCurrentPlayerGameStatistics();
    final int scoredPoints = scoredFieldString == 'Bust'
        ? 0
        : getValueOfSpecificDart(scoredFieldString);

    setRevertPossible = true;

    if (getGameSettings.getInputMethod == InputMethod.ThreeDarts) {
      if (scoredFieldString == 'Bust') submitBusted(stats);

      setAllRemainingScoresPerDart(stats);
    } else {
      stats.setTotalPoints = stats.getTotalPoints + scoredPoints;
      stats.setCurrentPoints = stats.getCurrentPoints - scoredPoints;
    }

    //add delay for last dart for three darts input method
    final int milliseconds =
        getGameSettings.getInputMethod == InputMethod.ThreeDarts &&
                getGameSettings.getAutomaticallySubmitPoints
            ? 800
            : 0;
    Future.delayed(Duration(milliseconds: milliseconds), () {
      stats.setPointsSelectedCount = 0;
      stats.setStartingPoints = stats.getCurrentPoints;
      setCurrentPointsSelected = 'Points';

      if (getGameSettings.getInputMethod == InputMethod.ThreeDarts) {
        setCurrentPointType = PointType.Single;
      } else {
        stats.setCurrentThrownDartsInLeg =
            stats.getCurrentThrownDartsInLeg + thrownDarts;
        stats.setAllThrownDarts = stats.getAllThrownDarts + thrownDarts;

        if (stats.getCurrentThrownDartsInLeg <= 9) {
          stats.setFirstNineAvgPoints =
              stats.getFirstNineAvgPoints + scoredPoints;
          stats.setFirstNineAvgCount = stats.getFirstNineAvgCount + thrownDarts;
        }
      }

      setCheckoutCountAtThrownDarts(stats, checkoutCount);

      final int totalPoints =
          getGameSettings.getInputMethod == InputMethod.Round
              ? scoredPoints
              : int.parse(getCurrentThreeDartsCalculated());

      stats.getAllScores.add(totalPoints);

      if (getGameSettings.getInputMethod == InputMethod.Round) {
        stats.setAllScoresCountForRound = stats.getAllScoresCountForRound + 1;
      }

      setScores(stats, totalPoints);
      legSetOrGameFinished(stats, context, totalPoints, thrownDarts);
      setNextPlayer(stats);

      if (getCurrentThreeDarts[2] != 'Dart 3') {
        resetCurrentThreeDarts();
      }

      notifyListeners();
    });
  }

  bool shouldSubmit(String thrownPoints) {
    if (thrownPoints == 'Bust' ||
        getGameSettings.getInputMethod == InputMethod.Round ||
        (getGameSettings.getInputMethod == InputMethod.ThreeDarts &&
                (getAmountOfDartsThrown() == 3) ||
            finishedLegSetOrGame(getCurrentThreeDartsCalculated()))) {
      return true;
    }
    return false;
  }

  //if player clicks on bust in three darts mode
  void submitBusted(PlayerGameStatisticsX01 stats) {
    final int amountOfThrownDarts = getAmountOfDartsThrown();

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

    getCurrentThreeDarts[0] = '0';
    getCurrentThreeDarts[1] = '0';
    getCurrentThreeDarts[2] = '0';
  }

  void setAllRemainingScoresPerDart(PlayerGameStatisticsX01 stats) {
    List<String> temp = [];

    if (getCurrentThreeDarts[0] != 'Dart 1') {
      temp.add(getCurrentThreeDarts[0]);
    }
    if (getCurrentThreeDarts[1] != 'Dart 2') {
      temp.add(getCurrentThreeDarts[1]);
    }
    if (getCurrentThreeDarts[2] != 'Dart 3') {
      temp.add(getCurrentThreeDarts[2]);
    }

    stats.getAllRemainingScoresPerDart.add(temp);
  }

  void setCheckoutCountAtThrownDarts(
      PlayerGameStatisticsX01 stats, int checkoutCount) {
    if (checkoutCount == 0) {
      return;
    }

    final Tuple3<String, int, int> tuple = Tuple3<String, int, int>(
        getCurrentLegSetAsString(),
        stats.getCurrentThrownDartsInLeg,
        checkoutCount);

    stats.setCheckoutCount = stats.getCheckoutCount + checkoutCount;
    stats.getCheckoutCountAtThrownDarts.add(tuple);
  }

  void setScores(PlayerGameStatisticsX01 stats, int totalPoints) {
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
    final String key = getCurrentLegSetAsString();
    if (stats.getAllScoresPerLeg.containsKey(key)) {
      //add to value list
      stats.getAllScoresPerLeg[key].add(totalPoints);
    } else {
      //create new pair in map
      stats.getAllScoresPerLeg[key] = [totalPoints];
    }
  }

  void legSetOrGameFinished(PlayerGameStatisticsX01 currentStats,
      BuildContext context, int totalPoints, int thrownDarts) {
    if (currentStats.getCurrentPoints != 0) {
      return;
    }

    final String currentLeg = getCurrentLegSetAsString();

    //set thrown darts per leg & reset points
    for (PlayerGameStatisticsX01 stats in getPlayerGameStatistics) {
      stats.getThrownDartsPerLeg[currentLeg] = stats.getCurrentThrownDartsInLeg;
      stats.getAmountOfFinishDarts[currentLeg] = thrownDarts;

      if (currentStats == stats) {
        stats.setDartsForWonLegCount =
            stats.getDartsForWonLegCount + stats.getCurrentThrownDartsInLeg;
        stats.getAllRemainingPoints.add(totalPoints);
      } else {
        stats.getAllRemainingPoints.add(stats.getCurrentPoints);
      }

      stats.setCurrentPoints = getGameSettings.getPointsOrCustom();
      stats.setStartingPoints = stats.getCurrentPoints;
    }

    //add checkout to list
    currentStats.getCheckouts[currentLeg] = totalPoints;

    //update won legs
    currentStats.setLegsWon = currentStats.getLegsWon + 1;
    currentStats.setLegsWonTotal = currentStats.getLegsWonTotal + 1;

    bool isGameFinished = false;
    if (getGameSettings.getSetsEnabled) {
      if (getGameSettings.getLegs == currentStats.getLegsWon) {
        //save leg count of each player -> in case a user wants to revert a set
        for (PlayerGameStatisticsX01 stats in getPlayerGameStatistics) {
          stats.getLegsCount.add(stats.getLegsWon);
        }

        //update won sets
        currentStats.setSetsWon = currentStats.getSetsWon + 1;
      }
    }

    if (isGameWon(currentStats)) {
      sortPlayerStats();
      currentStats.setGameWon = true;
      isGameFinished = true;
    } else if (gameDraw()) {
      currentStats.setGameDraw = true;
      isGameFinished = true;
    }

    if (isGameFinished || currentStats.getGameDraw)
      Navigator.of(context).pushNamed('/finishX01');
    else {
      for (PlayerGameStatisticsX01 stats in getPlayerGameStatistics)
        stats.setCurrentThrownDartsInLeg = 0;
    }

    //set player who will begin next leg
    if (getPlayerLegStartIndex == getGameSettings.getPlayers.length - 1)
      setPlayerLegStartIndex = 0;
    else
      setPlayerLegStartIndex = getPlayerLegStartIndex + 1;

    if (getGameSettings.getInputMethod == InputMethod.ThreeDarts)
      resetCurrentThreeDarts();
  }

  setNextPlayer(PlayerGameStatisticsX01 stats) {
    //case 1 -> input method is round
    //case 2 -> input method is three darts -> 3 darts entered
    //case 3 -> input method is three darts -> 1 or 2 darts entered & finished leg/set/game
    if ((getGameSettings.getInputMethod == InputMethod.Round) ||
        (getGameSettings.getInputMethod == InputMethod.ThreeDarts &&
            (getCurrentThreeDarts[2] != 'Dart 3' ||
                stats.getCurrentPoints ==
                    getGameSettings.getPointsOrCustom()))) {
      final int indexOfCurrentPlayer =
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
    submitPoints('Bust', context);
  }

  void revertPoints() {
    if (!checkIfRevertPossible()) {
      return;
    }

    PlayerGameStatisticsX01 currentStats = getCurrentPlayerGameStatistics();

    bool alreadyReverted = false;
    int lastPoints = 0;
    bool legOrSetReverted = false;
    bool roundCompleted = false; //in order to revert only 1 dart or full round

    if (getGameSettings.getInputMethod == InputMethod.Round ||
        (getGameSettings.getInputMethod == InputMethod.ThreeDarts &&
            getAmountOfDartsThrown() == 0)) {
      roundCompleted = true;

      //set previous player
      final int indexOfCurrentPlayer =
          getGameSettings.getPlayers.indexOf(getCurrentPlayerToThrow);

      if ((indexOfCurrentPlayer - 1) < 0) {
        setCurrentPlayerToThrow = getGameSettings.getPlayers.last;
      } else {
        setCurrentPlayerToThrow =
            getGameSettings.getPlayers[indexOfCurrentPlayer - 1];
      }

      //start player index
      setPlayerLegStartIndex =
          getGameSettings.getPlayers.indexOf(getCurrentPlayerToThrow);

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
              final int amountOfThrownDarts = getAmountOfDartsThrown();
              stats.setCurrentPoints = getValueOfSpecificDart(
                  getCurrentThreeDarts[amountOfThrownDarts - 1]);
              getCurrentThreeDarts[amountOfThrownDarts - 1] =
                  'Dart ' + amountOfThrownDarts.toString();
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
      if (getGameSettings.getInputMethod == InputMethod.Round) {
        lastPoints = currentStats.getAllScores.last;
      } else {
        lastPoints = currentStats.getAllScoresPerDart.last;
      }

      if (getGameSettings.getInputMethod == InputMethod.ThreeDarts) {
        final int amountOfThrownDarts = getAmountOfDartsThrown();
        if (amountOfThrownDarts == 0) {
          setLastThrownDarts(currentStats.getAllRemainingScoresPerDart.last);
          getCurrentThreeDarts[2] = 'Dart 3';
        } else {
          getCurrentThreeDarts[amountOfThrownDarts - 1] =
              'Dart ' + amountOfThrownDarts.toString();
        }
      }

      currentStats.setCurrentPoints =
          currentStats.getCurrentPoints + lastPoints;
    }

    if (alreadyReverted == false) {
      revertStats(currentStats, lastPoints, false, roundCompleted);
    }

    setCurrentPointsSelected = 'Points';
    checkIfRevertPossible(); //if 1 score is left -> enters this if & removes last score -> without this call the revert btn is still highlighted
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
            int.parse(getCurrentThreeDartsCalculated()) + lastScore;
      }

      //thrown darts per leg
      if (stats.getThrownDartsPerLeg.isNotEmpty) {
        String lastKey = stats.getThrownDartsPerLeg.lastKey();
        currentThrownDartsInLeg = stats.getThrownDartsPerLeg[lastKey];
        int? amountOfFinishDarts =
            getGameSettings.getInputMethod == InputMethod.ThreeDarts
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
            getGameSettings.getInputMethod == InputMethod.Round ? 3 : 1;
        stats.setFirstNineAvgCount = stats.getFirstNineAvgCount - amountOfDarts;
      }

      currentThrownDartsInLeg = stats.getCurrentThrownDartsInLeg;
      //thrown darts per leg
      if (getGameSettings.getInputMethod == InputMethod.Round) {
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
        if (tuple.item1 == getCurrentLegSetAsString() &&
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
    if (getGameSettings.getInputMethod == InputMethod.ThreeDarts) {
      stats.setPointsSelectedCount = getAmountOfDartsThrown();
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
      if (getGameSettings.getInputMethod == InputMethod.ThreeDarts) {
        points += int.parse(getCurrentThreeDartsCalculated());
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

  bool isCheckoutPossible() {
    final PlayerGameStatisticsX01 stats = getCurrentPlayerGameStatistics();
    final String currentThreeDartsCalculated = getCurrentThreeDartsCalculated();

    int points = stats.getCurrentPoints;
    if (getGameSettings.getInputMethod == InputMethod.ThreeDarts) {
      points += int.parse(currentThreeDartsCalculated);
    }

    if (points <= 170 && !bogeyNumbers.contains(points)) {
      return true;
    }

    return false;
  }

  //returns 0, 1, 2, 3 or -1
  int getAmountOfCheckoutPossibilities(String scoredPointsString) {
    final int thrownPoints = int.parse(scoredPointsString);

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
    final PlayerGameStatisticsX01 stats = getCurrentPlayerGameStatistics();
    final int currentPoints = stats.getCurrentPoints;
    final int result = currentPoints - thrownPoints;

    //double out
    if (getGameSettings.getModeOut == ModeOutIn.Double) {
      if (isDoubleField(currentPoints.toString())) {
        return 3;
      } else if (result <= 50 && thrownPoints <= 60) {
        return 2;
      } else if (result <= 50 && thrownPoints > 60) {
        if (possibleTwoDartFinish(thrownPoints)) {
          return 2;
        }
        return 1;
      }
    }

    return -1;
  }

  //determine if its possible to score with 1 dart in order to leave a double field -> 2 darts on double instead of 1
  bool possibleTwoDartFinish(int thrownPoints) {
    for (int i = 20; i > 0; i--) {
      int tripple = i * 3;
      int result = thrownPoints - tripple;
      if (isDoubleField(result.toString())) {
        return true;
      }
    }
    return false;
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
    final int thrownPoints = int.parse(thrownPointsString);

    //these checkouts are possible with 3 darts & additionally with 2 darts (cause of bull)
    if (threeDartFinishesWithBull.contains(thrownPoints)) {
      return false;
    }

    final PlayerGameStatisticsX01 stats = getCurrentPlayerGameStatistics();
    int currentPoints = stats.getCurrentPoints;
    if (getGameSettings.getInputMethod == InputMethod.ThreeDarts) {
      currentPoints = stats.getStartingPoints;
    }

    //99 = special case
    if ((thrownPoints > 100 || thrownPoints == 99) &&
        (currentPoints - thrownPoints == 0)) {
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

  bool isSingleField(String pointsString) {
    final int points = int.parse(pointsString);

    if (points > 0 && points <= 20) {
      return true;
    }

    return false;
  }

  bool isDoubleField(String pointsString) {
    final int points = int.parse(pointsString);

    if (((points <= 40 && points % 2 == 0) || points == 50) && points != 0) {
      return true;
    }

    return false;
  }

  bool isTrippleField(int points) {
    if (points <= 60 && points % 3 == 0) {
      return true;
    }

    return false;
  }

  bool areInvalidDoubleInPoints(String pointsSelected) {
    if (pointsSelected == '1' ||
        pointsSelected == '3' ||
        pointsSelected == '5') {
      return true;
    }

    return false;
  }

  bool _gameWonFirstToWithSets(PlayerGameStatisticsX01 stats) {
    return getGameSettings.getMode == BestOfOrFirstToEnum.FirstTo &&
        getGameSettings.getSetsEnabled &&
        getGameSettings.getSets == stats.getSetsWon;
  }

  bool _gameWonFirstToWithLegs(PlayerGameStatisticsX01 stats) {
    return getGameSettings.getMode == BestOfOrFirstToEnum.FirstTo &&
        stats.getLegsWon >= getGameSettings.getLegs;
  }

  bool _gameWonBestOfWithSets(PlayerGameStatisticsX01 stats) {
    return getGameSettings.getMode == BestOfOrFirstToEnum.BestOf &&
        getGameSettings.getSetsEnabled &&
        ((stats.getSetsWon * 2) - 1) == getGameSettings.getSets;
  }

  bool _gameWonBestOfWithLegs(PlayerGameStatisticsX01 stats) {
    return getGameSettings.getMode == BestOfOrFirstToEnum.BestOf &&
        ((stats.getLegsWon * 2) - 1) == getGameSettings.getLegs;
  }

  bool gameDraw() {
    for (PlayerGameStatisticsX01 stats in getPlayerGameStatistics) {
      if (getGameSettings.getSetsEnabled &&
          !(stats.getSetsWon == (getGameSettings.getSets / 2))) {
        return false;
      } else if (!getGameSettings.getSetsEnabled &&
          !(stats.getLegsWon == (getGameSettings.getLegs / 2))) {
        return false;
      }
    }
    return true;
  }

  bool isGameWon(PlayerGameStatisticsX01 stats) {
    if (getReachedSuddenDeath) {
      return true;
    }

    if (_gameWonFirstToWithSets(stats) ||
        _gameWonBestOfWithSets(stats) ||
        _gameWonBestOfWithLegs(stats)) {
      return true;
    } else if (_gameWonFirstToWithLegs(stats)) {
      if (!getGameSettings.getWinByTwoLegsDifference) {
        return true;
      }

      //suddean death reached
      if (getGameSettings.getSuddenDeath && reachedSuddenDeath()) {
        setReachedSuddenDeath = true;
      }

      if (isLegDifferenceAtLeastTwo(stats)) {
        return true;
      }
    }

    return false;
  }

  //for win by two legs diff -> checks if leg won difference is at least 2 at each player -> return true (valid win)
  bool isLegDifferenceAtLeastTwo(PlayerGameStatisticsX01 playerToCheck) {
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
  int getCurrentLeg() {
    int result = 1;

    for (PlayerGameStatisticsX01 stats in getPlayerGameStatistics)
      result += stats.getLegsWon;

    return result;
  }

  //needed to set all scores per leg
  int getCurrentSet() {
    int result = 1;
    for (PlayerGameStatisticsX01 stats in getPlayerGameStatistics)
      result += stats.getSetsWon;

    return result;
  }

  //needed for allScoresPerLeg + CheckoutCountAtThrownDarts
  //returns e.g. 'Leg 1' or 'Set 1 Leg 2'
  String getCurrentLegSetAsString() {
    final int currentLeg = getCurrentLeg();
    int currentSet = -1;
    String key = '';

    if (getGameSettings.getSetsEnabled) {
      currentSet = getCurrentSet();
      key += 'Set ' + currentSet.toString() + ' - ';
    }
    key += 'Leg ' + currentLeg.toString();

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

  void resetCurrentThreeDarts() {
    getCurrentThreeDarts[0] = 'Dart 1';
    getCurrentThreeDarts[1] = 'Dart 2';
    getCurrentThreeDarts[2] = 'Dart 3';
  }

  int getAmountOfDartsThrown() {
    int count = 0;

    if (getCurrentThreeDarts[0] != 'Dart 1') {
      count++;
    }
    if (getCurrentThreeDarts[1] != 'Dart 2') {
      count++;
    }
    if (getCurrentThreeDarts[2] != 'Dart 3') {
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

  List<String> getAllLegSetStringsExceptCurrentOne() {
    List<String> result = [];
    String currentSetLegString = getCurrentLegSetAsString();

    for (String key in getPlayerGameStatistics[0].getAllScoresPerLeg.keys) {
      if (key != currentSetLegString) {
        result.add(key);
      }
    }

    return result;
  }

  String getLastDartThrown() {
    for (int i = 0; i < getCurrentThreeDarts.length; i++) {
      if (getCurrentThreeDarts[i].contains('Dart')) {
        if (i == 0) {
          return getCurrentThreeDarts[0];
        }
        return getCurrentThreeDarts[i - 1];
      }
    }

    return getCurrentThreeDarts[2];
  }
}
