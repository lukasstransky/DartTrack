import 'package:dart_app/constants.dart';
import 'package:dart_app/models/bot.dart';
import 'package:dart_app/models/game_settings/game_settings.dart';
import 'package:dart_app/models/player.dart';
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

  removePlayer(Player playerToRemove, bool removeTeam) {
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

  checkTeamNamingIds(Team team) {
    final String lastCharFromTeamName =
        team.getName.substring(team.getName.length - 1);
    if (!team.getName.startsWith('Team ') &&
        int.tryParse(lastCharFromTeamName) == null) return;

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

  _setNewTeamNamingId(int currentTeamNamingId, int newTeamNamingId) {
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

  addPlayer(Player player) {
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

  _createTeamAndAddPlayer(Player player) {
    final int teamNameId = getTeamNamingIds.length + 1;
    final Team team = new Team(name: 'Team $teamNameId');

    team.getPlayers.add(player);
    getTeams.add(team);
    getTeamNamingIds.add(teamNameId);
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

  notify() {
    notifyListeners();
  }

  int getPointsOrCustom() {
    if (getCustomPoints != -1) return getCustomPoints;

    return getPoints;
  }

  bool isCurrentUserInPlayers(BuildContext context) {
    final String currentPlayerName =
        context.read<AuthService>().getPlayer!.getName;

    for (Player player in getPlayers)
      if (player.getName == currentPlayerName) return true;

    return false;
  }

  int getCountOfBotPlayers() {
    int count = 0;
    for (Player player in getPlayers) {
      if (player is Bot) count++;
    }

    return count;
  }
}
