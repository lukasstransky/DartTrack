import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_cricket_p.dart';
import 'package:dart_app/models/game_settings/game_settings_p.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/games/game_cricket_p.dart';
import 'package:dart_app/models/games/game_score_training_p.dart';
import 'package:dart_app/models/games/game_single_double_training_p.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/models/player_statistics/player_game_stats_single_double_training.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats.dart';
import 'package:dart_app/models/player_statistics/player_game_stats_score_training.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats_cricket.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats_x01.dart';
import 'package:dart_app/models/team.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class Game_P with ChangeNotifier implements Comparable<Game_P> {
  String? _gameId;
  String _name; // e.g. X01 or Cricket
  DateTime _dateTime; // when game was played
  GameSettings_P? _gameSettings; // there are different settings for each game
  List<PlayerOrTeamGameStats> _playerGameStatistics = [];
  List<PlayerOrTeamGameStats> _teamGameStatistics = [];
  Player? _currentPlayerToThrow;
  Team? _currentTeamToThrow;
  bool _isOpenGame = false;
  bool _isGameFinished =
      false; // for team mode -> needed for weird behaviour when clicking the show players/teams btn in the stats tab
  bool _isFavouriteGame = false;
  bool _revertPossible = false;
  List<String> _currentThreeDarts = ['Dart 1', 'Dart 2', 'Dart 3'];
  bool _showLoadingSpinner = false;
  List<String> _setLegWithPlayerOrTeamWhoFinishedIt =
      []; // currently only used for x01

  Game_P({
    required String name,
    required DateTime dateTime,
  })  : this._name = name,
        this._dateTime = dateTime;

  Game_P.Firestore(
      {String? gameId,
      required String name,
      required bool isGameFinished,
      required bool isOpenGame,
      required bool isFavouriteGame,
      required DateTime dateTime,
      required GameSettings_P gameSettings,
      required List<PlayerOrTeamGameStats> playerGameStatistics,
      required List<PlayerOrTeamGameStats> teamGameStatistics,
      required bool revertPossible,
      required List<String> currentThreeDarts,
      required List<String> setLegWithPlayerOrTeamWhoFinishedIt,
      Player? currentPlayerToThrow,
      Team? currentTeamToThrow})
      : this._gameId = gameId,
        this._name = name,
        this._isGameFinished = isGameFinished,
        this._isOpenGame = isOpenGame,
        this._isFavouriteGame = isFavouriteGame,
        this._dateTime = dateTime,
        this._gameSettings = gameSettings,
        this._playerGameStatistics = playerGameStatistics,
        this._teamGameStatistics = teamGameStatistics,
        this._revertPossible = revertPossible,
        this._currentPlayerToThrow = currentPlayerToThrow,
        this._currentTeamToThrow = currentTeamToThrow,
        this._currentThreeDarts = currentThreeDarts,
        this._setLegWithPlayerOrTeamWhoFinishedIt =
            setLegWithPlayerOrTeamWhoFinishedIt;

  get getGameId => this._gameId;
  set setGameId(String? gameId) => this._gameId = gameId;

  String get getName => this._name;
  set setName(String name) => this._name = name;

  DateTime get getDateTime => this._dateTime;
  set setDateTime(DateTime dateTime) => this._dateTime = dateTime;

  get getGameSettings => this._gameSettings;
  set setGameSettings(GameSettings_P? gameSettings) =>
      this._gameSettings = gameSettings;

  get getPlayerGameStatistics => this._playerGameStatistics;
  set setPlayerGameStatistics(
          List<PlayerOrTeamGameStats> playerGameStatistics) =>
      this._playerGameStatistics = playerGameStatistics;

  get getTeamGameStatistics => this._teamGameStatistics;
  set setTeamGameStatistics(List<PlayerOrTeamGameStats> value) =>
      this._teamGameStatistics = value;

  get getCurrentPlayerToThrow => this._currentPlayerToThrow;
  set setCurrentPlayerToThrow(Player? currentPlayerToThrow) =>
      this._currentPlayerToThrow = currentPlayerToThrow;

  get getCurrentTeamToThrow => this._currentTeamToThrow;
  set setCurrentTeamToThrow(value) => this._currentTeamToThrow = value;

  bool get getIsOpenGame => this._isOpenGame;
  set setIsOpenGame(bool value) => this._isOpenGame = value;

  bool get getIsGameFinished => this._isGameFinished;
  set setIsGameFinished(bool value) => this._isGameFinished = value;

  bool get getIsFavouriteGame => this._isFavouriteGame;
  set setIsFavouriteGame(bool value) => this._isFavouriteGame = value;

  bool get getRevertPossible => this._revertPossible;
  set setRevertPossible(bool revertPossible) =>
      this._revertPossible = revertPossible;

  List<String> get getCurrentThreeDarts => this._currentThreeDarts;
  set setCurrentThreeDarts(List<String> currentThreeDarts) =>
      this._currentThreeDarts = currentThreeDarts;

  bool get getShowLoadingSpinner => this._showLoadingSpinner;
  set setShowLoadingSpinner(bool value) => this._showLoadingSpinner = value;

  List<String> get getLegSetWithPlayerOrTeamWhoFinishedIt =>
      _setLegWithPlayerOrTeamWhoFinishedIt;
  set setLegSetWithPlayerOrTeamWhoFinishedIt(List<String> value) =>
      _setLegWithPlayerOrTeamWhoFinishedIt = value;

  Map<String, dynamic> toMapX01(GameX01_P game, bool openGame) {
    final GameSettingsX01_P settings = getGameSettings as GameSettingsX01_P;

    Map<String, dynamic> result = {
      'name': getName,
      'dateTime': getDateTime,
      'isFavouriteGame': getIsFavouriteGame,
    };

    result['gameSettings'] = settings.toMapX01(game.getGameSettings, openGame);
    result['legSetWithPlayerOrTeamWhoFinishedIt'] =
        game.getLegSetWithPlayerOrTeamWhoFinishedIt;

    if (openGame) {
      result['currentThreeDarts'] = getCurrentThreeDarts;
      result['isOpenGame'] = getIsOpenGame;
      result['playerGameStatistics'] = getPlayerGameStatistics.map((item) {
        return item.toMapX01(
            item as PlayerOrTeamGameStatsX01, game, settings, '', openGame);
      }).toList();
      result['currentPlayerToThrow'] =
          getCurrentPlayerToThrow!.toMap(getCurrentPlayerToThrow as Player);
      result['revertPossible'] = getIsOpenGame;
      result['isOpenGame'] = getRevertPossible;
      result['playerOrTeamLegStartIndex'] = game.getPlayerOrTeamLegStartIndex;
      result['reachedSuddenDeath'] = game.getReachedSuddenDeath;

      if (settings.getSingleOrTeam == SingleOrTeamEnum.Team) {
        result['currentPlayerOfTeamsBeforeLegFinish'] =
            Utils.convertDoubleListToSimpleList(
                game.getCurrentPlayerOfTeamsBeforeLegFinish);
        result['teamGameStatistics'] = getTeamGameStatistics.map((item) {
          return item.toMapX01(
              item as PlayerOrTeamGameStatsX01, game, settings, '', openGame);
        }).toList();
        result['currentTeamToThrow'] =
            getCurrentTeamToThrow!.toMap(getCurrentTeamToThrow as Team);
      }
    } else {
      result['isGameFinished'] = true;
    }

    return result;
  }

  Map<String, dynamic> toMapScoreTraining(
      GameScoreTraining_P game, bool openGame) {
    Map<String, dynamic> result = {
      'name': getName,
      'dateTime': getDateTime,
      'isFavouriteGame': getIsFavouriteGame,
    };

    result['gameSettings'] =
        game.getGameSettings.toMapScoreTraining(game.getGameSettings, openGame);

    if (openGame) {
      result['currentThreeDarts'] = getCurrentThreeDarts;
      result['isOpenGame'] = true;
      result['playerGameStatistics'] = getPlayerGameStatistics.map((item) {
        return item.toMapScoreTraining(
            item as PlayerGameStatsScoreTraining, '', openGame);
      }).toList();
      result['currentPlayerToThrow'] =
          getCurrentPlayerToThrow!.toMap(getCurrentPlayerToThrow as Player);
      result['revertPossible'] = getRevertPossible;
    } else {
      result['isGameFinished'] = true;
    }

    return result;
  }

  Map<String, dynamic> toMapSingleDoubleTraining(
      GameSingleDoubleTraining_P game, bool openGame) {
    Map<String, dynamic> result = {
      'name': game.getMode.name,
      'dateTime': getDateTime,
      'isFavouriteGame': getIsFavouriteGame,
    };

    result['gameSettings'] = game.getGameSettings
        .toMapSingleDoubleTraining(game.getGameSettings, openGame);

    if (openGame) {
      result['currentThreeDarts'] = getCurrentThreeDarts;
      result['isOpenGame'] = true;
      result['playerGameStatistics'] = getPlayerGameStatistics.map((item) {
        return item.toMapSingleDoubleTraining(
            item as PlayerGameStatsSingleDoubleTraining, '', openGame);
      }).toList();
      result['currentPlayerToThrow'] =
          getCurrentPlayerToThrow!.toMap(getCurrentPlayerToThrow as Player);
      result['revertPossible'] = getRevertPossible;
      result['currentFieldToHit'] = game.getCurrentFieldToHit;
      if (game.getGameSettings.getMode == ModesSingleDoubleTraining.Random) {
        result['randomFieldsGenerated'] = game.getRandomFieldsGenerated;
      }
      if (game.getGameSettings.getIsTargetNumberEnabled) {
        result['amountOfRoundsRemaining'] = game.getAmountOfRoundsRemaining;
      }
      result['allFieldsToHit'] = game.getAllFieldsToHit;
    } else {
      result['isGameFinished'] = true;
    }

    return result;
  }

  Map<String, dynamic> toMapCricket(GameCricket_P game, bool openGame) {
    final GameSettingsCricket_P settings =
        getGameSettings as GameSettingsCricket_P;

    Map<String, dynamic> result = {
      'name': GameMode.Cricket.name,
      'dateTime': getDateTime,
      'isFavouriteGame': getIsFavouriteGame,
      'gameSettings':
          game.getGameSettings.toMapCricket(game.getGameSettings, openGame),
    };

    if (openGame) {
      result['currentThreeDarts'] = getCurrentThreeDarts;
      result['isOpenGame'] = getIsOpenGame;
      result['playerGameStatistics'] = getPlayerGameStatistics.map((item) {
        return item.toMapCricket(
            item as PlayerOrTeamGameStatsCricket, settings, '', openGame);
      }).toList();
      result['currentPlayerToThrow'] =
          getCurrentPlayerToThrow!.toMap(getCurrentPlayerToThrow as Player);
      result['revertPossible'] = getIsOpenGame;
      result['isOpenGame'] = getRevertPossible;
      result['playerOrTeamLegStartIndex'] = game.getPlayerOrTeamLegStartIndex;
      result['legSetWithPlayerOrTeamWhoFinishedIt'] =
          game.getLegSetWithPlayerOrTeamWhoFinishedIt;
      if (settings.getSingleOrTeam == SingleOrTeamEnum.Team) {
        result['currentPlayerOfTeamsBeforeLegFinish'] =
            Utils.convertDoubleListToSimpleList(
                game.getCurrentPlayerOfTeamsBeforeLegFinish);
        result['teamGameStatistics'] = getTeamGameStatistics.map((item) {
          return item.toMapCricket(
              item as PlayerOrTeamGameStatsCricket, settings, '', openGame);
        }).toList();
        result['currentTeamToThrow'] =
            getCurrentTeamToThrow!.toMap(getCurrentTeamToThrow as Team);
      }
    } else {
      result['isGameFinished'] = true;
    }

    return result;
  }

  factory Game_P.fromMap(
      dynamic map, GameMode mode, String gameId, bool openGame) {
    late GameSettings_P gameSettings;
    dynamic gameSettingsMap = map['gameSettings'];

    if (mode == GameMode.X01) {
      gameSettings = GameSettings_P.fromMapX01(gameSettingsMap);
    } else if (mode == GameMode.ScoreTraining) {
      gameSettings = GameSettings_P.fromMapScoreTraining(gameSettingsMap);
    } else if (mode == GameMode.SingleTraining ||
        mode == GameMode.DoubleTraining) {
      gameSettings =
          GameSettings_P.fromMapSingleDoubleTraining(gameSettingsMap);
    } else if (mode == GameMode.Cricket) {
      gameSettings = GameSettings_P.fromMapCricket(gameSettingsMap);
    }

    final DateTime dateTime =
        DateTime.parse(map['dateTime'].toDate().toString());

    if (openGame) {
      return Game_P.Firestore(
        gameId: gameId,
        name: map['name'],
        isGameFinished: false,
        isOpenGame: true,
        isFavouriteGame: false,
        dateTime: dateTime,
        gameSettings: gameSettings,
        playerGameStatistics: map['playerGameStatistics']
            .map<PlayerOrTeamGameStats?>((item) {
              List<List<String>> allRemainingScoresPerDart = [];
              if (mode == GameMode.X01 || mode == GameMode.ScoreTraining) {
                allRemainingScoresPerDart =
                    Utils.convertSimpleListBackToDoubleList(
                        item['allRemainingScoresPerDart'] != null
                            ? item['allRemainingScoresPerDart']
                            : []);
              }

              if (mode == GameMode.X01) {
                return PlayerOrTeamGameStatsX01.fromMapX01(
                    item, allRemainingScoresPerDart);
              } else if (mode == GameMode.ScoreTraining) {
                return PlayerOrTeamGameStats.fromMapScoreTraining(
                    item, allRemainingScoresPerDart);
              } else if (mode == GameMode.SingleTraining ||
                  mode == GameMode.DoubleTraining) {
                return PlayerOrTeamGameStats.fromMapSingleDoubleTraining(item);
              } else if (mode == GameMode.Cricket) {
                return PlayerOrTeamGameStats.fromMapCricket(item);
              }
            })
            .toList()
            .whereType<PlayerOrTeamGameStats>()
            .toList(),
        teamGameStatistics: map['teamGameStatistics'] != null
            ? map['teamGameStatistics']
                .map<PlayerOrTeamGameStats?>((item) {
                  List<List<String>> allRemainingScoresPerDart = [];
                  if (mode == GameMode.X01 || mode == GameMode.ScoreTraining) {
                    allRemainingScoresPerDart =
                        Utils.convertSimpleListBackToDoubleList(
                            item['allRemainingScoresPerDart'] != null
                                ? item['allRemainingScoresPerDart']
                                : []);
                  }

                  if (mode == GameMode.X01) {
                    return PlayerOrTeamGameStatsX01.fromMapX01(
                        item, allRemainingScoresPerDart);
                  } else if (mode == GameMode.Cricket) {
                    return PlayerOrTeamGameStats.fromMapCricket(item);
                  }
                })
                .toList()
                .whereType<PlayerOrTeamGameStats>()
                .toList()
            : [],
        revertPossible: map['revertPossible'],
        currentPlayerToThrow: Player.getPlayerFromList(gameSettings.getPlayers,
            Player.fromMap(map['currentPlayerToThrow'])),
        currentTeamToThrow: map['currentTeamToThrow'] != null
            ? Team.fromMap(map['currentTeamToThrow'])
            : null,
        currentThreeDarts: map['currentThreeDarts'] != null
            ? map['currentThreeDarts'].cast<String>()
            : ['Dart 1', 'Dart 2', 'Dart 3'],
        setLegWithPlayerOrTeamWhoFinishedIt:
            map['legSetWithPlayerOrTeamWhoFinishedIt'] != null
                ? map['legSetWithPlayerOrTeamWhoFinishedIt'].cast<String>()
                : [],
      );
    }

    return Game_P.Firestore(
      gameId: gameId,
      name: map['name'],
      isGameFinished: true,
      isOpenGame: false,
      revertPossible: false,
      isFavouriteGame: map['isFavouriteGame'],
      dateTime: dateTime,
      gameSettings: gameSettings,
      playerGameStatistics: [],
      teamGameStatistics: [],
      currentThreeDarts: [],
      setLegWithPlayerOrTeamWhoFinishedIt:
          map['legSetWithPlayerOrTeamWhoFinishedIt'] != null
              ? map['legSetWithPlayerOrTeamWhoFinishedIt'].cast<String>()
              : [],
    );
  }

  @override
  int compareTo(Game_P other) {
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

  notify() {
    notifyListeners();
  }

  int getAmountOfDartsThrown() {
    var count = 0;

    if (getCurrentThreeDarts[0] != 'Dart 1') {
      count++;
    }
    if (getCurrentThreeDarts[1] != 'Dart 2') {
      count++;
    }
    if (getCurrentThreeDarts[2] != 'Dart 3') {
      count++;
    }

    return count;
  }
}
