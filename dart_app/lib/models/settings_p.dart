import 'package:flutter/material.dart';

class Settings_P with ChangeNotifier {
  String _version = '';
  bool _showLoadingSpinner = false;
  bool _vibrationFeedbackEnabled = false;

  String get getVersion => this._version;
  set setVersion(String value) => this._version = value;

  bool get getShowLoadingSpinner => this._showLoadingSpinner;
  set setShowLoadingSpinner(bool value) => this._showLoadingSpinner = value;

  bool get getVibrationFeedbackEnabled => this._vibrationFeedbackEnabled;
  set setVibrationFeedbackEnabled(bool value) =>
      this._vibrationFeedbackEnabled = value;

  notify() {
    notifyListeners();
  }
}
