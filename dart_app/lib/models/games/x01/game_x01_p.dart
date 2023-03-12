import 'dart:collection';

import 'package:dart_app/constants.dart';
import 'package:dart_app/models/bot.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats_x01.dart';
import 'package:dart_app/models/team.dart';
import 'package:dart_app/screens/game_modes/shared/game/point_btns_three_darts/utils_point_btns_three_darts.dart';
import 'package:dart_app/utils/globals.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameX01_P extends Game_P {
  GameX01_P() : super(dateTime: DateTime.now(), name: 'X01');

  String _currentPointsSelected = 'Points';
  int _playerOrTeamLegStartIndex =
      0; //to determine which player/team should begin next leg
  bool _revertPossible = false;
  bool _init = false;
  bool _reachedSuddenDeath = false;
  PointType _currentPointType =
      PointType.Single; //only for input type -> three darts
  bool _canBePressed =
      true; //only for input type -> three darts + automatically submit points (to disable buttons when delay is active)
  bool _areTeamStatsDisplayed =
      true; // only for team mode -> to determine if team or player stats should be displayed in game stats
  Map<String, List<String>> _currentPlayerOfTeamsBeforeLegFinish =
      {}; // for reverting -> save current player whose turn it was before leg was finished for each team (e.g.: Leg 1; 'Strainski', 'a')
  Map<String, String> _setLegWithPlayerOrTeamWhoFinishedIt =
      {}; // for reverting -> to set correct previous player/team
  bool botSubmittedPoints =
      false; // bug when playing against bot -> ending game -> starting new one (index for listview builder is not able to use)

  factory GameX01_P.createGame(Game_P? game) {
    GameX01_P gameX01 = new GameX01_P();

    gameX01.setDateTime = game!.getDateTime;
    gameX01.setGameId = game.getGameId;
    gameX01.setGameSettings = game.getGameSettings;
    gameX01.setPlayerGameStatistics = game.getPlayerGameStatistics;
    gameX01.setTeamGameStatistics = game.getTeamGameStatistics;
    gameX01.setCurrentPlayerToThrow = game.getCurrentPlayerToThrow;
    gameX01.setCurrentTeamToThrow = game.getCurrentTeamToThrow;
    gameX01.setIsGameFinished = game.getIsGameFinished;
    gameX01.setIsOpenGame = game.getIsOpenGame;
    gameX01.setIsFavouriteGame = game.getIsFavouriteGame;

    return gameX01;
  }

  factory GameX01_P.fromMapX01(map, mode, gameId, openGame) {
    final Game_P game = Game_P.fromMap(map, mode, gameId, openGame);

    GameX01_P gameX01 = new GameX01_P();
    gameX01.setGameId = game.getGameId;
    gameX01.setName = game.getName;
    gameX01.setIsGameFinished = game.getIsGameFinished;
    gameX01.setIsOpenGame = game.getIsOpenGame;
    gameX01.setIsFavouriteGame = game.getIsFavouriteGame;
    gameX01.setDateTime = game.getDateTime;
    gameX01.setGameSettings = game.getGameSettings;
    gameX01.setRevertPossible = game.getRevertPossible;
    gameX01.setCurrentPlayerToThrow = game.getCurrentPlayerToThrow;
    gameX01.setCurrentTeamToThrow = game.getCurrentTeamToThrow;
    gameX01.setPlayerGameStatistics = game.getPlayerGameStatistics;
    gameX01.setTeamGameStatistics = game.getTeamGameStatistics;
    gameX01.setCurrentThreeDarts = game.getCurrentThreeDarts;
    gameX01.setPlayerOrTeamLegStartIndex = map['playerOrTeamLegStartIndex'];
    gameX01.setReachedSuddenDeath = map['reachedSuddenDeath'];
    gameX01.setCurrentPlayerOfTeamsBeforeLegFinish =
        map['currentPlayerOfTeamsBeforeLegFinish'] != null
            ? SplayTreeMap<String, List<dynamic>>.from(
                    map['currentPlayerOfTeamsBeforeLegFinish'])
                .map((key, value) => MapEntry(key, value.cast<String>()))
            : new SplayTreeMap();
    gameX01.setLegSetWithPlayerOrTeamWhoFinishedIt =
        map['legSetWithPlayerOrTeamWhoFinishedIt'] != null
            ? Map<String, String>.from(
                map['legSetWithPlayerOrTeamWhoFinishedIt'])
            : {};

    return gameX01;
  }

  /************************************************************/
  /********              GETTER & SETTER               ********/
  /************************************************************/

  String get getCurrentPointsSelected => this._currentPointsSelected;
  set setCurrentPointsSelected(String currentPointsSelected) =>
      this._currentPointsSelected = currentPointsSelected;

  int get getPlayerOrTeamLegStartIndex => this._playerOrTeamLegStartIndex;
  set setPlayerOrTeamLegStartIndex(int playerOrTeamLegStartIndex) =>
      this._playerOrTeamLegStartIndex = playerOrTeamLegStartIndex;

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

  bool get getCanBePressed => this._canBePressed;
  set setCanBePressed(bool canBePressed) {
    this._canBePressed = canBePressed;
  }

  bool get getAreTeamStatsDisplayed => this._areTeamStatsDisplayed;
  set setAreTeamStatsDisplayed(bool value) =>
      this._areTeamStatsDisplayed = value;

  Map<String, List<String>> get getCurrentPlayerOfTeamsBeforeLegFinish =>
      this._currentPlayerOfTeamsBeforeLegFinish;
  set setCurrentPlayerOfTeamsBeforeLegFinish(Map<String, List<String>> value) =>
      this._currentPlayerOfTeamsBeforeLegFinish = value;

  Map<String, String> get getLegSetWithPlayerOrTeamWhoFinishedIt =>
      this._setLegWithPlayerOrTeamWhoFinishedIt;
  set setLegSetWithPlayerOrTeamWhoFinishedIt(Map<String, String> value) =>
      this._setLegWithPlayerOrTeamWhoFinishedIt = value;

  bool get getBotSubmittedPoints => this.botSubmittedPoints;
  set setBotSubmittedPoints(bool botSubmittedPoints) =>
      this.botSubmittedPoints = botSubmittedPoints;

  /************************************************************/
  /********                 METHDODS                   ********/
  /************************************************************/

  reset() {
    setCurrentPointsSelected = 'Points';
    setPlayerOrTeamLegStartIndex = 0;
    setInit = false;
    setReachedSuddenDeath = false;
    setCurrentPointType = PointType.Single;
    UtilsPointBtnsThreeDarts.resetCurrentThreeDarts(getCurrentThreeDarts);
    setCanBePressed = true;
    setAreTeamStatsDisplayed = true;
    setCurrentPlayerOfTeamsBeforeLegFinish = {};
    setLegSetWithPlayerOrTeamWhoFinishedIt = {};
    setBotSubmittedPoints = false;

    setGameId = '';
    setPlayerGameStatistics = [];
    setTeamGameStatistics = [];
    setCurrentPlayerToThrow = null;
    setCurrentTeamToThrow = null;
    setIsOpenGame = false;
    setIsGameFinished = false;
    setIsFavouriteGame = false;
    setRevertPossible = false;
    setCurrentThreeDarts = ['Dart 1', 'Dart 2', 'Dart 3'];
    setShowLoadingSpinner = false;

    g_average = '-';
    g_last_throw = '-';
    g_thrown_darts = '-';
  }

  //to determine if points button should be disabled -> e.g current points are 80 -> shouldnt be possible to press any other points buttons -> invalid points
  bool shouldPointBtnBeDisabled(String btnValueToCheck) {
    //todo weird bug -> if solves it -> maybe have a look on it (starting game -> end it with cross -> click any button)
    if (getPlayerGameStatistics.isNotEmpty) {
      PlayerOrTeamGameStatsX01 stats = getCurrentPlayerGameStats();

      if (getGameSettings.getInputMethod == InputMethod.Round) {
        return _shouldPointBtnBeDisabledRound(btnValueToCheck, stats);
      } else {
        return _shouldPointBtnBeDisabledThreeDarts(btnValueToCheck, stats);
      }
    }

    return true;
  }

  PlayerOrTeamGameStatsX01 getCurrentPlayerGameStats() {
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

  PlayerOrTeamGameStatsX01 getCurrentTeamGameStats() {
    return getTeamGameStatistics.firstWhere(
        (stats) => stats.getTeam.getName == getCurrentTeamToThrow.getName);
  }

  bool isCheckoutPossible() {
    final PlayerOrTeamGameStatsX01 stats = getCurrentPlayerGameStats();
    final String currentThreeDartsCalculated =
        Utils.getCurrentThreeDartsCalculated(getCurrentThreeDarts);

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

  //for checkout counting dialog -> to show the amount of darts for finising the leg, set or game -> in order to calc average correctly
  bool finishedLegSetOrGame(String scoredPoints) {
    final PlayerOrTeamGameStatsX01 currentStats = getCurrentPlayerGameStats();

    if (getGameSettings.getInputMethod == InputMethod.ThreeDarts) {
      if (currentStats.getCurrentPoints == 0) {
        return true;
      }
      return false;
    }

    int currentPoints = currentStats.getCurrentPoints - int.parse(scoredPoints);
    if (currentPoints == 0) {
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

    final PlayerOrTeamGameStatsX01 stats = getCurrentPlayerGameStats();
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
  String getCurrentSetLegAsString(
      GameX01_P gameX01, GameSettingsX01_P gameSettingsX01) {
    final int currentLeg = _getCurrentLeg(gameX01, gameSettingsX01);

    int currentSet = -1;
    String key = '';

    if (gameSettingsX01.getSetsEnabled) {
      currentSet = _getCurrentSet(gameX01, gameSettingsX01);
      key += 'Set ' + currentSet.toString() + ' - ';
    }
    key += 'Leg ' + currentLeg.toString();

    return key;
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

  List<String> getAllLegSetStringsExceptCurrentOne(
      GameX01_P gameX01, GameSettingsX01_P gameSettingsX01) {
    final String currentSetLegString =
        getCurrentSetLegAsString(gameX01, gameSettingsX01);

    List<String> result = [];
    for (String key in Utils.getPlayersOrTeamStatsListStatsScreen(
            gameX01, gameSettingsX01)[0]
        .getAllScoresPerLeg
        .keys) {
      if (key != currentSetLegString) result.add(key);
    }

    return result;
  }

  /************************************************************/
  /********              PRIVATE METHODS               ********/
  /************************************************************/

  bool _shouldPointBtnBeDisabledRound(
      String btnValueToCheck, PlayerOrTeamGameStatsX01 stats) {
    // DOUBLE IN
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

    if (getCurrentPointsSelected == 'Points' &&
        getGameSettings.getInputMethod == InputMethod.Round) {
      if (btnValueToCheck == '0' ||
          int.parse(btnValueToCheck) > stats.getCurrentPoints) {
        return true;
      }
    } else {
      final int result = btnValueToCheck == 'Bull'
          ? int.parse(getCurrentPointsSelected)
          : int.parse(getCurrentPointsSelected + btnValueToCheck);

      if (result > 180 ||
          result > stats.getCurrentPoints ||
          NO_SCORES_POSSIBLE.contains(result) ||
          stats.getCurrentPoints - result == 1) {
        return true;
      }

      // double out (prevent from finishing with 171, 174, 180)
      if (getGameSettings.getModeOut == ModeOutIn.Double) {
        if (result >= 171 && stats.getCurrentPoints <= 180) {
          return true;
        }
      }
    }

    return false;
  }

  bool _shouldPointBtnBeDisabledThreeDarts(
      String btnValueToCheck, PlayerOrTeamGameStatsX01 stats) {
    if (stats.getCurrentPoints == 0) {
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
      if (btnValueToCheck == 'Bull') {
        return false;
      }

      if (btnValueToCheck == '0' || btnValueToCheck == '25') {
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
        //only enable fields with D and bull
        return (getCurrentPointType == PointType.Double ||
                btnValueToCheck == 'Bull')
            ? false
            : true;
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
    final PlayerOrTeamGameStatsX01 stats = getCurrentPlayerGameStats();

    int currentPoints = stats.getStartingPoints;
    int doubleCount = 0;

    //check at which dart currentPoints were on a double field -> increment counter
    for (String point in getCurrentThreeDarts) {
      if (isDoubleField(currentPoints.toString())) {
        doubleCount++;
      }
      currentPoints -= Utils.getValueOfSpecificDart(point);
    }

    if (doubleCount == 0) {
      return -1;
    }
    return doubleCount;
  }

  int _getAmountOfCheckoutPossibilitiesForInputMethodRound(int thrownPoints) {
    final PlayerOrTeamGameStatsX01 stats = getCurrentPlayerGameStats();
    final int currentPoints = stats.getCurrentPoints;
    final int result = currentPoints - thrownPoints;

    // double out
    if (getGameSettings.getModeOut == ModeOutIn.Double) {
      if (isDoubleField(currentPoints.toString())) {
        return 3;
      } else if (result <= 50 && thrownPoints <= 60) {
        return 2;
      } else if (result <= 50 && thrownPoints > 60) {
        return 1;
      }
    }

    return -1;
  }

  //needed to set all scores per leg
  int _getCurrentLeg(GameX01_P gameX01, GameSettingsX01_P gameSettingsX01) {
    int result = 1;

    if (gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Single) {
      for (PlayerOrTeamGameStatsX01 stats in this.getPlayerGameStatistics) {
        result += stats.getLegsWon;
      }
    } else {
      for (PlayerOrTeamGameStatsX01 stats in this.getTeamGameStatistics) {
        result += stats.getLegsWon;
      }

      return result;
    }

    return result;
  }

  //needed to set all scores per leg
  int _getCurrentSet(GameX01_P gameX01, GameSettingsX01_P gameSettingsX01) {
    int result = 1;

    for (PlayerOrTeamGameStatsX01 stats
        in Utils.getPlayersOrTeamStatsListStatsScreen(gameX01, gameSettingsX01))
      result += stats.getSetsWon;

    return result;
  }

  PlayerOrTeamGameStatsX01 getPlayerGameStats(
      PlayerOrTeamGameStatsX01? statsToFind) {
    late PlayerOrTeamGameStatsX01 result;

    for (PlayerOrTeamGameStatsX01 playerStats in this.getPlayerGameStatistics) {
      if (playerStats == statsToFind) result = playerStats;
    }

    return result;
  }

  PlayerOrTeamGameStatsX01 getTeamStatsFromPlayer(String playerName) {
    late PlayerOrTeamGameStatsX01 result;

    for (PlayerOrTeamGameStatsX01 teamStats in this.getTeamGameStatistics) {
      for (Player player in teamStats.getTeam.getPlayers) {
        if (player.getName == playerName) result = teamStats;
      }
    }

    return result;
  }

  dynamic getPlayerStatsFromCurrentTeamToThrow(
      GameX01_P gameX01, GameSettingsX01_P gameSettingsX01) {
    List<PlayerOrTeamGameStatsX01> result = [];

    for (PlayerOrTeamGameStatsX01 stats in gameX01.getPlayerGameStatistics) {
      final Team teamOfPlayer = gameSettingsX01.findTeamForPlayer(
          stats.getPlayer.getName, gameSettingsX01);

      if (teamOfPlayer.getName == gameX01.getCurrentTeamToThrow.getName) {
        result.add(stats);
      }
    }

    return result;
  }

  bool isGameDraw(BuildContext context) {
    for (PlayerOrTeamGameStatsX01 stats in Utils.getPlayersOrTeamStatsList(
        context.read<GameX01_P>(), context.read<GameSettingsX01_P>())) {
      if (stats.getGameDraw) {
        return true;
      }
    }
    return false;
  }

  //for win by two legs diff -> checks if leg won difference is at least 2 at each player -> return true (valid win)
  bool isLegDifferenceAtLeastTwo(PlayerOrTeamGameStatsX01 playerToCheck,
      GameX01_P gameX01, GameSettingsX01_P gameSettingsX01) {
    for (PlayerOrTeamGameStatsX01 stats
        in Utils.getPlayersOrTeamStatsList(gameX01, gameSettingsX01)) {
      if (stats != playerToCheck &&
          (playerToCheck.getLegsWon - 2) < stats.getLegsWon) {
        return false;
      }
    }

    return true;
  }
}
