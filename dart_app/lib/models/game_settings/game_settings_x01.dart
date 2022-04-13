import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings.dart';
import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/models/player_statistics/player_game_statistics_x01.dart';
import 'package:dart_app/models/team.dart';

import 'dart:developer';

class GameSettingsX01 extends GameSettings {
  SingleOrTeamEnum _singleOrTeam = SingleOrTeamEnum.Single;
  List<Team> _teams = []; //todo
  List<Player> _players = [];
  BestOfOrFirstToEnum _mode = BestOfOrFirstToEnum.FirstTo;
  int _points = 301;
  int _customPoints = -1;
  int _legs = 1;
  int _sets = 3;
  bool _setsEnabled = false;
  SingleOrDouble _modeIn = SingleOrDouble.SingleField;
  SingleOrDouble _modeOut = SingleOrDouble.DoubleField;
  bool _winByTwoLegsDifference = false;
  bool _suddenDeath = false;
  int? _maxExtraLegs = 2;
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

  get getSingleOrTeam => this._singleOrTeam;
  set setSingleOrTeam(SingleOrTeamEnum _singleOrTeam) =>
      this._singleOrTeam = _singleOrTeam;

  get getTeams => this._teams;

  get getPlayers => this._players;

  get getMode => this._mode;
  set setMode(BestOfOrFirstToEnum mode) => this._mode = mode;

  get getPoints => this._points;
  set setPoints(int points) => {
        this._points = points,
        this._customPoints = -1,
        notifyListeners(),
      };

  get getCustomPoints => this._customPoints;
  set setCustomPoints(int customPoints) => {
        this._customPoints = customPoints,
        notifyListeners(),
      };

  get getLegs => this._legs;
  set setLegs(int legs) => {
        this._legs = legs,
        notifyListeners(),
      };

  get getSets => this._sets;
  set setSets(int sets) => {
        this._sets = sets,
        notifyListeners(),
      };

  get getSetsEnabled => this._setsEnabled;
  set setSetsEnabled(bool setsEnabled) => this._setsEnabled = setsEnabled;

  get getModeIn => this._modeIn;
  set setModeIn(SingleOrDouble modeIn) => this._modeIn = modeIn;

  get getModeOut => this._modeOut;
  set setModeOut(SingleOrDouble modeOut) => this._modeOut = modeOut;

  get getWinByTwoLegsDifference => this._winByTwoLegsDifference;
  set setWinByTwoLegsDifference(bool winByTwoLegsDifference) =>
      this._winByTwoLegsDifference = winByTwoLegsDifference;

  get getSuddenDeath => this._suddenDeath;
  set setSuddenDeath(bool suddenDeath) => {
        this._suddenDeath = suddenDeath,
        notifyListeners(),
      };

  get getMaxExtraLegs => this._maxExtraLegs;
  set setMaxExtraLegs(int? maxLegDifference) => {
        this._maxExtraLegs = maxLegDifference,
        notifyListeners(),
      };

  get getEnableCheckoutCounting => this._enableCheckoutCounting;
  set setEnableCheckoutCounting(bool enableCheckoutCounting) => {
        this._enableCheckoutCounting = enableCheckoutCounting,
        notifyListeners(),
      };

  get getCheckoutCountingFinallyDisabled =>
      this._checkoutCountingFinallyDisabled;
  set setCheckoutCountingFinallyDisabled(
          bool checkoutCountingFinallyDisabled) =>
      {
        this._checkoutCountingFinallyDisabled = checkoutCountingFinallyDisabled,
        notifyListeners(),
      };

  get getShowAverage => this._showAverage;
  set setShowAverage(bool showAverage) => {
        this._showAverage = showAverage,
        notifyListeners(),
      };

  get getShowFinishWays => this._showFinishWays;
  set setShowFinishWays(bool showFinishWays) => {
        this._showFinishWays = showFinishWays,
        notifyListeners(),
      };

  get getShowThrownDartsPerLeg => this._showThrownDartsPerLeg;
  set setShowThrownDartsPerLeg(bool showThrownDartsPerLeg) => {
        this._showThrownDartsPerLeg = showThrownDartsPerLeg,
        notifyListeners(),
      };

  get getShowLastThrow => this._showLastThrow;
  set setShowLastThrow(bool showLastThrow) => {
        this._showLastThrow = showLastThrow,
        notifyListeners(),
      };

  get getCallerEnabled => this._callerEnabled;
  set setCallerEnabled(bool callerEnabled) => {
        this._callerEnabled = callerEnabled,
        notifyListeners(),
      };

