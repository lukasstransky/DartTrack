import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/models/team.dart';
import 'package:flutter/material.dart';

class GameSettings with ChangeNotifier {
  List<Team> _teams = []; //todo
  List<Player> _players = [];

  List<Team> get getTeams => this._teams;
  set setTeams(List<Team> value) => this._teams = value;

  List<Player> get getPlayers => this._players;
  set setPlayers(List<Player> value) => this._players = value;

  GameSettings() {}

  factory GameSettings.fromMapX01(map) {
    late ModeOutIn modeIn;
    late ModeOutIn modeOut;
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

    return GameSettingsX01.firestore(
      checkoutCounting: map['checkoutCounting'],
      legs: map['legs'],
      modeIn: modeIn,
      modeOut: modeOut,
      points: map['points'],
      sets: map['sets'] == null ? 0 : map['sets'],
      setsEnabled: map['setsEnabled'],
      singleOrTeam: map['singleOrTeam'] == 'Single'
          ? SingleOrTeamEnum.Single
          : SingleOrTeamEnum.Team,
      winByTwoLegsDifference: map['winByTwoLegsDifference'],
      players: map['players'] == null
          ? []
          : map['players'].map<Player>((item) {
              return Player.fromMap(item);
            }).toList(),
    );
  }
}
