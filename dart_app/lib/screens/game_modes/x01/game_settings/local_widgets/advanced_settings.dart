import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class AdvancedSettings extends StatelessWidget {
  double _getProperValueForTransformation(GameSettingsX01 gameSettingsX01) {
    int counter = _getCountOfPresentSwitchers(gameSettingsX01);
    if (counter == 3) {
      return -3.5;
    } else if (counter == 2) {
      return -2;
    } else if (counter == 1) {
      return -0.5;
    }
    return 0;
  }

  int _getCountOfPresentSwitchers(GameSettingsX01 gameSettingsX01) {
    int counter = 0;
    if (_checkoutCountingPresent(gameSettingsX01)) {
      counter++;
    }
    if (_winByTwoLegsPresent(gameSettingsX01)) {
      counter++;
    }
    if (!gameSettingsX01.getWinByTwoLegsDifference) {
      counter++;
    }
    return counter;
  }

  bool _checkoutCountingPresent(GameSettingsX01 gameSettingsX01) {
    return gameSettingsX01.getModeOut == ModeOutIn.Double;
  }

  bool _winByTwoLegsPresent(GameSettingsX01 gameSettingsX01) {
    return gameSettingsX01.getLegs > 1 &&
        !gameSettingsX01.getSetsEnabled &&
        !gameSettingsX01.getDrawMode;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameSettingsX01>(
      builder: (_, gameSettingsX01, __) => Container(
        transform: Matrix4.translationValues(
            0.0, _getProperValueForTransformation(gameSettingsX01).h, 0.0),
        child: Padding(
          padding: EdgeInsets.only(left: 7.w),
          child: Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () {
                Navigator.of(context).pushNamed('/inGameSettingsX01');
              },
              icon: Icon(
                Icons.settings,
              ),
              label: const Text(
                'Advanced Setttings',
              ),
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
