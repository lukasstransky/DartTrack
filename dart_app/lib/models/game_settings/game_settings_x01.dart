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
  late SingleOrTeamEnum _singleOrTeam;
  late BestOfOrFirstToEnum _mode;
  late int _points;
  late int _customPoints;
  late int _legs;
  late int _sets;
  late bool _setsEnabled;
  late SingleOrDouble _modeIn;
  late SingleOrDouble _modeOut;
  late bool _winByTwoLegsDifference;
  late bool _suddenDeath;
  late int _maxExtraLegs;
  late bool _enableCheckoutCounting;
  late bool
      _checkoutCountingFinallyDisabled; //if user disables checkout counting in the in game settings -> cant be reversed (cause of inconsistent stats then)
  late bool _showAverage;
  late bool _showFinishWays;
  late bool _showThrownDartsPerLeg;
  late bool _showLastThrow;
  late bool _callerEnabled;
  late bool _vibrationFeedbackEnabled;
  late bool _automaticallySubmitPoints;
  late bool _showMostScoredPoints;
  late InputMethod _inputMethod;
  late bool _showInputMethodInGameScreen;
  late List<int> _botNamingIds;
  late List<int> _teamNamingIds;

  GameSettingsX01() {
    this.initValues();
  }

  GameSettingsX01.firestore({
    required bool checkoutCounting,
    required int legs,
    required int sets,
    required SingleOrDouble modeIn,
    required SingleOrDouble modeOut,
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

  SingleOrDouble get getModeIn => this._modeIn;
  set setModeIn(SingleOrDouble modeIn) => this._modeIn = modeIn;

  SingleOrDouble get getModeOut => this._modeOut;
  set setModeOut(SingleOrDouble modeOut) => this._modeOut = modeOut;

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

  List<int> get getBotNamingIds => this._botNamingIds;
  set setBotNamingIds(List<int> value) => this._botNamingIds = value;

  List<int> get getTeamNamingIds => this._teamNamingIds;
  set setTeamNamingIds(List<int> value) => this._teamNamingIds = value;

  void switchSingleOrTeamMode() async {
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
      setSingleOrTeam = SingleOrTeamEnum.Single;
    }

    notifyListeners();
  }

  void switchSingleOrDoubleIn() {
    if (_modeIn == SingleOrDouble.SingleField)
      setModeIn = SingleOrDouble.DoubleField;
    else
      setModeIn = SingleOrDouble.SingleField;

    notifyListeners();
  }

  void switchSingleOrDoubleOut() {
    if (_modeOut == SingleOrDouble.SingleField)
      setModeOut = SingleOrDouble.DoubleField;
    else
      setModeOut = SingleOrDouble.SingleField;

    notifyListeners();
  }

  void switchBestOfOrFirstTo() {
    if (_mode == BestOfOrFirstToEnum.BestOf) {
      setMode = BestOfOrFirstToEnum.FirstTo;
      if (_setsEnabled) {
        setLegs = 2;
        setSets = 3;
      } else
        setLegs = 5;
    } else {
      setMode = BestOfOrFirstToEnum.BestOf;
      setWinByTwoLegsDifference = false;
      if (_setsEnabled) {
        setSets = 5;
        setLegs = 3;
      } else
        setLegs = 11;
    }

    notifyListeners();
  }

  void setsClicked() {
    if (_mode == BestOfOrFirstToEnum.FirstTo) {
      setSets = 3;
      setLegs = 2;
    } else {
      setSets = 5;
      setLegs = 3;
    }

    setSetsEnabled = !_setsEnabled;
    notifyListeners();
  }

  void switchWinByTwoLegsDifference(bool value) {
    setWinByTwoLegsDifference = value;
    if (_winByTwoLegsDifference == true) {
      setSuddenDeath = false;
      setMaxExtraLegs = STANDARD_MAX_EXTRA_LEGS;
    }

    notifyListeners();
  }

  void removePlayer(Player playerToRemove) {
    getPlayers.remove(playerToRemove);

    //remove player from team
    outerLoop:
    for (Team team in getTeams) {
      for (Player player in team.getPlayers) {
        if (player == playerToRemove) {
          //remove team if no other player is in it
          if (team.getPlayers.length == 1) getTeams.remove(team);
          team.getPlayers.remove(playerToRemove);
          break outerLoop;
        }
      }
    }

    notifyListeners();
  }

  void checkBotNamingIds(Player player) {
    if (!(player is Bot)) return;

    int botNamingId =
        int.parse(player.getName.substring(player.getName.length - 1));
    getBotNamingIds.remove(botNamingId);

    if (getBotNamingIds.isEmpty || getBotNamingIds.last == botNamingId) return;

    int idCounter = 1;
    for (botNamingId in getBotNamingIds) {
      if (botNamingId != idCounter) {
        final int index = getBotNamingIds.indexOf(botNamingId);
        getBotNamingIds[index] = idCounter;
        _setNewBotNamingId(botNamingId, idCounter);
      }
      idCounter++;
    }
    notifyListeners();
  }

  void _setNewBotNamingId(int currentBotNamingId, int newBotNamingId) {
    for (Player player in getPlayers) {
      if (player is Bot) {
        final int botNamingId =
            int.parse(player.getName.substring(player.getName.length - 1));
        if (botNamingId == currentBotNamingId) {
          final String newBotName =
              player.getName.substring(0, player.getName.length - 1) +
                  newBotNamingId.toString();
          player.setName = newBotName;
        }
      }
    }
    notifyListeners();
  }

  void checkTeamNamingIds(Team team) {
    int teamNamingId =
        int.parse(team.getName.substring(team.getName.length - 1));
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
    if (getTeams.isEmpty)
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
      final int botNamingId = int.parse(
          playerToDelete.getName.substring(playerToDelete.getName.length - 1));
      getBotNamingIds.remove(botNamingId);
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

    if (getModeIn == SingleOrDouble.SingleField)
      result += 'Single In / ';
    else
      result += 'Double In / ';

    if (getModeOut == SingleOrDouble.SingleField)
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
    for (Player player in this.getPlayers) {
      defaultSettingsX01.playersNames.add(player.getName);
    }
    defaultSettingsX01.botNamingIds = this.getBotNamingIds;

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
    this.setCustomPoints = defaultSettingsX01.customPoints;
    this.setEnableCheckoutCounting = defaultSettingsX01.enableCheckoutCounting;
    this.setInputMethod = defaultSettingsX01.inputMethod;
    this.setLegs = defaultSettingsX01.legs;
    this.setMaxExtraLegs = defaultSettingsX01.maxExtraLegs;
    this.setMode = defaultSettingsX01.mode;
    this.setModeIn = defaultSettingsX01.modeIn;
    this.setModeOut = defaultSettingsX01.modeOut;
    this.setPoints = defaultSettingsX01.points;
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
    this.setPlayers = defaultSettingsX01.players;
    this.setBotNamingIds = defaultSettingsX01.botNamingIds;
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
        defaultSettingsX01.samePlayers(this.getPlayers)) {
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
        this.getPlayers.length == 0) {
      return true;
    }
    return false;
  }

  void initValues() {
    setPlayers = [];
    setBotNamingIds = [];
    setTeamNamingIds = [];

    setSingleOrTeam = DEFAULT_SINGLE_OR_TEAM;
    setMode = DEFAULT_MODE;
    setPoints = DEFAULT_POINTS;
    setCustomPoints = DEFAULT_CUSTOM_POINTS;
    setLegs = DEFAULT_LEGS;
    setSets = DEFAULT_SETS;
    setSetsEnabled = DEFAULT_SETS_ENABLED;
    setModeIn = DEFAULT_MODE_IN;
    setModeOut = DEFAULT_MODE_OUT;
    setWinByTwoLegsDifference = DEFAULT_WIN_BY_TWO_LEGS_DIFFERENCE;
    setSuddenDeath = DEFAULT_SUDDEN_DEATH;
    setMaxExtraLegs = DEFAULT_MAX_EXTRA_LEGS;
    setEnableCheckoutCounting = DEFAULT_ENABLE_CHECKOUT_COUNTING;
    setCheckoutCountingFinallyDisabled =
        DEFAULT_CHECKOUT_COUNTING_FINALLY_DISABLED;
    setShowAverage = DEFAULT_SHOW_AVG;
    setShowFinishWays = DEFAULT_SHOW_FINISH_WAYS;
    setShowThrownDartsPerLeg = DEFAULT_SHOW_THROWN_DARTS_PER_LEG;
    setShowLastThrow = DEFAULT_SHOW_LAST_THROW;
    setCallerEnabled = DEFAULT_CALLER_ENABLED;
    setVibrationFeedbackEnabled = DEFAULT_VIBRATION_FEEDBACK;
    setAutomaticallySubmitPoints = DEFAULT_AUTO_SUBMIT_POINTS;
    setShowMostScoredPoints = DEFAULT_SHOW_MOST_SCORED_POINTS;
    setInputMethod = DEFAULT_INPUT_METHOD;
    setShowInputMethodInGameScreen = DEFAULT_SHOW_INPUT_METHOD_IN_GAME_SCREEN;
  }
}
