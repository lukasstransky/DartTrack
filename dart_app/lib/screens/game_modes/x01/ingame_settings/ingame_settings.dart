import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/screens/game_modes/x01/ingame_settings/local_widgets/disable_checkout_counting.dart';
import 'package:dart_app/screens/game_modes/x01/ingame_settings/local_widgets/general_settings.dart';
import 'package:dart_app/screens/game_modes/x01/ingame_settings/local_widgets/hide_show.dart';
import 'package:dart_app/screens/game_modes/x01/ingame_settings/local_widgets/input_method_settings.dart';
import 'package:dart_app/utils/app_bars/custom_app_bar.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'dart:developer';

class InGameSettings extends StatelessWidget {
  const InGameSettings({Key? key}) : super(key: key);

  static const routeName = "/inGameSettingsX01";

  @override
  Widget build(BuildContext context) {
    final gameX01 = Provider.of<GameX01>(context, listen: false);

    return Scaffold(
      appBar: CustomAppBar(true, "Game Settings"),
      body: Center(
        child: Container(
          width: 95.w,
          child: Consumer<GameSettingsX01>(
            builder: (_, gameSettingsX01, __) => Column(
              children: [
                HideShow(),
                GeneralSettings(),
                InputMethodSettings(),
                if (gameSettingsX01.getEnableCheckoutCounting &&
                    gameSettingsX01.getCheckoutCountingFinallyDisabled ==
                        false &&
                    gameX01.getInit)
                  DisableCheckoutCounting(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
