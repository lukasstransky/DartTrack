import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class DrawModeX01 extends StatelessWidget {
  double _getProperValueForTransformation(SelectorModel selectorModel) {
    if (_checkoutCountingPresent(selectorModel) &&
        _winByTwoLegsPresent(selectorModel)) {
      return -3.0;
    } else if (_noCheckoutCountAndWinByDiffPresent(selectorModel)) {
      return 0.0;
    } else if (_checkoutCountingPresent(selectorModel) &&
        !_winByTwoLegsPresent(selectorModel)) {
      return -1.5;
    } else if (!_checkoutCountingPresent(selectorModel) &&
        _winByTwoLegsPresent(selectorModel)) {
      return -1.5;
    }
    return -3.0;
  }

  bool _noCheckoutCountAndWinByDiffPresent(SelectorModel selectorModel) {
    if (!_checkoutCountingPresent(selectorModel) &&
        !_winByTwoLegsPresent(selectorModel)) {
      return true;
    }
    return false;
  }

  bool _checkoutCountingPresent(SelectorModel selectorModel) {
    return selectorModel.modeOut == ModeOutIn.Double;
  }

  bool _winByTwoLegsPresent(SelectorModel selectorModel) {
    return selectorModel.legs > 1 && !selectorModel.drawMode;
  }

  _drawModeSwitchPressed(GameSettingsX01_P gameSettingsX01, bool value) {
    if (value == false) {
      gameSettingsX01.setSets = DEFAULT_SETS_BEST_OF_SETS_ENABLED;
      if (gameSettingsX01.getSetsEnabled) {
        gameSettingsX01.setLegs = DEFAULT_LEGS_BEST_OF_SETS_ENABLED;
      } else {
        gameSettingsX01.setLegs = DEFAULT_LEGS_BEST_OF_NO_SETS;
      }
    } else {
      gameSettingsX01.setBestOfOrFirstTo = BestOfOrFirstToEnum.BestOf;
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
    return Selector<GameSettingsX01_P, SelectorModel>(
      selector: (_, gameSettingsX01) => SelectorModel(
        drawMode: gameSettingsX01.getDrawMode,
        winByTwoLegsDifference: gameSettingsX01.getWinByTwoLegsDifference,
        legs: gameSettingsX01.getLegs,
        modeOut: gameSettingsX01.getModeOut,
        setsEnabled: gameSettingsX01.getSetsEnabled,
      ),
      builder: (_, selectorModel, __) {
        if (!selectorModel.winByTwoLegsDifference) {
          return Container(
            width: WIDTH_GAMESETTINGS.w,
            transform: Matrix4.translationValues(
                0.0, _getProperValueForTransformation(selectorModel).h, 0.0),
            margin: EdgeInsets.only(
                top: _noCheckoutCountAndWinByDiffPresent(selectorModel)
                    ? MARGIN_GAMESETTINGS.h
                    : 0.h),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Draw mode',
                      style: TextStyle(
                        color: Utils.getTextColorForGameSettingsPage(),
                      ),
                    ),
                    Switch(
                      thumbColor: MaterialStateProperty.all(
                          Theme.of(context).colorScheme.secondary),
                      activeColor: Theme.of(context).colorScheme.secondary,
                      inactiveThumbColor:
                          Theme.of(context).colorScheme.secondary,
                      value: selectorModel.drawMode,
                      onChanged: (value) => _drawModeSwitchPressed(
                          context.read<GameSettingsX01_P>(), value),
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

class SelectorModel {
  final ModeOutIn modeOut;
  final bool winByTwoLegsDifference;
  final int legs;
  final bool setsEnabled;
  final bool drawMode;

  SelectorModel({
    required this.modeOut,
    required this.winByTwoLegsDifference,
    required this.legs,
    required this.setsEnabled,
    required this.drawMode,
  });
}
