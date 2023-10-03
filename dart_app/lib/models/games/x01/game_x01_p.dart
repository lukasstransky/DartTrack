import 'package:dart_app/constants.dart';
import 'package:dart_app/models/bot.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/game_settings/x01/helper/sudden_death_starter.dart';
import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats_x01.dart';
import 'package:dart_app/models/team.dart';
import 'package:dart_app/screens/game_modes/shared/game/point_btns_three_darts/utils_point_btns_three_darts.dart';
import 'package:dart_app/utils/globals.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';

class GameX01_P extends Game_P {
  GameX01_P() : super(dateTime: DateTime.now(), name: GameMode.X01.name);

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
  List<List<String>> _currentPlayerOfTeamsBeforeLegFinish =
      []; // for reverting -> save current player whose turn it was before leg was finished for each team (e.g.: Leg 1; 'Strainski', 'a')
  bool botSubmittedPoints = false;
  SuddenDeathStarter?
      suddenDeathStarter; // only needed for reverting sudden death from finish screen

  factory GameX01_P.fromMapX01(
      dynamic map, GameMode mode, String gameId, bool openGame) {
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
            ? Utils.convertSimpleListBackToDoubleList(
                map['currentPlayerOfTeamsBeforeLegFinish'])
            : [];
    gameX01.setLegSetWithPlayerOrTeamWhoFinishedIt =
        map['legSetWithPlayerOrTeamWhoFinishedIt'] != null
            ? map['legSetWithPlayerOrTeamWhoFinishedIt'].cast<String>()
            : {};

    return gameX01;
  } // bug when playing against bot -> ending game -> starting new one (index for listview builder is not able to use)

  factory GameX01_P.createGame(Game_P? game) {
    GameX01_P gameX01 = new GameX01_P();

    gameX01.setDateTime = game!.getDateTime;
    gameX01.setName = game.getName;
    gameX01.setGameId = game.getGameId;
    gameX01.setGameSettings = game.getGameSettings;
    gameX01.setPlayerGameStatistics = game.getPlayerGameStatistics;
    gameX01.setTeamGameStatistics = game.getTeamGameStatistics;
    gameX01.setCurrentPlayerToThrow = game.getCurrentPlayerToThrow;
    gameX01.setCurrentTeamToThrow = game.getCurrentTeamToThrow;
    gameX01.setIsGameFinished = game.getIsGameFinished;
    gameX01.setIsOpenGame = game.getIsOpenGame;
    gameX01.setIsFavouriteGame = game.getIsFavouriteGame;
    gameX01.setLegSetWithPlayerOrTeamWhoFinishedIt =
        game.getLegSetWithPlayerOrTeamWhoFinishedIt;

    return gameX01;
  }

  /************************************************************/
  /********              GETTER & SETTER               ********/
  /// *********************************************************

  String get getCurrentPointsSelected => _currentPointsSelected;
  set setCurrentPointsSelected(String currentPointsSelected) =>
      _currentPointsSelected = currentPointsSelected;

  int get getPlayerOrTeamLegStartIndex => _playerOrTeamLegStartIndex;
  set setPlayerOrTeamLegStartIndex(int playerOrTeamLegStartIndex) =>
      _playerOrTeamLegStartIndex = playerOrTeamLegStartIndex;

  @override
  bool get getRevertPossible => _revertPossible;
  @override
  set setRevertPossible(bool revertPossible) =>
      _revertPossible = revertPossible;

  bool get getInit => _init;
  set setInit(bool init) => _init = init;

  bool get getReachedSuddenDeath => _reachedSuddenDeath;
  set setReachedSuddenDeath(bool reachedSuddenDeath) =>
      _reachedSuddenDeath = reachedSuddenDeath;

  PointType get getCurrentPointType => _currentPointType;
  set setCurrentPointType(PointType currentPointType) => {
        _currentPointType = currentPointType,
      };

  bool get getCanBePressed => _canBePressed;
  set setCanBePressed(bool canBePressed) {
    _canBePressed = canBePressed;
  }

  bool get getAreTeamStatsDisplayed => _areTeamStatsDisplayed;
  set setAreTeamStatsDisplayed(bool value) => _areTeamStatsDisplayed = value;

  List<List<String>> get getCurrentPlayerOfTeamsBeforeLegFinish =>
      _currentPlayerOfTeamsBeforeLegFinish;
  set setCurrentPlayerOfTeamsBeforeLegFinish(List<List<String>> value) =>
      _currentPlayerOfTeamsBeforeLegFinish = value;

  bool get getBotSubmittedPoints => botSubmittedPoints;
  set setBotSubmittedPoints(bool botSubmittedPoints) =>
      this.botSubmittedPoints = botSubmittedPoints;

