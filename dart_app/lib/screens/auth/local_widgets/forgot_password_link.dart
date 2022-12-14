import 'package:dart_app/models/auth.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
        onTap: () => {
          Navigator.of(context).pushNamed('/forgotPassword'),
          context.read<Auth>().getEmailController.clear(),
        },
        child: Text(
          'Forgot password?',
          style: TextStyle(color: Colors.grey, fontSize: 11.sp),
        ),
      ),
    );
  }
}
