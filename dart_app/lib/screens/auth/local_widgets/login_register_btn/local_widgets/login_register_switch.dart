import 'package:dart_app/constants.dart';
import 'package:dart_app/models/auth.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class LoginRegisterSwitch extends StatelessWidget {
  const LoginRegisterSwitch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Auth_P auth = context.read<Auth_P>();

    return Padding(
      padding: EdgeInsets.only(top: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            auth.getAuthMode == AuthMode.Login
                ? 'Don\'t have an account? '
                : 'Already have an account? ',
            style: TextStyle(fontSize: 12.sp, color: Colors.white),
          ),
          GestureDetector(
            key: Key('loginRegisterSwitch'),
            onTap: () => auth.switchAuthMode(),
            child: Text(
              auth.getAuthMode == AuthMode.Login ? 'Register' : 'Login',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12.sp,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
