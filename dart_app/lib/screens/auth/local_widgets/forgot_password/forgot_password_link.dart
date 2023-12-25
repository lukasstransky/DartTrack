import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ForgotPasswordLink extends StatelessWidget {
  const ForgotPasswordLink({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 1.h,
        bottom: 0.5.h,
        right: 5.w,
        left: Utils.isLandscape(context) ? 50.w : 0,
      ),
      alignment:
          Utils.isLandscape(context) ? Alignment.center : Alignment.centerRight,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed('/forgotPassword');
        },
        child: Text(
          'Forgot password?',
          style: TextStyle(
            color: Colors.white38,
            fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
          ),
        ),
      ),
    );
  }
}
