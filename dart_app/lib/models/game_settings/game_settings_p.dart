import 'package:dart_app/constants.dart';
import 'package:dart_app/models/bot.dart';
import 'package:dart_app/models/game_settings/game_settings_cricket_p.dart';
import 'package:dart_app/models/game_settings/game_settings_score_training_p.dart';
import 'package:dart_app/models/game_settings/game_settings_single_double_training_p.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/models/team.dart';
import 'package:dart_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameSettings_P with ChangeNotifier {
  List<Team> _teams = [];
  List<int> _teamNamingIds = <int>[];
  List<Player> _players = [];

  List<Team> get getTeams => this._teams;
  set setTeams(List<Team> value) => this._teams = value;

  List<int> get getTeamNamingIds => _teamNamingIds;
  set setTeamNamingIds(List<int> value) => _teamNamingIds = value;

  List<Player> get getPlayers => this._players;
  set setPlayers(List<Player> value) => this._players = value;

  GameSettings_P() {}

  Map<String, dynamic> toMapX01(GameSettingsX01_P settings, bool openGame) {
    Map<String, dynamic> result = {
      'players': settings.getPlayers.map((player) {
        return player.toMap(player);
      }).toList(),
      'singleOrTeam': settings.getSingleOrTeam.toString().split('.').last,
      'legs': settings.getLegs,
      if (settings.getSetsEnabled) 'sets': settings.getSets,
      'setsEnabled': settings.getSetsEnabled,
      'points': settings.getPointsOrCustom(),
      'mode': settings.getBestOfOrFirstTo.toString().split('.').last,
      'modeIn':
          settings.getModeIn.toString().split('.').last.replaceAll('Field', ''),
      'modeOut': settings.getModeOut
          .toString()
          .split('.')
          .last
          .replaceAll('Field', ''),
      'winByTwoLegsDifference': settings.getWinByTwoLegsDifference,
      if (settings.getWinByTwoLegsDifference && settings.getSuddenDeath)
        'suddenDeath': settings.getSuddenDeath,
      if (settings.getWinByTwoLegsDifference && settings.getSuddenDeath)
        'maxExtraLegs': settings.getMaxExtraLegs,
      'checkoutCounting': settings.getEnableCheckoutCounting,
      'drawMode': settings.getDrawMode,
    };

    if (settings.getSingleOrTeam == SingleOrTeamEnum.Team) {
      result['teams'] = settings.getTeams.map((team) {
        return team.toMap(team);
      }).toList();
    }

    if (openGame) {
      result['inputMethod'] =
          settings.getInputMethod.toString().split('.').last;
      result['showAverage'] = settings.getShowAverage;
      if ((settings.getSingleOrTeam == SingleOrTeamEnum.Single &&
              settings.getPlayers == 2) ||
          (settings.getSingleOrTeam == SingleOrTeamEnum.Team &&
              settings.getTeams == 2)) {
        result['showFinishWays'] = settings.getShowFinishWays;
        result['showLastThrow'] = settings.getShowLastThrow;
        result['showThrownDartsPerLeg'] = settings.getShowThrownDartsPerLeg;
      }
      result['showInputMethodInGameScreen'] =
          settings.getShowInputMethodInGameScreen;
      result['showMostScoredPoints'] = settings.getShowMostScoredPoints;
      result['mostScoredPoints'] = settings.getMostScoredPoints;
      result['automaticallySubmitPoints'] =
          settings.getAutomaticallySubmitPoints;
      result['checkoutCountingFinallyDisabled'] =
          settings.getCheckoutCountingFinallyDisabled;
    }

    return result;
  }

  Map<String, dynamic> toMapScoreTraining(
      GameSettingsScoreTraining_P settings, bool openGame) {
    Map<String, dynamic> result = {
      'players': settings.getPlayers.map((player) {
        return player.toMap(player);
      }).toList(),
      'mode': settings.getMode.toString().split('.').last,
      'maxRoundsOrPoints': settings.getMaxRoundsOrPoints,
    };

    if (openGame) {
      result['inputMethod'] =
          settings.getInputMethod.toString().split('.').last;
    }

    return result;
  }

  Map<String, dynamic> toMapSingleDoubleTraining(
      GameSettingsSingleDoubleTraining_P settings, bool openGame) {
    Map<String, dynamic> result = {
      'players': settings.getPlayers.map((player) {
        return player.toMap(player);
      }).toList(),
    };

    if (settings.getIsTargetNumberEnabled) {
      result['targetNumber'] = settings.getTargetNumber;
      result['amountOfRounds'] = settings.getAmountOfRounds;
    } else {
      result['mode'] = settings.getMode.toString().split('.').last;
    }

    return result;
  }

  Map<String, dynamic> toMapCricket(
      GameSettingsCricket_P settings, bool openGame) {
    Map<String, dynamic> result = {
      'players': settings.getPlayers.map((player) {
        return player.toMap(player);
      }).toList(),
      'singleOrTeam': settings.getSingleOrTeam.toString().split('.').last,
      'legs': settings.getLegs,
      if (settings.getSetsEnabled) 'sets': settings.getSets,
      'setsEnabled': settings.getSetsEnabled,
      'bestOfOrFirstTo': settings.getBestOfOrFirstTo.toString().split('.').last,
      'mode': settings.getMode.name,
    };

    if (settings.getSingleOrTeam == SingleOrTeamEnum.Team) {
      result['teams'] = settings.getTeams.map((team) {
        return team.toMap(team);
      }).toList();
    }

    return result;
  }

  factory GameSettings_P.fromMapX01(map) {
    late ModeOutIn modeIn;
    late ModeOutIn modeOut;
    late BestOfOrFirstToEnum mode;
    late InputMethod inputMethod;

    switch (map['modeIn']) {
      case 'Single':
        modeIn = ModeOutIn.Single;
        break;
      case 'Double':
        modeIn = ModeOutIn.Double;
        break;
      case 'Master':
        modeIn = ModeOutIn.Master;
        break;
    }

    switch (map['modeOut']) {
      case 'Single':
        modeOut = ModeOutIn.Single;
        break;
      case 'Double':
        modeOut = ModeOutIn.Double;
        break;
      case 'Master':
        modeOut = ModeOutIn.Master;
        break;
    }

    switch (map['mode']) {
      case 'BestOf':
        mode = BestOfOrFirstToEnum.BestOf;
        break;
      case 'FirstTo':
        mode = BestOfOrFirstToEnum.FirstTo;
        break;
    }

    if (map['inputMethod'] == null) {
      inputMethod = InputMethod.Round;
    } else {
      switch (map['inputMethod']) {
        case 'Round':
          inputMethod = InputMethod.Round;
          break;
        case 'ThreeDarts':
          inputMethod = InputMethod.ThreeDarts;
          break;
      }
    }

    return GameSettingsX01_P.firestore(
      checkoutCounting: map['checkoutCounting'],
      legs: map['legs'],
      modeIn: modeIn,
      modeOut: modeOut,
      mode: mode,
      points: map['points'],
      sets: map['sets'] == null ? 0 : map['sets'],
      setsEnabled: map['setsEnabled'],
      singleOrTeam: map['singleOrTeam'] == 'Single'
          ? SingleOrTeamEnum.Single
          : SingleOrTeamEnum.Team,
      winByTwoLegsDifference: map['winByTwoLegsDifference'],
      suddenDeath: map['suddenDeath'] == null ? false : map['suddenDeath'],
      maxExtraLegs: map['maxExtraLegs'] == null ? 2 : map['maxExtraLegs'],
      drawMode: map['drawMode'] == null ? false : map['drawMode'],
      players: map['players'] == null
          ? []
          : map['players'].map<Player>((item) {
              return Player.fromMap(item);
            }).toList(),
      teams: map['teams'] == null
          ? []
          : map['teams'].map<Team>((item) {
              return Team.fromMap(item);
            }).toList(),
      inputMethod: inputMethod,
      automaticallySubmitPoints: map['automaticallySubmitPoints'] == null
          ? DEFAULT_AUTO_SUBMIT_POINTS
          : map['automaticallySubmitPoints'],
      checkoutCountingFinallyDisabled:
          map['checkoutCountingFinallyDisabled'] == null
              ? DEFAULT_CHECKOUT_COUNTING_FINALLY_DISABLED
              : map['checkoutCountingFinallyDisabled'],
      mostScoredPoints: map['mostScoredPoints'] == null
          ? []
          : map['mostScoredPoints'].cast<String>(),
      showAverage:
          map['showAverage'] == null ? DEFAULT_SHOW_AVG : map['showAverage'],
      showFinishWays: map['showFinishWays'] == null
          ? DEFAULT_SHOW_FINISH_WAYS
          : map['showFinishWays'],
      showInputMethodInGameScreen: map['showInputMethodInGameScreen'] == null
          ? DEFAULT_SHOW_INPUT_METHOD_IN_GAME_SCREEN
          : map['showInputMethodInGameScreen'],
      showLastThrow: map['showLastThrow'] == null
          ? DEFAULT_SHOW_LAST_THROW
          : map['showLastThrow'],
      showMostScoredPoints: map['showMostScoredPoints'] == null
          ? DEFAULT_SHOW_MOST_SCORED_POINTS
          : map['showMostScoredPoints'],
      showThrownDartsPerLeg: map['showThrownDartsPerLeg'] == null
          ? DEFAULT_SHOW_THROWN_DARTS_PER_LEG
          : map['showThrownDartsPerLeg'],
    );
  }

  factory GameSettings_P.fromMapScoreTraining(map) {
    late ScoreTrainingModeEnum mode;
    late InputMethod inputMethod;

    switch (map['mode']) {
      case 'MaxPoints':
        mode = ScoreTrainingModeEnum.MaxPoints;
        break;
      case 'MaxRounds':
        mode = ScoreTrainingModeEnum.MaxRounds;
        break;
    }

    if (map['inputMethod'] == null) {
      inputMethod = InputMethod.Round;
    } else {
      switch (map['inputMethod']) {
        case 'Round':
          inputMethod = InputMethod.Round;
          break;
        case 'ThreeDarts':
          inputMethod = InputMethod.ThreeDarts;
          break;
      }
    }

    return GameSettingsScoreTraining_P.firestoreScoreTraining(
      mode: mode,
      maxRoundsOrPoints: map['maxRoundsOrPoints'],
      inputMethod: inputMethod,
      players: map['players'] == null
          ? []
          : map['players'].map<Player>((item) {
              return Player.fromMap(item);
            }).toList(),
    );
  }

  factory GameSettings_P.fromMapSingleDoubleTraining(map) {
    ModesSingleDoubleTraining mode = ModesSingleDoubleTraining.Ascending;

    if (map['mode'] != null) {
      switch (map['mode']) {
        case 'Ascending':
          mode = ModesSingleDoubleTraining.Ascending;
          break;
        case 'Descending':
          mode = ModesSingleDoubleTraining.Descending;
          break;
        case 'Random':
          mode = ModesSingleDoubleTraining.Random;
          break;
      }
    }

    return GameSettingsSingleDoubleTraining_P.firestore(
      mode: mode,
      targetNumber: map['targetNumber'] != null
          ? map['targetNumber']
          : DEFAULT_TARGET_NUMBER,
      isTargetNumberEnabled: map['targetNumber'] != null ? true : false,
      amountOfRounds: map['amountOfRounds'] != null
          ? map['amountOfRounds']
          : DEFUALT_ROUNDS_FOR_TARGET_NUMBER,
      players: map['players'] == null
          ? []
          : map['players'].map<Player>((item) {
              return Player.fromMap(item);
            }).toList(),
    );
  }

  factory GameSettings_P.fromMapCricket(map) {
    late CricketMode cricketMode;

    switch (map['mode']) {
      case 'Standard':
        cricketMode = CricketMode.Standard;
        break;
      case 'Cut throat':
        cricketMode = CricketMode.CutThroat;
        break;
      case 'No score':
        cricketMode = CricketMode.NoScore;
        break;
    }

    return GameSettingsCricket_P.firestore(
      singleOrTeam: map['singleOrTeam'] == 'Single'
          ? SingleOrTeamEnum.Single
          : SingleOrTeamEnum.Team,
      bestOfOrFirstTo: map['bestOfOrFirstTo'] == 'BestOf'
          ? BestOfOrFirstToEnum.BestOf
          : BestOfOrFirstToEnum.FirstTo,
      mode: cricketMode,
      legs: map['legs'] != null
          ? map['legs']
          : DEFAULT_LEGS_FIRST_TO_NO_SETS_CRICKET,
      sets: map['sets'] != null
          ? map['sets']
          : DEFAULT_SETS_FIRST_TO_SETS_ENABLED_CRICKET,
      setsEnabled: map['setsEnabled'] != null
          ? map['setsEnabled']
          : DEFAULT_SETS_ENABLED_CRICKET,
      players: map['players'] == null
          ? []
          : map['players'].map<Player>((item) {
              return Player.fromMap(item);
            }).toList(),
      teams: map['teams'] == null
          ? []
          : map['teams'].map<Team>((item) {
              return Team.fromMap(item);
            }).toList(),
    );
  }

  bool checkIfPlayerNameExists(String playerNameToCheck) {
    for (Player player in getPlayers)
      if (player.getName == playerNameToCheck) {
        return true;
      }
    return false;
  }

  notify() {
    notifyListeners();
  }

  bool isCurrentUserInPlayers(BuildContext context) {
    final String currentUsername =
        context.read<AuthService>().getUsernameFromSharedPreferences() ?? '';

    if (currentUsername == 'Guest') {
      return false;
    }

    for (Player player in getPlayers) {
      if (player.getName == currentUsername) {
        return true;
      }
    }

    return false;
  }

  bool checkIfTeamNameExists(String? teamNameToCheck) {
    for (Team team in getTeams)
      if (team.getName == teamNameToCheck) {
        return true;
      }

    return false;
  }

  void removePlayer(Player playerToRemove, bool removeTeam,
      [bool isSinglesTab = false]) {
    getPlayers.removeWhere((Player p) => p.getName == playerToRemove.getName);

    //remove also player from team -> not same references as in single players list
    if (isSinglesTab) {
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
      }
    }

    //remove player from team
    outerLoop:
    for (Team team in getTeams) {
      for (Player player in team.getPlayers) {
        if (player == playerToRemove) {
          team.getPlayers.remove(playerToRemove);

          if (team.getPlayers.isEmpty && removeTeam) {
            getTeams.remove(team);
          }
          break outerLoop;
        }
      }
    }

    notifyListeners();
  }

  void addPlayer(Player player) {
    getPlayers.add(player);
    assignOrCreateTeamForPlayer(player);
    notify();
  }

  void setLoggedInPlayerToFirstOne(String loggedInPlayerName) {
    final int index =
        getPlayers.indexWhere((p) => p.getName == loggedInPlayerName);
    if (index != -1) {
      final Player player = getPlayers.removeAt(index);
      getPlayers.insert(0, player);
    }
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
      if (!foundTeamWithLessTwoPlayers) {
        _createTeamAndAddPlayer(player);
      }
    }
  }

  void _createTeamAndAddPlayer(Player player) {
    final int teamNameId = getTeamNamingIds.length + 1;
    final Team team = Team(name: 'Team $teamNameId');

    team.getPlayers.add(Player.clone(player));
    getTeams.add(team);
    getTeamNamingIds.add(teamNameId);
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

  Team findTeamForPlayer(String playerNameToFind) {
    late Team result;
    for (Team team in getTeams) {
      for (Player player in team.getPlayers) {
        if (player.getName == playerNameToFind) {
          result = team;
        }
      }
    }

    return result;
  }

  setNextTeamAndPlayer(Game_P game, bool shouldSetNextPlayerOrTeam) {
    final List<Team> teams = getTeams;
    int indexOfCurrentTeam = -1;
    for (int i = 0; i < teams.length; i++) {
      if (teams[i].getName == game.getCurrentTeamToThrow.getName) {
        indexOfCurrentTeam = i;
      }
    }

    final List<Player> players = game.getCurrentTeamToThrow.getPlayers;
    int indexOfCurrentPlayerInCurrentTeam = -1;
    for (int i = 0; i < players.length; i++) {
      if (players[i].getName ==
          game.getCurrentTeamToThrow.getCurrentPlayerToThrow.getName) {
        indexOfCurrentPlayerInCurrentTeam = i;
      }
    }

    if (shouldSetNextPlayerOrTeam) {
      // set next player of current team
      if (indexOfCurrentPlayerInCurrentTeam + 1 == players.length) {
        // round of all players finished -> restart from beginning
        game.getCurrentTeamToThrow.setCurrentPlayerToThrow = players[0];
      } else {
        game.getCurrentTeamToThrow.setCurrentPlayerToThrow =
            players[indexOfCurrentPlayerInCurrentTeam + 1];
      }

      // set next team
      if (indexOfCurrentTeam + 1 == teams.length) {
        // round of all teams finished -> restart from beginning
        game.setCurrentTeamToThrow = teams[0];
      } else {
        game.setCurrentTeamToThrow = teams[indexOfCurrentTeam + 1];
      }

      // set next player of next team
      game.setCurrentPlayerToThrow =
          game.getCurrentTeamToThrow.getCurrentPlayerToThrow;

      if (game is GameX01_P && game.getCurrentPlayerToThrow is Bot) {
        game.setBotSubmittedPoints = false;
      }
    }
  }

  setNextPlayer(Game_P game, bool shouldSetNextPlayerOrTeam) {
    final List<Player> players = getPlayers;

    if (shouldSetNextPlayerOrTeam) {
      final int indexOfCurrentPlayer =
          players.indexOf(game.getCurrentPlayerToThrow);

      if (indexOfCurrentPlayer + 1 == players.length) {
        //round of all players finished -> restart from beginning
        game.setCurrentPlayerToThrow = players[0];
      } else {
        game.setCurrentPlayerToThrow = players[indexOfCurrentPlayer + 1];
      }

      if (game is GameX01_P && game.getCurrentPlayerToThrow is Bot) {
        game.setBotSubmittedPoints = false;
      }
    }
  }

  playerOrTeamNameWithMoreThanEightChars([bool checkForTeams = false]) {
    final int maxChars = 10;
    if (checkForTeams) {
      for (Team team in getTeams) {
        if (team.getName.length >= maxChars) {
          return true;
        }
      }
      return false;
    }
    for (Player player in getPlayers) {
      if (player.getName.length >= maxChars) {
        return true;
      }
    }
    return false;
  }
}
