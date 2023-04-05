import 'package:dart_app/constants.dart';
import 'package:dart_app/models/bot.dart';
import 'package:dart_app/models/game_settings/game_settings_p.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/models/team.dart';

class GameSettingsX01_P extends GameSettings_P {
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
  bool _vibrationFeedbackEnabled = DEFAULT_VIBRATION_FEEDBACK;
  bool _automaticallySubmitPoints = DEFAULT_AUTO_SUBMIT_POINTS;
  bool _showMostScoredPoints = DEFAULT_SHOW_MOST_SCORED_POINTS;
  List<String> _mostScoredPoints = <String>[];
  InputMethod _inputMethod = DEFAULT_INPUT_METHOD;
  bool _showInputMethodInGameScreen = DEFAULT_SHOW_INPUT_METHOD_IN_GAME_SCREEN;

  bool _drawMode = DEFAULT_DRAW_MODE;
  List<int> _teamNamingIds = <int>[];

  GameSettingsX01_P();

  GameSettingsX01_P.firestore({
    required bool checkoutCounting,
    required int legs,
    required int sets,
    required ModeOutIn modeIn,
    required ModeOutIn modeOut,
    required BestOfOrFirstToEnum mode,
    required int points,
    required SingleOrTeamEnum singleOrTeam,
    required bool winByTwoLegsDifference,
    required bool suddenDeath,
    required int maxExtraLegs,
    required bool drawMode,
    required bool setsEnabled,
    required InputMethod inputMethod,
    required bool showAverage,
    required bool showFinishWays,
    required bool showLastThrow,
    required bool showThrownDartsPerLeg,
    required bool vibrationFeedbackEnabled,
    required bool showInputMethodInGameScreen,
    required bool showMostScoredPoints,
    required List<String> mostScoredPoints,
    required bool automaticallySubmitPoints,
    required bool checkoutCountingFinallyDisabled,
    List<Player>? players,
    List<Team>? teams,
  }) {
    _enableCheckoutCounting = checkoutCounting;
    _legs = legs;
    _sets = sets;
    _modeIn = modeIn;
    _modeOut = modeOut;
    _mode = mode;
    _points = points;
    _singleOrTeam = singleOrTeam;
    _winByTwoLegsDifference = winByTwoLegsDifference;
    _suddenDeath = suddenDeath;
    _maxExtraLegs = maxExtraLegs;
    _drawMode = drawMode;
    _setsEnabled = setsEnabled;
    _showAverage = showAverage;
    _showFinishWays = showFinishWays;
    _showLastThrow = showLastThrow;
    _showThrownDartsPerLeg = showThrownDartsPerLeg;
    _vibrationFeedbackEnabled = vibrationFeedbackEnabled;
    _showInputMethodInGameScreen = showInputMethodInGameScreen;
    _showMostScoredPoints = showMostScoredPoints;
    _mostScoredPoints = mostScoredPoints;
    _automaticallySubmitPoints = automaticallySubmitPoints;
    _checkoutCountingFinallyDisabled = checkoutCountingFinallyDisabled;
    _inputMethod = inputMethod;

    if (players != null) {
      setPlayers = players;
    }
    if (teams != null) {
      setTeams = teams;
    }
  }

  SingleOrTeamEnum get getSingleOrTeam => _singleOrTeam;
  set setSingleOrTeam(SingleOrTeamEnum _singleOrTeam) =>
      this._singleOrTeam = _singleOrTeam;

  BestOfOrFirstToEnum get getMode => _mode;
  set setMode(BestOfOrFirstToEnum mode) => _mode = mode;

  int get getPoints => _points;
  set setPoints(int points) => {
        _points = points,
        _customPoints = -1,
      };

  int get getCustomPoints => _customPoints;
  set setCustomPoints(int customPoints) => _customPoints = customPoints;

  int get getLegs => _legs;
  set setLegs(int legs) => _legs = legs;

  int get getSets => _sets;
  set setSets(int sets) => _sets = sets;

  bool get getSetsEnabled => _setsEnabled;
  set setSetsEnabled(bool setsEnabled) => _setsEnabled = setsEnabled;

  ModeOutIn get getModeIn => _modeIn;
  set setModeIn(ModeOutIn modeIn) => _modeIn = modeIn;

