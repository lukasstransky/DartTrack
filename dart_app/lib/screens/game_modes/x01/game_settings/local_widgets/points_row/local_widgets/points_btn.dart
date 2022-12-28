import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class PointsBtn extends StatelessWidget {
  const PointsBtn({
    Key? key,
    required this.points,
  }) : super(key: key);

  final int points;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Consumer<GameSettingsX01_P>(
        builder: (_, gameSettingsX01, __) => Container(
          height: Utils.getHeightForWidget(gameSettingsX01).h,
          decoration: points != 301
              ? BoxDecoration(
                  border: Border(
                    left: points == 701
                        ? BorderSide(
                            color: Utils.getPrimaryColorDarken(context),
                            width: GAME_SETTINGS_BTN_BORDER_WITH)
                        : BorderSide.none,
                    top: BorderSide(
                        color: Utils.getPrimaryColorDarken(context),
                        width: GAME_SETTINGS_BTN_BORDER_WITH),
                    bottom: BorderSide(
                        color: Utils.getPrimaryColorDarken(context),
                        width: GAME_SETTINGS_BTN_BORDER_WITH),
                  ),
                )
              : null,
          child: ElevatedButton(
            onPressed: () => {
              gameSettingsX01.setPoints = points,
              gameSettingsX01.notify(),
            },
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                points.toString(),
                style: TextStyle(
                  color: Utils.getTextColorForGameSettingsBtn(
                      gameSettingsX01.getPoints == points &&
                          gameSettingsX01.getCustomPoints == -1,
                      context),
                ),
              ),
            ),
            style: ButtonStyle(
              splashFactory: NoSplash.splashFactory,
              shadowColor: MaterialStateProperty.all(Colors.transparent),
              overlayColor: MaterialStateProperty.all(Colors.transparent),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  side: points == 301
                      ? BorderSide(
                          color: Utils.getPrimaryColorDarken(context),
                          width: GAME_SETTINGS_BTN_BORDER_WITH,
                        )
                      : BorderSide.none,
                  borderRadius: points == 301
                      ? BorderRadius.only(
                          topLeft: Radius.circular(BUTTON_BORDER_RADIUS),
                          bottomLeft: Radius.circular(BUTTON_BORDER_RADIUS),
                        )
                      : BorderRadius.zero,
                ),
              ),
              backgroundColor: gameSettingsX01.getPoints == points &&
                      gameSettingsX01.getCustomPoints == -1
                  ? Utils.getPrimaryMaterialStateColorDarken(context)
                  : Utils.getColor(Theme.of(context).colorScheme.primary),
            ),
          ),
        ),
      ),
    );
  }
}
