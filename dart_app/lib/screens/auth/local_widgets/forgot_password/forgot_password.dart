import 'package:dart_app/constants.dart';
import 'package:dart_app/models/auth_p.dart';
import 'package:dart_app/screens/auth/local_widgets/email_input/email_input_forgot_passwrod.dart';
import 'package:dart_app/services/auth_service.dart';
import 'package:dart_app/utils/app_bars/custom_app_bar.dart';
import 'package:dart_app/utils/button_styles.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class ForgotPassword extends StatefulWidget {
  static const routeName = '/forgotPassword';

  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final GlobalKey<FormState> _forgotPasswordFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
        appBar: CustomAppBar(title: 'Reset password'),
        resizeToAvoidBottomInset: false,
        body: Form(
          key: _forgotPasswordFormKey,
          child: Center(
            child: Container(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Forgot password',
                    style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.titleLarge!.fontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    width: 80.w,
                    padding: EdgeInsets.only(bottom: 1.h, top: 1.h),
                    child: Text(
                      'Please provide your email to receive a link for resetting your password.',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize:
                            Theme.of(context).textTheme.bodyMedium!.fontSize,
                      ),
                    ),
                  ),
                  EmailInputForgotPassword(),
                  ResetPasswordBtn(
                      forgotPasswordFormKey: _forgotPasswordFormKey),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ResetPasswordBtn extends StatelessWidget {
  const ResetPasswordBtn({
    Key? key,
    required this.forgotPasswordFormKey,
  }) : super(key: key);

  final GlobalKey<FormState> forgotPasswordFormKey;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 1.h),
      width: 40.w,
      child: TextButton(
        child: Text(
          'Reset password',
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
            fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
          ),
        ),
        style: ButtonStyles.darkPrimaryColorBtnStyle(context).copyWith(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
          ),
        ),
        onPressed: () => resetPassword(context),
      ),
    );
  }

  resetPassword(BuildContext context) async {
    final bool isConnected = await Utils.hasInternetConnection();
    if (!isConnected) {
      return;
    }

    final Auth_P auth = context.read<Auth_P>();

    if (!forgotPasswordFormKey.currentState!.validate()) {
      return;
    }
    forgotPasswordFormKey.currentState!.save();

    // show loading spinner
    context.loaderOverlay.show();
    auth.notify();

    try {
      await context
          .read<AuthService>()
          .resetPassword(auth.getForgotPasswordEmail.trim());

      Navigator.of(context).pop();

      Fluttertoast.showToast(
        msg: 'Email for resetting password sent!',
        toastLength: Toast.LENGTH_LONG,
        fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
      );

      // hide loading spinner
      context.loaderOverlay.hide();
      auth.notify();
    } on FirebaseAuthException catch (error) {
      String errorMessage = 'Error occurred!';

      if (error.toString().contains('user-not-found')) {
        errorMessage = 'Could not find a user with that email!';
      }

      _showErrorDialog(errorMessage, context);
    } catch (error) {
      const String errorMessage = 'Error occurred! Please try again later.';

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

    // hide loading spinner
    context.loaderOverlay.hide();
    context.read<Auth_P>().notify();
  }
}
