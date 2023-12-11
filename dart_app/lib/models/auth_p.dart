import 'package:dart_app/constants.dart';

import 'package:flutter/material.dart';

class Auth_P with ChangeNotifier {
  bool _passwordVisible = false;
  bool _showLoadingSpinner = false;
  AuthMode _authMode = AuthMode.Login;
  String _forgotPasswordEmail = '';
  String _loginEmail = '';
  String _registerEmail = '';
  String _loginPassword = '';
  String _registerPassword = '';
  String _username = '';

  bool get getPasswordVisible => this._passwordVisible;
  set setPasswordVisible(bool value) => this._passwordVisible = value;

  bool get getShowLoadingSpinner => this._showLoadingSpinner;
  set setShowLoadingSpinner(bool value) => this._showLoadingSpinner = value;

  AuthMode get getAuthMode => this._authMode;
  set setAuthMode(AuthMode value) => this._authMode = value;

  String get getForgotPasswordEmail => this._forgotPasswordEmail;
  set setForgotPasswordEmail(String value) => this._forgotPasswordEmail = value;

  String get getLoginEmail => this._loginEmail;
  set setLoginEmail(String value) => this._loginEmail = value;

  String get getRegisterEmail => this._registerEmail;
  set setRegisterEmail(String value) => this._registerEmail = value;

  String get getLoginPassword => this._loginPassword;
  set setLoginPassword(String value) => this._loginPassword = value;

  String get getRegisterPassword => this._registerPassword;
  set setRegisterPassword(String value) => this._registerPassword = value;

  String get getUsername => this._username;
  set setUsername(String value) => this._username = value;

  switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      _authMode = AuthMode.Register;
    } else {
      _authMode = AuthMode.Login;
    }

    notify();
  }

  notify() {
    notifyListeners();
  }
}
