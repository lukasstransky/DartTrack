import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:sizer/sizer.dart';

class CheckoutCountingX01 extends StatelessWidget {
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

    return Selector<GameSettingsX01_P, SelectorModel>(
      selector: (_, gameSettingsX01) => SelectorModel(
        drawMode: gameSettingsX01.getDrawMode,
        enableCheckoutCounting: gameSettingsX01.getEnableCheckoutCounting,
        legs: gameSettingsX01.getLegs,
        modeOut: gameSettingsX01.getModeOut,
        setsEnabled: gameSettingsX01.getSetsEnabled,
      ),
      builder: (_, selectorModel, __) {
        if (selectorModel.modeOut == ModeOutIn.Double) {
          return Container(
            width: WIDTH_GAMESETTINGS.w,
            transform: Matrix4.translationValues(0.0,
                _winByDiffWidgetIsPresent(selectorModel) ? -1.5.h : 0.0, 0.0),
            margin: EdgeInsets.only(
                top: _noWinByDiffWidgetIsPresent(selectorModel)
                    ? MARGIN_GAMESETTINGS.h
                    : 0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Counting of checkout %',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                      ),
                    ),
                    Transform.scale(
                      scale: scaleFactorSwitch,
                      child: Switch(
                        thumbColor: MaterialStateProperty.all(
                            Theme.of(context).colorScheme.secondary),
                        activeColor: Theme.of(context).colorScheme.secondary,
                        inactiveThumbColor:
                            Theme.of(context).colorScheme.secondary,
                        value: selectorModel.enableCheckoutCounting,
                        onChanged: (value) {
                          Utils.handleVibrationFeedback(context);
                          gameSettingsX01.setEnableCheckoutCounting = value;
                          gameSettingsX01.notify();
                        },
                      ),
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

  bool _winByDiffWidgetIsPresent(SelectorModel selectorModel) {
    return selectorModel.legs > 1 && !selectorModel.drawMode;
  }

  bool _noWinByDiffWidgetIsPresent(SelectorModel selectorModel) {
    if (selectorModel.legs == 1 || selectorModel.drawMode) {
      return true;
    }
    return false;
  }
}

class SelectorModel {
  final ModeOutIn modeOut;
  final bool enableCheckoutCounting;
  final int legs;
  final bool setsEnabled;
  final bool drawMode;

  SelectorModel({
    required this.modeOut,
    required this.enableCheckoutCounting,
    required this.legs,
    required this.setsEnabled,
    required this.drawMode,
  });
}