  ModeOutIn get getModeOut => _modeOut;
  set setModeOut(ModeOutIn modeOut) => _modeOut = modeOut;

  bool get getWinByTwoLegsDifference => _winByTwoLegsDifference;
  set setWinByTwoLegsDifference(bool winByTwoLegsDifference) =>
      _winByTwoLegsDifference = winByTwoLegsDifference;

  bool get getSuddenDeath => _suddenDeath;
  set setSuddenDeath(bool suddenDeath) => _suddenDeath = suddenDeath;

  int get getMaxExtraLegs => _maxExtraLegs;
  set setMaxExtraLegs(int maxLegDifference) => _maxExtraLegs = maxLegDifference;

  bool get getEnableCheckoutCounting => _enableCheckoutCounting;
  set setEnableCheckoutCounting(bool enableCheckoutCounting) =>
      _enableCheckoutCounting = enableCheckoutCounting;

  bool get getCheckoutCountingFinallyDisabled =>
      _checkoutCountingFinallyDisabled;
  set setCheckoutCountingFinallyDisabled(
          bool checkoutCountingFinallyDisabled) =>
      _checkoutCountingFinallyDisabled = checkoutCountingFinallyDisabled;

  bool get getShowAverage => _showAverage;
  set setShowAverage(bool showAverage) => _showAverage = showAverage;

  bool get getShowFinishWays => _showFinishWays;
  set setShowFinishWays(bool showFinishWays) =>
      _showFinishWays = showFinishWays;

  bool get getShowThrownDartsPerLeg => _showThrownDartsPerLeg;
  set setShowThrownDartsPerLeg(bool showThrownDartsPerLeg) =>
      _showThrownDartsPerLeg = showThrownDartsPerLeg;

  bool get getShowLastThrow => _showLastThrow;
  set setShowLastThrow(bool showLastThrow) => _showLastThrow = showLastThrow;

  bool get getVibrationFeedbackEnabled => _vibrationFeedbackEnabled;
  set setVibrationFeedbackEnabled(bool vibrationFeedbackEnabled) =>
      _vibrationFeedbackEnabled = vibrationFeedbackEnabled;

  bool get getAutomaticallySubmitPoints => _automaticallySubmitPoints;
  set setAutomaticallySubmitPoints(bool automaticallySubmitPoints) =>
      _automaticallySubmitPoints = automaticallySubmitPoints;

  bool get getShowMostScoredPoints => _showMostScoredPoints;
  set setShowMostScoredPoints(bool showMostScoredPoints) =>
      _showMostScoredPoints = showMostScoredPoints;

  List<String> get getMostScoredPoints => _mostScoredPoints;
  set setMostScoredPoints(List<String> value) => _mostScoredPoints = value;

  InputMethod get getInputMethod => _inputMethod;
  set setInputMethod(InputMethod inputMethod) => _inputMethod = inputMethod;

  bool get getShowInputMethodInGameScreen => _showInputMethodInGameScreen;
  set setShowInputMethodInGameScreen(bool showInputMethodInGameScreen) {
    _showInputMethodInGameScreen = showInputMethodInGameScreen;
  }

  bool get getDrawMode => _drawMode;
  set setDrawMode(bool value) => _drawMode = value;

  List<int> get getTeamNamingIds => _teamNamingIds;
  set setTeamNamingIds(List<int> value) => _teamNamingIds = value;

