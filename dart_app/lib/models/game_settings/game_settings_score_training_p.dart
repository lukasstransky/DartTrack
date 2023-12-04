import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_p.dart';
import 'package:dart_app/models/games/game_score_training_p.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/models/player_statistics/player_game_stats_score_training.dart';
import 'package:dart_app/utils/globals.dart';

import 'package:flutter/material.dart';

class GameSettingsScoreTraining_P extends GameSettings_P {
  ScoreTrainingModeEnum _mode = ScoreTrainingModeEnum.MaxRounds;
  int _maxRoundsOrPoints = DEFAULT_ROUNDS_SCORE_TRAINING;
  InputMethod _inputMethod = InputMethod.Round;
  bool automaticallySubmitPoints = false;

  GlobalKey<FormState> _formKeyMaxRoundsOrPoints = GlobalKey<FormState>();
  GlobalKey<FormState> _formKeyTargetNumber = GlobalKey<FormState>();

  GameSettingsScoreTraining_P() {}

  GameSettingsScoreTraining_P clone() {
    return GameSettingsScoreTraining_P()
      .._mode = this._mode
      .._maxRoundsOrPoints = this._maxRoundsOrPoints
      .._inputMethod = this._inputMethod
      ..automaticallySubmitPoints = this.automaticallySubmitPoints;
  }

  GameSettingsScoreTraining_P.firestoreScoreTraining({
    required ScoreTrainingModeEnum mode,
    required int maxRoundsOrPoints,
    required InputMethod inputMethod,
    List<Player>? players,
  }) {
    this.setMode = mode;
    this.setMaxRoundsOrPoints = maxRoundsOrPoints;
    this.setInputMethod = inputMethod;
    if (players != null) {
      setPlayers = players;
    }
  }

  ScoreTrainingModeEnum get getMode => this._mode;
  set setMode(ScoreTrainingModeEnum value) => this._mode = value;

  int get getMaxRoundsOrPoints => this._maxRoundsOrPoints;
  set setMaxRoundsOrPoints(int value) => this._maxRoundsOrPoints = value;

  InputMethod get getInputMethod => this._inputMethod;
  set setInputMethod(InputMethod value) => this._inputMethod = value;
  bool get getAutomaticallySubmitPoints => this.automaticallySubmitPoints;

  set setAutomaticallySubmitPoints(bool automaticallySubmitPoints) =>
      this.automaticallySubmitPoints = automaticallySubmitPoints;

  GlobalKey<FormState> get getFormKeyMaxRoundsOrPoints =>
      this._formKeyMaxRoundsOrPoints;
  set setFormKeyMaxRoundsOrPoints(GlobalKey<FormState> value) =>
      this._formKeyMaxRoundsOrPoints = value;

  GlobalKey<FormState> get getFormKeyTargetNumber => this._formKeyTargetNumber;
  set setFormKeyTargetNumber(GlobalKey<FormState> value) =>
      this._formKeyTargetNumber = value;

  switchMode() {
    if (getMode == ScoreTrainingModeEnum.MaxRounds) {
      setMode = ScoreTrainingModeEnum.MaxPoints;
      setMaxRoundsOrPoints = DEFAULT_POINTS_SCORE_TRAINING;
      maxRoundsOrPointsTextController.text =
          DEFAULT_POINTS_SCORE_TRAINING.toString();
    } else {
      setMode = ScoreTrainingModeEnum.MaxRounds;
      setMaxRoundsOrPoints = DEFAULT_ROUNDS_SCORE_TRAINING;
      maxRoundsOrPointsTextController.text =
          DEFAULT_ROUNDS_SCORE_TRAINING.toString();
    }

    notify();
  }

  reset() {
    setMode = ScoreTrainingModeEnum.MaxRounds;
    setMaxRoundsOrPoints = DEFAULT_ROUNDS_SCORE_TRAINING;
    setInputMethod = InputMethod.Round;

    setFormKeyMaxRoundsOrPoints = GlobalKey<FormState>();
    setPlayers = [];
  }

  notify() {
    notifyListeners();
  }

  String getModeStringFinishScreen(bool isOpenGame, GameScoreTraining_P game) {
    if (getMode == ScoreTrainingModeEnum.MaxRounds) {
      if (isOpenGame) {
        int playedRounds = game.getGameSettings.getMaxRoundsOrPoints;
        for (PlayerGameStatsScoreTraining stats
            in game.getPlayerGameStatistics) {
          if (stats.getRoundsOrPointsLeft < playedRounds) {
            playedRounds = stats.getRoundsOrPointsLeft;
          }
        }

        return '${game.getGameSettings.getMaxRoundsOrPoints - playedRounds} out of ${getMaxRoundsOrPoints} rounds played';
      }
      return '${getMaxRoundsOrPoints} rounds played';
    }
    return 'First to ${getMaxRoundsOrPoints} points';
  }

  String getModeStringStatsScreen() {
    if (getMode == ScoreTrainingModeEnum.MaxRounds) {
      return '${getMaxRoundsOrPoints} rounds';
    }
    return 'First to ${getMaxRoundsOrPoints} points';
  }
}
