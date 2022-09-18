import 'package:dart_app/constants.dart';
import 'package:dart_app/models/bot.dart';
import 'package:dart_app/models/default_settings_x01.dart';
import 'package:dart_app/models/game_settings/game_settings.dart';
import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/models/player_statistics/player_game_statistics_x01.dart';
import 'package:dart_app/models/team.dart';

import 'package:dart_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameSettingsX01 extends GameSettings {
  SingleOrTeamEnum _singleOrTeam = DEFAULT_SINGLE_OR_TEAM;
  BestOfOrFirstToEnum _mode = DEFAULT_MODE;
  int _points = DEFAULT_POINTS;
  int _customPoints = DEFAULT_CUSTOM_POINTS;
  int _legs = DEFAULT_LEGS;
  int _sets = DEFAULT_SETS;
  bool _setsEnabled = DEFAULT_SETS_ENABLED;
  ModeOutIn _modeIn = DEFAULT_MODE_IN;
  ModeOutIn _modeOut = DEFAULT_MODE_OUT;
  bool _winByTwoLegsDifference = DEFAULT_WIN_BY_TWO_LEGS_DIFFERENCE;
  bool _suddenDeath = DEFAULT_SUDDEN_DEATH;
  int _maxExtraLegs = DEFAULT_MAX_EXTRA_LEGS;
  bool _enableCheckoutCounting = DEFAULT_ENABLE_CHECKOUT_COUNTING;
  bool _checkoutCountingFinallyDisabled =
      DEFAULT_CHECKOUT_COUNTING_FINALLY_DISABLED; //if user disables checkout counting in the in game settings -> cant be reversed (cause of inconsistent stats then)
  bool _showAverage = DEFAULT_SHOW_AVG;
  bool _showFinishWays = DEFAULT_SHOW_FINISH_WAYS;
  bool _showThrownDartsPerLeg = DEFAULT_SHOW_THROWN_DARTS_PER_LEG;
  bool _showLastThrow = DEFAULT_SHOW_LAST_THROW;
  bool _callerEnabled = DEFAULT_CALLER_ENABLED;
  bool _vibrationFeedbackEnabled = DEFAULT_VIBRATION_FEEDBACK;
  bool _automaticallySubmitPoints = DEFAULT_AUTO_SUBMIT_POINTS;
  bool _showMostScoredPoints = DEFAULT_SHOW_MOST_SCORED_POINTS;
  InputMethod _inputMethod = DEFAULT_INPUT_METHOD;
  bool _showInputMethodInGameScreen = DEFAULT_SHOW_INPUT_METHOD_IN_GAME_SCREEN;
  bool _drawMode = DEFAULT_DRAW_MODE;
  List<int> _teamNamingIds = [];

  GameSettingsX01() {}

  GameSettingsX01.firestore({
    required bool checkoutCounting,
    required int legs,
    required int sets,
    required ModeOutIn modeIn,
    required ModeOutIn modeOut,
    required BestOfOrFirstToEnum mode,
    required int points,
    required SingleOrTeamEnum singleOrTeam,
    required bool winByTwoLegsDifference,
    required bool setsEnabled,
    List<Player>? players,
  }) {
    this._enableCheckoutCounting = checkoutCounting;
    this._legs = legs;
    this._sets = sets;
    this._modeIn = modeIn;
    this._modeOut = modeOut;
    this._mode = mode;
    this._points = points;
    this._singleOrTeam = singleOrTeam;
    this._winByTwoLegsDifference = winByTwoLegsDifference;
    this._setsEnabled = setsEnabled;
    if (players != null) {
      setPlayers = players;
    }
  }

  SingleOrTeamEnum get getSingleOrTeam => this._singleOrTeam;
  set setSingleOrTeam(SingleOrTeamEnum _singleOrTeam) =>
      this._singleOrTeam = _singleOrTeam;

  BestOfOrFirstToEnum get getMode => this._mode;
  set setMode(BestOfOrFirstToEnum mode) => this._mode = mode;

  int get getPoints => this._points;
  set setPoints(int points) => {
        this._points = points,
        this._customPoints = -1,
      };

  int get getCustomPoints => this._customPoints;
  set setCustomPoints(int customPoints) => {
        this._customPoints = customPoints,
      };

  int get getLegs => this._legs;
  set setLegs(int legs) => {
        this._legs = legs,
      };

  int get getSets => this._sets;
  set setSets(int sets) => {
        this._sets = sets,
      };

  bool get getSetsEnabled => this._setsEnabled;
  set setSetsEnabled(bool setsEnabled) => this._setsEnabled = setsEnabled;

  ModeOutIn get getModeIn => this._modeIn;
  set setModeIn(ModeOutIn modeIn) => this._modeIn = modeIn;

  ModeOutIn get getModeOut => this._modeOut;
  set setModeOut(ModeOutIn modeOut) => this._modeOut = modeOut;

  bool get getWinByTwoLegsDifference => this._winByTwoLegsDifference;
  set setWinByTwoLegsDifference(bool winByTwoLegsDifference) =>
      this._winByTwoLegsDifference = winByTwoLegsDifference;

  bool get getSuddenDeath => this._suddenDeath;
  set setSuddenDeath(bool suddenDeath) => {
        this._suddenDeath = suddenDeath,
      };

  int get getMaxExtraLegs => this._maxExtraLegs;
  set setMaxExtraLegs(int maxLegDifference) => {
        this._maxExtraLegs = maxLegDifference,
      };

  bool get getEnableCheckoutCounting => this._enableCheckoutCounting;
  set setEnableCheckoutCounting(bool enableCheckoutCounting) => {
        this._enableCheckoutCounting = enableCheckoutCounting,
      };

  bool get getCheckoutCountingFinallyDisabled =>
      this._checkoutCountingFinallyDisabled;
  set setCheckoutCountingFinallyDisabled(
          bool checkoutCountingFinallyDisabled) =>
      {
        this._checkoutCountingFinallyDisabled = checkoutCountingFinallyDisabled,
      };

  bool get getShowAverage => this._showAverage;
  set setShowAverage(bool showAverage) => {
        this._showAverage = showAverage,
      };

  bool get getShowFinishWays => this._showFinishWays;
  set setShowFinishWays(bool showFinishWays) => {
        this._showFinishWays = showFinishWays,
      };

  bool get getShowThrownDartsPerLeg => this._showThrownDartsPerLeg;
  set setShowThrownDartsPerLeg(bool showThrownDartsPerLeg) => {
        this._showThrownDartsPerLeg = showThrownDartsPerLeg,
      };

  bool get getShowLastThrow => this._showLastThrow;
  set setShowLastThrow(bool showLastThrow) => {
        this._showLastThrow = showLastThrow,
      };

  bool get getCallerEnabled => this._callerEnabled;
  set setCallerEnabled(bool callerEnabled) => {
        this._callerEnabled = callerEnabled,
      };

  bool get getVibrationFeedbackEnabled => this._vibrationFeedbackEnabled;
  set setVibrationFeedbackEnabled(bool vibrationFeedbackEnabled) => {
        this._vibrationFeedbackEnabled = vibrationFeedbackEnabled,
      };

  bool get getAutomaticallySubmitPoints => this._automaticallySubmitPoints;
  set setAutomaticallySubmitPoints(bool automaticallySubmitPoints) => {
        this._automaticallySubmitPoints = automaticallySubmitPoints,
      };

  bool get getShowMostScoredPoints => this._showMostScoredPoints;
  set setShowMostScoredPoints(bool showMostScoredPoints) => {
        this._showMostScoredPoints = showMostScoredPoints,
      };

  InputMethod get getInputMethod => this._inputMethod;
  set setInputMethod(InputMethod inputMethod) =>
      this._inputMethod = inputMethod;

  bool get getShowInputMethodInGameScreen => this._showInputMethodInGameScreen;
  set setShowInputMethodInGameScreen(bool showInputMethodInGameScreen) {
    this._showInputMethodInGameScreen = showInputMethodInGameScreen;
  }

  bool get getDrawMode => this._drawMode;
  set setDrawMode(bool value) => this._drawMode = value;

  List<int> get getTeamNamingIds => this._teamNamingIds;
  set setTeamNamingIds(List<int> value) => this._teamNamingIds = value;

  void switchSingleOrTeamMode(BuildContext context) async {
    if (_singleOrTeam == SingleOrTeamEnum.Single) {
      setSingleOrTeam = SingleOrTeamEnum.Team;
      /*await Future.delayed(const Duration(milliseconds: 100));
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (scrollControllerTeams.hasClients)
          scrollControllerTeams.animateTo(
              scrollControllerTeams.position.maxScrollExtent,
              duration: Duration(milliseconds: 300),
              curve: Curves.fastOutSlowIn);
      });*/
    } else {
      final int countOfBotPlayers = getCountOfBotPlayers();
      final int countOfGuestPlayers = getPlayers.length - countOfBotPlayers;
      if (countOfBotPlayers >= 1 && countOfGuestPlayers >= 2) {
        const String loggedInUser = '';
        // final String loggedInUser =
        //     context.read<AuthService>().getPlayer!.getName;
        List<Player> toRemove = [];

        for (int i = 2; i < getPlayers.length; i++) {
          if (getPlayers.elementAt(i).getName == loggedInUser) {
            toRemove.add(getPlayers.elementAt(1));
          } else {
            toRemove.add(getPlayers.elementAt(i));
          }
        }

        toRemove.forEach((player) =>
            removePlayer(player, false)); //to avoid concurrency problem
      }
      if (countOfBotPlayers == 2) {
        Player playerToRemove = getPlayers
            .where((player) => player is Bot && player.getName == 'Bot2')
            .first;
        removePlayer(playerToRemove, false);
      }

      setSingleOrTeam = SingleOrTeamEnum.Single;
    }

    notifyListeners();
  }

  void switchBestOfOrFirstTo() {
    if (getMode == BestOfOrFirstToEnum.BestOf) {
      setMode = BestOfOrFirstToEnum.FirstTo;

      if (getDrawMode) {
        setDrawMode = false;
      }

      if (getSetsEnabled) {
        setLegs = DEFAULT_LEGS_FIRST_TO_SETS_ENABLED;
        setSets = DEFAULT_SETS_FIRST_TO_SETS_ENABLED;
      } else {
        setLegs = DEFAULT_LEGS_FIRST_TO_NO_SETS;
      }
    } else {
      setMode = BestOfOrFirstToEnum.BestOf;
      setWinByTwoLegsDifference = false;

      if (getSetsEnabled) {
        setSets = DEFAULT_SETS_BEST_OF_SETS_ENABLED;
        setLegs = DEFAULT_LEGS_BEST_OF_SETS_ENABLED;
      } else {
        setLegs = DEFAULT_LEGS_BEST_OF_NO_SETS;
      }
    }

    notifyListeners();
  }

  void setsBtnClicked() {
    setSetsEnabled = !getSetsEnabled;
    setWinByTwoLegsDifference = false;
    setSuddenDeath = false;
    setMaxExtraLegs = DEFAULT_MAX_EXTRA_LEGS;

    if (getDrawMode) {
      setSets = DEFAULT_SETS_DRAW_MODE;
      setLegs = getSetsEnabled
          ? DEFAULT_LEGS_DRAW_MODE_SETS_ENABLED
          : DEFAULT_LEGS_DRAW_MODE;
    } else {
      if (getMode == BestOfOrFirstToEnum.FirstTo) {
        setSets = DEFAULT_SETS_FIRST_TO_SETS_ENABLED;
        setLegs = getSetsEnabled
            ? DEFAULT_LEGS_FIRST_TO_SETS_ENABLED
            : DEFAULT_LEGS_FIRST_TO_NO_SETS;
      } else {
        setSets = DEFAULT_SETS_BEST_OF_SETS_ENABLED;
        setLegs = getSetsEnabled
            ? setLegs = DEFAULT_LEGS_BEST_OF_SETS_ENABLED
            : setSets = DEFAULT_LEGS_BEST_OF_NO_SETS;
      }
    }

    notifyListeners();
  }

  void switchWinByTwoLegsDifference(bool value) {
    if (getWinByTwoLegsDifference == true) {
      setSuddenDeath = false;
      setMaxExtraLegs = STANDARD_MAX_EXTRA_LEGS;
    }
    setWinByTwoLegsDifference = value;

    this.notify();
  }

  void removePlayer(Player playerToRemove, bool removeTeam) {
    getPlayers.remove(playerToRemove);

    //remove player from team
    outerLoop:
    for (Team team in getTeams) {
      for (Player player in team.getPlayers) {
        if (player == playerToRemove) {
          if (playerToRemove is Bot &&
              playerToRemove.getName == 'Bot1' &&
              getCountOfBotPlayers() == 2) {
            getPlayers
                .where((player) => player is Bot && player.getName == 'Bot2')
                .first
                .setName = 'Bot1';
          }
          team.getPlayers.remove(playerToRemove);
          if (team.getPlayers.isEmpty && removeTeam) {
            getTeams.remove(team);
            checkTeamNamingIds(team);
          }
          break outerLoop;
        }
      }
    }

    notifyListeners();
  }

  void checkTeamNamingIds(Team team) {
    final String lastCharFromTeamName =
        team.getName.substring(team.getName.length - 1);
    if (!team.getName.startsWith('Team ') &&
        int.tryParse(lastCharFromTeamName) == null) {
      return;
    }

    int teamNamingId = int.parse(lastCharFromTeamName);
    getTeamNamingIds.remove(teamNamingId);

    if (getTeamNamingIds.isEmpty || getTeamNamingIds.last == teamNamingId)
      return;

    int idCounter = 1;
    for (teamNamingId in getTeamNamingIds) {
      if (teamNamingId != idCounter) {
        final int index = getTeamNamingIds.indexOf(teamNamingId);
        getTeamNamingIds[index] = idCounter;
        _setNewTeamNamingId(teamNamingId, idCounter);
      }
      idCounter++;
    }
    notifyListeners();
  }

  void _setNewTeamNamingId(int currentTeamNamingId, int newTeamNamingId) {
    for (Team team in getTeams) {
      final int teamNamingId =
          int.parse(team.getName.substring(team.getName.length - 1));
      if (teamNamingId == currentTeamNamingId) {
        final String newTeamName =
            team.getName.substring(0, team.getName.length - 1) +
                newTeamNamingId.toString();
        team.setName = newTeamName;
      }
    }
    notifyListeners();
  }

  void addPlayer(Player player) {
    getPlayers.add(player);

    //add a Team to each Player in case someone adds Players in the Single mode & then switches to Teams mode -> automatically assigned Teams
    if (getTeams.isEmpty || getPlayers.length == 2)
      _createTeamAndAddPlayer(player);
    else {
      bool foundTeamWithLessTwoPlayers = false;
      for (Team team in getTeams) {
        if (team.getPlayers.length < MAX_PLAYERS_IN_TEAM_FOR_AUTO_ASSIGNING) {
          team.getPlayers.add(player);
          foundTeamWithLessTwoPlayers = true;
          break;
        }
      }
      if (!foundTeamWithLessTwoPlayers) _createTeamAndAddPlayer(player);
    }

    notifyListeners();
  }

  void _createTeamAndAddPlayer(Player player) {
    final int teamNameId = getTeamNamingIds.length + 1;
    final Team team = new Team(name: 'Team $teamNameId');

    team.getPlayers.add(player);
    getTeams.add(team);
    getTeamNamingIds.add(teamNameId);
  }

  void addNewPlayerToSpecificTeam(Player playerToAdd, Team? teamForNewPlayer) {
    getPlayers.add(playerToAdd);
    for (Team team in getTeams)
      if (team == teamForNewPlayer) team.getPlayers.add(playerToAdd);

    notifyListeners();
  }

  void addNewTeam(String teamName) {
    getTeams.add(new Team(name: teamName));
    notifyListeners();
  }

  //checks if player can be added to only one team -> return that team (prevent to show only 1 radio button in selecting team dialog)
  Team? checkIfMultipleTeamsToAdd() {
    int count = 0;
    Team? team;

    for (Team t in getTeams) {
      if (t.getPlayers.length < MAX_PLAYERS_PER_TEAM) {
        count++;
        team = t;
      }
    }
    if (count == 1) return team;

    return null;
  }

  //checks if its possible to add an player to a team -> e.g. there is 1 team with the MAX players in the team -> should not be possible to add a player, instead only possible to add a team
  bool possibleToAddPlayerToSomeTeam() {
    for (Team t in getTeams)
      if (t.getPlayers.length < MAX_PLAYERS_PER_TEAM) return true;

    return false;
  }

  //for swaping team -> if only one other team is available then the current one -> swap immediately instead of showing 1 radio button
  Team? checkIfSwappingOnlyToOneTeamPossible(Player playerToSwap) {
    Team? currentTeam = getTeamOfPlayer(playerToSwap);
    int count = 0;
    Team? resultTeam;

    for (Team team in getTeams) {
      if (team.getPlayers.length < MAX_PLAYERS_PER_TEAM &&
          team != currentTeam) {
        count++;
        resultTeam = team;
      }
    }

    if (count == 1) return resultTeam;
    return null;
  }

  Team? getTeamOfPlayer(Player playerToCheck) {
    for (Team team in getTeams) {
      for (Player player in team.getPlayers) {
        if (player == playerToCheck) return team;
      }
    }
    return null;
  }

  void swapTeam(Player playerToSwap, Team? newTeam) {
    final Team? currentTeam = getTeamOfPlayer(playerToSwap);

    for (Team team in getTeams) {
      if (team == currentTeam) team.getPlayers.remove(playerToSwap);
      if (team == newTeam) team.getPlayers.add(playerToSwap);
    }

    notifyListeners();
  }

  List<Team> getPossibleTeamsToSwap(Player playerToSwap) {
    final Team? currentTeam = getTeamOfPlayer(playerToSwap);
    List<Team> result = [];

    for (Team team in getTeams) if (team != currentTeam) result.add(team);

    return result;
  }

  void deleteTeam(Team teamToDelete) {
    getTeams.remove(teamToDelete);
    for (Player playerToDelete in teamToDelete.getPlayers) {
      getPlayers.remove(playerToDelete);
    }

    notifyListeners();
  }

  bool checkIfTeamNameExists(String? teamNameToCheck) {
    for (Team team in getTeams)
      if (team.getName == teamNameToCheck) return true;

    return false;
  }

  bool checkIfPlayerNameExists(String? playerNameToCheck) {
    for (Player player in getPlayers)
      if (player.getName == playerNameToCheck) return true;

    return false;
  }

  bool checkIfPlayerAlreadyInserted(Player playerToInsert) {
    for (Player player in getPlayers)
      if (player.getName == playerToInsert.getName) return true;

    return false;
  }

  void updatePlayerName(String newPlayerName, Player playerToUpdate) {
    playerToUpdate.setName = newPlayerName;
  }

  void notify() {
    notifyListeners();
  }

  void setBeginnerPlayer(Player? playerToSet) {
    int index = 0;

    for (int i = 0; i < getPlayers.length; i++)
      if (getPlayers[i] == playerToSet) index = i;

    //otherwise player is already first in list
    if (index != 0) {
      final Player temp = getPlayers[0];
      getPlayers[0] = playerToSet as Player;
      getPlayers[index] = temp;
    }
  }

  void setBeginnerTeam(Team? teamToSet) {
    int index = 0;

    for (int i = 0; i < getTeams.length; i++)
      if (getTeams[i] == teamToSet) index = i;

    //otherwise team is already first in list
    if (index != 0) {
      final Team temp = getTeams[0];
      getTeams[0] = teamToSet as Team;
      getTeams[index] = temp;
    }
  }

  int getPointsOrCustom() {
    if (getCustomPoints != -1) return getCustomPoints;

    return getPoints;
  }

  void switchInputMethod(GameX01 gameX01) {
    if (getInputMethod == InputMethod.Round)
      setInputMethod = InputMethod.ThreeDarts;
    else {
      setInputMethod = InputMethod.Round;

      //in case user enters e.g. 1 or 2 darts in three dart mode -> switches to round mode
      if (gameX01.getInit) {
        PlayerGameStatisticsX01? stats =
            gameX01.getCurrentPlayerGameStatistics();
        final int currentPointsEntered =
            int.parse(gameX01.getCurrentThreeDartsCalculated());
        stats.setCurrentPoints = stats.getCurrentPoints + currentPointsEntered;
        gameX01.resetCurrentThreeDarts();
      }
    }

    notifyListeners();
  }

  String getGameMode() {
    String result = '';
    if (getMode == BestOfOrFirstToEnum.BestOf)
      result += 'Best Of ';
    else
      result += 'First To ';

    if (getSetsEnabled) {
      if (getSets > 1)
        result += getSets.toString() + ' Sets - ';
      else
        result += getSets.toString() + ' Set - ';
    }
    if (getLegs > 1)
      result += getLegs.toString() + ' Legs';
    else
      result += getLegs.toString() + ' Leg';

    return result;
  }

  String getGameModeDetails(bool showPoints) {
    String result = '';

    if (showPoints) {
      if (getCustomPoints != -1)
        result += getCustomPoints.toString() + ' / ';
      else
        result += getPoints.toString() + ' / ';
    }

    if (getModeIn == ModeOutIn.Single)
      result += 'Single In / ';
    else
      result += 'Double In / ';

    if (getModeOut == ModeOutIn.Single)
      result += 'Single Out';
    else
      result += 'Double Out';

    if (getSuddenDeath)
      result += ' / SD - after ' + getMaxExtraLegs.toString() + ' Legs';

    return result;
  }

  bool isCurrentUserInPlayers(BuildContext context) {
    for (Player player in getPlayers)
      if (player.getName == context.read<AuthService>().getPlayer!.getName)
        return true;

    return false;
  }

  void setNewGameSettingsFromOpenGame(GameSettingsX01 gameSettingsX01) {
    setEnableCheckoutCounting = gameSettingsX01.getEnableCheckoutCounting;
    setLegs = gameSettingsX01.getLegs;
    setSets = gameSettingsX01.getSets;
    setModeIn = gameSettingsX01.getModeIn;
    setModeOut = gameSettingsX01.getModeOut;
    if (startPointsPossibilities.contains(gameSettingsX01.getPoints)) {
      setPoints = gameSettingsX01.getPoints;
    } else {
      setCustomPoints = gameSettingsX01.getPoints;
    }
    setSingleOrTeam = gameSettingsX01.getSingleOrTeam;
    setWinByTwoLegsDifference = gameSettingsX01.getWinByTwoLegsDifference;
    setSuddenDeath = gameSettingsX01.getSuddenDeath;
    setPlayers = gameSettingsX01.getPlayers;
  }

  void setDefaultSettings(BuildContext context) {
    final defaultSettingsX01 =
        Provider.of<DefaultSettingsX01>(context, listen: false);

    defaultSettingsX01.automaticallySubmitPoints =
        this.getAutomaticallySubmitPoints;
    defaultSettingsX01.callerEnabled = this.getCallerEnabled;
    defaultSettingsX01.checkoutCountingFinallyDisabled =
        this.getCheckoutCountingFinallyDisabled;
    defaultSettingsX01.customPoints = this.getCustomPoints;
    defaultSettingsX01.enableCheckoutCounting = this.getEnableCheckoutCounting;
    defaultSettingsX01.inputMethod = this.getInputMethod;
    defaultSettingsX01.legs = this.getLegs;
    defaultSettingsX01.maxExtraLegs = this.getMaxExtraLegs;
    defaultSettingsX01.mode = this.getMode;
    defaultSettingsX01.modeIn = this.getModeIn;
    defaultSettingsX01.modeOut = this.getModeOut;
    defaultSettingsX01.points = this.getPoints;
    defaultSettingsX01.sets = this.getSets;
    defaultSettingsX01.setsEnabled = this.getSetsEnabled;
    defaultSettingsX01.showAverage = this.getShowAverage;
    defaultSettingsX01.showFinishWays = this.getShowFinishWays;
    defaultSettingsX01.showInputMethodInGameScreen =
        this.getShowInputMethodInGameScreen;
    defaultSettingsX01.showLastThrow = this.getShowLastThrow;
    defaultSettingsX01.showMostScoredPoints = this.getShowMostScoredPoints;
    defaultSettingsX01.showThrownDartsPerLeg = this.getShowThrownDartsPerLeg;
    defaultSettingsX01.singleOrTeam = this.getSingleOrTeam;
    defaultSettingsX01.suddenDeath = this.getSuddenDeath;
    defaultSettingsX01.vibrationFeedbackEnabled =
        this.getVibrationFeedbackEnabled;
    defaultSettingsX01.winByTwoLegsDifference = this.getWinByTwoLegsDifference;
    defaultSettingsX01.players = this.getPlayers;
    defaultSettingsX01.playersNames = [];
    defaultSettingsX01.drawMode = this.getDrawMode;
    for (Player player in this.getPlayers) {
      defaultSettingsX01.playersNames.add(player.getName);
    }

    this.notify();
  }

  void setSettingsFromDefault(BuildContext context) {
    final defaultSettingsX01 =
        Provider.of<DefaultSettingsX01>(context, listen: false);

    this.setAutomaticallySubmitPoints =
        defaultSettingsX01.automaticallySubmitPoints;
    this.setCallerEnabled = defaultSettingsX01.callerEnabled;
    this.setCheckoutCountingFinallyDisabled =
        defaultSettingsX01.checkoutCountingFinallyDisabled;
    this.setEnableCheckoutCounting = defaultSettingsX01.enableCheckoutCounting;
    this.setInputMethod = defaultSettingsX01.inputMethod;
    this.setLegs = defaultSettingsX01.legs;
    this.setMaxExtraLegs = defaultSettingsX01.maxExtraLegs;
    this.setMode = defaultSettingsX01.mode;
    this.setModeIn = defaultSettingsX01.modeIn;
    this.setModeOut = defaultSettingsX01.modeOut;
    this.setPoints = defaultSettingsX01.points;
    this.setCustomPoints = defaultSettingsX01.customPoints;
    this.setSets = defaultSettingsX01.sets;
    this.setSetsEnabled = defaultSettingsX01.setsEnabled;
    this.setShowAverage = defaultSettingsX01.showAverage;
    this.setShowFinishWays = defaultSettingsX01.showFinishWays;
    this.setShowInputMethodInGameScreen =
        defaultSettingsX01.showInputMethodInGameScreen;
    this.setShowLastThrow = defaultSettingsX01.showLastThrow;
    this.setShowMostScoredPoints = defaultSettingsX01.showMostScoredPoints;
    this.setShowThrownDartsPerLeg = defaultSettingsX01.showThrownDartsPerLeg;
    this.setSingleOrTeam = defaultSettingsX01.singleOrTeam;
    this.setSuddenDeath = defaultSettingsX01.suddenDeath;
    this.setVibrationFeedbackEnabled =
        defaultSettingsX01.vibrationFeedbackEnabled;
    this.setWinByTwoLegsDifference = defaultSettingsX01.winByTwoLegsDifference;
    this.setDrawMode = defaultSettingsX01.drawMode;
    this.setPlayers = defaultSettingsX01.players;
    //teams not supported for favourites
    this.setTeamNamingIds = [];
    this.setTeams = [];
  }

  bool defaultSettingsSelected(BuildContext context) {
    final defaultSettingsX01 =
        Provider.of<DefaultSettingsX01>(context, listen: false);

    if (defaultSettingsX01.automaticallySubmitPoints ==
            this.getAutomaticallySubmitPoints &&
        defaultSettingsX01.callerEnabled == this.getCallerEnabled &&
        defaultSettingsX01.checkoutCountingFinallyDisabled ==
            this.getCheckoutCountingFinallyDisabled &&
        defaultSettingsX01.customPoints == this.getCustomPoints &&
        defaultSettingsX01.enableCheckoutCounting ==
            this.getEnableCheckoutCounting &&
        defaultSettingsX01.inputMethod == this.getInputMethod &&
        defaultSettingsX01.legs == this.getLegs &&
        defaultSettingsX01.maxExtraLegs == this.getMaxExtraLegs &&
        defaultSettingsX01.mode == this.getMode &&
        defaultSettingsX01.modeIn == this.getModeIn &&
        defaultSettingsX01.modeOut == this.getModeOut &&
        defaultSettingsX01.points == this.getPoints &&
        defaultSettingsX01.sets == this.getSets &&
        defaultSettingsX01.setsEnabled == this.getSetsEnabled &&
        defaultSettingsX01.showAverage == this.getShowAverage &&
        defaultSettingsX01.showFinishWays == this.getShowFinishWays &&
        defaultSettingsX01.showInputMethodInGameScreen ==
            this.getShowInputMethodInGameScreen &&
        defaultSettingsX01.showLastThrow == this.getShowLastThrow &&
        defaultSettingsX01.showMostScoredPoints ==
            this.getShowMostScoredPoints &&
        defaultSettingsX01.showThrownDartsPerLeg ==
            this.getShowThrownDartsPerLeg &&
        defaultSettingsX01.singleOrTeam == this.getSingleOrTeam &&
        defaultSettingsX01.suddenDeath == this.getSuddenDeath &&
        defaultSettingsX01.vibrationFeedbackEnabled ==
            this.getVibrationFeedbackEnabled &&
        defaultSettingsX01.winByTwoLegsDifference ==
            this.getWinByTwoLegsDifference &&
        defaultSettingsX01.drawMode == this.getDrawMode &&
        defaultSettingsX01.samePlayers(this.getPlayers, context)) {
      return true;
    }
    return false;
  }

  bool generalDefaultSettingsSelected() {
    if (this.getAutomaticallySubmitPoints == DEFAULT_AUTO_SUBMIT_POINTS &&
        this.getCallerEnabled == DEFAULT_CALLER_ENABLED &&
        this.getCheckoutCountingFinallyDisabled ==
            DEFAULT_CHECKOUT_COUNTING_FINALLY_DISABLED &&
        this.getCustomPoints == DEFAULT_CUSTOM_POINTS &&
        this.getEnableCheckoutCounting == DEFAULT_ENABLE_CHECKOUT_COUNTING &&
        this.getInputMethod == DEFAULT_INPUT_METHOD &&
        this.getLegs == DEFAULT_LEGS &&
        this.getMaxExtraLegs == DEFAULT_MAX_EXTRA_LEGS &&
        this.getMode == DEFAULT_MODE &&
        this.getModeIn == DEFAULT_MODE_IN &&
        this.getModeOut == DEFAULT_MODE_OUT &&
        this.getPoints == DEFAULT_POINTS &&
        this.getSets == DEFAULT_SETS &&
        this.getSetsEnabled == DEFAULT_SETS_ENABLED &&
        this.getShowAverage == DEFAULT_SHOW_AVG &&
        this.getShowFinishWays == DEFAULT_SHOW_FINISH_WAYS &&
        this.getShowInputMethodInGameScreen ==
            DEFAULT_SHOW_INPUT_METHOD_IN_GAME_SCREEN &&
        this.getShowLastThrow == DEFAULT_SHOW_LAST_THROW &&
        this.getShowMostScoredPoints == DEFAULT_SHOW_MOST_SCORED_POINTS &&
        this.getShowThrownDartsPerLeg == DEFAULT_SHOW_THROWN_DARTS_PER_LEG &&
        this.getSingleOrTeam == DEFAULT_SINGLE_OR_TEAM &&
        this.getSuddenDeath == DEFAULT_SUDDEN_DEATH &&
        this.getVibrationFeedbackEnabled == DEFAULT_VIBRATION_FEEDBACK &&
        this.getWinByTwoLegsDifference == DEFAULT_WIN_BY_TWO_LEGS_DIFFERENCE &&
        this.getPlayers.length == 0 &&
        this.getDrawMode == DEFAULT_DRAW_MODE) {
      return true;
    }
    return false;
  }

  int getCountOfBotPlayers() {
    int count = 0;
    for (Player player in getPlayers) {
      if (player is Bot) {
        count++;
      }
    }

    return count;
  }
}