  void removePlayer(Player playerToRemove, bool removeTeam) {
    getPlayers.removeWhere((Player p) => p.getName == playerToRemove.getName);

    //remove also player from team -> not same references as in single players list
    if (getSingleOrTeam == SingleOrTeamEnum.Single) {
      Team? emptyTeamToRemove;
      for (Team team in getTeams) {
        team.getPlayers
            .removeWhere((Player p) => p.getName == playerToRemove.getName);
        if (team.getPlayers.isEmpty) {
          emptyTeamToRemove = team;
        }
      }
      if (emptyTeamToRemove != null) {
        getTeams.remove(emptyTeamToRemove);
        checkTeamNamingIds(emptyTeamToRemove);
      }
    }

    //remove player from team
    outerLoop:
    for (Team team in getTeams) {
      for (Player player in team.getPlayers) {
        if (player == playerToRemove) {
          if (playerToRemove is Bot &&
              playerToRemove.getName == 'Bot1' &&
              getCountOfBotPlayers() == 2) {
            getPlayers
                .where((Player player) =>
                    player is Bot && player.getName == 'Bot2')
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
    if (!team.getName.startsWith('Team ') ||
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
    assignOrCreateTeamForPlayer(player);
    notifyListeners();
  }

  //add a Team to each Player in case someone adds Players in the Single mode & then switches to Teams mode -> automatically assigned Teams
  void assignOrCreateTeamForPlayer(Player player) {
    if (getTeams.isEmpty || getPlayers.length == 2)
      _createTeamAndAddPlayer(player);
    else {
      bool foundTeamWithLessTwoPlayers = false;
      for (Team team in getTeams) {
        if (team.getPlayers.length < MAX_PLAYERS_IN_TEAM_FOR_AUTO_ASSIGNING) {
          team.getPlayers.add(Player.clone(player));
          foundTeamWithLessTwoPlayers = true;
          break;
        }
      }
      if (!foundTeamWithLessTwoPlayers) _createTeamAndAddPlayer(player);
    }
  }

  void _createTeamAndAddPlayer(Player player) {
    final int teamNameId = getTeamNamingIds.length + 1;
    final Team team = Team(name: 'Team $teamNameId');

    team.getPlayers.add(Player.clone(player));
    getTeams.add(team);
    getTeamNamingIds.add(teamNameId);
  }

  bool checkIfTeamNameExists(String? teamNameToCheck) {
    for (Team team in getTeams)
      if (team.getName == teamNameToCheck) return true;

    return false;
  }

  @override
  void notify() {
    notifyListeners();
  }

  int getPointsOrCustom() {
    if (getCustomPoints != -1) {
      return getCustomPoints;
    }

    return getPoints;
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

  String getGameModeDetails(bool showPoints) {
    String result = '';

    if (showPoints) {
      if (getCustomPoints != -1) {
        result += '${getCustomPoints.toString()} - ';
      } else {
        result += '${getPoints.toString()} - ';
      }
    }

    switch (getModeIn) {
      case ModeOutIn.Single:
        result += 'Single in - ';
        break;
      case ModeOutIn.Double:
        result += 'Double in - ';
        break;
      case ModeOutIn.Master:
        result += 'Master in - ';
        break;
    }

    switch (getModeOut) {
      case ModeOutIn.Single:
        result += 'Single out';
        break;
      case ModeOutIn.Double:
        result += 'Double out';
        break;
      case ModeOutIn.Master:
        result += 'Master out';
        break;
    }

    return result;
  }

  String getSuddenDeathInfo() {
    return '(Sudden death - after max. ${getMaxExtraLegs.toString()} leg${getMaxExtraLegs > 1 ? 's' : ''})';
  }

  String getGameMode() {
    String result = '';

    if (getMode == BestOfOrFirstToEnum.BestOf) {
      result += 'Best of ';
    } else {
      result += 'First to ';
    }

    if (getSetsEnabled) {
      if (getSets > 1) {
        result += '${getSets.toString()} sets - ';
      } else {
        result += '${getSets.toString()} set - ';
      }
    }
    if (getLegs > 1) {
      result += '${getLegs.toString()} legs';
    } else {
      result += '${getLegs.toString()} leg';
    }

    return result;
  }

  Player getPlayerFromTeam(String playerName) {
    late Player result;
    for (Team team in getTeams) {
      for (Player player in team.getPlayers) {
        if (player.getName == playerName) {
          result = player;
        }
      }
    }
    return result;
  }

  Player? getPlayerFromSingles(String playerName) {
    Player? result;
    for (Player player in getPlayers) {
      if (player.getName == playerName) {
        result = player;
      }
    }
    return result;
  }

  Team findTeamForPlayer(
      String playerNameToFind, GameSettingsX01_P gameSettingsX01) {
    late Team result;
    for (Team team in gameSettingsX01.getTeams) {
      for (Player player in team.getPlayers) {
        if (player.getName == playerNameToFind) result = team;
      }
    }

    return result;
  }
}
