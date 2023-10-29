import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/utils/button_styles.dart';
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
      child: Selector<GameSettingsX01_P, SelectorModel>(
        selector: (_, gameSettingsX01) => SelectorModel(
          points: gameSettingsX01.getPoints,
          customPoints: gameSettingsX01.getCustomPoints,
          singleOrTeam: gameSettingsX01.getSingleOrTeam,
        ),
        builder: (_, selectorModel, __) => Container(
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
          child: ElevatedButton(
            onPressed: () {
              Utils.handleVibrationFeedback(context);
              gameSettingsX01.setPoints = points;
              gameSettingsX01.notify();
            },
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                points.toString(),
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Utils.getTextColorForGameSettingsBtn(
                          selectorModel.points == points &&
                              selectorModel.customPoints == -1,
                          context),
                      fontSize:
                          Theme.of(context).textTheme.bodyMedium!.fontSize,
                    ),
              ),
            ),
            style: ButtonStyles.primaryColorBtnStyle(
                    context,
                    selectorModel.points == points &&
                        selectorModel.customPoints == -1)
                .copyWith(
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
  final SingleOrTeamEnum singleOrTeam;

  SelectorModel({
    required this.points,
    required this.customPoints,
    required this.singleOrTeam,
  });
}
