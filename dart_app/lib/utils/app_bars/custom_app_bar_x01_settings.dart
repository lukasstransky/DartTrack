import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/default_settings_x01.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/models/game_settings/helper/default_settings_helper.dart';
import 'package:dart_app/services/firestore/firestore_service_default_settings.dart';

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
        contentPadding: _edgeInsets,
        title: const Text('Info'),
        content: const Text('These settings are the general default settings!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  _showDialogForDefaultSettings() async {
    final gameSettingsX01 = context.read<GameSettingsX01>();
    final bool defaultSettingsSelected =
        DefaultSettingsHelper.defaultSettingsSelected(context);

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: _edgeInsets,
        title: defaultSettingsSelected
            ? const Text('Undo default settings')
            : const Text('Save settings as default'),
        content: defaultSettingsSelected
            ? const Text(
                'Do you want to reset to the general default settings?')
            : const Text('Do you want to set these settings as default?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => _setOrUndoDefaultSettings(
                gameSettingsX01, defaultSettingsSelected),
            child: const Text('Continue'),
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
        contentPadding: _edgeInsets,
        title: const Text('Info'),
        content: const Text('Team mode for default settings is not supported!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  _setOrUndoDefaultSettings(
      GameSettingsX01 gameSettingsX01, bool defaultSettingsSelected) {
    final defaultSettingsX01 = context.read<DefaultSettingsX01>();
    final FirestoreServiceDefaultSettings firestoreServiceDefaultSettings =
        context.read<FirestoreServiceDefaultSettings>();

    if (defaultSettingsSelected) {
      defaultSettingsX01.isSelected = false;
      defaultSettingsX01.resetValues();
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
    final defaultSettingsX01 = context.read<DefaultSettingsX01>();
    final gameSettingsX01 = context.read<GameSettingsX01>();

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
      centerTitle: true,
      title: Column(
        children: [
          Text(
            'Game Settings',
            style: TextStyle(fontSize: 14.sp),
          ),
        ],
      ),
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pushNamed('/home'),
            icon: Icon(Icons.arrow_back),
          )
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Consumer<GameSettingsX01>(
            builder: (_, gameSettingsX01, __) => IconButton(
              onPressed: () async => _defaultSettingsBtnClicked(),
              icon: DefaultSettingsHelper.defaultSettingsSelected(context)
                  ? Icon(MdiIcons.cardsHeart)
                  : Icon(MdiIcons.heartOutline),
            ),
          ),
        ),
      ],
    );
  }
}
