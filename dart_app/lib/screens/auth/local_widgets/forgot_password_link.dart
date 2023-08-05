import 'package:dart_app/constants.dart';
import 'package:dart_app/utils/globals.dart';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ForgotPasswordLink extends StatelessWidget {
  const ForgotPasswordLink({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 1.h, bottom: 0.5.h, right: 5.w),
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed('/forgotPassword');
          passwordTextController.clear();
          emailTextController.clear();
        },
        child: Text(
          'Forgot password?',
          style: TextStyle(
            color: Colors.white38,
            fontSize: DEFAULT_FONT_SIZE.sp,
          ),
        ),
      ),
    );
  }
}