  SuddenDeathStarter? get getSuddenDeathStarter => this.suddenDeathStarter;
  set setSuddenDeathStarter(SuddenDeathStarter? suddenDeathStarter) =>
      this.suddenDeathStarter = suddenDeathStarter;

  /************************************************************/
  /********                 METHDODS                   ********/
  /// *********************************************************

  reset() {
    setCurrentPointsSelected = 'Points';
    setPlayerOrTeamLegStartIndex = 0;
    setRevertPossible = false;
    setInit = false;
    setReachedSuddenDeath = false;
    setCurrentPointType = PointType.Single;
    setCanBePressed = true;
    setAreTeamStatsDisplayed = true;
    setCurrentPlayerOfTeamsBeforeLegFinish = [];
    setBotSubmittedPoints = false;
    suddenDeathStarter = null;

    setGameId = '';
    setDateTime = DateTime.now();
    setPlayerGameStatistics = [];
    setTeamGameStatistics = [];
    setCurrentPlayerToThrow = null;
    setCurrentTeamToThrow = null;
    setIsOpenGame = false;
    setIsGameFinished = false;
    setIsFavouriteGame = false;
    setRevertPossible = false;
    UtilsPointBtnsThreeDarts.resetCurrentThreeDarts(getCurrentThreeDarts);
    setShowLoadingSpinner = false;
    setLegSetWithPlayerOrTeamWhoFinishedIt = [];
    setSafeAreaPadding = EdgeInsets.zero;

    g_average = '-';
    g_last_throw = '-';
    g_thrown_darts = '-';
  }

  init(GameSettingsX01_P gameSettings) {
    reset();

    setGameSettings = gameSettings;
    setPlayerGameStatistics = [];

    if (gameSettings.getSingleOrTeam == SingleOrTeamEnum.Single) {
      setCurrentPlayerToThrow = gameSettings.getPlayers.first;
    } else {
      setCurrentTeamToThrow = gameSettings.getTeams.first;

      // reverse players in teams
      for (Team team in gameSettings.getTeams) {
        team.setPlayers = team.getPlayers.reversed.toList();
      }
      // set players in correct order
      List<Player> players = [];
      for (Team team in gameSettings.getTeams) {
        for (Player player in team.getPlayers) {
          players.add(player);
        }
      }
      gameSettings.setPlayers = players;

      setCurrentPlayerToThrow = gameSettings.getTeams.first.getPlayers.first;
    }

    setInit = true;
    final int points = gameSettings.getPointsOrCustom();

    for (Player player in gameSettings.getPlayers) {
      getPlayerGameStatistics.add(
        new PlayerOrTeamGameStatsX01(
          mode: GameMode.X01.name,
          player: player,
          currentPoints: points,
          dateTime: getDateTime,
        ),
      );
    }

    if (gameSettings.getSingleOrTeam == SingleOrTeamEnum.Team) {
      for (Team team in gameSettings.getTeams) {
        getTeamGameStatistics.add(
          new PlayerOrTeamGameStatsX01.Team(
            team: team,
            mode: GameMode.X01.name,
            currentPoints: points,
            dateTime: getDateTime,
          ),
        );
        team.setCurrentPlayerToThrow = team.getPlayers.first;
      }

      for (PlayerOrTeamGameStats teamStats in getTeamGameStatistics) {
        teamStats.getTeam.setCurrentPlayerToThrow =
            teamStats.getTeam.getPlayers.first;
      }

      // set team for player stats in order to sort them
      for (PlayerOrTeamGameStats playerStats in getPlayerGameStatistics) {
        final Team team =
            gameSettings.findTeamForPlayer(playerStats.getPlayer.getName);
        playerStats.setTeam = team;
      }

      getPlayerGameStatistics.sort((a, b) =>
          (a.getTeam as Team).getName.compareTo((b.getTeam as Team).getName));
    }

    if (gameSettings.getInputMethod == InputMethod.ThreeDarts) {
      setCurrentPointType = PointType.Single;
    }
  }

