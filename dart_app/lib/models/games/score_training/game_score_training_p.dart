import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/score_training/game_settings_score_training_p.dart';
import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/models/player_statistics/score_training/player_game_statistics_score_training.dart';
import 'package:dart_app/screens/game_modes/shared/game/point_btns_three_darts/utils_point_btns_three_darts.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameScoreTraining_P extends Game_P {
  String _currentPointsSelected = 'Points';
  List<String> _currentThreeDarts = ['Dart 1', 'Dart 2', 'Dart 3'];
  PointType _currentPointType = PointType.Single;

  GameScoreTraining_P()
      : super(dateTime: DateTime.now(), name: 'Score Training');

  String get getCurrentPointsSelected => this._currentPointsSelected;
  set setCurrentPointsSelected(String value) =>
      this._currentPointsSelected = value;

  List<String> get getCurrentThreeDarts => this._currentThreeDarts;
  set setCurrentThreeDarts(List<String> value) =>
      this._currentThreeDarts = value;

  PointType get getCurrentPointType => this._currentPointType;
  set setCurrentPointType(PointType value) => this._currentPointType = value;

  factory GameScoreTraining_P.createGame(Game_P game_p) {
    GameScoreTraining_P gameScoreTraining_P = new GameScoreTraining_P();

    gameScoreTraining_P.setDateTime = game_p.getDateTime;
    gameScoreTraining_P.setGameId = game_p.getGameId;
    gameScoreTraining_P.setGameSettings = game_p.getGameSettings;
    gameScoreTraining_P.setPlayerGameStatistics =
        game_p.getPlayerGameStatistics;
    gameScoreTraining_P.setCurrentPlayerToThrow =
        game_p.getCurrentPlayerToThrow;
    gameScoreTraining_P.setIsGameFinished = game_p.getIsGameFinished;
    gameScoreTraining_P.setIsOpenGame = game_p.getIsOpenGame;
    gameScoreTraining_P.setIsFavouriteGame = game_p.getIsFavouriteGame;

    return gameScoreTraining_P;
  }

  init(BuildContext context) {
    if (context.read<GameSettingsScoreTraining_P>().getPlayers.length !=
        getPlayerGameStatistics.length) {
      reset();

      setGameSettings = context.read<GameSettingsScoreTraining_P>();
      setCurrentPlayerToThrow = getGameSettings.getPlayers.first;

      for (Player player in getGameSettings.getPlayers) {
        getPlayerGameStatistics.add(
          new PlayerGameStatisticsScoreTraining(
            mode: 'Score Training',
            player: player,
            dateTime: getDateTime,
            roundOrPointsLeft: getGameSettings.getMaxRoundsOrPoints,
          ),
        );
      }

      if (getGameSettings.getInputMethod == InputMethod.ThreeDarts) {
        setCurrentPointType = PointType.Single;
      }
    }
  }

  PlayerGameStatisticsScoreTraining getCurrentPlayerGameStats() {
    return getPlayerGameStatistics.firstWhere(
        (stats) => stats.getPlayer.getName == getCurrentPlayerToThrow.getName);
  }

  _setAllRemainingScoresPerDart(PlayerGameStatisticsScoreTraining stats) {
    final List<String> currentThreeDarts = getCurrentThreeDarts;

    List<String> dartsPerRound = [];
    if (currentThreeDarts[0] != 'Dart 1') {
      dartsPerRound.add(currentThreeDarts[0]);
    }
    if (currentThreeDarts[1] != 'Dart 2') {
      dartsPerRound.add(currentThreeDarts[1]);
    }
    if (currentThreeDarts[2] != 'Dart 3') {
      dartsPerRound.add(currentThreeDarts[2]);
    }

    stats.getAllRemainingScoresPerDart.add(dartsPerRound);
  }

  submitPoints(BuildContext context) {
    final PlayerGameStatisticsScoreTraining stats = getCurrentPlayerGameStats();
    final settings = context.read<GameSettingsScoreTraining_P>();

    setRevertPossible = true;

    late int thrownPoints;
    if (settings.getInputMethod == InputMethod.Round) {
      thrownPoints = int.parse(getCurrentPointsSelected);

      // current score
      stats.setCurrentScore = stats.getCurrentScore + thrownPoints;

      // thrown darts
      stats.setThrownDarts = stats.getThrownDarts + 3;
    } else {
      thrownPoints =
          int.parse(Utils.getCurrentThreeDartsCalculated(getCurrentThreeDarts));

      // three dart mode rounds count
      stats.setThreeDartModeRoundsCount = stats.getThreeDartModeRoundsCount + 1;

      _setAllRemainingScoresPerDart(stats);
    }

    // input method
    if (settings.getInputMethod == InputMethod.Round) {
      stats.getInputMethodForRounds.add(InputMethod.Round);
    }

    // total rounds count
    stats.setTotalRoundsCount = stats.getTotalRoundsCount + 1;

    // all scores
    stats.getAllScores.add(thrownPoints);

    // rounds or points left
    if (settings.getMode == ScoreTrainingModeEnum.MaxRounds) {
      stats.setRoundsOrPointsLeft = stats.getRoundsOrPointsLeft - 1;
    } else {
      if (settings.getInputMethod == InputMethod.Round) {
        stats.setRoundsOrPointsLeft =
            stats.getRoundsOrPointsLeft - thrownPoints;
      }
    }

    // precise scores
    if (stats.getPreciseScores.containsKey(thrownPoints)) {
      stats.getPreciseScores[thrownPoints] =
          stats.getPreciseScores[thrownPoints]! + 1;
    } else {
      stats.getPreciseScores[thrownPoints] = 1;
    }

    // rounded score even
    List<int> keys = stats.getRoundedScoresEven.keys.toList();
    keys.sort();
    if (thrownPoints == 180) {
      stats.getRoundedScoresEven[keys[keys.length - 1]] =
          stats.getRoundedScoresEven[keys[keys.length - 1]]! + 1;
    } else {
      for (int i = 0; i < keys.length - 1; i++) {
        if (thrownPoints >= keys[i] && thrownPoints < keys[i + 1]) {
          stats.getRoundedScoresEven[keys[i]] =
              stats.getRoundedScoresEven[keys[i]]! + 1;
        }
      }
    }

    // rounded scores odd
    keys = stats.getRoundedScoresOdd.keys.toList();
    keys.sort();
    if (thrownPoints >= 170) {
      stats.getRoundedScoresOdd[keys[keys.length - 1]] =
          stats.getRoundedScoresOdd[keys[keys.length - 1]]! + 1;
    } else {
      for (int i = 0; i < keys.length - 1; i++) {
        if (thrownPoints >= keys[i] && thrownPoints < keys[i + 1]) {
          stats.getRoundedScoresOdd[keys[i]] =
              stats.getRoundedScoresOdd[keys[i]]! + 1;
        }
      }
    }

    // is game finished
    bool finished = false;
    if (settings.getMode == ScoreTrainingModeEnum.MaxRounds) {
      for (PlayerGameStatisticsScoreTraining playerStats
          in getPlayerGameStatistics) {
        if (playerStats.getRoundsOrPointsLeft == 0) {
          finished = true;
          break;
        }
      }

      if (finished) {
        Navigator.of(context).pushNamed('/finishScoreTraining');
      }
    } else {
      if (stats.getRoundsOrPointsLeft <= 0) {
        finished = true;
        Navigator.of(context).pushNamed('/finishScoreTraining');
      }
    }

    // set next player if needed
    final List<Player> players = getGameSettings.getPlayers;
    if (getPlayerGameStatistics.length > 1) {
      final int indexOfCurrentPlayer = players.indexOf(getCurrentPlayerToThrow);

      if (indexOfCurrentPlayer + 1 == players.length) {
        // round of all players finished -> restart from beginning
        setCurrentPlayerToThrow = players[0];
      } else {
        setCurrentPlayerToThrow = players[indexOfCurrentPlayer + 1];
      }
    }

    setCurrentPointsSelected = 'Points';
    UtilsPointBtnsThreeDarts.resetCurrentThreeDarts(
        context.read<GameScoreTraining_P>().getCurrentThreeDarts);
    if (!finished) {
      notify();
    }
  }

  submitPointsThreeDartsMode(
      String pointValue,
      String pointValueWithDoubleOrTripplePrefix,
      GameScoreTraining_P gameScoreTraining_P,
      BuildContext context) {
    setRevertPossible = true;

    if (pointValue == 'Bust') {
      gameScoreTraining_P.getCurrentThreeDarts[0] = '0';
      gameScoreTraining_P.getCurrentThreeDarts[1] = '0';
      gameScoreTraining_P.getCurrentThreeDarts[2] = '0';
      notify();
      return;
    }
    UtilsPointBtnsThreeDarts.updateCurrentThreeDarts(
        gameScoreTraining_P.getCurrentThreeDarts,
        pointValueWithDoubleOrTripplePrefix);

    final PlayerGameStatisticsScoreTraining stats = getCurrentPlayerGameStats();
    final int scoredPoints = int.parse(UtilsPointBtnsThreeDarts.calculatePoints(
        pointValue, gameScoreTraining_P.getCurrentPointType));

    // input method
    stats.getInputMethodForRounds.add(InputMethod.ThreeDarts);

    // current score
    stats.setCurrentScore = stats.getCurrentScore + scoredPoints;

    // points left
    if (context.read<GameSettingsScoreTraining_P>().getMode ==
        ScoreTrainingModeEnum.MaxPoints) {
      stats.setRoundsOrPointsLeft = stats.getRoundsOrPointsLeft - scoredPoints;
    }

    // thrown darats
    stats.setThrownDarts = stats.getThrownDarts + 1;

    // all scores per dart
    stats.getAllScoresPerDart.add(scoredPoints);

    // all scores per dart as string count
    final String key = pointValueWithDoubleOrTripplePrefix;
    if (stats.getAllScoresPerDartAsStringCount.containsKey(key)) {
      stats.getAllScoresPerDartAsStringCount[key] =
          stats.getAllScoresPerDartAsStringCount[key]! + 1;
    } else {
      stats.getAllScoresPerDartAsStringCount[key] = 1;
    }

    notify();
  }

  reset() {
    setPlayerGameStatistics = [];
    setTeamGameStatistics = [];
    setCurrentPlayerToThrow = null;
    setCurrentTeamToThrow = null;
    setIsOpenGame = false;
    setIsGameFinished = false;

    setCurrentPointsSelected = 'Points';
    setCurrentThreeDarts = ['Dart 1', 'Dart 2', 'Dart 3'];
    setRevertPossible = false;
    setCurrentPointType = PointType.Single;
  }

  notify() {
    notifyListeners();
  }

  int getAmountOfDartsThrown() {
    int count = 0;

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

  bool _isCompleteRound(GameSettingsScoreTraining_P settings) {
    if (settings.getInputMethod == InputMethod.Round) {
      return true;
    } else if (settings.getInputMethod == InputMethod.ThreeDarts &&
        getAmountOfDartsThrown() == 0) {
      return true;
    }
    return false;
  }

  _setLastThrownDarts(List<String> points) {
    for (int i = 0; i < points.length; i++) {
      getCurrentThreeDarts[i] = points[i];
    }
  }

  _setPreviousPlayer() {
    if (!(getGameSettings.getInputMethod == InputMethod.Round ||
        (getGameSettings.getInputMethod == InputMethod.ThreeDarts &&
            getAmountOfDartsThrown() == 0))) {
      return;
    }

    if (getGameSettings.getPlayers.length == 1) {
      return;
    }

    // set previous player
    final int indexOfCurrentPlayer = getGameSettings.getPlayers.indexOf(
        getGameSettings.getPlayers
            .where((p) => p.getName == getCurrentPlayerToThrow.getName)
            .first);

    if ((indexOfCurrentPlayer - 1) < 0) {
      setCurrentPlayerToThrow = getGameSettings.getPlayers.last;
    } else {
      setCurrentPlayerToThrow =
          getGameSettings.getPlayers[indexOfCurrentPlayer - 1];
    }
  }

  revert(BuildContext context) {
    if (!_isRevertPossible()) {
      return;
    }

    _setPreviousPlayer();

    final PlayerGameStatisticsScoreTraining stats = getCurrentPlayerGameStats();
    final settings = context.read<GameSettingsScoreTraining_P>();

    // input method for rounds
    if (stats.getInputMethodForRounds.isNotEmpty) {
      final InputMethod lastInputMethod =
          stats.getInputMethodForRounds.removeLast();

      if (settings.getInputMethod != lastInputMethod) {
        settings.setInputMethod = lastInputMethod;
        settings.notify();
      }
    }

    final int lastPoints = settings.getInputMethod == InputMethod.Round
        ? stats.getAllScores.last
        : stats.getAllScoresPerDart.last;
    final bool isCompleteRound = _isCompleteRound(settings);

    if (settings.getInputMethod == InputMethod.ThreeDarts) {
      if (getAmountOfDartsThrown() == 0) {
        _setLastThrownDarts(stats.getAllRemainingScoresPerDart.last);
        getCurrentThreeDarts[2] = 'Dart 3';
      } else {
        getCurrentThreeDarts[getAmountOfDartsThrown() - 1] =
            'Dart ' + getAmountOfDartsThrown().toString();
      }

      // all scores per dart + count
      final String point = stats.getAllScoresPerDart.last.toString();
      stats.getAllScoresPerDart.removeLast();

      // precise scores per dart
      if (stats.getAllScoresPerDartAsStringCount.containsKey(point)) {
        stats.getAllScoresPerDartAsStringCount[point] =
            stats.getAllScoresPerDartAsStringCount[point]! - 1;
        // if amount of precise scores is 0 -> remove it from map
        if (stats.getAllScoresPerDartAsStringCount[point] == 0) {
          stats.getAllScoresPerDartAsStringCount
              .removeWhere((key, value) => key == point);
        }
      }
    }

    // current score
    stats.setCurrentScore = stats.getCurrentScore - lastPoints;

    // thrown darts
    if (settings.getInputMethod == InputMethod.Round) {
      stats.setThrownDarts = stats.getThrownDarts - 3;
    } else {
      stats.setThrownDarts = stats.getThrownDarts - 1;
    }

    // points left
    if (settings.getMode == ScoreTrainingModeEnum.MaxPoints) {
      stats.setRoundsOrPointsLeft = stats.getRoundsOrPointsLeft + lastPoints;
    }

    if (isCompleteRound) {
      // rounds left
      if (settings.getMode == ScoreTrainingModeEnum.MaxRounds) {
        stats.setRoundsOrPointsLeft = stats.getRoundsOrPointsLeft + 1;
      }

      // all scores
      final int roundScore = stats.getAllScores.removeLast();

      // precise scores
      if (stats.getPreciseScores.containsKey(roundScore)) {
        stats.getPreciseScores[roundScore] =
            stats.getPreciseScores[roundScore]! - 1;
        // if amount of precise scores is 0 -> remove it from map
        if (stats.getPreciseScores[roundScore] == 0) {
          stats.getPreciseScores.removeWhere((key, value) => key == roundScore);
        }
      }

      // rounded scores even
      List<int> keys = stats.getRoundedScoresEven.keys.toList();
      keys.sort();
      if (roundScore == 180) {
        stats.getRoundedScoresEven[180] = stats.getRoundedScoresEven[180]! - 1;
      } else {
        for (int i = 0; i < keys.length - 1; i++) {
          if (roundScore >= keys[i] && roundScore < keys[i + 1]) {
            stats.getRoundedScoresEven[keys[i]] =
                stats.getRoundedScoresEven[keys[i]]! - 1;
          }
        }
      }

      // rounded scores odd
      keys = stats.getRoundedScoresOdd.keys.toList();
      keys.sort();
      if (roundScore >= 170) {
        stats.getRoundedScoresOdd[170] = stats.getRoundedScoresOdd[170]! - 1;
      } else {
        for (int i = 0; i < keys.length - 1; i++) {
          if (roundScore >= keys[i] && roundScore < keys[i + 1]) {
            stats.getRoundedScoresOdd[keys[i]] =
                stats.getRoundedScoresOdd[keys[i]]! - 1;
          }
        }
      }

      // total + three dart mode rounds count
      stats.setTotalRoundsCount = stats.getTotalRoundsCount - 1;
      if (settings.getInputMethod == InputMethod.ThreeDarts) {
        stats.setThreeDartModeRoundsCount =
            stats.getThreeDartModeRoundsCount - 1;
      }
    }

    // if 1 score is left, the revert btn is still highlighted without this call
    _isRevertPossible();

    notify();
  }

  bool _isRevertPossible() {
    bool result = false;
    for (PlayerGameStatisticsScoreTraining stats in getPlayerGameStatistics) {
      if (stats.getAllScores.length > 0 ||
          stats.getAllScoresPerDart.length > 0) {
        result = true;
      }
    }

    setRevertPossible = result;
    notify();

    return result;
  }
}
