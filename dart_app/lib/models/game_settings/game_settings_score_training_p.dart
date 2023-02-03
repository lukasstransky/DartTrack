import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_p.dart';
import 'package:dart_app/models/games/game_score_training_p.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/models/player_statistics/player_game_stats_score_training.dart';

import 'package:flutter/material.dart';

class GameSettingsScoreTraining_P extends GameSettings_P {
  ScoreTrainingModeEnum _mode = ScoreTrainingModeEnum.MaxRounds;
  int _maxRoundsOrPoints = DEFAULT_ROUNDS_SCORE_TRAINING;
  InputMethod _inputMethod = InputMethod.Round;
  bool automaticallySubmitPoints = false;

  TextEditingController _maxRoundsOrPointsController =
      new TextEditingController(text: DEFAULT_ROUNDS_SCORE_TRAINING.toString());
  GlobalKey<FormState> _formKeyMaxRoundsOrPoints = GlobalKey<FormState>();
  TextEditingController _targetNumberController =
      new TextEditingController(text: DEFAULT_TARGET_NUMBER.toString());
  GlobalKey<FormState> _formKeyTargetNumber = GlobalKey<FormState>();

  GameSettingsScoreTraining_P() {}

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

  TextEditingController get getMaxRoundsOrPointsController =>
      this._maxRoundsOrPointsController;
  set setMaxRoundsOrPointsController(TextEditingController value) =>
      this._maxRoundsOrPointsController = value;

  GlobalKey<FormState> get getFormKeyTargetNumber => this._formKeyTargetNumber;
  set setFormKeyTargetNumber(GlobalKey<FormState> value) =>
      this._formKeyTargetNumber = value;

  TextEditingController get getTargetNumberController =>
      this._targetNumberController;
  set setTargetNumberController(TextEditingController value) =>
      this._targetNumberController = value;

  switchMode() {
    if (getMode == ScoreTrainingModeEnum.MaxRounds) {
      setMode = ScoreTrainingModeEnum.MaxPoints;
      setMaxRoundsOrPoints = DEFAULT_POINTS_SCORE_TRAINING;
    } else {
      setMode = ScoreTrainingModeEnum.MaxRounds;
      setMaxRoundsOrPoints = DEFAULT_ROUNDS_SCORE_TRAINING;
    }
    setControllerTextValueToDefault();

    notify();
  }

  setControllerTextValueToDefault() {
    if (getMode == ScoreTrainingModeEnum.MaxRounds) {
      setMaxRoundsOrPointsController = new TextEditingController(
          text: DEFAULT_ROUNDS_SCORE_TRAINING.toString());
    } else {
      setMaxRoundsOrPointsController = new TextEditingController(
          text: DEFAULT_POINTS_SCORE_TRAINING.toString());
    }
  }

  reset() {
    setMode = ScoreTrainingModeEnum.MaxRounds;
    setMaxRoundsOrPoints = DEFAULT_ROUNDS_SCORE_TRAINING;
    setInputMethod = InputMethod.Round;
    setMaxRoundsOrPointsController = new TextEditingController(
        text: DEFAULT_ROUNDS_SCORE_TRAINING.toString());
    setFormKeyMaxRoundsOrPoints = GlobalKey<FormState>();
    setPlayers = [];
  }

  notify() {
    notifyListeners();
  }

  String getModeStringFinishScreen(bool isOpenGame, GameScoreTraining_P game) {
    if (getMode == ScoreTrainingModeEnum.MaxRounds) {
      if (isOpenGame) {
        int unplayedRounds = 0;
        for (PlayerGameStatsScoreTraining stats
            in game.getPlayerGameStatistics) {
          if (stats.getRoundsOrPointsLeft > unplayedRounds) {
            unplayedRounds = stats.getRoundsOrPointsLeft;
          }
        }

        return '${unplayedRounds} out of ${getMaxRoundsOrPoints} rounds remain unplayed';
      }
      return '${getMaxRoundsOrPoints} rounds played';
    }
    return 'First to ${getMaxRoundsOrPoints} points';
  }

  String getModeStringStatsScreen() {
    if (getMode == ScoreTrainingModeEnum.MaxRounds) {
      return 'Best of ${getMaxRoundsOrPoints} rounds';
    }
    return 'First to ${getMaxRoundsOrPoints} points';
  }
}
