import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/default_settings_x01_p.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/game_settings/x01/helper/default_settings_helper.dart';
import 'package:dart_app/services/auth_service.dart';
import 'package:dart_app/services/firestore/firestore_service_default_settings.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class CustomAppBarX01Settings extends StatefulWidget with PreferredSizeWidget {
  @override
  State<CustomAppBarX01Settings> createState() =>
      _CustomAppBarX01SettingsState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _CustomAppBarX01SettingsState extends State<CustomAppBarX01Settings> {
  final _edgeInsets = EdgeInsets.only(
      bottom: DIALOG_CONTENT_PADDING_BOTTOM,
      top: DIALOG_CONTENT_PADDING_TOP,
      left: DIALOG_CONTENT_PADDING_LEFT,
      right: DIALOG_CONTENT_PADDING_RIGHT);

  _showDialogForGenerelDefaultSettings() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.primary,
        contentPadding: _edgeInsets,
        title: Text(
          'Info',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'These settings are the general default settings!',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Continue',
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
            style: ButtonStyle(
              backgroundColor:
                  Utils.getPrimaryMaterialStateColorDarken(context),
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
        backgroundColor: Theme.of(context).colorScheme.primary,
        contentPadding: _edgeInsets,
        title: Text(
          defaultSettingsSelected
              ? 'Undo default settings'
              : 'Save settings as default',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          defaultSettingsSelected
              ? 'Do you want to reset to the general default settings?'
              : 'Do you want to set these settings as default?',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
            style: ButtonStyle(
              backgroundColor:
                  Utils.getPrimaryMaterialStateColorDarken(context),
            ),
          ),
          TextButton(
            onPressed: () => _setOrUndoDefaultSettings(
                gameSettingsX01, defaultSettingsSelected),
            child: Text(
              'Save',
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
            style: ButtonStyle(
              backgroundColor:
                  Utils.getPrimaryMaterialStateColorDarken(context),
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
        backgroundColor: Theme.of(context).colorScheme.primary,
        contentPadding: _edgeInsets,
        title: const Text(
          'Info',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Team mode for default settings is not supported!',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Continue',
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
            style: ButtonStyle(
              backgroundColor:
                  Utils.getPrimaryMaterialStateColorDarken(context),
            ),
          ),
        ],
      ),
    );
  }

  _setOrUndoDefaultSettings(
      GameSettingsX01_P gameSettingsX01, bool defaultSettingsSelected) {
    final defaultSettingsX01 = context.read<DefaultSettingsX01_P>();
    final FirestoreServiceDefaultSettings firestoreServiceDefaultSettings =
        context.read<FirestoreServiceDefaultSettings>();

    if (defaultSettingsSelected) {
      defaultSettingsX01.isSelected = false;
      defaultSettingsX01.resetValues(context.read<AuthService>().getPlayer);
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

    if (DefaultSettingsHelper.generalDefaultSettingsSelected(context) &&
        !defaultSettingsX01.isSelected) {
      this._showDialogForGenerelDefaultSettings();
    } else if (gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Team) {
      this._showDialogForNoTeamModeSupported();
    } else {
      this._showDialogForDefaultSettings();
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
            'Game Settings',
            style: TextStyle(
                fontSize: 14.sp,
                color: Utils.getTextColorForGameSettingsPage()),
          ),
        ],
      ),
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pushNamed('/home'),
            icon: Icon(Icons.arrow_back,
                color: Theme.of(context).colorScheme.secondary),
          )
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Consumer<GameSettingsX01_P>(
            builder: (_, gameSettingsX01, __) => IconButton(
              onPressed: () async => _defaultSettingsBtnClicked(),
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
