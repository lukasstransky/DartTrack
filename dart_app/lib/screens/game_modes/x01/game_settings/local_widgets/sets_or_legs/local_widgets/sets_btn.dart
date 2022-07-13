import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class SetsBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final gameSettingsX01 =
        Provider.of<GameSettingsX01>(context, listen: false);

    return Expanded(
      child: SizedBox(
        height: WIDGET_HEIGHT_GAMESETTINGS.h,
        child: Selector<GameSettingsX01, bool>(
          selector: (_, gameSettingsX01) => gameSettingsX01.getSetsEnabled,
          builder: (_, setsEnabled, __) => ElevatedButton(
            onPressed: () => gameSettingsX01.setsClicked(),
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: const Text('Sets'),
            ),
            style: ButtonStyle(
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(BUTTON_BORDER_RADIUS),
                  ),
                ),
              ),
              backgroundColor: setsEnabled == true
                  ? Utils.getColor(Theme.of(context).colorScheme.primary)
                  : Utils.getColor(Colors.grey),
            ),
          ),
        ),
      ),
    );
  }
}
