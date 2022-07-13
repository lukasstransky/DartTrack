import 'package:dart_app/constants.dart';
import 'package:dart_app/models/bot.dart';
import 'package:dart_app/models/game_settings/game_settings.dart';
import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/models/player_statistics/player_game_statistics_x01.dart';
import 'package:dart_app/models/team.dart';

import 'package:dart_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameSettingsX01 extends GameSettings {
  SingleOrTeamEnum _singleOrTeam = SingleOrTeamEnum.Single;
  BestOfOrFirstToEnum _mode = BestOfOrFirstToEnum.FirstTo;
  int _points = 301;
  int _customPoints = -1;
  int _legs = 1;
  int _sets = 5;
  bool _setsEnabled = false;
  SingleOrDouble _modeIn = SingleOrDouble.SingleField;
  SingleOrDouble _modeOut = SingleOrDouble.DoubleField;
  bool _winByTwoLegsDifference = false;
  bool _suddenDeath = false;
  int _maxExtraLegs = 2;
  bool _enableCheckoutCounting = false;
  bool _checkoutCountingFinallyDisabled =
      false; //if user disables checkout counting in the in game settings -> cant be reversed (cause of inconsistent stats then)
  bool _showAverage = true;
  bool _showFinishWays = true;
  bool _showThrownDartsPerLeg = true;
  bool _showLastThrow = true;
  bool _callerEnabled = false;
  bool _vibrationFeedbackEnabled = false;
  bool _automaticallySubmitPoints = true;
  bool _showMostScoredPoints = false;
  InputMethod _inputMethod = InputMethod.Round;
  bool _showInputMethodInGameScreen = false;
  List<int> _botNamingIds = [];
  List<int> _teamNamingIds = [];

  GameSettingsX01() {}

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
        notifyListeners(),
      };

  int get getCustomPoints => this._customPoints;
  set setCustomPoints(int customPoints) => {
        this._customPoints = customPoints,
        notifyListeners(),
      };

  int get getLegs => this._legs;
  set setLegs(int legs) => {
        this._legs = legs,
        notifyListeners(),
      };

  int get getSets => this._sets;
  set setSets(int sets) => {
        this._sets = sets,
        notifyListeners(),
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
        notifyListeners(),
      };

  int get getMaxExtraLegs => this._maxExtraLegs;
  set setMaxExtraLegs(int maxLegDifference) => {
        this._maxExtraLegs = maxLegDifference,
        notifyListeners(),
      };

  bool get getEnableCheckoutCounting => this._enableCheckoutCounting;
  set setEnableCheckoutCounting(bool enableCheckoutCounting) => {
        this._enableCheckoutCounting = enableCheckoutCounting,
        notifyListeners(),
      };

  bool get getCheckoutCountingFinallyDisabled =>
      this._checkoutCountingFinallyDisabled;
  set setCheckoutCountingFinallyDisabled(
          bool checkoutCountingFinallyDisabled) =>
      {
        this._checkoutCountingFinallyDisabled = checkoutCountingFinallyDisabled,
        notifyListeners(),
      };

  bool get getShowAverage => this._showAverage;
  set setShowAverage(bool showAverage) => {
        this._showAverage = showAverage,
        notifyListeners(),
      };

  bool get getShowFinishWays => this._showFinishWays;
  set setShowFinishWays(bool showFinishWays) => {
        this._showFinishWays = showFinishWays,
        notifyListeners(),
      };

  bool get getShowThrownDartsPerLeg => this._showThrownDartsPerLeg;
  set setShowThrownDartsPerLeg(bool showThrownDartsPerLeg) => {
        this._showThrownDartsPerLeg = showThrownDartsPerLeg,
        notifyListeners(),
      };

  bool get getShowLastThrow => this._showLastThrow;
  set setShowLastThrow(bool showLastThrow) => {
        this._showLastThrow = showLastThrow,
        notifyListeners(),
      };

  bool get getCallerEnabled => this._callerEnabled;
  set setCallerEnabled(bool callerEnabled) => {
        this._callerEnabled = callerEnabled,
        notifyListeners(),
      };

  bool get getVibrationFeedbackEnabled => this._vibrationFeedbackEnabled;
  set setVibrationFeedbackEnabled(bool vibrationFeedbackEnabled) => {
        this._vibrationFeedbackEnabled = vibrationFeedbackEnabled,
        notifyListeners(),
      };

  bool get getAutomaticallySubmitPoints => this._automaticallySubmitPoints;
  set setAutomaticallySubmitPoints(bool automaticallySubmitPoints) => {
        this._automaticallySubmitPoints = automaticallySubmitPoints,
        notifyListeners(),
      };

  bool get getShowMostScoredPoints => this._showMostScoredPoints;
  set setShowMostScoredPoints(bool showMostScoredPoints) => {
        this._showMostScoredPoints = showMostScoredPoints,
        notifyListeners(),
      };

  InputMethod get getInputMethod => this._inputMethod;
  set setInputMethod(InputMethod inputMethod) =>
      this._inputMethod = inputMethod;

  bool get getShowInputMethodInGameScreen => this._showInputMethodInGameScreen;
  set setShowInputMethodInGameScreen(bool showInputMethodInGameScreen) {
    this._showInputMethodInGameScreen = showInputMethodInGameScreen;
    notifyListeners();
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

  void resetValues() {
    _singleOrTeam = SingleOrTeamEnum.Single;
    setTeams = [];
    setPlayers = [];
    _mode = BestOfOrFirstToEnum.FirstTo;
    _points = 301;
    _customPoints = -1;
    _legs = 1;
    _sets = 5;
    _setsEnabled = false;
    _modeIn = SingleOrDouble.SingleField;
    _modeOut = SingleOrDouble.DoubleField;
    _winByTwoLegsDifference = false;
    _suddenDeath = false;
    _maxExtraLegs = 2;
    _enableCheckoutCounting = false;
    _checkoutCountingFinallyDisabled = false;
    _showAverage = true;
    _showFinishWays = true;
    _showThrownDartsPerLeg = true;
    _showLastThrow = true;
    _callerEnabled = false;
    _vibrationFeedbackEnabled = false;
    _automaticallySubmitPoints = true;
    _showMostScoredPoints = false;
    _inputMethod = InputMethod.Round;
    _showInputMethodInGameScreen = false;
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
}
