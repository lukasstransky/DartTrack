import 'package:dart_app/constants.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SetsBtn extends StatelessWidget {
  const SetsBtn({
    Key? key,
    required this.gameSettings,
  }) : super(key: key);

  final dynamic gameSettings;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: WIDGET_HEIGHT_GAMESETTINGS.h,
        child: ElevatedButton(
          onPressed: () {
            Utils.handleVibrationFeedback(context);
            gameSettings.setsBtnClicked();
          },
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'Sets',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Utils.getTextColorForGameSettingsBtn(
                        gameSettings.getSetsEnabled, context),
                    fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                  ),
            ),
          ),
          style: ButtonStyle(
            splashFactory: NoSplash.splashFactory,
            shadowColor: MaterialStateProperty.all(Colors.transparent),
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                side: BorderSide(
                  color: Utils.getPrimaryColorDarken(context),
                  width: GAME_SETTINGS_BTN_BORDER_WITH.w,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(BUTTON_BORDER_RADIUS),
                ),
              ),
            ),
            backgroundColor: gameSettings.getSetsEnabled
                ? Utils.getPrimaryMaterialStateColorDarken(context)
                : Utils.getColor(Theme.of(context).colorScheme.primary),
          ),
        ),
      ),
    );
  }
}