  //to determine if points button should be disabled -> e.g current points are 80 -> shouldnt be possible to press any other points buttons -> invalid points
  bool shouldPointBtnBeDisabled(String btnValueToCheck) {
    if (getPlayerGameStatistics.isNotEmpty) {
      var stats = getCurrentPlayerGameStats();

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
    final stats = getCurrentPlayerGameStats();
    final currentThreeDartsCalculated =
        Utils.getCurrentThreeDartsCalculated(getCurrentThreeDarts);

    var points = stats.getCurrentPoints;
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
    final thrownPoints = int.parse(scoredPointsString);

    if (getGameSettings.getInputMethod == InputMethod.ThreeDarts) {
      return _getAmountOfCheckoutPossibilitiesForInputMethodThreeDarts(
          thrownPoints);
    }

    return _getAmountOfCheckoutPossibilitiesForInputMethodRound(thrownPoints);
  }

  //for checkout counting dialog -> to show the amount of darts for finising the leg, set or game -> in order to calc average correctly
  bool finishedLegSetOrGame(String scoredPoints) {
    final currentStats = getCurrentPlayerGameStats();

    if (getGameSettings.getInputMethod == InputMethod.ThreeDarts) {
      if (currentStats.getCurrentPoints == 0) {
        return true;
      }
      return false;
    }

    var currentPoints = currentStats.getCurrentPoints - int.parse(scoredPoints);
    if (currentPoints == 0) {
      return true;
    }

    return false;
  }

  //checks if the finish is possible with ONLY 3 darts
  bool finishedWithThreeDarts(String thrownPointsString) {
    //no need to check for <= 170 or bogey numbers -> this method is only called after checkoutPossible()
    final thrownPoints = int.parse(thrownPointsString);

    //these checkouts are possible with 3 darts & additionally with 2 darts (cause of bull)
    if (THREE_DART_FINISHES_WITH_BULL.contains(thrownPoints)) {
      return false;
    }

    final stats = getCurrentPlayerGameStats();

    var currentPoints = stats.getCurrentPoints;
    if (getGameSettings.getInputMethod == InputMethod.ThreeDarts) {
      final int thrownDarts =
          int.parse(Utils.getCurrentThreeDartsCalculated(getCurrentThreeDarts));
      currentPoints = stats.getCurrentPoints + thrownDarts;
    }

    //99 = special case
    if ((thrownPoints > 100 || thrownPoints == 99) &&
        (currentPoints - thrownPoints == 0)) {
      return true;
    }

    return false;
  }

  bool isDoubleField(String pointsString) {
    final points = int.parse(pointsString);

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

  List<String> getAllLegSetStringsExceptCurrentOne(
      GameX01_P gameX01, GameSettingsX01_P gameSettingsX01) {
    final String currentSetLegString =
        Utils.getCurrentSetLegAsString(gameX01, gameSettingsX01);

    var result = <String>[];
    for (String key in Utils.getPlayersOrTeamStatsListStatsScreen(
            gameX01, gameSettingsX01)[0]
        .getThrownDartsPerLeg
        .keys) {
      if (key != currentSetLegString) {
        result.add(key);
      }
    }

    return result;
  }

  /************************************************************/
  /********              PRIVATE METHODS               ********/
  /// *********************************************************

  bool _shouldPointBtnBeDisabledRound(
      String btnValueToCheck, PlayerOrTeamGameStatsX01 stats) {
    if (stats.getPlayer is Bot) {
      return false;
    }

    final int? currentPointsAndBtnToCheck = getCurrentPointsSelected != 'Points'
        ? int.tryParse(getCurrentPointsSelected + btnValueToCheck)
        : int.tryParse(btnValueToCheck);
    if (currentPointsAndBtnToCheck == null) {
      return false;
    }

    // DOUBLE IN
    if (stats.getCurrentPoints == getGameSettings.getPointsOrCustom() &&
        getGameSettings.getModeIn == ModeOutIn.Double) {
      if (DOUBLE_IN_IMPOSSIBLE_SCORES.contains(currentPointsAndBtnToCheck) ||
          currentPointsAndBtnToCheck > 170) {
        return true;
      }
    }

    if (getCurrentPointsSelected == 'Points' &&
        getGameSettings.getInputMethod == InputMethod.Round &&
        btnValueToCheck != 'Bull') {
      if (btnValueToCheck == '0' ||
          int.parse(btnValueToCheck) > stats.getCurrentPoints) {
        return true;
      }
    } else if (getCurrentPointsSelected != 'Points') {
      final result = btnValueToCheck == 'Bull'
          ? int.parse(getCurrentPointsSelected)
          : int.parse(getCurrentPointsSelected + btnValueToCheck);

      // should be able to left 1 point when playing single out
      if (getGameSettings.getModeOut == ModeOutIn.Single &&
          stats.getCurrentPoints - result == 1) {
        return false;
      }

      if (result > 180 ||
          result > stats.getCurrentPoints ||
          NO_SCORES_POSSIBLE.contains(result)) {
        return true;
      }

      // prevent from finishing with bogey numbers
      if (stats.getCurrentPoints <= 169 && BOGEY_NUMBERS.contains(result)) {
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
    if (stats.getCurrentPoints == 0 || getAmountOfDartsThrown() == 3) {
      return true;
    }

    //calculate points based on single, double or tripple
    var result = 0;
    if (btnValueToCheck == 'Bull') {
      result += 50;
    } else {
      var points = int.parse(btnValueToCheck);
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
    final stats = getCurrentPlayerGameStats();
    final int thrownDarts =
        int.parse(Utils.getCurrentThreeDartsCalculated(getCurrentThreeDarts));

    int currentPoints = stats.getCurrentPoints + thrownDarts;
    int doubleCount = 0;

    //check at which dart currentPoints were on a double field -> increment counter
    for (var point in getCurrentThreeDarts) {
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

  bool _twoPossibleCheckoutDarts(int currentPoints, int thrownPoints) {
    // for single dart
    for (int i = 1; i <= 20; i++) {
      if (i > thrownPoints) {
        break;
      }

      int result = currentPoints - i;
      if (isDoubleField(result.toString())) {
        return true;
      }
    }

    // for double dart
    for (int i = 2; i <= 40; i += 2) {
      if (i > thrownPoints) {
        break;
      }

      int result = currentPoints - i;
      if (isDoubleField(result.toString())) {
        return true;
      }
    }

    // for tripple dart
    for (int i = 3; i <= 20; i += 3) {
      if (i > thrownPoints) {
        break;
      }

      int result = currentPoints - i;
      if (isDoubleField(result.toString())) {
        return true;
      }
    }

    return false;
  }

  int _getAmountOfCheckoutPossibilitiesForInputMethodRound(int thrownPoints) {
    final PlayerOrTeamGameStatsX01 stats =
        Utils.getCurrentPlayerOrTeamStats(this, this.getGameSettings);
    final int currentPoints = stats.getCurrentPoints;
    final int result = currentPoints - thrownPoints;

    // double out
    if (getGameSettings.getModeOut == ModeOutIn.Double) {
      if (result >= 51) {
        return -1;
      }

      if (isDoubleField(currentPoints.toString())) {
        return 3;
      } else if (currentPoints < 40 && currentPoints % 2 == 1) {
        return 2;
      } else if (_twoPossibleCheckoutDarts(currentPoints, thrownPoints)) {
        return 2;
      } else if (THREE_DART_FINISHES_WITH_BULL.contains(currentPoints) &&
          result <= 50) {
        return 2;
      } else if (result == 0 && currentPoints <= 100) {
        return 2;
      } else if (currentPoints >= 51 && result <= 50) {
        return 1;
      }
    }

    return -1;
  }

  PlayerOrTeamGameStatsX01 getPlayerGameStats(
      PlayerOrTeamGameStatsX01? statsToFind) {
    late PlayerOrTeamGameStatsX01 result;

    for (PlayerOrTeamGameStatsX01 playerStats in getPlayerGameStatistics) {
      if (playerStats == statsToFind) result = playerStats;
    }

    return result;
  }

  PlayerOrTeamGameStatsX01 getTeamStatsFromPlayer(String playerName) {
    late PlayerOrTeamGameStatsX01 result;

    for (PlayerOrTeamGameStatsX01 teamStats in getTeamGameStatistics) {
      for (Player player in teamStats.getTeam.getPlayers) {
        if (player.getName == playerName) {
          result = teamStats;
        }
      }
    }

    return result;
  }

  dynamic getPlayerStatsFromCurrentTeamToThrow(
      GameX01_P gameX01, GameSettingsX01_P gameSettingsX01) {
    var result = <PlayerOrTeamGameStatsX01>[];

    for (PlayerOrTeamGameStatsX01 stats in gameX01.getPlayerGameStatistics) {
      final teamOfPlayer =
          gameSettingsX01.findTeamForPlayer(stats.getPlayer.getName);

      if (teamOfPlayer.getName == gameX01.getCurrentTeamToThrow.getName) {
        result.add(stats);
      }
    }

    return result;
  }

  bool isGameDraw(dynamic playersOrTeamsList) {
    for (PlayerOrTeamGameStatsX01 stats in playersOrTeamsList) {
      if (stats.getGameDraw) {
        return true;
      }
    }
    return false;
  }

  //for win by two legs diff -> checks if leg won difference is at least 2 at each player -> return true (valid win)
  bool isLegDifferenceAtLeastTwo(PlayerOrTeamGameStatsX01 playerToCheck,
      GameX01_P gameX01, GameSettingsX01_P gameSettingsX01) {
    for (PlayerOrTeamGameStatsX01 stats in Utils.getPlayersOrTeamStatsList(
        gameX01, gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Team)) {
      if (stats != playerToCheck &&
          (playerToCheck.getLegsWon - 2) < stats.getLegsWon) {
        return false;
      }
    }

    return true;
  }
}
