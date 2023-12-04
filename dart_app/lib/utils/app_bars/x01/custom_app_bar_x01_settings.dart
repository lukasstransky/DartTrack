import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/default_settings_x01_p.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/game_settings/x01/helper/default_settings_helper.dart';
import 'package:dart_app/services/auth_service.dart';
import 'package:dart_app/services/firestore/firestore_service_default_settings.dart';
import 'package:dart_app/utils/button_styles.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class CustomAppBarX01Settings extends StatefulWidget
    implements PreferredSizeWidget {
  @override
  State<CustomAppBarX01Settings> createState() =>
      _CustomAppBarX01SettingsState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarX01SettingsState extends State<CustomAppBarX01Settings> {
  _showDialogForGenerelDefaultSettings() {
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
          'Information',
          style: TextStyle(
            color: Colors.white,
            fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
          ),
        ),
        content: Container(
          width: TEXT_DIALOG_WIDTH.w,
          child: Text(
            'These settings are the general default settings.',
            style: TextStyle(
              color: Colors.white,
              fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
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
              'Continue',
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
  }

  _showDialogForDefaultSettings() async {
    final gameSettingsX01 = context.read<GameSettingsX01_P>();
    final bool defaultSettingsSelected =
        DefaultSettingsHelper.defaultSettingsSelected(context);

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
          defaultSettingsSelected
              ? 'Undo default settings'
              : 'Save settings as default',
          style: TextStyle(
            color: Colors.white,
            fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
          ),
        ),
        content: Container(
          width: 80.w,
          child: Text(
            defaultSettingsSelected
                ? 'Do you want to reset to the general default settings?'
                : 'Do you want to set these settings as default?',
            style: TextStyle(
              color: Colors.white,
              fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
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
            style: ButtonStyles.darkPrimaryColorBtnStyle(context).copyWith(
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
              _setOrUndoDefaultSettings(
                  gameSettingsX01, defaultSettingsSelected);
            },
            child: Text(
              defaultSettingsSelected ? 'Undo' : 'Save',
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
  }

  _showDialogForNoTeamModeSupported() {
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
          'Information',
          style: TextStyle(
            color: Colors.white,
            fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
          ),
        ),
        content: Container(
          width: TEXT_DIALOG_WIDTH.w,
          child: Text(
            'Team mode is not supported for default settings.',
            style: TextStyle(
              color: Colors.white,
              fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
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
              'Continue',
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
  }

  _showDialogCurrentUserNotInPlayers(String username) {
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
        title: Container(
          width: TEXT_DIALOG_WIDTH.w,
          child: Text(
            'Information',
            style: TextStyle(
              color: Colors.white,
              fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
            ),
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
              children: [
                TextSpan(
                  text:
                      'Not able to save default settings, because current logged in user "',
                ),
                TextSpan(
                  text: username,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: '" is not present within the players.',
                ),
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
              'Continue',
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
  }

  _showDialogIfLoggedInAsGuest() {
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
        title: Container(
          width: TEXT_DIALOG_WIDTH.w,
          child: Text(
            'Information',
            style: TextStyle(
              color: Colors.white,
              fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
            ),
          ),
        ),
        content: Container(
          width: DIALOG_NORMAL_WIDTH.w,
          child: Text(
            'Logged in as a guest, it is not possible to set default settings.',
            style: TextStyle(
              color: Colors.white,
              fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
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
              'Continue',
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
  }

  _setOrUndoDefaultSettings(
      GameSettingsX01_P gameSettingsX01, bool defaultSettingsSelected) async {
    final bool isConnected = await Utils.hasInternetConnection();
    if (!isConnected) {
      return;
    }

    final defaultSettingsX01 = context.read<DefaultSettingsX01_P>();
    final FirestoreServiceDefaultSettings firestoreServiceDefaultSettings =
        context.read<FirestoreServiceDefaultSettings>();

    if (defaultSettingsSelected) {
      defaultSettingsX01.isSelected = false;
      defaultSettingsX01.resetValues(
          context.read<AuthService>().getUsernameFromSharedPreferences());
      DefaultSettingsHelper.setSettingsFromDefault(context);
    } else {
      defaultSettingsX01.isSelected = true;
      DefaultSettingsHelper.setDefaultSettings(context);
    }
    firestoreServiceDefaultSettings.postDefaultSettingsX01(context);

    gameSettingsX01.notify();
    Navigator.of(context).pop();
  }

  _defaultSettingsBtnClicked() {
    final defaultSettingsX01 = context.read<DefaultSettingsX01_P>();
    final gameSettingsX01 = context.read<GameSettingsX01_P>();
    final String username =
        context.read<AuthService>().getUsernameFromSharedPreferences() ?? '';

    if (username == 'Guest') {
      _showDialogIfLoggedInAsGuest();
    } else if (DefaultSettingsHelper.generalDefaultSettingsSelected(context) &&
        !defaultSettingsX01.isSelected) {
      _showDialogForGenerelDefaultSettings();
    } else if (gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Team) {
      _showDialogForNoTeamModeSupported();
    } else if (!gameSettingsX01.getPlayers.any((p) => p.getName == username)) {
      _showDialogCurrentUserNotInPlayers(username);
    } else {
      _showDialogForDefaultSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      title: Column(
        children: [
          Text(
            'Settings',
            style: TextStyle(
                fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
                color: Utils.getTextColorForGameSettingsPage()),
          ),
        ],
      ),
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            splashColor:
                Utils.darken(Theme.of(context).colorScheme.primary, 10),
            splashRadius: SPLASH_RADIUS,
            highlightColor:
                Utils.darken(Theme.of(context).colorScheme.primary, 10),
            onPressed: () {
              Utils.handleVibrationFeedback(context);
              Navigator.of(context).pushNamed('/home');
            },
            icon: Icon(
              size: ICON_BUTTON_SIZE.h,
              Icons.arrow_back,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 2.5.w),
          child: Consumer<GameSettingsX01_P>(
            builder: (_, gameSettingsX01, __) => IconButton(
              splashColor:
                  Utils.darken(Theme.of(context).colorScheme.primary, 10),
              splashRadius: SPLASH_RADIUS,
              highlightColor:
                  Utils.darken(Theme.of(context).colorScheme.primary, 10),
              onPressed: () async {
                Utils.handleVibrationFeedback(context);
                _defaultSettingsBtnClicked();
              },
              iconSize: ICON_BUTTON_SIZE.h,
              icon: DefaultSettingsHelper.defaultSettingsSelected(context)
                  ? Icon(MdiIcons.heart,
                      color: Theme.of(context).colorScheme.secondary)
                  : Icon(MdiIcons.heartOutline,
                      color: Theme.of(context).colorScheme.secondary),
            ),
          ),
        ),
      ],
    );
  }
}
