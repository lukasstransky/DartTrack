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
      builder: (_, selectorModel, __) => InkWell(
        child: Container(
          width: WIDTH_GAMESETTINGS.w,
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(top: 1.h, bottom: 1.h),
          child: InkWell(
            splashColor:
                Utils.darken(Theme.of(context).colorScheme.primary, 10),
            highlightColor:
                Utils.darken(Theme.of(context).colorScheme.primary, 10),
            onTap: () {
              Utils.handleVibrationFeedback(context);
              Navigator.of(context).pushNamed('/inGameSettingsX01');
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.settings,
                  color: Theme.of(context).colorScheme.secondary,
                  size: ICON_BUTTON_SIZE.h,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Advanced settings',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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
