import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_p.dart';
import 'package:flutter/material.dart';

class GameSettingsScoreTraining_P extends GameSettings_P {
  ScoreTrainingModeEnum _mode = ScoreTrainingModeEnum.MaxRounds;
  int _maxRoundsOrPoints = DEFAULT_ROUNDS_SCORE_TRAINING;
  bool _isTargetNumberEnabled = false;
  int _targetNumber = DEFAULT_TARGET_NUMBER;

  TextEditingController _maxRoundsOrPointsController =
      new TextEditingController(text: DEFAULT_ROUNDS_SCORE_TRAINING.toString());
  GlobalKey<FormState> _formKeyMaxRoundsOrPoints = GlobalKey<FormState>();
  TextEditingController _targetNumberController =
      new TextEditingController(text: DEFAULT_TARGET_NUMBER.toString());
  GlobalKey<FormState> _formKeyTargetNumber = GlobalKey<FormState>();

  GameSettingsScoreTraining_P() {}

  ScoreTrainingModeEnum get getMode => this._mode;
  set setMode(ScoreTrainingModeEnum value) => this._mode = value;

  int get getMaxRoundsOrPoints => this._maxRoundsOrPoints;
  set setMaxRoundsOrPoints(int value) => this._maxRoundsOrPoints = value;

  bool get getIsTargetNumberEnabled => this._isTargetNumberEnabled;
  set setIsTargetNumberEnabled(bool value) =>
      this._isTargetNumberEnabled = value;

  int get getTargetNumber => this._targetNumber;
  set setTargetNumber(int value) => this._targetNumber = value;

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

  resetTargetNumberToDefault() {
    setIsTargetNumberEnabled = false;
    setTargetNumber = DEFAULT_TARGET_NUMBER;
    setTargetNumberController =
        new TextEditingController(text: DEFAULT_TARGET_NUMBER.toString());
    setFormKeyTargetNumber = GlobalKey<FormState>();
  }

  reset() {
    setMode = ScoreTrainingModeEnum.MaxRounds;
    setMaxRoundsOrPoints = DEFAULT_ROUNDS_SCORE_TRAINING;
    setMaxRoundsOrPointsController = new TextEditingController(
        text: DEFAULT_ROUNDS_SCORE_TRAINING.toString());
    setFormKeyMaxRoundsOrPoints = GlobalKey<FormState>();
    setPlayers = [];
    resetTargetNumberToDefault();
  }

  notify() {
    notifyListeners();
  }
}
