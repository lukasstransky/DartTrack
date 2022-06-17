import 'package:dart_app/models/bot.dart';
import 'package:dart_app/models/game_settings/game_settings.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/models/player_statistics/player_game_statistics.dart';
import 'package:dart_app/models/player_statistics/player_game_statistics_x01.dart';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Game with ChangeNotifier implements Comparable<Game> {
  String? _gameId;
  String _name; //e.g. X01 or Cricket
  DateTime _dateTime; //when game was played
  GameSettings? _gameSettings; //there are different settings for each game
  List<PlayerGameStatistics> _playerGameStatistics = [];
  Player? _currentPlayerToThrow; //player whose turn it is

  Game({
    required String name,
    required DateTime dateTime,
  })  : this._name = name,
        this._dateTime = DateTime.now();

  //needed to save game to firestore
  Game.firestore(
      {String? gameId,
      required String name,
      required DateTime dateTime,
      required GameSettings gameSettings,
      required List<PlayerGameStatistics> playerGameStatistics,
      Player? currentPlayerToThrow})
      : this._gameId = gameId,
        this._name = name,
        this._dateTime = dateTime,
        this._gameSettings = gameSettings,
        this._playerGameStatistics = playerGameStatistics,
        this._currentPlayerToThrow = currentPlayerToThrow;

  Map<String, dynamic> toMapX01(GameX01 gameX01, bool openGame) {
    GameSettingsX01 gameSettingsX01 = _gameSettings as GameSettingsX01;

    return {
      'gameId': _gameId,
      'name': _name,
      'dateTime': _dateTime,
      if (openGame)
        'playerGameStatistics': _playerGameStatistics.map((item) {
          return item.toMapX01(
              item as PlayerGameStatisticsX01, gameX01, "", openGame);
        }).toList(),
      if (openGame && gameX01.getCurrentPlayerToThrow is Bot)
        'currentPlayerToThrow': {
          'name': gameX01.getCurrentPlayerToThrow.getName,
          'preDefinedAverage':
              gameX01.getCurrentPlayerToThrow.getPreDefinedAverage
        },
      if (openGame && !(gameX01.getCurrentPlayerToThrow is Bot))
        'currentPlayerToThrow': {
          'name': gameX01.getCurrentPlayerToThrow.getName,
        },
      'gameSettings': {
        if (openGame)
          'players': gameX01.getGameSettings.getPlayers.map((player) {
            return player.toMap(player);
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
            .replaceAll("Field", ""),
        'modeOut': gameSettingsX01.getModeOut
            .toString()
            .split('.')
            .last
            .replaceAll("Field", ""),
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
      case "X01":
        gameSettings = GameSettings.fromMapX01(map['gameSettings']);
      //add other cases for other game modes...(other settings)
    }

    if (openGame) {
      return Game.firestore(
          gameId: gameId,
          name: map['name'],
          dateTime: DateTime.parse(map['dateTime'].toDate().toString()),
          gameSettings: gameSettings,
          currentPlayerToThrow: Player.getPlayerFromList(
              gameSettings.getPlayers,
              Player.fromMap(map['currentPlayerToThrow'])),
          playerGameStatistics:
              map['playerGameStatistics'].map<PlayerGameStatistics>((item) {
            return PlayerGameStatistics.fromMapX01(item);
          }).toList());
    }

    return Game.firestore(
        gameId: gameId,
        name: map['name'],
        dateTime: DateTime.parse(map['dateTime'].toDate().toString()),
        gameSettings: gameSettings,
        playerGameStatistics: []);
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
          List<PlayerGameStatistics> playerGameStatistics) =>
      this._playerGameStatistics = playerGameStatistics;

  get getCurrentPlayerToThrow => this._currentPlayerToThrow;
  set setCurrentPlayerToThrow(Player? currentPlayerToThrow) =>
      this._currentPlayerToThrow = currentPlayerToThrow;

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
