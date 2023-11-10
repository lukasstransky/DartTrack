import 'package:dart_app/constants.dart';
import 'package:dart_app/models/auth.dart';
import 'package:dart_app/models/settings_p.dart';
import 'package:dart_app/screens/settings/local_widgets/settings_card_item.dart';
import 'package:dart_app/services/auth_service.dart';
import 'package:dart_app/utils/button_styles.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class SettingsAccountDetails extends StatefulWidget {
  const SettingsAccountDetails({Key? key}) : super(key: key);

  @override
  State<SettingsAccountDetails> createState() => _SettingsAccountDetailsState();
}

class _SettingsAccountDetailsState extends State<SettingsAccountDetails> {
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _currentPasswordController =
      new TextEditingController();
  final TextEditingController _newPasswordController =
      new TextEditingController();
  final TextEditingController _confirmationPasswordController =
      new TextEditingController();

  final GlobalKey<FormState> _emailFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _passwordFormKey = GlobalKey<FormState>();

  bool _emailValid = true;
  String _errorMessage = '';

  @override
  void dispose() {
    _emailController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmationPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 1.h),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(CARD_SHAPE_ROUNDING),
        ),
        elevation: 5,
        margin: EdgeInsets.all(0),
        color: Utils.darken(Theme.of(context).colorScheme.primary, 10),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                left: 1.5.w,
                top: 0.5.h,
              ),
              alignment: Alignment.centerLeft,
              child: Text(
                'Account details',
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
                  color: Utils.getTextColorDarken(context),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SettingsCardItem(
              name: 'Email',
              onItemPressed: _showDialogForChangingEmail,
            ),
            SettingsCardItem(
              name: 'Password',
              onItemPressed: _showDialogForChangingPassword,
            ),
          ],
        ),
      ),
    );
  }

  _showDialogForChangingEmail(BuildContext context) async {
    final Auth_P auth = context.read<Auth_P>();

    Utils.forcePortraitMode(context);

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DIALOG_SHAPE_ROUNDING),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        contentPadding:
            Utils.isMobile(context) ? DIALOG_CONTENT_PADDING_MOBILE : null,
        title: Text(
          'Change email',
          style: TextStyle(
            color: Colors.white,
            fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
          ),
        ),
        content: Container(
          width: DIALOG_NORMAL_WIDTH.w,
          child: Form(
            key: _emailFormKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: 80.w,
                    child: Selector<Auth_P, bool>(
                      selector: (_, auth) => auth.getPasswordVisible,
                      builder: (_, passwordVisible, __) => TextFormField(
                        autofocus: true,
                        obscureText: !passwordVisible,
                        controller: _currentPasswordController,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(MAX_PASSWORD_LENGTH),
                        ],
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            _currentPasswordController.clear();
                            return ('Password is required!');
                          }
                          if (_errorMessage.isNotEmpty) {
                            final String temp = _errorMessage;
                            _errorMessage = '';
                            return temp;
                          }
                          return null;
                        },
                        style: TextStyle(
                          color: Colors.white,
                          fontSize:
                              Theme.of(context).textTheme.bodyMedium!.fontSize,
                        ),
                        decoration: InputDecoration(
                          errorStyle:
                              TextStyle(fontSize: DIALOG_ERROR_MSG_FONTSIZE.sp),
                          prefixIcon: Icon(
                            size: ICON_BUTTON_SIZE.h,
                            Icons.lock,
                            color: Utils.getPrimaryColorDarken(context),
                          ),
                          suffixIcon: IconButton(
                            splashColor: Utils.darken(
                                Theme.of(context).colorScheme.primary, 10),
                            iconSize: ICON_BUTTON_SIZE.h,
                            splashRadius: SPLASH_RADIUS,
                            highlightColor: Utils.darken(
                                Theme.of(context).colorScheme.primary, 10),
                            icon: Icon(passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                            color: Utils.getPrimaryColorDarken(context),
                            onPressed: () {
                              Utils.handleVibrationFeedback(context);
                              auth.setPasswordVisible = !passwordVisible;
                              auth.notify();
                            },
                          ),
                          filled: true,
                          fillColor: Utils.darken(
                              Theme.of(context).colorScheme.primary, 10),
                          hintText: 'Current password',
                          hintStyle: TextStyle(
                            fontSize: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .fontSize,
                            color: Utils.getPrimaryColorDarken(context),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 1.h),
                    child: TextFormField(
                      controller: _emailController,
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          return ('Please enter a email!');
                        }
                        if (!_emailValid) {
                          return 'Email already exists!';
                        }
                        if (!RegExp(EMAIL_REGEX).hasMatch(value)) {
                          return ('Please enter a valid email!');
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(MAX_EMAIL_LENGTH)
                      ],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize:
                            Theme.of(context).textTheme.bodyMedium!.fontSize,
                      ),
                      decoration: InputDecoration(
                        errorStyle:
                            TextStyle(fontSize: DIALOG_ERROR_MSG_FONTSIZE.sp),
                        prefixIcon: Icon(
                          size: ICON_BUTTON_SIZE.h,
                          Icons.mail,
                          color: Utils.getPrimaryColorDarken(context),
                        ),
                        hintText: 'New email',
                        fillColor: Utils.darken(
                            Theme.of(context).colorScheme.primary, 10),
                        filled: true,
                        hintStyle: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.bodyMedium!.fontSize,
                          color: Utils.getPrimaryColorDarken(context),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Utils.handleVibrationFeedback(context);
              _emailController.clear();
              _currentPasswordController.clear();
              auth.setPasswordVisible = false;
              Navigator.of(context).pop();
            },
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
              ),
            ),
            style: ButtonStyles.darkPrimaryColorBtnStyle(context).copyWith(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(DIALOG_BTN_SHAPE_ROUNDING),
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Utils.handleVibrationFeedback(context);
              final bool isConnected = await Utils.hasInternetConnection();
              if (!isConnected) {
                return;
              }
              _onSaveClickedForEmailDialog(context);
            },
            child: Text(
              'Update',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
              ),
            ),
            style: ButtonStyles.darkPrimaryColorBtnStyle(context).copyWith(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(DIALOG_BTN_SHAPE_ROUNDING),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
  }

  _onSaveClickedForEmailDialog(BuildContext context) async {
    final AuthService authService = context.read<AuthService>();
    final String newEmail = _emailController.text;
    final bool emailAlreadyExists =
        await authService.emailAlreadyExists(newEmail);

    _emailValid = !emailAlreadyExists;
    if (!_emailFormKey.currentState!.validate()) {
      return;
    }

    final bool reauthenticationSuccessful =
        await _reauthenticateUser(authService, _emailFormKey);
    if (reauthenticationSuccessful) {
      authService.updateEmailInFirestore(newEmail);
      authService.updateEmail(newEmail, context);

      context.read<Auth_P>().setPasswordVisible = false;
      _emailController.clear();
      _currentPasswordController.clear();
      Navigator.of(context).pop();
      Fluttertoast.showToast(
        msg: 'Email updated successfully.',
        toastLength: Toast.LENGTH_LONG,
        fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
      );
    }
  }

  _showDialogForChangingPassword(BuildContext context) async {
    Utils.forcePortraitMode(context);

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DIALOG_SHAPE_ROUNDING),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        contentPadding:
            Utils.isMobile(context) ? DIALOG_CONTENT_PADDING_MOBILE : null,
        title: Text(
          'Change password',
          style: TextStyle(
            color: Colors.white,
            fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
          ),
        ),
        content: Container(
          width: DIALOG_NORMAL_WIDTH.w,
          child: Form(
            key: _passwordFormKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  PasswordInputField(
                    passwordController: _currentPasswordController,
                    hintText: 'Old password',
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        _currentPasswordController.clear();
                        return ('Password is required!');
                      }
                      if (_errorMessage.isNotEmpty) {
                        final String temp = _errorMessage;
                        _errorMessage = '';
                        return temp;
                      }
                      return null;
                    },
                    autofocus: true,
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 1.h),
                    child: PasswordInputField(
                      passwordController: _newPasswordController,
                      hintText: 'New password',
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          _newPasswordController.clear();
                          return ('Password is required!');
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 1.h),
                    child: PasswordInputField(
                      passwordController: _confirmationPasswordController,
                      hintText: 'Confirm password',
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          _confirmationPasswordController.clear();
                          return ('Password is required!');
                        }
                        if (value != _newPasswordController.text) {
                          return 'The passwords do not match!';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Utils.handleVibrationFeedback(context);
              _currentPasswordController.clear();
              _newPasswordController.clear();
              _confirmationPasswordController.clear();
              context.read<Auth_P>().setPasswordVisible = false;
              Navigator.of(context).pop();
            },
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
              ),
            ),
            style: ButtonStyle(
              backgroundColor:
                  Utils.getPrimaryMaterialStateColorDarken(context),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(DIALOG_BTN_SHAPE_ROUNDING),
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Utils.handleVibrationFeedback(context);
              final bool isConnected = await Utils.hasInternetConnection();
              if (!isConnected) {
                return;
              }
              _onSaveClickedForPasswordDialog(context);
            },
            child: Text(
              'Update',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
              ),
            ),
            style: ButtonStyles.darkPrimaryColorBtnStyle(context).copyWith(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(DIALOG_BTN_SHAPE_ROUNDING),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
  }

  _onSaveClickedForPasswordDialog(BuildContext context) async {
    final Settings_P settings = context.read<Settings_P>();
    settings.setShowLoadingSpinner = true;
    settings.notify();
    final AuthService authService = context.read<AuthService>();

    if (!_passwordFormKey.currentState!.validate()) {
      return;
    }

    final bool reauthenticationSuccessful =
        await _reauthenticateUser(authService, _passwordFormKey);
    if (reauthenticationSuccessful) {
      authService.getCurrentUser!.updatePassword(_newPasswordController.text);

      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmationPasswordController.clear();
      context.read<Auth_P>().setPasswordVisible = false;
      Navigator.of(context).pop();
      Fluttertoast.showToast(
        msg: 'Password updated successfully.',
        toastLength: Toast.LENGTH_LONG,
        fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
      );
    }

    settings.setShowLoadingSpinner = false;
    settings.notify();
  }

  Future<bool> _reauthenticateUser(
      AuthService authService, GlobalKey<FormState> formKey) async {
    final AuthCredential credential = EmailAuthProvider.credential(
        email: authService.getCurrentUserEmail!,
        password: _currentPasswordController.text);

    try {
      await authService.getCurrentUser!
          .reauthenticateWithCredential(credential);

      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        _errorMessage = 'Please logout/login again!';
      } else if (e.code == 'wrong-password') {
        _errorMessage = 'Incorrect password!';
      }
      formKey.currentState!.validate();
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'An unexpected error occurred. Please try again later.',
        toastLength: Toast.LENGTH_LONG,
        fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
      );
    }

    return false;
  }
}

