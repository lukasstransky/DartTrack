import 'package:dart_app/constants.dart';
import 'package:dart_app/models/firestore/stats_firestore_x01_p.dart';
import 'package:dart_app/models/settings_p.dart';
import 'package:dart_app/services/auth_service.dart';
import 'package:dart_app/utils/button_styles.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class LogoutBtn extends StatelessWidget {
  const LogoutBtn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 2.h),
      child: ElevatedButton.icon(
        style: ButtonStyles.anyColorBtnStyle(context,
                Utils.darken(Theme.of(context).colorScheme.primary, 10))
            .copyWith(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
          ),
        ),
        onPressed: () async {
          Utils.handleVibrationFeedback(context);
          final bool isConnected = await Utils.hasInternetConnection();
          if (!isConnected) {
            return;
          }

          final String username =
              context.read<AuthService>().getUsernameFromSharedPreferences() ??
                  '';
          if (username == 'Guest') {
            context.loaderOverlay.show();
            context.read<Settings_P>().notify();
          }

          await context.read<StatsFirestoreX01_P>().resetAll();
          await context.read<AuthService>().logout(context);
          Navigator.of(context).pushNamed('/loginRegister');

          if (username == 'Guest') {
            context.loaderOverlay.hide();
            context.read<Settings_P>().notify();
          }
        },
        icon: Icon(
          size: ICON_BUTTON_SIZE.h,
          Icons.logout,
          color: Theme.of(context).colorScheme.secondary,
        ),
        label: Text(
          'Logout',
          style: TextStyle(
            fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
