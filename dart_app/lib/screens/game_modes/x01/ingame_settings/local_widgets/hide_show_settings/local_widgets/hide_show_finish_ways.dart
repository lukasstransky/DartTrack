import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class HideShowFinishWays extends StatelessWidget {
  const HideShowFinishWays({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameSettingsX01 = context.read<GameSettingsX01>();

    return Container(
      height: HEIGHT_IN_GAME_SETTINGS_WIDGETS.h,
      padding: EdgeInsets.only(left: 2.5.w),
      child: Row(
        children: [
          Text(
            'Finish Ways',
            style: TextStyle(
                fontSize: FONTSIZE_IN_GAME_SETTINGS.sp, color: Colors.white),
          ),
          Spacer(),
          Selector<GameSettingsX01, bool>(
            selector: (_, gameSettingsX01) => gameSettingsX01.getShowFinishWays,
            builder: (_, showFinishWays, __) => Switch(
              value: showFinishWays,
              onChanged: (value) {
                gameSettingsX01.setShowFinishWays = value;
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
