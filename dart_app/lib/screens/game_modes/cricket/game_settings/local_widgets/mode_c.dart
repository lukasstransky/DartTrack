import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_cricket_p.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class ModeCricket extends StatelessWidget {
  const ModeCricket({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BorderRadius borderRadiusStandard = BorderRadius.only(
      topLeft: Radius.circular(BUTTON_BORDER_RADIUS),
      bottomLeft: Radius.circular(BUTTON_BORDER_RADIUS),
    );
    final BorderRadius borderRadiusNoScore = BorderRadius.only(
      topRight: Radius.circular(BUTTON_BORDER_RADIUS),
      bottomRight: Radius.circular(BUTTON_BORDER_RADIUS),
    );

    return Container(
      width: WIDTH_GAMESETTINGS.w,
      height: WIDGET_HEIGHT_GAMESETTINGS.h,
      margin: EdgeInsets.only(
        top: MARGIN_GAMESETTINGS.h,
        bottom: MARGIN_GAMESETTINGS.h,
      ),
      child: Selector<GameSettingsCricket_P, CricketMode>(
        selector: (_, gameSettingsCricket) => gameSettingsCricket.getMode,
        builder: (_, mode, __) => Row(
          children: [
            ModeCricketBtn(
              value: 'Standard',
              expression: mode == CricketMode.Standard,
              borderRadius: borderRadiusStandard,
            ),
            ModeCricketBtn(
              value: 'Cut throat',
              expression: mode == CricketMode.CutThroat,
              borderRadius: BorderRadius.zero,
            ),
            ModeCricketBtn(
              value: 'No score',
              expression: mode == CricketMode.NoScore,
              borderRadius: borderRadiusNoScore,
            ),
          ],
        ),
      ),
    );
  }
}

class ModeCricketBtn extends StatelessWidget {
  const ModeCricketBtn({
    Key? key,
    required this.value,
    required this.expression,
    required this.borderRadius,
  }) : super(key: key);

  final String value;
  final bool expression;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final GameSettingsCricket_P gameSettingsCricket =
        context.read<GameSettingsCricket_P>();

    return Expanded(
      child: Container(
        decoration: value == 'Cut throat'
            ? BoxDecoration(
                border: Border(
                  top: BorderSide(
                      color: Utils.getPrimaryColorDarken(context),
                      width: GAME_SETTINGS_BTN_BORDER_WITH.w),
                  bottom: BorderSide(
                      color: Utils.getPrimaryColorDarken(context),
                      width: GAME_SETTINGS_BTN_BORDER_WITH.w),
                ),
              )
            : null,
        child: ElevatedButton(
          onPressed: () {
            Utils.handleVibrationFeedback(context);
            if (value == 'Standard') {
              gameSettingsCricket.setMode = CricketMode.Standard;
            } else if (value == 'Cut throat') {
              gameSettingsCricket.setMode = CricketMode.CutThroat;
            } else if (value == 'No score') {
              gameSettingsCricket.setMode = CricketMode.NoScore;
            }
            gameSettingsCricket.notify();
          },
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: TextStyle(
                color:
                    Utils.getTextColorForGameSettingsBtn(expression, context),
              ),
            ),
          ),
          style: ButtonStyle(
            splashFactory: NoSplash.splashFactory,
            shadowColor: MaterialStateProperty.all(Colors.transparent),
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            shape: value != 'Cut throat'
                ? MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      side: BorderSide(
                        color: Utils.getPrimaryColorDarken(context),
                        width: GAME_SETTINGS_BTN_BORDER_WITH.w,
                      ),
                      borderRadius: borderRadius,
                    ),
                  )
                : MaterialStateProperty.all(
                    RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  ),
            backgroundColor: expression
                ? Utils.getPrimaryMaterialStateColorDarken(context)
                : Utils.getColor(Theme.of(context).colorScheme.primary),
          ),
        ),
      ),
    );
  }
}
