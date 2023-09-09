import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class HideShowThrownDartsX01 extends StatelessWidget {
  const HideShowThrownDartsX01({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameSettingsX01 = context.read<GameSettingsX01_P>();
    final double scaleFactorSwitch = Utils.getSwitchScaleFactor(context);
    final double paddingRight = Utils.getResponsiveValue(
      context: context,
      mobileValue: 0.h,
      tabletValue: ADVANCED_SETTINGS_SWITCH_PADDING_RIGHT_TABLET.w,
    );

    return Container(
      height: WIDGET_HEIGHT_GAMESETTINGS.h,
      padding: EdgeInsets.only(left: 2.5.w),
      child: Row(
        children: [
          Text(
            'Thrown darts per leg',
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
              color: Colors.white,
            ),
          ),
          Spacer(),
          Selector<GameSettingsX01_P, bool>(
            selector: (_, gameSettingsX01) =>
                gameSettingsX01.getShowThrownDartsPerLeg,
            builder: (_, showThrownDartsPerLeg, __) => Transform.scale(
              scale: scaleFactorSwitch,
              child: Container(
                padding: EdgeInsets.only(right: paddingRight),
                child: Switch(
                  value: showThrownDartsPerLeg,
                  onChanged: (value) {
                    Utils.handleVibrationFeedback(context);
                    gameSettingsX01.setShowThrownDartsPerLeg = value;
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
