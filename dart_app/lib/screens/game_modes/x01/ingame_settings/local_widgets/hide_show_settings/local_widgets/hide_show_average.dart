import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class HideShowAverage extends StatelessWidget {
  const HideShowAverage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameSettingsX01 = context.read<GameSettingsX01>();

    return Container(
      padding: EdgeInsets.only(left: 2.5.w),
      height: HEIGHT_IN_GAME_SETTINGS_WIDGETS.h,
      child: Row(
        children: [
          Text(
            'Average',
            style: TextStyle(fontSize: FONTSIZE_IN_GAME_SETTINGS.sp),
          ),
          Spacer(),
          Selector<GameSettingsX01, bool>(
            selector: (_, gameSettingsX01) => gameSettingsX01.getShowAverage,
            builder: (_, showAverage, __) => Switch(
              value: showAverage,
              onChanged: (value) {
                gameSettingsX01.setShowAverage = value;
                gameSettingsX01.notify();
              },
            ),
          ),
        ],
      ),
    );
  }
}
