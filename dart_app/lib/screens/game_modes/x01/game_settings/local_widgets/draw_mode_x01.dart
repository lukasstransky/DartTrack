import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class DrawModeX01 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double scaleFactorSwitch = Utils.getSwitchScaleFactor(context);

    return Selector<GameSettingsX01_P, SelectorModel>(
      selector: (_, gameSettingsX01) => SelectorModel(
        drawMode: gameSettingsX01.getDrawMode,
        winByTwoLegsDifference: gameSettingsX01.getWinByTwoLegsDifference,
      ),
      builder: (_, selectorModel, __) {
        final bool disableSwitch = selectorModel.winByTwoLegsDifference;
        final double textSwitchSpace = Utils.getResponsiveValue(
          context: context,
          mobileValue: 0,
          tabletValue: TEXT_SWITCH_SPACE_TABLET,
        );
        final double paddingTop = Utils.getResponsiveValue(
          context: context,
          mobileValue: 0,
          tabletValue: 1,
        );

        return Container(
          width: WIDTH_GAMESETTINGS.w,
          padding: EdgeInsets.only(top: paddingTop.h),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Draw mode',
                    style: TextStyle(
                      color: disableSwitch ? Colors.white70 : Colors.white,
                      fontSize:
                          Theme.of(context).textTheme.bodyMedium!.fontSize,
                    ),
                  ),
                  SizedBox(
                    width: textSwitchSpace.w,
                  ),
                  Transform.scale(
                    scale: scaleFactorSwitch,
                    child: Switch(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      thumbColor: disableSwitch
                          ? MaterialStateProperty.all(Colors.grey)
                          : MaterialStateProperty.all(
                              Theme.of(context).colorScheme.secondary),
                      value: selectorModel.drawMode,
                      onChanged: (value) {
                        if (disableSwitch) {
                          Fluttertoast.showToast(
                            msg:
                                'Not possible with win by two legs difference!',
                            toastLength: Toast.LENGTH_LONG,
                            fontSize: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .fontSize!,
                          );
                          return;
                        }

                        Utils.handleVibrationFeedback(context);
                        _drawModeSwitchPressed(
                            context.read<GameSettingsX01_P>(), value);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
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
}

class SelectorModel {
  final bool winByTwoLegsDifference;
  final bool drawMode;

  SelectorModel({
    required this.winByTwoLegsDifference,
    required this.drawMode,
  });
}
