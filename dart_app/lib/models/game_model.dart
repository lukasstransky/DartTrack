import './game_settings/game_settings_model.dart';

class Game {
  String? name; //e.g. X01 or Cricket
  DateTime? dateTime; //when game was played
  GameSettings? gameSettings; //there are different settings for each game
  List<String>? playerGameStatisticsIds;

  get getName => this.name;
  set setName(String? name) => this.name = name;

  get getDateTime => this.dateTime;
  set setDateTime(DateTime? dateTime) => this.dateTime = dateTime;

  get getGameSettings => this.gameSettings;
  set setGameSettings(GameSettings? gameSettings) =>
      this.gameSettings = gameSettings;

  get getPlayerGameStatisticsIds => this.playerGameStatisticsIds;
  set setPlayerGameStatisticsIds(List<String>? playerGameStatisticsIds) =>
      this.playerGameStatisticsIds = playerGameStatisticsIds;

  Game(
      {this.name,
      this.dateTime,
      this.gameSettings,
      this.playerGameStatisticsIds});
}
