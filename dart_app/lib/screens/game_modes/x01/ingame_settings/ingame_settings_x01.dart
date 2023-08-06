import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/screens/game_modes/x01/ingame_settings/local_widgets/disable_checkout_counting_x01.dart';
import 'package:dart_app/screens/game_modes/x01/ingame_settings/local_widgets/hide_show_settings/hide_show_x01.dart';
import 'package:dart_app/screens/game_modes/x01/ingame_settings/local_widgets/input_method_settings/input_method_settings_x01.dart';
import 'package:dart_app/utils/app_bars/custom_app_bar.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class InGameSettingsX01 extends StatelessWidget {
  const InGameSettingsX01({Key? key}) : super(key: key);

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
      appBar: CustomAppBar(title: 'X01 settings'),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Center(
                child: Container(
                  width: 95.w,
                  child: Column(
                    children: [
                      HideShowX01(),
                      InputMethodSettingsX01(),
                      Selector<GameSettingsX01_P, bool>(
                        selector: (_, gameSettingsX01) =>
                            gameSettingsX01.getCheckoutCountingFinallyDisabled,
                        builder: (_, __, ___) =>
                            _showDisableCheckoutCounting(context)
                                ? DisableCheckoutCountingX01()
                                : SizedBox.shrink(),
                      ),
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
