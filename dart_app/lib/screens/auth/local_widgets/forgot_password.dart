import 'package:dart_app/models/auth.dart';
import 'package:dart_app/screens/auth/local_widgets/email_input.dart';
import 'package:dart_app/services/auth_service.dart';
import 'package:dart_app/utils/app_bars/custom_app_bar.dart';
import 'package:dart_app/utils/globals.dart';
import 'package:dart_app/utils/utils.dart';

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
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    width: 80.w,
                    padding: EdgeInsets.only(bottom: 1.h, top: 1.h),
                    child: Text(
                      'Please provide your email to receive a link for resetting your password.',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                  EmailInput(isForgotPasswordScreen: true),
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

  resetPassword(String email, BuildContext context) async {
    final Auth_P auth = context.read<Auth_P>();

    auth.setEmailAlreadyExists = await context
        .read<AuthService>()
        .emailAlreadyExists(emailTextController.text);

    if (!forgotPasswordFormKey.currentState!.validate()) {
      return;
    }
    forgotPasswordFormKey.currentState!.save();

    // show loading spinner
    context.loaderOverlay.show();
    auth.notify();

    await context.read<AuthService>().resetPassword(email.trim());

    passwordTextController.clear();
    Navigator.of(context).pop();
    Fluttertoast.showToast(
        msg: 'Email for resetting password sent!',
        toastLength: Toast.LENGTH_LONG);

    // hide loading spinner
    context.loaderOverlay.hide();
    auth.notify();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 1.h),
      width: 40.w,
      child: TextButton(
        child: Text(
          'Reset password',
          style: TextStyle(color: Theme.of(context).colorScheme.secondary),
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
          backgroundColor: Utils.getPrimaryMaterialStateColorDarken(context),
        ),
        onPressed: () => resetPassword(emailTextController.text, context),
      ),
    );
  }
}
