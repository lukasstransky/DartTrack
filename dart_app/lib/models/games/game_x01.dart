import 'package:dart_app/constants.dart';
import 'package:dart_app/models/bot.dart';
import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/models/player_statistics/player_game_statistics_x01.dart';

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

  //gets called when user goes back to settings from game screen
  reset() {
    setCurrentPointsSelected = 'Points';
    setPlayerLegStartIndex = 0;
    setRevertPossible = false;
    setPlayerGameStatistics = [];
    setInit = false;
    setReachedSuddenDeath = false;
    setCurrentPlayerToThrow = null;
    resetCurrentThreeDarts();
  }

  //to determine if points button should be disabled -> e.g current points are 80 -> shouldnt be possible to press any other points buttons -> invalid points
  bool shouldPointBtnBeDisabled(String btnValueToCheck) {
    //todo weird bug -> if solves it -> maybe have a look on it (starting game -> end it with cross -> click any button)
    if (getPlayerGameStatistics.isNotEmpty) {
      PlayerGameStatisticsX01 stats = getCurrentPlayerGameStatistics();

      if (getGameSettings.getInputMethod == InputMethod.Round) {
        return _shouldPointBtnBeDisabledRound(btnValueToCheck, stats);
      } else {
        return _shouldPointBtnBeDisabledThreeDarts(btnValueToCheck, stats);
      }
    }

    return true;
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

  bool isCheckoutPossible() {
    final PlayerGameStatisticsX01 stats = getCurrentPlayerGameStatistics();
    final String currentThreeDartsCalculated = getCurrentThreeDartsCalculated();

    int points = stats.getCurrentPoints;
    if (getGameSettings.getInputMethod == InputMethod.ThreeDarts) {
      points += int.parse(currentThreeDartsCalculated);
    }

    if (points <= 170 && !BOGEY_NUMBERS.contains(points)) {
      return true;
    }

    return false;
  }

  //returns 0, 1, 2, 3 or -1
  int getAmountOfCheckoutPossibilities(String scoredPointsString) {
    final int thrownPoints = int.parse(scoredPointsString);

    if (getGameSettings.getInputMethod == InputMethod.ThreeDarts) {
      return _getAmountOfCheckoutPossibilitiesForInputMethodThreeDarts(
          thrownPoints);
    }

    return _getAmountOfCheckoutPossibilitiesForInputMethodRound(thrownPoints);
  }

  notify() {
    notifyListeners();
  }

  //for checkout counting dialog -> to show the amount of darts for finising the leg, set or game -> in order to calc average correctly
  bool finishedLegSetOrGame(String points) {
    final PlayerGameStatisticsX01 stats = getCurrentPlayerGameStatistics();

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
    if (THREE_DART_FINISHES_WITH_BULL.contains(thrownPoints)) {
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

  //needed for allScoresPerLeg + CheckoutCountAtThrownDarts
  //returns e.g. 'Leg 1' or 'Set 1 Leg 2'
  String getCurrentLegSetAsString() {
    final int currentLeg = _getCurrentLeg();
    int currentSet = -1;
    String key = '';

    if (getGameSettings.getSetsEnabled) {
      currentSet = _getCurrentSet();
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

  resetCurrentThreeDarts() {
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

  List<String> getAllLegSetStringsExceptCurrentOne() {
    final String currentSetLegString = getCurrentLegSetAsString();
    List<String> result = [];

    for (String key in getPlayerGameStatistics[0].getAllScoresPerLeg.keys) {
      if (key != currentSetLegString) {
        result.add(key);
      }
    }

    return result;
  }

  /************************************************************/
  /********              PRIVATE METHODS               ********/
  /************************************************************/

  bool _shouldPointBtnBeDisabledRound(
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
          NO_SCORES_POSSIBLE.contains(result) ||
          stats.getCurrentPoints - result == 1) {
        return true;
      }
    }

    return false;
  }

  bool _shouldPointBtnBeDisabledThreeDarts(
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
        NO_SCORES_POSSIBLE.contains(result) ||
        (stats.getCurrentPoints - result) == 1) {
      return true;
    }

    return false;
  }

  //differs to round mode
  //e.g. 60 points remaining -> S20, D20 -> only 1 dart on double possible -> dont show 2 as with round mode
  int _getAmountOfCheckoutPossibilitiesForInputMethodThreeDarts(
      int thrownPoints) {
    final PlayerGameStatisticsX01 stats = getCurrentPlayerGameStatistics();

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

  int _getAmountOfCheckoutPossibilitiesForInputMethodRound(int thrownPoints) {
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
        if (_possibleTwoDartFinish(thrownPoints)) {
          return 2;
        }
        return 1;
      }
    }

    return -1;
  }

  //determine if its possible to score with 1 dart in order to leave a double field -> 2 darts on double instead of 1
  bool _possibleTwoDartFinish(int thrownPoints) {
    for (int i = 20; i > 0; i--) {
      final int tripple = i * 3;
      final int result = thrownPoints - tripple;

      if (isDoubleField(result.toString())) {
        return true;
      }
    }
    return false;
  }

  //needed to set all scores per leg
  int _getCurrentLeg() {
    int result = 1;

    for (PlayerGameStatisticsX01 stats in getPlayerGameStatistics)
      result += stats.getLegsWon;

    return result;
  }

  //needed to set all scores per leg
  int _getCurrentSet() {
    int result = 1;

    for (PlayerGameStatisticsX01 stats in getPlayerGameStatistics)
      result += stats.getSetsWon;

    return result;
  }
}
