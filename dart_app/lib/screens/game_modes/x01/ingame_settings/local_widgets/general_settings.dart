import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class GeneralSettings extends StatelessWidget {
  const GeneralSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameSettingsX01 =
        Provider.of<GameSettingsX01>(context, listen: false);

    return SizedBox(
      height: 15.h,
      child: Padding(
        padding: EdgeInsets.only(top: 1.0.h),
        child: Card(
          elevation: 5,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 0.5.h, left: 1.5.w, bottom: 1.h),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'General',
                    style: TextStyle(
                        fontSize: FONTSIZE_HEADINGS_IN_GAME_SETTINGS.sp,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: EdgeInsets.only(left: 2.5.w),
                  child: SizedBox(
                    height: HEIGHT_IN_GAME_SETTINGS_WIDGETS.h,
                    child: Row(
                      children: [
                        Text(
                          'Caller',
                          style:
                              TextStyle(fontSize: FONTSIZE_IN_GAME_SETTINGS.sp),
                        ),
                        Spacer(),
                        Switch(
                          value: gameSettingsX01.getCallerEnabled,
                          onChanged: (value) {
                            gameSettingsX01.setCallerEnabled = value;
                            gameSettingsX01.notify();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: EdgeInsets.only(left: 2.5.w),
                  child: SizedBox(
                    height: HEIGHT_IN_GAME_SETTINGS_WIDGETS.h,
                    child: Row(
                      children: [
                        Text(
                          'Vibration Feedback',
                          style:
                              TextStyle(fontSize: FONTSIZE_IN_GAME_SETTINGS.sp),
                        ),
                        Spacer(),
                        Switch(
                          value: gameSettingsX01.getVibrationFeedbackEnabled,
                          onChanged: (value) {
                            gameSettingsX01.setVibrationFeedbackEnabled = value;
                            gameSettingsX01.notify();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