class PasswordInputField extends StatelessWidget {
  const PasswordInputField({
    Key? key,
    required this.passwordController,
    required this.validator,
    required this.hintText,
    this.autofocus = false,
  }) : super(key: key);

  final TextEditingController passwordController;
  final String? Function(String?) validator;
  final String hintText;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final Auth_P auth = context.read<Auth_P>();

    return Container(
      width: 80.w,
      child: Selector<Auth_P, bool>(
        selector: (_, auth) => auth.getPasswordVisible,
        builder: (_, passwordVisible, __) => TextFormField(
          autofocus: autofocus,
          obscureText: !passwordVisible,
          controller: passwordController,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.done,
          inputFormatters: [
            LengthLimitingTextInputFormatter(MAX_PASSWORD_LENGTH),
          ],
          validator: validator,
          style: TextStyle(
            color: Colors.white,
            fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
          ),
          decoration: InputDecoration(
            errorStyle: TextStyle(fontSize: DIALOG_ERROR_MSG_FONTSIZE.sp),
            prefixIcon: Icon(
              size: ICON_BUTTON_SIZE.h,
              Icons.lock,
              color: Utils.getPrimaryColorDarken(context),
            ),
            suffixIcon: IconButton(
              splashColor:
                  Utils.darken(Theme.of(context).colorScheme.primary, 10),
              splashRadius: SPLASH_RADIUS,
              highlightColor:
                  Utils.darken(Theme.of(context).colorScheme.primary, 10),
              icon: Icon(
                  size: ICON_BUTTON_SIZE.h,
                  passwordVisible ? Icons.visibility : Icons.visibility_off),
              color: Utils.getPrimaryColorDarken(context),
              onPressed: () {
                Utils.handleVibrationFeedback(context);
                auth.setPasswordVisible = !passwordVisible;
                auth.notify();
              },
            ),
            filled: true,
            fillColor: Utils.darken(Theme.of(context).colorScheme.primary, 10),
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
              color: Utils.getPrimaryColorDarken(context),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
