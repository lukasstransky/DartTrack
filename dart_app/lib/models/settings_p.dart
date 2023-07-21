import 'package:flutter/material.dart';

class Settings_P with ChangeNotifier {
  String _version = '';
  bool _isUernameUpdated = false;
  bool _loadIsUsernameUpdated = true;
  bool _isResettingStatsOrDeletingAccount = false;
  bool _vibrationFeedbackEnabled = false;

  String get getVersion => this._version;
  set setVersion(String value) => this._version = value;

  bool get getIsUernameUpdated => this._isUernameUpdated;
  set setIsUernameUpdated(bool isUernameUpdated) =>
      this._isUernameUpdated = isUernameUpdated;

  bool get getLoadIsUsernameUpdated => this._loadIsUsernameUpdated;
  set setLoadIsUsernameUpdated(bool loadIsUsernameUpdated) =>
      this._loadIsUsernameUpdated = loadIsUsernameUpdated;

  bool get getIsResettingStatsOrDeletingAccount =>
      this._isResettingStatsOrDeletingAccount;
  set setIsResettingStatsOrDeletingAccount(bool value) =>
      this._isResettingStatsOrDeletingAccount = value;

  bool get getVibrationFeedbackEnabled => this._vibrationFeedbackEnabled;
  set setVibrationFeedbackEnabled(bool value) =>
      this._vibrationFeedbackEnabled = value;

  notify() {
    notifyListeners();
  }
}
