import 'package:dart_app/models/default_settings_x01.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/services/firestore_service.dart';

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
  showDialogForGenerelDefaultSettings() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
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

  showDialogForResettingToGeneralDefaultSettings() {
    final defaultSettingsX01 =
        Provider.of<DefaultSettingsX01>(context, listen: false);
    final gameSettingsX01 =
        Provider.of<GameSettingsX01>(context, listen: false);
    final FirestoreService firestoreService = context.read<FirestoreService>();

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset to general default settings'),
        content:
            const Text('Do you want to reset to the general default settings?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => {
              defaultSettingsX01.isSelected = false,
              defaultSettingsX01.resetValues(),
              firestoreService.postDefaultSettingsX01(context),
              gameSettingsX01.notify(),
              Navigator.of(context).pop(),
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  showDialogForDefaultSettings() {
    final defaultSettingsX01 =
        Provider.of<DefaultSettingsX01>(context, listen: false);
    final gameSettingsX01 =
        Provider.of<GameSettingsX01>(context, listen: false);
    final bool defaultSettingsSelected =
        gameSettingsX01.defaultSettingsSelected(context);
    final FirestoreService firestoreService = context.read<FirestoreService>();

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: defaultSettingsSelected
            ? Text('Undo default settings')
            : Text('Save settings as default'),
        content: defaultSettingsSelected
            ? Text('Do you want to reset to the general default settings?')
            : Text('Do you want to set these settings as default?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => {
              if (defaultSettingsSelected)
                {
                  defaultSettingsX01.isSelected = false,
                  defaultSettingsX01.resetValues(),
                }
              else
                {
                  defaultSettingsX01.isSelected = true,
                  gameSettingsX01.setDefaultSettings(context),
                },
              firestoreService.postDefaultSettingsX01(context),
              gameSettingsX01.notify(),
              Navigator.of(context).pop(),
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final defaultSettingsX01 =
        Provider.of<DefaultSettingsX01>(context, listen: false);

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
            onPressed: () {
              Navigator.of(context).pushNamed('/home');
            },
            icon: Icon(Icons.arrow_back),
          )
        ],
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 10),
          child: Consumer<GameSettingsX01>(
            builder: (_, gameSettingsX01, __) => IconButton(
              onPressed: () async => {
                if (gameSettingsX01.generalDefaultSettingsSelected() &&
                    !defaultSettingsX01.isSelected)
                  {
                    this.showDialogForGenerelDefaultSettings(),
                  }
                else if (gameSettingsX01.generalDefaultSettingsSelected() &&
                    defaultSettingsX01.isSelected)
                  {
                    this.showDialogForResettingToGeneralDefaultSettings(),
                  }
                else
                  {
                    this.showDialogForDefaultSettings(),
                  }
              },
              icon: gameSettingsX01.defaultSettingsSelected(context)
                  ? Icon(MdiIcons.cardsHeart)
                  : Icon(MdiIcons.heartOutline),
            ),
          ),
        ),
      ],
    );
  }
}
