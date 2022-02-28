import 'package:dart_app/models/player_model.dart';
import 'package:dart_app/models/player_statistics/player_game_statistics_model.dart';
import 'package:flutter/cupertino.dart';

import '../game_settings/game_settings_model.dart';

class Game with ChangeNotifier {
  String? _name; //e.g. X01 or Cricket
  DateTime _dateTime; //when game was played
  GameSettings? _gameSettings; //there are different settings for each game
  List<PlayerGameStatistics>? _playerGameStatistics = [];
  Player? _currentPlayerToThrow; //player whose turn it is

  get getName => this._name;
  set setName(String? name) => this._name = name;

  get getDateTime => this._dateTime;
  set setDateTime(DateTime dateTime) => this._dateTime = dateTime;

  get getGameSettings => this._gameSettings;
  set setGameSettings(GameSettings? gameSettings) =>
      this._gameSettings = gameSettings;

  get getPlayerGameStatistics => this._playerGameStatistics;
  set setPlayerGameStatistics(
          List<PlayerGameStatistics>? playerGameStatistics) =>
      this._playerGameStatistics = playerGameStatistics;

  get getCurrentPlayerToThrow => this._currentPlayerToThrow;
  set setCurrentPlayerToThrow(Player? currentPlayerToThrow) =>
      this._currentPlayerToThrow = currentPlayerToThrow;

  Game({
    String? name,
    DateTime? dateTime,
  })  : this._name = name,
        this._dateTime = dateTime ?? DateTime.now();
}
