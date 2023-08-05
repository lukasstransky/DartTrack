import 'package:dart_app/constants.dart';
import 'package:dart_app/services/auth_service.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class LogoutBtn extends StatelessWidget {
  const LogoutBtn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 2.h),
      child: ElevatedButton.icon(
        style: ButtonStyle(
          backgroundColor: Utils.getColor(
              Utils.darken(Theme.of(context).colorScheme.primary, 10)),
        ),
        onPressed: () async {
          Utils.handleVibrationFeedback(context);
          await context.read<AuthService>().logout(context);
          Navigator.of(context).pushNamed('/loginRegister');
        },
        icon: Icon(
          size: ICON_BUTTON_SIZE.h,
          Icons.logout,
          color: Theme.of(context).colorScheme.secondary,
        ),
        label: Text(
          'Logout',
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
