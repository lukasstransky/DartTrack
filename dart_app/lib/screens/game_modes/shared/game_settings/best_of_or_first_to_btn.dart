import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class BestOfOrFirstToBtn extends StatelessWidget {
  const BestOfOrFirstToBtn({
    Key? key,
    required this.gameSettings,
  }) : super(key: key);

  final dynamic gameSettings;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: WIDTH_GAMESETTINGS.w,
      height: gameSettings is GameSettingsX01_P &&
              Utils.shouldShrinkWidget(gameSettings)
          ? WIDGET_HEIGHT_GAMESETTINGS_TEAMS.h
          : WIDGET_HEIGHT_GAMESETTINGS.h,
      margin: EdgeInsets.only(top: MARGIN_GAMESETTINGS.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BestOfBtn(gameSettingsProvider: gameSettings),
          FirstToBtn(gameSettingsProvider: gameSettings),
        ],
      ),
    );
  }
}

class BestOfBtn extends StatelessWidget {
  const BestOfBtn({
    Key? key,
    required this.gameSettingsProvider,
  }) : super(key: key);

  final dynamic gameSettingsProvider;

  @override
  Widget build(BuildContext context) {
    final bool isBestOf =
        gameSettingsProvider.getBestOfOrFirstTo == BestOfOrFirstToEnum.BestOf;

    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          Utils.handleVibrationFeedback(context);
          if (!isBestOf) {
            gameSettingsProvider.switchBestOfOrFirstTo();
          }
        },
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'Best of',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color:
                      Utils.getTextColorForGameSettingsBtn(isBestOf, context),
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
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(BUTTON_BORDER_RADIUS),
                bottomLeft: Radius.circular(BUTTON_BORDER_RADIUS),
              ),
            ),
          ),
          backgroundColor: isBestOf
              ? Utils.getPrimaryMaterialStateColorDarken(context)
              : Utils.getColor(Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }
}

class FirstToBtn extends StatelessWidget {
  const FirstToBtn({
    Key? key,
    required this.gameSettingsProvider,
  }) : super(key: key);

  final dynamic gameSettingsProvider;

  @override
  Widget build(BuildContext context) {
    final bool isFirstTo =
        gameSettingsProvider.getBestOfOrFirstTo == BestOfOrFirstToEnum.FirstTo;

    return Expanded(
      child: SizedBox(
        child: ElevatedButton(
          onPressed: () {
            Utils.handleVibrationFeedback(context);
            if (!isFirstTo) {
              gameSettingsProvider.switchBestOfOrFirstTo();
            }
          },
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'First to',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Utils.getTextColorForGameSettingsBtn(
                        isFirstTo, context),
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
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(BUTTON_BORDER_RADIUS),
                  bottomRight: Radius.circular(BUTTON_BORDER_RADIUS),
                ),
              ),
            ),
            backgroundColor: isFirstTo
                ? Utils.getPrimaryMaterialStateColorDarken(context)
                : Utils.getColor(Theme.of(context).colorScheme.primary),
          ),
        ),
      ),
    );
  }
}
