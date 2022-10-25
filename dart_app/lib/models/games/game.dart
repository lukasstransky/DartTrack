import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_statistics.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_statistics_x01.dart';
import 'package:dart_app/models/team.dart';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class Game with ChangeNotifier implements Comparable<Game> {
  String? _gameId;
  String _name; //e.g. X01 or Cricket
  DateTime _dateTime; //when game was played
  GameSettings? _gameSettings; //there are different settings for each game
  List<PlayerOrTeamGameStatistics> _playerGameStatistics = [];
  List<PlayerOrTeamGameStatistics> _teamGameStatistics = [];
  Player? _currentPlayerToThrow;
  Team? _currentTeamToThrow;
  bool _isGameFinished =
      false; // for team mode -> needed for weird behaviour when clicking the show players/teams btn in the stats tab

  Game({
    required String name,
    required DateTime dateTime,
  })  : this._name = name,
        this._dateTime = dateTime;

  //needed to save game to firestore
  Game.Firestore(
      {String? gameId,
      required String name,
      required bool isGameFinished,
      required DateTime dateTime,
      required GameSettings gameSettings,
      required List<PlayerOrTeamGameStatistics> playerGameStatistics,
      required List<PlayerOrTeamGameStatistics> teamGameStatistics,
      Player? currentPlayerToThrow})
      : this._gameId = gameId,
        this._name = name,
        this._isGameFinished = isGameFinished,
        this._dateTime = dateTime,
        this._gameSettings = gameSettings,
        this._playerGameStatistics = playerGameStatistics,
        this._teamGameStatistics = teamGameStatistics,
        this._currentPlayerToThrow = currentPlayerToThrow;

  Map<String, dynamic> toMapX01(GameX01 gameX01, bool openGame) {
    GameSettingsX01 gameSettingsX01 = getGameSettings as GameSettingsX01;

    return {
      'gameId': _gameId,
      'name': _name,
      'dateTime': _dateTime,
      if (!openGame) 'isGameFinished': true,
      if (openGame)
        'playerGameStatistics': _playerGameStatistics.map((item) {
          return item.toMapX01(item as PlayerOrTeamGameStatisticsX01, gameX01,
              gameSettingsX01, '', openGame);
        }).toList(),
      if (openGame)
        'currentPlayerToThrow':
            _currentPlayerToThrow!.toMap(_currentPlayerToThrow as Player),
      'gameSettings': {
        if (openGame)
          'players': gameSettingsX01.getPlayers.map((player) {
            return player.toMap(player);
          }).toList(),
        if (gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Team)
          'teams': gameSettingsX01.getTeams.map((team) {
            return team.toMap(team);
          }).toList(),
        'singleOrTeam':
            gameSettingsX01.getSingleOrTeam.toString().split('.').last,
        'legs': gameSettingsX01.getLegs,
        if (gameSettingsX01.getSetsEnabled) 'sets': gameSettingsX01.getSets,
        'points': gameSettingsX01.getPointsOrCustom(),
        'mode': gameSettingsX01.getMode.toString().split('.').last,
        'modeIn': gameSettingsX01.getModeIn
            .toString()
            .split('.')
            .last
            .replaceAll('Field', ''),
        'modeOut': gameSettingsX01.getModeOut
            .toString()
            .split('.')
            .last
            .replaceAll('Field', ''),
        'winByTwoLegsDifference': gameSettingsX01.getWinByTwoLegsDifference,
        if (gameSettingsX01.getWinByTwoLegsDifference)
          'suddenDeath': gameSettingsX01.getSuddenDeath,
        if (gameSettingsX01.getWinByTwoLegsDifference)
          'maxExtraLegs': gameSettingsX01.getMaxExtraLegs,
        'checkoutCounting': gameSettingsX01.getEnableCheckoutCounting,
        'setsEnabled': gameSettingsX01.getSetsEnabled,
      },
    };
  }

  factory Game.fromMap(map, mode, gameId, openGame) {
    late GameSettings gameSettings;
    switch (mode) {
      case 'X01':
        gameSettings = GameSettings.fromMapX01(map['gameSettings']);
      //add other cases like cricket...
    }

    DateTime dateTime = DateTime.parse(map['dateTime'].toDate().toString());

    if (openGame) {
      return Game.Firestore(
          gameId: gameId,
          name: map['name'],
          isGameFinished: false,
          dateTime: dateTime,
          gameSettings: gameSettings,
          currentPlayerToThrow: Player.getPlayerFromList(
              gameSettings.getPlayers,
              Player.fromMap(map['currentPlayerToThrow'])),
          playerGameStatistics: map['playerGameStatistics']
              .map<PlayerOrTeamGameStatistics?>((item) {
                switch (mode) {
                  case 'X01':
                    return PlayerOrTeamGameStatistics.fromMapX01(item);
                  //add other cases like cricket...
                }
              })
              .toList()
              .whereType<PlayerOrTeamGameStatistics>()
              .toList(),
          teamGameStatistics: map['teamGameStatistics']
              .map<PlayerOrTeamGameStatistics?>((item) {
                switch (mode) {
                  case 'X01':
                    return PlayerOrTeamGameStatistics.fromMapX01(item);
                  //add other cases like cricket...
                }
              })
              .toList()
              .whereType<PlayerOrTeamGameStatistics>()
              .toList());
    }

    return Game.Firestore(
        gameId: gameId,
        name: map['name'],
        isGameFinished: true,
        dateTime: dateTime,
        gameSettings: gameSettings,
        playerGameStatistics: [],
        teamGameStatistics: []);
  }

  get getGameId => this._gameId;
  set setGameId(String? gameId) => this._gameId = gameId;

  String get getName => this._name;
  set setName(String name) => this._name = name;

  DateTime get getDateTime => this._dateTime;
  set setDateTime(DateTime dateTime) => this._dateTime = dateTime;

  get getGameSettings => this._gameSettings;
  set setGameSettings(GameSettings? gameSettings) =>
      this._gameSettings = gameSettings;

  get getPlayerGameStatistics => this._playerGameStatistics;
  set setPlayerGameStatistics(
          List<PlayerOrTeamGameStatistics> playerGameStatistics) =>
      this._playerGameStatistics = playerGameStatistics;

  get getTeamGameStatistics => this._teamGameStatistics;
  set setTeamGameStatistics(List<PlayerOrTeamGameStatistics> value) =>
      this._teamGameStatistics = value;

  get getCurrentPlayerToThrow => this._currentPlayerToThrow;
  set setCurrentPlayerToThrow(Player? currentPlayerToThrow) =>
      this._currentPlayerToThrow = currentPlayerToThrow;

  get getCurrentTeamToThrow => this._currentTeamToThrow;
  set setCurrentTeamToThrow(value) => this._currentTeamToThrow = value;

  bool get getIsGameFinished => this._isGameFinished;
  set setIsGameFinished(bool value) => this._isGameFinished = value;

  @override
  int compareTo(Game other) {
    if (!getDateTime.isBefore(other.getDateTime)) {
      return -1;
    } else if (getDateTime.isBefore(other.getDateTime)) {
      return 1;
    } else {
      return 0;
    }
  }

  String getFormattedDateTime() {
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm');
    return formatter.format(getDateTime);
  }
}