  get getVibrationFeedbackEnabled => this._vibrationFeedbackEnabled;
  set setVibrationFeedbackEnabled(bool vibrationFeedbackEnabled) => {
        this._vibrationFeedbackEnabled = vibrationFeedbackEnabled,
        notifyListeners(),
      };

  get getAutomaticallySubmitPoints => this._automaticallySubmitPoints;
  set setAutomaticallySubmitPoints(bool automaticallySubmitPoints) => {
        this._automaticallySubmitPoints = automaticallySubmitPoints,
        notifyListeners(),
      };

  get getShowMostScoredPoints => this._showMostScoredPoints;
  set setShowMostScoredPoints(bool showMostScoredPoints) => {
        this._showMostScoredPoints = showMostScoredPoints,
        notifyListeners(),
      };

  get getInputMethod => this._inputMethod;
  set setInputMethod(InputMethod inputMethod) =>
      this._inputMethod = inputMethod;

  get getShowInputMethodInGameScreen => this._showInputMethodInGameScreen;
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
    if (_setsEnabled == false) {
      setSetsEnabled = true;
    } else {
      setSetsEnabled = false;
    }
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
    _players = List.from(_players)..remove(player);
    //remove player from team
    for (Team team in _teams) {
      List<Player> players = team.getPlayers as List<Player>;
      for (Player p in players) {
        if (p == player) {
          //remove team if no other player is in it
          if (team.getPlayers.length == 1) {
            _teams = List.from(_teams)..remove(team);
          }
          team.setPlayers = List.from(players)..remove(player);
        }
      }
    }
    notifyListeners();
  }

  void addPlayer(Player player) {
    _players = [..._players, player];
    //add a Team to each Player in case someone adds Players in the Single mode & then switches to Teams mode -> automatically assigned Teams

    if (_teams.isEmpty) {
      Team team = new Team(name: "Team");
      team.setPlayers = [...team.getPlayers, player];
      _teams = [..._teams, team];
    } else {
      bool foundExistingTeam = false;
      for (Team team in _teams) {
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
        _teams = [..._teams, team];
      }
    }

    notifyListeners();
  }

  void addNewPlayerToSpecificTeam(Player playerToAdd, Team? teamToAdd) {
    _players = [..._players, playerToAdd];
    for (Team team in _teams) {
      if (team == teamToAdd) {
        List<Player> players = team.getPlayers as List<Player>;
        team.setPlayers = [...players, playerToAdd];
      }
    }
    notifyListeners();
  }

  void addNewTeam(String teamName) {
    Team newTeam = new Team(name: teamName);
    _teams = [..._teams, newTeam];
    notifyListeners();
  }

  //checks if player can be added to only one team -> return that team (prevent to show only 1 radio button in selecting team dialog)
  Team? checkIfMultipleTeamsToAdd() {
    int count = 0;
    Team? team;

    for (Team t in _teams) {
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
    for (Team t in _teams) {
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

    for (Team t in _teams) {
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
    for (Team t in _teams) {
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
    for (Team t in _teams) {
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

    for (Team t in _teams) {
      if (t != currentTeam) {
        result = [...result, t];
      }
    }

    return result;
  }

  void deleteTeam(Team teamToDelete) {
    for (Team t in _teams) {
      if (t == teamToDelete) {
        _teams = List.from(_teams)..remove(teamToDelete);

        for (Player playerToDelete in t.getPlayers) {
          _players = List.from(_players)..remove(playerToDelete);
        }
      }
    }

    notifyListeners();
  }

  bool checkIfTeamNameExists(String? teamNameToCheck) {
    for (Team t in _teams) {
      if (t.getName == teamNameToCheck) {
        return true;
      }
    }
    return false;
  }

  bool checkIfPlayerNameExists(String? playerNameToCheck) {
    for (Player p in _players) {
      if (p.getName == playerNameToCheck) {
        return true;
      }
    }
    return false;
  }

  bool checkIfPlayerAlreadyInserted(Player playerToInsert) {
    for (Player p in _players) {
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
    for (int i = 0; i < _players.length; i++) {
      if (_players[i] == playerToSet) {
        index = i;
      }
    }

    //otherwise player is already first in list
    if (index != 0) {
      Player temp = _players[0];
      _players[0] = playerToSet as Player;
      _players[index] = temp;
    }
  }

  void setBeginnerTeam(Team? teamToSet) {
    int index = 0;
    for (int i = 0; i < _teams.length; i++) {
      if (_teams[i] == teamToSet) {
        index = i;
      }
    }

    //otherwise team is already first in list
    if (index != 0) {
      Team temp = _teams[0];
      _teams[0] = teamToSet as Team;
      _teams[index] = temp;
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
}
