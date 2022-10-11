import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class VibrationFeedback extends StatelessWidget {
  const VibrationFeedback({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameSettingsX01 = context.read<GameSettingsX01>();

    return Container(
      height: HEIGHT_IN_GAME_SETTINGS_WIDGETS.h,
      padding: EdgeInsets.only(left: 2.5.w),
      child: Row(
        children: [
          Text(
            'Vibration Feedback',
            style: TextStyle(fontSize: FONTSIZE_IN_GAME_SETTINGS.sp),
          ),
          Spacer(),
          Selector<GameSettingsX01, bool>(
            selector: (_, gameSettingsX01) =>
                gameSettingsX01.getVibrationFeedbackEnabled,
            builder: (_, vibrationFeedbackEnabled, __) => Switch(
              value: vibrationFeedbackEnabled,
              onChanged: (value) {
                gameSettingsX01.setVibrationFeedbackEnabled = value;
                gameSettingsX01.notify();
              },
            ),
          ),
        ],
      ),
    );
  }
}
