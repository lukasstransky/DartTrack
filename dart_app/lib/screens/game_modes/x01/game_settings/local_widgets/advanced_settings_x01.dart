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
        width: WIDTH_GAMESETTINGS.w,
        padding: EdgeInsets.only(
            top: 1.h, bottom: Utils.isLandscape(context) ? 1.h : 0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Container(
            child: GestureDetector(
              onTap: () {
                Utils.handleVibrationFeedback(context);
                Navigator.of(context).pushNamed('/inGameSettingsX01');
              },
              child: Container(
                padding: EdgeInsets.only(bottom: 1.h),
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
                        fontSize:
                            Theme.of(context).textTheme.bodyMedium!.fontSize,
                      ),
                    ),
                  ],
                ),
              ),
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
