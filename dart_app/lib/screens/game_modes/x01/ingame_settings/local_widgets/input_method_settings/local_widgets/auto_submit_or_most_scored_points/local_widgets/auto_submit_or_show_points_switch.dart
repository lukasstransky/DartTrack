import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class AutoSubmitOrShowMostScoredPointsSwitch extends StatelessWidget {
  const AutoSubmitOrShowMostScoredPointsSwitch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GameSettingsX01_P gameSettingsX01 = context.read<GameSettingsX01_P>();
    final double scaleFactorSwitch = Utils.getSwitchScaleFactor(context);
    final double paddingRight = Utils.getResponsiveValue(
      context: context,
      mobileValue: 0.h,
      tabletValue: ADVANCED_SETTINGS_SWITCH_PADDING_RIGHT_TABLET.w,
    );

    if (gameSettingsX01.getInputMethod == InputMethod.Round) {
      return Padding(
        padding: EdgeInsets.only(left: 2.5.w),
        child: Row(
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'Most scored points',
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                  color: Colors.white,
                ),
              ),
            ),
            Spacer(),
            Transform.scale(
              scale: scaleFactorSwitch,
              child: Container(
                padding: EdgeInsets.only(right: paddingRight),
                child: Switch(
                  value: gameSettingsX01.getShowMostScoredPoints,
                  onChanged: (value) {
                    Utils.handleVibrationFeedback(context);
                    gameSettingsX01.setShowMostScoredPoints = value;

                    gameSettingsX01.notify();
                  },
                  thumbColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.secondary),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.only(left: 2.5.w),
      child: Row(
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'Automatically submit points',
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                color: Colors.white,
              ),
            ),
          ),
          Spacer(),
          Selector<GameSettingsX01_P, bool>(
            selector: (_, gameSettingsX01) =>
                gameSettingsX01.getAutomaticallySubmitPoints,
            builder: (_, automaticallySubmitPoints, __) => Transform.scale(
              scale: scaleFactorSwitch,
              child: Container(
                padding: EdgeInsets.only(right: paddingRight),
                child: Switch(
                  value: automaticallySubmitPoints,
                  onChanged: (value) {
                    Utils.handleVibrationFeedback(context);
                    gameSettingsX01.setAutomaticallySubmitPoints = value;

                    gameSettingsX01.notify();
                  },
                  thumbColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.secondary),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
