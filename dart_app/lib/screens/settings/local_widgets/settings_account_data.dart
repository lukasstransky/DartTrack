import 'package:dart_app/constants.dart';
import 'package:dart_app/models/settings_p.dart';
import 'package:dart_app/screens/settings/local_widgets/settings_card_item.dart';
import 'package:dart_app/services/auth_service.dart';
import 'package:dart_app/services/firestore/firestore_service_games.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class SettingsAccountData extends StatelessWidget {
  const SettingsAccountData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 2.0.h,
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(CARD_SHAPE_ROUNDING),
        ),
        elevation: 5,
        margin: EdgeInsets.all(0),
        color: Utils.darken(Theme.of(context).colorScheme.primary, 10),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                left: 1.5.w,
                top: 0.5.h,
              ),
              alignment: Alignment.centerLeft,
              child: Text(
                'Account data',
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
                  color: Utils.getTextColorDarken(context),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SettingsCardItem(
              name: 'Reset statistics',
              onItemPressed: _showDialogForResettingStatistics,
            ),
            SettingsCardItem(
              name: 'Delete account',
              onItemPressed: _showDialogForDeletingAccount,
            ),
          ],
        ),
      ),
    );
  }

  _showDialogForResettingStatistics(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DIALOG_SHAPE_ROUNDING),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        contentPadding:
            Utils.isMobile(context) ? DIALOG_CONTENT_PADDING_MOBILE : null,
        title: Text(
          'Reset statistics',
          style: TextStyle(
            color: Colors.white,
            fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
          ),
        ),
        content: Container(
          width: DIALOG_NORMAL_WIDTH.w,
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                color: Colors.white,
                fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
              ),
              children: <TextSpan>[
                TextSpan(text: 'Are you sure you want to reset '),
                TextSpan(
                  text: 'all statistics',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                    text:
                        '? \nThis action will permanently delete all of your game data and cannot be undone.'),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Utils.handleVibrationFeedback(context);
              Navigator.of(context).pop();
            },
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
              ),
            ),
            style: ButtonStyle(
              splashFactory: NoSplash.splashFactory,
              shadowColor: MaterialStateProperty.all(Colors.transparent),
              overlayColor: MaterialStateProperty.all(Colors.transparent),
              backgroundColor:
                  Utils.getPrimaryMaterialStateColorDarken(context),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(DIALOG_BTN_SHAPE_ROUNDING),
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Utils.handleVibrationFeedback(context);
              context.read<FirestoreServiceGames>().resetStatistics(context);
              Navigator.of(context).pop();
            },
            child: Text(
              'Reset statistics',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
              ),
            ),
            style: ButtonStyle(
              splashFactory: NoSplash.splashFactory,
              shadowColor: MaterialStateProperty.all(Colors.transparent),
              overlayColor: MaterialStateProperty.all(Colors.transparent),
              backgroundColor:
                  Utils.getColor(DANGER_BACKGROUND_COLOR_BTN_IN_DIALOG),
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
  }

  _showDialogForDeletingAccount(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DIALOG_SHAPE_ROUNDING),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        contentPadding:
            Utils.isMobile(context) ? DIALOG_CONTENT_PADDING_MOBILE : null,
        title: Text(
          'Delete account',
          style: TextStyle(
            color: Colors.white,
            fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
          ),
        ),
        content: Container(
          width: DIALOG_NORMAL_WIDTH.w,
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                color: Colors.white,
                fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
              ),
              children: <TextSpan>[
                TextSpan(text: 'Are you sure you want to '),
                TextSpan(
                  text: 'delete your account',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                    text:
                        '? \nThis action is irreversible and will permanently delete your account and associated data.'),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Utils.handleVibrationFeedback(context);
              Navigator.of(context).pop();
            },
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
              ),
            ),
            style: ButtonStyle(
              splashFactory: NoSplash.splashFactory,
              shadowColor: MaterialStateProperty.all(Colors.transparent),
              overlayColor: MaterialStateProperty.all(Colors.transparent),
              backgroundColor:
                  Utils.getPrimaryMaterialStateColorDarken(context),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(DIALOG_BTN_SHAPE_ROUNDING),
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Utils.handleVibrationFeedback(context);
              _onDeleteAccountClicked(context);
              Navigator.of(context).pop();
            },
            child: Text(
              'Delete account',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
              ),
            ),
            style: ButtonStyle(
              splashFactory: NoSplash.splashFactory,
              shadowColor: MaterialStateProperty.all(Colors.transparent),
              overlayColor: MaterialStateProperty.all(Colors.transparent),
              backgroundColor:
                  Utils.getColor(DANGER_BACKGROUND_COLOR_BTN_IN_DIALOG),
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
  }

  _onDeleteAccountClicked(BuildContext context) async {
    final AuthService authService = context.read<AuthService>();
    final Settings_P settings = context.read<Settings_P>();
    final User? user = authService.getCurrentUser;

    if (user == null) {
      return;
    }

    settings.setIsResettingStatsOrDeletingAccount = true;
    settings.notify();

    final navigator = Navigator.of(context);

    Future.microtask(() async {
      context.read<FirestoreServiceGames>().resetStatistics(context, true);
      await authService.deleteAccount(context);
      navigator.pushNamed('/loginRegister');

      settings.setIsResettingStatsOrDeletingAccount = false;
      settings.notify();
    });
  }
}
