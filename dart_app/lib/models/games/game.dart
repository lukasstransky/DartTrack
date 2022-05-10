import 'package:dart_app/models/game_settings/game_settings.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/models/player_statistics/player_game_statistics.dart';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class Game with ChangeNotifier {
  String? _name; //e.g. X01 or Cricket
  DateTime _dateTime; //when game was played
  GameSettings? _gameSettings; //there are different settings for each game
  List<PlayerGameStatistics> _playerGameStatistics = [];
  Player? _currentPlayerToThrow; //player whose turn it is

  Game({
    String? name,
    DateTime? dateTime,
  })  : this._name = name,
        this._dateTime = dateTime ?? DateTime.now();

  //needed to save game to firestore
  Game.firestore({String? name, DateTime? dateTime, GameSettings? gameSettings})
      : this._name = name,
        this._dateTime = dateTime ?? DateTime.now(),
        this._gameSettings = gameSettings;

  Map<String, dynamic> toMapX01() {
    GameSettingsX01 gameSettingsX01 = _gameSettings as GameSettingsX01;
    return {
      'name': _name,
      'dateTime': _dateTime,
      'gameSettings': {
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

  factory Game.fromMap(map, mode) {
    late GameSettings gameSettings;
    switch (mode) {
      case "X01":
        gameSettings = GameSettings.fromMapX01(map['gameSettings']);
      //add other cases for other game modes...(other settings)
    }

    return Game.firestore(
        name: map['name'],
        dateTime: DateTime.parse(map['dateTime'].toDate().toString()),
        gameSettings: gameSettings);
  }

  get getName => this._name;
  set setName(String? name) => this._name = name;

  get getDateTime => this._dateTime;
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

  String getFormattedDateTime() {
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm');
    return formatter.format(getDateTime);
  }
}
