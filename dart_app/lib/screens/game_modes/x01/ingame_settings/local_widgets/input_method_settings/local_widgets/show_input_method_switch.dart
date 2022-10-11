import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class ShowInputMethodSwitch extends StatelessWidget {
  const ShowInputMethodSwitch({Key? key}) : super(key: key);

  _switchBtnPressed(GameSettingsX01 gameSettingsX01, bool value) {
    gameSettingsX01.setShowInputMethodInGameScreen = value;
    gameSettingsX01.notify();
  }

  @override
  Widget build(BuildContext context) {
    final gameSettingsX01 = context.read<GameSettingsX01>();

    return Container(
      height: 4.h,
      padding: EdgeInsets.only(left: 2.5.w),
      child: Row(
        children: [
          Text(
            'Show in Game Screen',
            style: TextStyle(fontSize: FONTSIZE_IN_GAME_SETTINGS.sp),
          ),
          Spacer(),
          Selector<GameSettingsX01, bool>(
            selector: (_, gameSettingsX01) =>
                gameSettingsX01.getShowInputMethodInGameScreen,
            builder: (_, showInputMethodInGameScreen, __) => Switch(
              value: showInputMethodInGameScreen,
              onChanged: (value) => _switchBtnPressed(gameSettingsX01, value),
            ),
          ),
        ],
      ),
    );
  }
}
