import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class ShowInputMethodSwitchX01 extends StatelessWidget {
  const ShowInputMethodSwitchX01({Key? key}) : super(key: key);

  _switchBtnPressed(GameSettingsX01_P gameSettingsX01, bool value) {
    gameSettingsX01.setShowInputMethodInGameScreen = value;
    gameSettingsX01.notify();
  }

  @override
  Widget build(BuildContext context) {
    final gameSettingsX01 = context.read<GameSettingsX01_P>();

    return Container(
      height: 4.h,
      padding: EdgeInsets.only(left: 2.5.w),
      child: Row(
        children: [
          Text(
            'Show in game screen',
            style: TextStyle(
              fontSize: FONTSIZE_IN_GAME_SETTINGS.sp,
              color: Colors.white,
            ),
          ),
          Spacer(),
          Selector<GameSettingsX01_P, bool>(
            selector: (_, gameSettingsX01) =>
                gameSettingsX01.getShowInputMethodInGameScreen,
            builder: (_, showInputMethodInGameScreen, __) => Switch(
              value: showInputMethodInGameScreen,
              onChanged: (value) => _switchBtnPressed(gameSettingsX01, value),
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
