import 'package:dart_app/constants.dart';

import 'package:flutter/material.dart';

class Auth_P with ChangeNotifier {
  final TextEditingController _usernameController = new TextEditingController();
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();

  bool _usernameValid = false;
  bool _emailAlreadyExists = false;
  bool _passwordVisible = false;
  bool _showLoadingSpinner = false;
  AuthMode _authMode = AuthMode.Login;

  TextEditingController get getUsernameController => this._usernameController;

  TextEditingController get getEmailController => this._emailController;

  TextEditingController get getPasswordController => this._passwordController;

  bool get getUsernameValid => this._usernameValid;
  set setUsernameValid(bool value) => this._usernameValid = value;

  bool get getEmailAlreadyExists => this._emailAlreadyExists;
  set setEmailAlreadyExists(bool value) => this._emailAlreadyExists = value;

  bool get getPasswordVisible => this._passwordVisible;
  set setPasswordVisible(bool value) => this._passwordVisible = value;

  bool get getShowLoadingSpinner => this._showLoadingSpinner;
  set setShowLoadingSpinner(bool value) => this._showLoadingSpinner = value;

  AuthMode get getAuthMode => this._authMode;
  set setAuthMode(AuthMode value) => this._authMode = value;

  switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      _emailController.text = '';
      _passwordController.text = '';
      _authMode = AuthMode.Register;
    } else {
      _emailController.text = '';
      _passwordController.text = '';
      _usernameController.text = '';
      _authMode = AuthMode.Login;
    }

    notify();
  }

  notify() {
    notifyListeners();
  }
}
