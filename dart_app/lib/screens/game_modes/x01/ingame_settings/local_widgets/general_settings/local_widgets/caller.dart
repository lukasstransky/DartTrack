import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class Caller extends StatelessWidget {
  const Caller({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameSettingsX01 = context.read<GameSettingsX01>();

    return Container(
      padding: EdgeInsets.only(left: 2.5.w),
      height: HEIGHT_IN_GAME_SETTINGS_WIDGETS.h,
      child: Row(
        children: [
          Text(
            'Caller',
            style: TextStyle(
                fontSize: FONTSIZE_IN_GAME_SETTINGS.sp, color: Colors.white),
          ),
          Spacer(),
          Selector<GameSettingsX01, bool>(
            selector: (_, gameSettingsX01) => gameSettingsX01.getCallerEnabled,
            builder: (_, callerEnabled, __) => Switch(
              value: callerEnabled,
              onChanged: (value) {
                gameSettingsX01.setCallerEnabled = value;
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
