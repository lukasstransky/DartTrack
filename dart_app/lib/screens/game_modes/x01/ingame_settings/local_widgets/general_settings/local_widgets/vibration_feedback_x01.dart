import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class VibrationFeedbackX01 extends StatelessWidget {
  const VibrationFeedbackX01({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameSettingsX01 = context.read<GameSettingsX01_P>();

    return Container(
      height: HEIGHT_IN_GAME_SETTINGS_WIDGETS.h,
      padding: EdgeInsets.only(left: 2.5.w),
      child: Row(
        children: [
          Text(
            'Vibration feedback',
            style: TextStyle(
                fontSize: FONTSIZE_IN_GAME_SETTINGS.sp, color: Colors.white),
          ),
          Spacer(),
          Selector<GameSettingsX01_P, bool>(
            selector: (_, gameSettingsX01) =>
                gameSettingsX01.getVibrationFeedbackEnabled,
            builder: (_, vibrationFeedbackEnabled, __) => Switch(
              value: vibrationFeedbackEnabled,
              onChanged: (value) {
                gameSettingsX01.setVibrationFeedbackEnabled = value;
                gameSettingsX01.notify();
              },
              thumbColor: MaterialStateProperty.all(
                  Theme.of(context).colorScheme.secondary),
              activeColor: Theme.of(context).colorScheme.secondary,
              inactiveThumbColor: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ],
      ),
    );
  }
}
