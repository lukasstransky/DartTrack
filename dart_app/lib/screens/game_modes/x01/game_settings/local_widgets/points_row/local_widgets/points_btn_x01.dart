import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class PointsBtnX01 extends StatelessWidget {
  const PointsBtnX01({
    Key? key,
    required this.points,
  }) : super(key: key);

  final int points;

  @override
  Widget build(BuildContext context) {
    final GameSettingsX01_P gameSettingsX01 = context.read<GameSettingsX01_P>();

    return Expanded(
      child: Container(
        height: WIDGET_HEIGHT_GAMESETTINGS.h,
        decoration: points != 301
            ? BoxDecoration(
                border: Border(
                  left: points == 701
                      ? BorderSide(
                          color: Utils.getPrimaryColorDarken(context),
                          width: GAME_SETTINGS_BTN_BORDER_WITH.w)
                      : BorderSide.none,
                  top: BorderSide(
                      color: Utils.getPrimaryColorDarken(context),
                      width: GAME_SETTINGS_BTN_BORDER_WITH.w),
                  bottom: BorderSide(
                      color: Utils.getPrimaryColorDarken(context),
                      width: GAME_SETTINGS_BTN_BORDER_WITH.w),
                ),
              )
            : null,
        child: Selector<GameSettingsX01_P, SelectorModel>(
          selector: (_, gameSettingsX01) => SelectorModel(
            points: gameSettingsX01.getPoints,
            customPoints: gameSettingsX01.getCustomPoints,
          ),
          builder: (_, selectorModel, __) => ElevatedButton(
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
                      selectorModel.points == points &&
                          selectorModel.customPoints == -1,
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
                          width: GAME_SETTINGS_BTN_BORDER_WITH.w,
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
              backgroundColor: selectorModel.points == points &&
                      selectorModel.customPoints == -1
                  ? Utils.getPrimaryMaterialStateColorDarken(context)
                  : Utils.getColor(Theme.of(context).colorScheme.primary),
            ),
          ),
        ),
      ),
    );
  }
}

class SelectorModel {
  final int points;
  final int customPoints;

  SelectorModel({
    required this.points,
    required this.customPoints,
  });
}
