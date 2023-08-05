import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class AdvancedSettingsX01 extends StatelessWidget {
  const AdvancedSettingsX01({Key? key}) : super(key: key);

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
      builder: (_, selectorModel, __) => Container(
        transform: Matrix4.translationValues(
            0.0, _getProperValueForTransformation(selectorModel).h, 0.0),
        child: Padding(
          padding: EdgeInsets.only(left: 7.w),
          child: Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () {
                Utils.handleVibrationFeedback(context);
                Navigator.of(context).pushNamed('/inGameSettingsX01');
              },
              icon: Icon(
                Icons.settings,
                color: Theme.of(context).colorScheme.secondary,
                size: ICON_BUTTON_SIZE.h,
              ),
              label: Text(
                'Advanced setttings',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 10.sp,
                ),
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

  double _getProperValueForTransformation(SelectorModel selectorModel) {
    int counter = _getCountOfPresentSwitchers(selectorModel);
    if (counter == 3) {
      return -3;
    } else if (counter == 2) {
      return -2;
    } else if (counter == 1) {
      return -0.5;
    }
    return 0;
  }

  int _getCountOfPresentSwitchers(SelectorModel selectorModel) {
    int counter = 0;
    if (selectorModel.modeOut == ModeOutIn.Double) {
      counter++;
    }
    if (_winByTwoLegsPresent(selectorModel)) {
      counter++;
    }
    if (!selectorModel.winByTwoLegsDifference) {
      counter++;
    }
    return counter;
  }

  bool _winByTwoLegsPresent(SelectorModel selectorModel) {
    return selectorModel.legs > 1 && !selectorModel.drawMode;
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
