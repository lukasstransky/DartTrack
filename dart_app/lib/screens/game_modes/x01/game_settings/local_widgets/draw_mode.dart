import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class DrawMode extends StatelessWidget {
  double _getProperValueForTransformation(GameSettingsX01 gameSettingsX01) {
    if (_checkoutCountingPresent(gameSettingsX01) &&
        _winByTwoLegsPresent(gameSettingsX01)) {
      return -3.0;
    } else if (_noCheckoutCountAndWinByDiffPresent(gameSettingsX01)) {
      return 0.0;
    } else if (_checkoutCountingPresent(gameSettingsX01) &&
        !_winByTwoLegsPresent(gameSettingsX01)) {
      return -1.5;
    } else if (!_checkoutCountingPresent(gameSettingsX01) &&
        _winByTwoLegsPresent(gameSettingsX01)) {
      return -1.5;
    }
    return -3.0;
  }

  bool _noCheckoutCountAndWinByDiffPresent(GameSettingsX01 gameSettingsX01) {
    if (!_checkoutCountingPresent(gameSettingsX01) &&
        !_winByTwoLegsPresent(gameSettingsX01)) {
      return true;
    }
    return false;
  }

  bool _checkoutCountingPresent(GameSettingsX01 gameSettingsX01) {
    return gameSettingsX01.getModeOut == ModeOutIn.Double;
  }

  bool _winByTwoLegsPresent(GameSettingsX01 gameSettingsX01) {
    return gameSettingsX01.getLegs > 1 &&
        !gameSettingsX01.getSetsEnabled &&
        !gameSettingsX01.getDrawMode;
  }

  _drawModeSwitchPressed(GameSettingsX01 gameSettingsX01, bool value) {
    if (value == false) {
      gameSettingsX01.setSets = DEFAULT_SETS_BEST_OF_SETS_ENABLED;
      if (gameSettingsX01.getSetsEnabled) {
        gameSettingsX01.setLegs = DEFAULT_LEGS_BEST_OF_SETS_ENABLED;
      } else {
        gameSettingsX01.setLegs = DEFAULT_LEGS_BEST_OF_NO_SETS;
      }
    } else {
      gameSettingsX01.setMode = BestOfOrFirstToEnum.BestOf;
      gameSettingsX01.setSets = DEFAULT_SETS_DRAW_MODE;

      if (gameSettingsX01.getSetsEnabled) {
        gameSettingsX01.setLegs = DEFAULT_LEGS_DRAW_MODE_SETS_ENABLED;
      } else {
        gameSettingsX01.setLegs = DEFAULT_LEGS_DRAW_MODE;
      }
    }

    gameSettingsX01.setDrawMode = value;

    gameSettingsX01.notify();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameSettingsX01>(
      builder: (_, gameSettingsX01, __) {
        if (!gameSettingsX01.getWinByTwoLegsDifference) {
          return Container(
            width: WIDTH_GAMESETTINGS.w,
            transform: Matrix4.translationValues(
                0.0, _getProperValueForTransformation(gameSettingsX01).h, 0.0),
            margin: EdgeInsets.only(
                top: _noCheckoutCountAndWinByDiffPresent(gameSettingsX01)
                    ? MARGIN_GAMESETTINGS.h
                    : 0.h),
            child: Column(
              children: [
                Row(
                  children: [
                    const Text('Draw Mode'),
                    Switch(
                      value: gameSettingsX01.getDrawMode,
                      onChanged: (value) {
                        _drawModeSwitchPressed(gameSettingsX01, value);
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        } else
          return SizedBox.shrink();
      },
    );
  }
}
