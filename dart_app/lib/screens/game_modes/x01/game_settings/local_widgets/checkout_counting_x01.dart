import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class CheckoutCountingX01 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GameSettingsX01_P gameSettingsX01 = context.read<GameSettingsX01_P>();
    final double scaleFactorSwitch = Utils.getSwitchScaleFactor(context);

    return Selector<GameSettingsX01_P, SelectorModel>(
      selector: (_, gameSettingsX01) => SelectorModel(
        enableCheckoutCounting: gameSettingsX01.getEnableCheckoutCounting,
        modeOut: gameSettingsX01.getModeOut,
      ),
      builder: (_, selectorModel, __) {
        final bool disableSwitch = selectorModel.modeOut != ModeOutIn.Double;
        final double textSwitchSpace = Utils.getResponsiveValue(
          context: context,
          mobileValue: 0,
          tabletValue: TEXT_SWITCH_SPACE_TABLET,
          otherValue: TEXT_SWITCH_SPACE_TABLET,
        );
        final double paddingTop = Utils.getResponsiveValue(
          context: context,
          mobileValue: 0,
          tabletValue: 1,
          otherValue: 1,
        );

        return Container(
          width: WIDTH_GAMESETTINGS.w,
          padding: EdgeInsets.only(top: paddingTop.h),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Counting of checkout %',
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
                      value: selectorModel.enableCheckoutCounting,
                      onChanged: (value) {
                        if (disableSwitch) {
                          Fluttertoast.showToast(
                            msg: 'Double out mode is required!',
                            toastLength: Toast.LENGTH_LONG,
                            fontSize: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .fontSize!,
                          );
                          return;
                        }

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
      },
    );
  }
}

class SelectorModel {
  final ModeOutIn modeOut;
  final bool enableCheckoutCounting;

  SelectorModel({
    required this.modeOut,
    required this.enableCheckoutCounting,
  });
}
