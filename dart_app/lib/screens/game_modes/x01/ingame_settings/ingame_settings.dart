import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/screens/game_modes/x01/ingame_settings/local_widgets/disable_checkout_counting.dart';
import 'package:dart_app/screens/game_modes/x01/ingame_settings/local_widgets/general_settings/general_settings.dart';
import 'package:dart_app/screens/game_modes/x01/ingame_settings/local_widgets/hide_show_settings/hide_show.dart';
import 'package:dart_app/screens/game_modes/x01/ingame_settings/local_widgets/input_method_settings/input_method_settings.dart';
import 'package:dart_app/utils/app_bars/custom_app_bar.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class InGameSettings extends StatelessWidget {
  const InGameSettings({Key? key}) : super(key: key);

  static const routeName = '/inGameSettingsX01';

  _showDisableCheckoutCounting(BuildContext context) {
    final gameSettingsX01 = context.read<GameSettingsX01_P>();
    final gameX01 = context.read<GameX01_P>();

    return gameX01.getInit &&
        gameSettingsX01.getEnableCheckoutCounting &&
        !gameSettingsX01.getCheckoutCountingFinallyDisabled;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Game Settings'),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: Container(
                  width: 95.w,
                  child: Column(
                    children: [
                      HideShow(),
                      GeneralSettings(),
                      InputMethodSettings(),
                      if (_showDisableCheckoutCounting(context))
                        DisableCheckoutCounting(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
