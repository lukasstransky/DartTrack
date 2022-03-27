import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class HideShow extends StatelessWidget {
  const HideShow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameSettingsX01 =
        Provider.of<GameSettingsX01>(context, listen: false);

    return SizedBox(
      height: 24.h,
      child: Padding(
        padding: EdgeInsets.only(top: 1.5.h),
        child: Card(
          elevation: 5,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 0.5.h, left: 1.5.w, bottom: 1.h),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Hide/Show",
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
                          "Average",
                          style:
                              TextStyle(fontSize: FONTSIZE_IN_GAME_SETTINGS.sp),
                        ),
                        Spacer(),
                        Switch(
                          value: gameSettingsX01.getShowAverage,
                          onChanged: (value) {
                            gameSettingsX01.setShowAverage = value;
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
                          "Finish Ways",
                          style:
                              TextStyle(fontSize: FONTSIZE_IN_GAME_SETTINGS.sp),
                        ),
                        Spacer(),
                        Switch(
                          value: gameSettingsX01.getShowFinishWays,
                          onChanged: (value) {
                            gameSettingsX01.setShowFinishWays = value;
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
                          "Last Throw",
                          style:
                              TextStyle(fontSize: FONTSIZE_IN_GAME_SETTINGS.sp),
                        ),
                        Spacer(),
                        Switch(
                          value: gameSettingsX01.getShowLastThrow,
                          onChanged: (value) {
                            gameSettingsX01.setShowLastThrow = value;
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
                          "Thrown Darts per Leg",
                          style:
                              TextStyle(fontSize: FONTSIZE_IN_GAME_SETTINGS.sp),
                        ),
                        Spacer(),
                        Switch(
                          value: gameSettingsX01.getShowThrownDartsPerLeg,
                          onChanged: (value) {
                            gameSettingsX01.setShowThrownDartsPerLeg = value;
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
