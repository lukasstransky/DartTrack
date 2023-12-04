import 'package:flutter/material.dart';

class Settings_P with ChangeNotifier {
  String _version = '';
  bool _showLoadingSpinner = false;
  bool _vibrationFeedbackEnabled = false;
  String _emailPassword = '';
  String _email = '';
  String _oldPassword = '';
  String _newPassword = '';
  String _confirmPassword = '';
  String _errorMsg = '';
  bool _emailValid = true;

  String get getVersion => this._version;
  set setVersion(String value) => this._version = value;

  bool get getShowLoadingSpinner => this._showLoadingSpinner;
  set setShowLoadingSpinner(bool value) => this._showLoadingSpinner = value;

  bool get getVibrationFeedbackEnabled => this._vibrationFeedbackEnabled;
  set setVibrationFeedbackEnabled(bool value) =>
      this._vibrationFeedbackEnabled = value;

  String get getEmailPassword => this._emailPassword;
  set setEmailPassword(String value) => this._emailPassword = value;

  String get getEmail => this._email;
  set setEmail(String value) => this._email = value;

  String get getOldPassword => this._oldPassword;
  set setOldPassword(String value) => this._oldPassword = value;

  String get getNewPassword => this._newPassword;
  set setNewPassword(String value) => this._newPassword = value;

  String get getConfirmPassword => this._confirmPassword;
  set setConfirmPassword(String value) => this._confirmPassword = value;

  String get getErrorMsg => this._errorMsg;
  set setErrorMsg(String value) => this._errorMsg = value;

  bool get getEmailValid => this._emailValid;
  set setEmailValid(bool value) => this._emailValid = value;

  notify() {
    notifyListeners();
  }
}
