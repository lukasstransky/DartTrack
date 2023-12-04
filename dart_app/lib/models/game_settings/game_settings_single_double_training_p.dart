import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_p.dart';
import 'package:dart_app/models/games/game_single_double_training_p.dart';
import 'package:dart_app/models/player.dart';
import 'package:flutter/material.dart';

class GameSettingsSingleDoubleTraining_P extends GameSettings_P {
  ModesSingleDoubleTraining _mode = ModesSingleDoubleTraining.Ascending;
  int _targetNumber = DEFAULT_TARGET_NUMBER;
  bool _isTargetNumberEnabled = false;
  int _amountOfRounds = DEFUALT_ROUNDS_FOR_TARGET_NUMBER;

  GlobalKey<FormState> _formKeyTargetNumber = GlobalKey<FormState>();
  GlobalKey<FormState> _formKeyAmountOfRounds = GlobalKey<FormState>();

  GameSettingsSingleDoubleTraining_P() {}

  GameSettingsSingleDoubleTraining_P clone() {
    return GameSettingsSingleDoubleTraining_P()
      .._mode = this._mode
      .._targetNumber = this._targetNumber
      .._isTargetNumberEnabled = this._isTargetNumberEnabled
      .._amountOfRounds = this._amountOfRounds;
  }

  GameSettingsSingleDoubleTraining_P.firestore({
    required ModesSingleDoubleTraining mode,
    required int targetNumber,
    required bool isTargetNumberEnabled,
    required int amountOfRounds,
    List<Player>? players,
  }) {
    this.setMode = mode;
    this.setTargetNumber = targetNumber;
    this.setIsTargetNumberEnabled = isTargetNumberEnabled;
    this.setAmountOfRounds = amountOfRounds;
    if (players != null) {
      setPlayers = players;
    }
  }

  ModesSingleDoubleTraining get getMode => this._mode;
  set setMode(ModesSingleDoubleTraining value) => this._mode = value;

  int get getTargetNumber => this._targetNumber;
  set setTargetNumber(int value) => this._targetNumber = value;

  bool get getIsTargetNumberEnabled => this._isTargetNumberEnabled;
  set setIsTargetNumberEnabled(bool value) =>
      this._isTargetNumberEnabled = value;

  int get getAmountOfRounds => this._amountOfRounds;
  set setAmountOfRounds(int value) => this._amountOfRounds = value;

  GlobalKey<FormState> get getFormKeyTargetNumber => this._formKeyTargetNumber;
  set setFormKeyTargetNumber(GlobalKey<FormState> value) =>
      this._formKeyTargetNumber = value;

  GlobalKey<FormState> get getFormKeyAmountOfRounds =>
      this._formKeyAmountOfRounds;
  set setFormKeyAmountOfRounds(GlobalKey<FormState> value) =>
      this._formKeyAmountOfRounds = value;

  notify() {
    notifyListeners();
  }

  changeMode(ModesSingleDoubleTraining newMode) {
    setMode = newMode;
    setIsTargetNumberEnabled = false;
    resetTargetNumberToDefault();
    notify();
  }

  reset() {
    setMode = ModesSingleDoubleTraining.Ascending;
    setPlayers = [];
    resetTargetNumberToDefault();
  }

  resetTargetNumberToDefault() {
    setTargetNumber = DEFAULT_TARGET_NUMBER;
    setIsTargetNumberEnabled = false;
    setAmountOfRounds = DEFUALT_ROUNDS_FOR_TARGET_NUMBER;
  }

  String getModeStringFinishScreen(
      bool isOpenGame, GameSingleDoubleTraining_P game) {
    if (getIsTargetNumberEnabled) {
      return 'Target number: ${game.getMode == GameMode.DoubleTraining ? 'D' : ''}${getTargetNumber}';
    }

    if (getMode == ModesSingleDoubleTraining.Random) {
      return 'Random';
    }

    late String mode;
    if (getMode == ModesSingleDoubleTraining.Ascending) {
      mode = 'Ascending';
    } else {
      mode = 'Descending';
    }

    if (isOpenGame) {
      return '${mode} - at field ${game.getCurrentFieldToHit}';
    }
    return mode;
  }
}
