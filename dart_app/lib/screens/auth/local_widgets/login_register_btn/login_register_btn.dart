import 'package:dart_app/constants.dart';
import 'package:dart_app/models/auth.dart';
import 'package:dart_app/screens/auth/local_widgets/login_register_btn/local_widgets/login_register_switch.dart';
import 'package:dart_app/screens/auth/local_widgets/login_register_btn/local_widgets/proceed_as_guest_link.dart';
import 'package:dart_app/services/auth_service.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class LoginRegisterBtn extends StatelessWidget {
  const LoginRegisterBtn(
      {Key? key,
      required GlobalKey<FormState> this.loginRegisterPageFormKey,
      required BuildContext this.context})
      : super(key: key);

  final GlobalKey<FormState> loginRegisterPageFormKey;
  final BuildContext context;

  Future<void> submit(bool isLogin) async {
    final AuthService authService = context.read<AuthService>();
    final Auth auth = context.read<Auth>();

    auth.setUsernameValid =
        await authService.usernameValid(auth.getUsernameController.text);
    if (isLogin) {
      auth.setEmailAlreadyExists = true;
    } else {
      // register
      auth.setEmailAlreadyExists =
          await authService.emailAlreadyExists(auth.getEmailController.text);
    }

    if (!loginRegisterPageFormKey.currentState!.validate()) {
      return;
    }
    loginRegisterPageFormKey.currentState!.save();

    // show loading spinner
    context.loaderOverlay.show();
    auth.notify();

    try {
      auth.getEmailController.text = auth.getEmailController.text.trim();

      if (auth.getAuthMode == AuthMode.Login) {
        await authService.login(
            auth.getEmailController.text, auth.getPasswordController.text);
      } else {
        await authService.register(
            auth.getEmailController.text, auth.getPasswordController.text);
      }

      Navigator.of(context).pushNamed('/home', arguments: {'isLogin': isLogin});

      // hide loading spinner
      context.loaderOverlay.hide();
      auth.notify();
    } on FirebaseAuthException catch (error) {
      String errorMessage = 'Authentication failed';

      if (error.toString().contains('email-already-in-use')) {
        auth.getEmailController.clear();
        errorMessage = 'This email address is already in use.';
        auth.getEmailController.clear();
      } else if (error.toString().contains('user-not-found')) {
        errorMessage = 'Could not find a user with that email.';
        auth.getPasswordController.clear();
      } else if (error.toString().contains('wrong-password')) {
        errorMessage = 'Invalid password.';
        auth.getPasswordController.clear();
      } else if (error.toString().contains('too-many-requests')) {
        errorMessage =
            'To many failed login attempts. Try again later or reset the password.';
        auth.getEmailController.clear();
        auth.getPasswordController.clear();
      } else if (error.toString().contains('weak-password')) {
        errorMessage = 'The password is tooweak.';
        auth.getPasswordController.clear();
      }

      _showErrorDialog(errorMessage);
    } catch (error) {
      const String errorMessage =
          'Could not authenticate you. Please try again later.';

      _showErrorDialog(errorMessage);
    }
  }

  _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: const EdgeInsets.only(
            bottom: DIALOG_CONTENT_PADDING_BOTTOM,
            top: DIALOG_CONTENT_PADDING_TOP,
            left: DIALOG_CONTENT_PADDING_LEFT,
            right: DIALOG_CONTENT_PADDING_RIGHT),
        title: const Text('An error occurred!'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Ok'),
          ),
        ],
      ),
    );

    // hide loading spinner
    context.loaderOverlay.hide();
    context.read<Auth>().notify();
  }

  @override
  Widget build(BuildContext context) {
    final bool isLogin = context.read<Auth>().getAuthMode == AuthMode.Login;

    return Column(
      children: [
        Container(
          key: Key('loginRegisterBtn'),
          width: 60.w,
          padding: EdgeInsets.only(top: isLogin ? 0 : 1.h),
          child: TextButton(
            child: Text(
              isLogin ? 'Login' : 'Register',
              style: TextStyle(fontSize: 12.sp, color: Colors.white),
            ),
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
              ),
              backgroundColor: MaterialStateProperty.all(
                  Theme.of(context).colorScheme.primary),
            ),
            onPressed: () => submit(isLogin),
          ),
        ),
        LoginRegisterSwitch(),
        ProceedAsGuestLink(),
      ],
    );
  }
}
