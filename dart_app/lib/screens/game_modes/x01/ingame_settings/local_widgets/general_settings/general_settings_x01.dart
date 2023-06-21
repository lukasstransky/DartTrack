import 'package:dart_app/constants.dart';
import 'package:dart_app/screens/game_modes/x01/ingame_settings/local_widgets/general_settings/local_widgets/vibration_feedback_x01.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class GeneralSettingsX01 extends StatelessWidget {
  const GeneralSettingsX01({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 11.h,
      padding: EdgeInsets.only(
        top: 2.0.h,
        left: 0.5.h,
        right: 0.5.h,
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(CARD_SHAPE_ROUNDING),
        ),
        elevation: 5,
        margin: EdgeInsets.all(0),
        color: Utils.darken(Theme.of(context).colorScheme.primary, 10),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                top: 0.5.h,
                left: 1.5.w,
              ),
              alignment: Alignment.centerLeft,
              child: Text(
                'General',
                style: TextStyle(
                  fontSize: FONTSIZE_HEADINGS_IN_GAME_SETTINGS.sp,
                  color: Utils.getTextColorDarken(context),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            VibrationFeedbackX01(),
          ],
        ),
      ),
    );
  }
}
