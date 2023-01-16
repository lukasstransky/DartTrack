import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class CheckoutCountingX01 extends StatelessWidget {
  bool _winByDiffWidgetIsPresent(GameSettingsX01_P gameSettingsX01) {
    return gameSettingsX01.getLegs > 1 &&
        !gameSettingsX01.getSetsEnabled &&
        !gameSettingsX01.getDrawMode;
  }

  bool _noWinByDiffWidgetIsPresent(GameSettingsX01_P gameSettingsX01) {
    if (gameSettingsX01.getLegs == 1 ||
        gameSettingsX01.getSetsEnabled ||
        gameSettingsX01.getDrawMode) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameSettingsX01_P>(
      builder: (_, gameSettingsX01, __) {
        if (gameSettingsX01.getModeOut == ModeOutIn.Double) {
          return Container(
            width: WIDTH_GAMESETTINGS.w,
            transform: Matrix4.translationValues(0.0,
                _winByDiffWidgetIsPresent(gameSettingsX01) ? -1.5.h : 0.0, 0.0),
            margin: EdgeInsets.only(
                top: _noWinByDiffWidgetIsPresent(gameSettingsX01)
                    ? MARGIN_GAMESETTINGS.h
                    : 0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Counting of Checkout %',
                      style: TextStyle(color: Colors.white),
                    ),
                    Switch(
                      thumbColor: MaterialStateProperty.all(
                          Theme.of(context).colorScheme.secondary),
                      activeColor: Theme.of(context).colorScheme.secondary,
                      inactiveThumbColor:
                          Theme.of(context).colorScheme.secondary,
                      value: gameSettingsX01.getEnableCheckoutCounting,
                      onChanged: (value) {
                        gameSettingsX01.setEnableCheckoutCounting = value;
                        gameSettingsX01.notify();
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        } else
          return SizedBox.shrink();
      },
    );
  }
}
