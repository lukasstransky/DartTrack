import 'package:dart_app/constants.dart';
import 'package:dart_app/models/auth.dart';
import 'package:dart_app/models/firestore/open_games_firestore.dart';
import 'package:dart_app/models/firestore/stats_firestore_c.dart';
import 'package:dart_app/models/firestore/stats_firestore_d_t.dart';
import 'package:dart_app/models/firestore/stats_firestore_s_t.dart';
import 'package:dart_app/models/firestore/stats_firestore_sc_t.dart';
import 'package:dart_app/models/firestore/stats_firestore_x01_p.dart';
import 'package:dart_app/models/game_settings/x01/default_settings_x01_p.dart';
import 'package:dart_app/screens/auth/local_widgets/login_register_btn/local_widgets/login_register_switch.dart';
import 'package:dart_app/screens/auth/local_widgets/login_register_btn/local_widgets/proceed_as_guest_link.dart';
import 'package:dart_app/services/auth_service.dart';
import 'package:dart_app/utils/globals.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class LoginRegisterBtn extends StatelessWidget {
  const LoginRegisterBtn(
      {Key? key, required GlobalKey<FormState> this.loginRegisterPageFormKey})
      : super(key: key);

  final GlobalKey<FormState> loginRegisterPageFormKey;

  Future<void> submit(bool isLogin, BuildContext context) async {
    final AuthService authService = context.read<AuthService>();
    final Auth_P auth = context.read<Auth_P>();
    context.read<StatsFirestoreX01_P>().resetLoadingFields();
    context.read<DefaultSettingsX01_P>().loadSettings = true;
    context.read<OpenGamesFirestore>().setLoadOpenGames = true;
    context.read<StatsFirestoreCricket_P>().loadGames = true;
    context.read<StatsFirestoreDoubleTraining_P>().loadGames = true;
    context.read<StatsFirestoreSingleTraining_P>().loadGames = true;
    context.read<StatsFirestoreScoreTraining_P>().loadGames = true;

    auth.setUsernameValid =
        await authService.usernameValid(usernameTextController.text);
    if (isLogin) {
      auth.setEmailAlreadyExists = true;
    } else {
      // register
      auth.setEmailAlreadyExists =
          await authService.emailAlreadyExists(emailTextController.text);
    }

    emailTextController.text = emailTextController.text.trim();
    if (!loginRegisterPageFormKey.currentState!.validate()) {
      return;
    }
    loginRegisterPageFormKey.currentState!.save();

    // show loading spinner
    context.loaderOverlay.show();
    auth.notify();

    try {
      if (auth.getAuthMode == AuthMode.Login) {
        await authService.login(
            emailTextController.text, passwordTextController.text);
      } else {
        // store the username in shared preferences
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', usernameTextController.text);
        await authService.register(
            emailTextController.text, passwordTextController.text);
      }

      Navigator.of(context).pushNamed('/home', arguments: {
        'isLogin': isLogin,
        'email': emailTextController.text,
        'username': usernameTextController.text,
      });

      auth.setAuthMode = AuthMode.Login;
      auth.setPasswordVisible = false;
      auth.setShowLoadingSpinner = false;

      emailTextController.clear();
      passwordTextController.clear();
      usernameTextController.clear();

      // hide loading spinner
      context.loaderOverlay.hide();
      auth.notify();
    } on FirebaseAuthException catch (error) {
      String errorMessage = 'Authentication failed';

      if (error.toString().contains('email-already-in-use')) {
        errorMessage = 'This email address is already in use!';
      } else if (error.toString().contains('user-not-found')) {
        errorMessage = 'Could not find a user with that email!';
      } else if (error.toString().contains('wrong-password')) {
        errorMessage = 'Invalid password!';
        passwordTextController.clear();
      } else if (error.toString().contains('too-many-requests')) {
        errorMessage =
            'To many failed login attempts! Try again later or reset the password.';
        emailTextController.clear();
        passwordTextController.clear();
      } else if (error.toString().contains('weak-password')) {
        errorMessage = 'The password is too weak!';
      }

      _showErrorDialog(errorMessage, context);
    } catch (error) {
      const String errorMessage =
          'Could not authenticate you! Please try again later.';

      _showErrorDialog(errorMessage, context);
    }
  }

  _showErrorDialog(String message, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DIALOG_SHAPE_ROUNDING),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        contentPadding:
            Utils.isMobile(context) ? DIALOG_CONTENT_PADDING_MOBILE : null,
        title: Text(
          'An error occurred',
          style: TextStyle(
            color: Colors.white,
            fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
          ),
        ),
        content: Container(
          width: DIALOG_NORMAL_WIDTH.w,
          child: Text(
            message,
            style: TextStyle(
              color: Colors.white,
              fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Ok',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
              ),
            ),
            style: ButtonStyle(
              splashFactory: NoSplash.splashFactory,
              shadowColor: MaterialStateProperty.all(Colors.transparent),
              overlayColor: MaterialStateProperty.all(Colors.transparent),
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
        ],
      ),
    );

    // hide loading spinner
    context.loaderOverlay.hide();
    context.read<Auth_P>().notify();
  }

  @override
  Widget build(BuildContext context) {
    final bool isLogin = context.read<Auth_P>().getAuthMode == AuthMode.Login;

    return Column(
      children: [
        Container(
          key: Key('loginRegisterBtn'),
          width: 40.w,
          padding: EdgeInsets.only(top: isLogin ? 0 : 1.h),
          child: TextButton(
            child: Text(
              isLogin ? 'Login' : 'Register',
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            style: ButtonStyle(
              splashFactory: NoSplash.splashFactory,
              shadowColor: MaterialStateProperty.all(Colors.transparent),
              overlayColor: MaterialStateProperty.all(Colors.transparent),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
              ),
              backgroundColor:
                  Utils.getPrimaryMaterialStateColorDarken(context),
            ),
            onPressed: () => submit(isLogin, context),
          ),
        ),
        LoginRegisterSwitch(),
        ProceedAsGuestLink(),
      ],
    );
  }
}
