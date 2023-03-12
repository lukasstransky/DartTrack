import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_score_training_p.dart';
import 'package:dart_app/models/game_settings/game_settings_single_double_training_p.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/models/team.dart';
import 'package:flutter/material.dart';

class GameSettings_P with ChangeNotifier {
  List<Team> _teams = [];
  List<Player> _players = [];

  List<Team> get getTeams => this._teams;
  set setTeams(List<Team> value) => this._teams = value;

  List<Player> get getPlayers => this._players;
  set setPlayers(List<Player> value) => this._players = value;

  GameSettings_P() {}

  Map<String, dynamic> toMapX01(GameSettingsX01_P gameSettings, bool openGame) {
    Map<String, dynamic> result = {
      'players': gameSettings.getPlayers.map((player) {
        return player.toMap(player);
      }).toList(),
      'singleOrTeam': gameSettings.getSingleOrTeam.toString().split('.').last,
      'legs': gameSettings.getLegs,
      if (gameSettings.getSetsEnabled) 'sets': gameSettings.getSets,
      'setsEnabled': gameSettings.getSetsEnabled,
      'points': gameSettings.getPointsOrCustom(),
      'mode': gameSettings.getMode.toString().split('.').last,
      'modeIn': gameSettings.getModeIn
          .toString()
          .split('.')
          .last
          .replaceAll('Field', ''),
      'modeOut': gameSettings.getModeOut
          .toString()
          .split('.')
          .last
          .replaceAll('Field', ''),
      'winByTwoLegsDifference': gameSettings.getWinByTwoLegsDifference,
      if (gameSettings.getWinByTwoLegsDifference && gameSettings.getSuddenDeath)
        'suddenDeath': gameSettings.getSuddenDeath,
      if (gameSettings.getWinByTwoLegsDifference && gameSettings.getSuddenDeath)
        'maxExtraLegs': gameSettings.getMaxExtraLegs,
      'checkoutCounting': gameSettings.getEnableCheckoutCounting,
      'drawMode': gameSettings.getDrawMode,
    };

    if (gameSettings.getSingleOrTeam == SingleOrTeamEnum.Team) {
      result['teams'] = gameSettings.getTeams.map((team) {
        return team.toMap(team);
      }).toList();
    }

    if (openGame) {
      result['inputMethod'] =
          gameSettings.getInputMethod.toString().split('.').last;
    }

    return result;
  }

  Map<String, dynamic> toMapScoreTraining(
      GameSettingsScoreTraining_P gameSettings, bool openGame) {
    Map<String, dynamic> result = {
      'players': gameSettings.getPlayers.map((player) {
        return player.toMap(player);
      }).toList(),
      'mode': gameSettings.getMode.toString().split('.').last,
      'maxRoundsOrPoints': gameSettings.getMaxRoundsOrPoints,
    };

    if (openGame) {
      result['inputMethod'] =
          gameSettings.getInputMethod.toString().split('.').last;
    }

    return result;
  }

  Map<String, dynamic> toMapSingleDoubleTraining(
      GameSettingsSingleDoubleTraining_P gameSettings, bool openGame) {
    Map<String, dynamic> result = {
      'players': gameSettings.getPlayers.map((player) {
        return player.toMap(player);
      }).toList(),
    };

    if (gameSettings.getIsTargetNumberEnabled) {
      result['targetNumber'] = gameSettings.getTargetNumber;
      result['amountOfRounds'] = gameSettings.getAmountOfRounds;
    } else {
      result['mode'] = gameSettings.getMode.toString().split('.').last;
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
      inputMethod: inputMethod,
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
}
