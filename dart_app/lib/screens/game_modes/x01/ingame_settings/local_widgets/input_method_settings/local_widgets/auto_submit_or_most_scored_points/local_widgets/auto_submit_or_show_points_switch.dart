import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:sizer/sizer.dart';

class AutoSubmitOrShowMostScoredPointsSwitch extends StatelessWidget {
  const AutoSubmitOrShowMostScoredPointsSwitch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GameSettingsX01_P gameSettingsX01 = context.read<GameSettingsX01_P>();

    late double scaleFactorSwitch;
    if (ResponsiveBreakpoints.of(context).isMobile) {
      scaleFactorSwitch = SWTICH_SCALE_FACTOR_MOBILE;
    } else if (ResponsiveBreakpoints.of(context).isTablet ||
        ResponsiveBreakpoints.of(context).isDesktop) {
      scaleFactorSwitch = SWTICH_SCALE_FACTOR_TABLET;
    } else {
      scaleFactorSwitch = SWTICH_SCALE_FACTOR_TABLET;
    }

    if (gameSettingsX01.getInputMethod == InputMethod.Round) {
      return Flexible(
        child: Padding(
          padding: EdgeInsets.only(left: 2.5.w),
          child: Row(
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'Most scored points',
                  style: TextStyle(
                    fontSize: FONTSIZE_IN_GAME_SETTINGS.sp,
                    color: Colors.white,
                  ),
                ),
              ),
              Spacer(),
              Transform.scale(
                scale: scaleFactorSwitch,
                child: Switch(
                  value: gameSettingsX01.getShowMostScoredPoints,
                  onChanged: (value) {
                    Utils.handleVibrationFeedback(context);
                    gameSettingsX01.setShowMostScoredPoints = value;

                    gameSettingsX01.notify();
                  },
                  thumbColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.secondary),
                  activeColor: Theme.of(context).colorScheme.secondary,
                  inactiveThumbColor: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Flexible(
      child: Padding(
        padding: EdgeInsets.only(left: 2.5.w),
        child: Row(
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'Automatically submit points',
                style: TextStyle(
                  fontSize: FONTSIZE_IN_GAME_SETTINGS.sp,
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
                child: Switch(
                  value: automaticallySubmitPoints,
                  onChanged: (value) {
                    Utils.handleVibrationFeedback(context);
                    gameSettingsX01.setAutomaticallySubmitPoints = value;

                    gameSettingsX01.notify();
                  },
                  thumbColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.secondary),
                  activeColor: Theme.of(context).colorScheme.secondary,
                  inactiveThumbColor: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
