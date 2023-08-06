import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:sizer/sizer.dart';

class HideShowAverageX01 extends StatelessWidget {
  const HideShowAverageX01({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late double scaleFactorSwitch;
    if (ResponsiveBreakpoints.of(context).isMobile) {
      scaleFactorSwitch = SWTICH_SCALE_FACTOR_MOBILE;
    } else if (ResponsiveBreakpoints.of(context).isTablet ||
        ResponsiveBreakpoints.of(context).isDesktop) {
      scaleFactorSwitch = SWTICH_SCALE_FACTOR_TABLET;
    } else {
      scaleFactorSwitch = SWTICH_SCALE_FACTOR_TABLET;
    }
    final GameSettingsX01_P gameSettingsX01 = context.read<GameSettingsX01_P>();

    return Container(
      padding: EdgeInsets.only(left: 2.5.w),
      height: HEIGHT_IN_GAME_SETTINGS_WIDGETS.h,
      child: Row(
        children: [
          Text(
            'Average',
            style: TextStyle(
              fontSize: FONTSIZE_IN_GAME_SETTINGS.sp,
              color: Colors.white,
            ),
          ),
          Spacer(),
          Selector<GameSettingsX01_P, bool>(
            selector: (_, gameSettingsX01) => gameSettingsX01.getShowAverage,
            builder: (_, showAverage, __) => Transform.scale(
              scale: scaleFactorSwitch,
              child: Switch(
                value: showAverage,
                onChanged: (value) {
                  Utils.handleVibrationFeedback(context);
                  gameSettingsX01.setShowAverage = value;
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
    );
  }
}
