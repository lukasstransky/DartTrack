import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings.dart';
import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/models/player_statistics/player_game_statistics_x01.dart';
import 'package:dart_app/models/team.dart';

import 'dart:developer';

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

  void switchSingleOrTeamMode() {
    setSingleOrTeam = _singleOrTeam == SingleOrTeamEnum.Single
        ? SingleOrTeamEnum.Team
        : SingleOrTeamEnum.Single;
    notifyListeners();
  }

  void switchSingleOrDoubleIn() {
    if (_modeIn == SingleOrDouble.SingleField) {
      setModeIn = SingleOrDouble.DoubleField;
    } else {
      setModeIn = SingleOrDouble.SingleField;
    }
    notifyListeners();
  }

  void switchSingleOrDoubleOut() {
    if (_modeOut == SingleOrDouble.SingleField) {
      setModeOut = SingleOrDouble.DoubleField;
    } else {
      setModeOut = SingleOrDouble.SingleField;
    }
    notifyListeners();
  }

  void switchBestOfOrFirstTo() {
    if (_mode == BestOfOrFirstToEnum.BestOf) {
      setMode = BestOfOrFirstToEnum.FirstTo;
      if (_setsEnabled) {
        setLegs = 2;
        setSets = 3;
      } else {
        setLegs = 5;
      }
    } else {
      setMode = BestOfOrFirstToEnum.BestOf;
      setWinByTwoLegsDifference = false;
      if (_setsEnabled) {
        setSets = 5;
        setLegs = 3;
      } else {
        setLegs = 11;
      }
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

  void removePlayer(Player player) {
    setPlayers = List.from(getPlayers)..remove(player);
    //remove player from team
    for (Team team in getTeams) {
      List<Player> players = team.getPlayers as List<Player>;
      for (Player p in players) {
        if (p == player) {
          //remove team if no other player is in it
          if (team.getPlayers.length == 1) {
            setTeams = List.from(getTeams)..remove(team);
          }
          team.setPlayers = List.from(players)..remove(player);
        }
      }
    }
    notifyListeners();
  }

  void addPlayer(Player player) {
    setPlayers = [...getPlayers, player];
    //add a Team to each Player in case someone adds Players in the Single mode & then switches to Teams mode -> automatically assigned Teams

    if (getTeams.isEmpty) {
      Team team = new Team(name: "Team");
      team.setPlayers = [...team.getPlayers, player];
      setTeams = [...getTeams, team];
    } else {
      bool foundExistingTeam = false;
      for (Team team in getTeams) {
        List<Player> players = team.getPlayers as List<Player>;
        if (players.length < 2) {
          team.setPlayers = [...players, player];
          foundExistingTeam = true;
          break;
        }
      }
      if (foundExistingTeam == false) {
        Team team = new Team(name: "Team");
        team.setPlayers = [...team.getPlayers, player];
        setTeams = [...getTeams, team];
      }
    }

    notifyListeners();
  }

  void addNewPlayerToSpecificTeam(Player playerToAdd, Team? teamToAdd) {
    setPlayers = [...getPlayers, playerToAdd];
    for (Team team in getTeams) {
      if (team == teamToAdd) {
        List<Player> players = team.getPlayers as List<Player>;
        team.setPlayers = [...players, playerToAdd];
      }
    }
    notifyListeners();
  }

  void addNewTeam(String teamName) {
    Team newTeam = new Team(name: teamName);
    setTeams = [...getTeams, newTeam];
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
    if (count == 1) {
      return team;
    }

    return null;
  }

  //checks if its possible to add an player to a team -> e.g. there is 1 team with the MAX players in the team -> should not be possible to add a player, instead only possible to add a team
  bool possibleToAddPlayer() {
    for (Team t in getTeams) {
      if (t.getPlayers.length < MAX_PLAYERS_PER_TEAM) {
        return true;
      }
    }

    return false;
  }

  //for swaping team -> if only one other team is available than the current one -> swap immediately instead of showing 1 radio button
  Team? checkIfMultipleTeamsToAddExceptCurrentTeam(Player playerToSwap) {
    Team? currentTeam = getTeamOfPlayer(playerToSwap);
    int count = 0;
    Team? team;

    for (Team t in getTeams) {
      if (t.getPlayers.length < MAX_PLAYERS_PER_TEAM && t != currentTeam) {
        count++;
        team = t;
      }
    }
    if (count == 1) {
      return team;
    }

    return null;
  }

  Team? getTeamOfPlayer(Player player) {
    for (Team t in getTeams) {
      for (Player p in t.getPlayers) {
        if (p == player) {
          return t;
        }
      }
    }

    return null;
  }

  void swapTeam(Player playerToSwap, Team? newTeam) {
    Team? currentTeam = getTeamOfPlayer(playerToSwap);
    for (Team t in getTeams) {
      if (t == currentTeam) {
        //remove player in current team
        t.setPlayers = List.from(t.getPlayers)..remove(playerToSwap);
      }
      if (t == newTeam) {
        //add player in new team
        t.setPlayers = [...t.getPlayers, playerToSwap];
      }
    }
    notifyListeners();
  }

  List<Team> getPossibleTeamsToSwap(Player playerToSwap) {
    Team? currentTeam = getTeamOfPlayer(playerToSwap);
    List<Team> result = [];

    for (Team t in getTeams) {
      if (t != currentTeam) {
        result = [...result, t];
      }
    }

    return result;
  }

  void deleteTeam(Team teamToDelete) {
    for (Team t in getTeams) {
      if (t == teamToDelete) {
        setTeams = List.from(getTeams)..remove(teamToDelete);

        for (Player playerToDelete in t.getPlayers) {
          setPlayers = List.from(getPlayers)..remove(playerToDelete);
        }
      }
    }

    notifyListeners();
  }

  bool checkIfTeamNameExists(String? teamNameToCheck) {
    for (Team t in getTeams) {
      if (t.getName == teamNameToCheck) {
        return true;
      }
    }
    return false;
  }

  bool checkIfPlayerNameExists(String? playerNameToCheck) {
    for (Player p in getPlayers) {
      if (p.getName == playerNameToCheck) {
        return true;
      }
    }
    return false;
  }

  bool checkIfPlayerAlreadyInserted(Player playerToInsert) {
    for (Player p in getPlayers) {
      if (p.getName == playerToInsert.getName) {
        return true;
      }
    }
    return false;
  }

  void updateTeamName(String newTeamName, Team teamToUpdate) {
    teamToUpdate.setName = newTeamName;
    notifyListeners();
  }

  void updatePlayerName(String newPlayerName, Player playerToUpdate) {
    playerToUpdate.setName = newPlayerName;
    notifyListeners();
  }

  void notify() {
    notifyListeners();
  }

  void setBeginnerPlayer(Player? playerToSet) {
    int index = 0;
    for (int i = 0; i < getPlayers.length; i++) {
      if (getPlayers[i] == playerToSet) {
        index = i;
      }
    }

    //otherwise player is already first in list
    if (index != 0) {
      Player temp = getPlayers[0];
      getPlayers[0] = playerToSet as Player;
      getPlayers[index] = temp;
    }
  }

  void setBeginnerTeam(Team? teamToSet) {
    int index = 0;
    for (int i = 0; i < getTeams.length; i++) {
      if (getTeams[i] == teamToSet) {
        index = i;
      }
    }

    //otherwise team is already first in list
    if (index != 0) {
      Team temp = getTeams[0];
      getTeams[0] = teamToSet as Team;
      getTeams[index] = temp;
    }
  }

  int getPointsOrCustom() {
    if (getCustomPoints != -1) {
      return getCustomPoints;
    }
    return getPoints;
  }

  void switchInputMethod(GameX01 gameX01) {
    if (getInputMethod == InputMethod.Round) {
      setInputMethod = InputMethod.ThreeDarts;
    } else {
      setInputMethod = InputMethod.Round;

      //in case user enters e.g. 1 or 2 darts in three dart mode -> switches to round mode
      if (gameX01.getInit) {
        PlayerGameStatisticsX01? stats =
            gameX01.getCurrentPlayerGameStatistics();
        int currentPointsEntered =
            int.parse(gameX01.getCurrentThreeDartsCalculated());
        stats.setCurrentPoints = stats.getCurrentPoints + currentPointsEntered;
        gameX01.resetCurrentThreeDarts();
      }
    }

    notifyListeners();
  }

  String getGameMode() {
    String result = "";
    if (getMode == BestOfOrFirstToEnum.BestOf)
      result += "Best Of ";
    else
      result += "First To ";

    if (getSetsEnabled) {
      if (getSets > 1)
        result += getSets.toString() + " Sets - ";
      else
        result += getSets.toString() + " Set - ";
    }
    if (getLegs > 1)
      result += getLegs.toString() + " Legs";
    else
      result += getLegs.toString() + " Leg";

    return result;
  }

  String getGameModeDetails(bool showPoints) {
    String result = "";

    if (showPoints) {
      if (getCustomPoints != -1)
        result += getCustomPoints.toString() + " / ";
      else
        result += getPoints.toString() + " / ";
    }

    if (getModeIn == SingleOrDouble.SingleField)
      result += "Single In / ";
    else
      result += "Double In / ";

    if (getModeOut == SingleOrDouble.SingleField)
      result += "Single Out";
    else
      result += "Double Out";

    if (getSuddenDeath)
      result += " / SD - after " + getMaxExtraLegs.toString() + " Legs";

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
    for (Player player in getPlayers) {
      if (player.getName == context.read<AuthService>().getPlayer!.getName) {
        return true;
      }
    }
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
