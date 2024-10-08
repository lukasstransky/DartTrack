import 'package:dart_app/constants.dart';
import 'package:dart_app/models/auth_p.dart';
import 'package:dart_app/screens/auth/local_widgets/email_input/email_input_register.dart';
import 'package:dart_app/screens/auth/local_widgets/email_input/email_input_login.dart';
import 'package:dart_app/screens/auth/local_widgets/forgot_password/forgot_password_link.dart';
import 'package:dart_app/screens/auth/local_widgets/login_register_btn/login_register_btn.dart';
import 'package:dart_app/screens/auth/local_widgets/password_input/password_input_login.dart';
import 'package:dart_app/screens/auth/local_widgets/password_input/password_input_register.dart';
import 'package:dart_app/screens/auth/local_widgets/password_input/password_input_register_repeat.dart';
import 'package:dart_app/screens/auth/local_widgets/username_input.dart';

import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class LoginRegisterPage extends StatefulWidget {
  static const routeName = '/loginRegister';

  const LoginRegisterPage({Key? key}) : super(key: key);

  @override
  _LoginRegisterPageState createState() => _LoginRegisterPageState();
}

class _LoginRegisterPageState extends State<LoginRegisterPage> {
  final GlobalKey<FormState> _loginRegisterPageFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Form(
          key: _loginRegisterPageFormKey,
          child: Selector<Auth_P, AuthMode>(
            selector: (_, auth) => auth.getAuthMode,
            builder: (_, authMode, __) => Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.only(bottom: 1.h),
                      child: Text(
                        authMode == AuthMode.Login ? 'Login' : 'Register',
                        style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.titleLarge!.fontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    if (authMode == AuthMode.Register) ...[
                      UsernameInput(),
                      EmailInputRegister(),
                      PasswordInputRegister(),
                      PasswordInputRegisterRepeat(),
                    ] else if (authMode == AuthMode.Login) ...[
                      EmailInputLogin(),
                      PasswordInputLogin(),
                      ForgotPasswordLink(),
                    ],
                    LoginRegisterBtn(
                        loginRegisterPageFormKey: _loginRegisterPageFormKey),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
