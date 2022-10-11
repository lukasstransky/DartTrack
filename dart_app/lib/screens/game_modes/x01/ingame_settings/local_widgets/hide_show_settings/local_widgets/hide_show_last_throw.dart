import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class HideShowLastThrow extends StatelessWidget {
  const HideShowLastThrow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameSettingsX01 = context.read<GameSettingsX01>();

    return Container(
      height: HEIGHT_IN_GAME_SETTINGS_WIDGETS.h,
      padding: EdgeInsets.only(left: 2.5.w),
      child: Row(
        children: [
          Text(
            'Last Throw',
            style: TextStyle(fontSize: FONTSIZE_IN_GAME_SETTINGS.sp),
          ),
          Spacer(),
          Selector<GameSettingsX01, bool>(
            selector: (_, gameSettingsX01) => gameSettingsX01.getShowLastThrow,
            builder: (_, showLastThrow, __) => Switch(
              value: showLastThrow,
              onChanged: (value) {
                gameSettingsX01.setShowLastThrow = value;
                gameSettingsX01.notify();
              },
            ),
          ),
        ],
      ),
    );
  }
}
