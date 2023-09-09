import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/models/settings_p.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class PointBtnRoundX01 extends StatelessWidget {
  const PointBtnRoundX01({
    this.point,
    this.activeBtn,
    this.mostScoredPointBtn,
    required this.safeAreaPadding,
  });

  final String? point;
  final bool? activeBtn;
  final bool? mostScoredPointBtn;
  final EdgeInsets safeAreaPadding;

  @override
  Widget build(BuildContext context) {
    final double _fontSize = Utils.getResponsiveValue(
      context: context,
      mobileValue: 30,
      tabletValue: 20,
    );

    return Container(
      decoration: BoxDecoration(
        border: _getBorder(context, safeAreaPadding),
      ),
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
          ),
          backgroundColor: _getBackgroundColor(context),
          overlayColor: _getOverlayColor(context),
        ),
        child: FittedBox(
          child: Text(
            point as String,
            style: TextStyle(
              fontSize: _fontSize.sp,
              color: Utils.getTextColorDarken(context),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        onPressed: () {
          Utils.handleVibrationFeedback(context);
          _pointBtnRoundClicked(context);
        },
      ),
    );
  }

  _updateCurrentPointsSelected(BuildContext context, String newPoints) {
    final GameX01_P gameX01 = context.read<GameX01_P>();

    if (gameX01.getCurrentPointsSelected == 'Points') {
      gameX01.setCurrentPointsSelected = newPoints;
    } else {
      final String result = gameX01.getCurrentPointsSelected + newPoints;
      gameX01.setCurrentPointsSelected = result;
    }

    gameX01.notify();
  }

  _pointBtnRoundClicked(BuildContext context) async {
    if (context.read<Settings_P>().getVibrationFeedbackEnabled &&
        this.activeBtn as bool) {
      HapticFeedback.lightImpact();
    }

    this.activeBtn as bool
        ? _updateCurrentPointsSelected(context, point as String)
        : null;
  }

  _getBackgroundColor(BuildContext context) {
    if (this.activeBtn as bool && this.mostScoredPointBtn as bool) {
      return MaterialStateProperty.all(Theme.of(context).colorScheme.primary);
    } else if (this.activeBtn as bool) {
      return MaterialStateProperty.all(Theme.of(context).colorScheme.primary);
    }

    return MaterialStateProperty.all(
        Utils.darken(Theme.of(context).colorScheme.primary, 25));
  }

  _getOverlayColor(BuildContext context) {
    if (this.activeBtn as bool) {
      return Utils.getColorOrPressed(
        Theme.of(context).colorScheme.primary,
        Utils.darken(Theme.of(context).colorScheme.primary, 25),
      );
    }

    return MaterialStateProperty.all(Colors.transparent);
  }

  _getBorder(BuildContext context, EdgeInsets safeAreaPadding) {
    final GameSettingsX01_P gameSettingsX01_P =
        context.read<GameSettingsX01_P>();

    if (gameSettingsX01_P.getShowMostScoredPoints &&
        gameSettingsX01_P.getMostScoredPoints.isNotEmpty &&
        this.mostScoredPointBtn as bool) {
      return Border(
        left: [
          gameSettingsX01_P.getMostScoredPoints[1],
          gameSettingsX01_P.getMostScoredPoints[3],
          gameSettingsX01_P.getMostScoredPoints[5],
        ].contains(point)
            ? BorderSide(
                color: Utils.getPrimaryColorDarken(context),
                width: GENERAL_BORDER_WIDTH.w,
              )
            : BorderSide.none,
        right: [
          gameSettingsX01_P.getMostScoredPoints[0],
          gameSettingsX01_P.getMostScoredPoints[2],
          gameSettingsX01_P.getMostScoredPoints[4],
        ].contains(point)
            ? BorderSide(
                color: Utils.getPrimaryColorDarken(context),
                width: GENERAL_BORDER_WIDTH.w,
              )
            : BorderSide.none,
        bottom: [
          gameSettingsX01_P.getMostScoredPoints[0],
          gameSettingsX01_P.getMostScoredPoints[1],
          gameSettingsX01_P.getMostScoredPoints[2],
          gameSettingsX01_P.getMostScoredPoints[3],
          gameSettingsX01_P.getMostScoredPoints[4],
          gameSettingsX01_P.getMostScoredPoints[5],
        ].contains(point)
            ? BorderSide(
                color: Utils.getPrimaryColorDarken(context),
                width: GENERAL_BORDER_WIDTH.w,
              )
            : BorderSide.none,
        top: [
          gameSettingsX01_P.getMostScoredPoints[0],
          gameSettingsX01_P.getMostScoredPoints[1],
        ].contains(point)
            ? BorderSide(
                color: Utils.getPrimaryColorDarken(context),
                width: GENERAL_BORDER_WIDTH.w,
              )
            : BorderSide.none,
      );
    }

    return Border(
      left: ([
                '0',
                '2',
                '5',
                '8',
              ].contains(point)) ||
              (Utils.isLandscape(context) &&
                  [
                    '1',
                    '4',
                    '7',
                  ].contains(point))
          ? BorderSide(
              color: Utils.getPrimaryColorDarken(context),
              width: GENERAL_BORDER_WIDTH.w,
            )
          : BorderSide.none,
      right: ([
                '0',
                '2',
                '5',
                '8',
              ].contains(point)) ||
              (Utils.isLandscape(context) &&
                  safeAreaPadding.right > 0 &&
                  [
                    '3',
                    '6',
                    '9',
                  ].contains(point))
          ? BorderSide(
              color: Utils.getPrimaryColorDarken(context),
              width: GENERAL_BORDER_WIDTH.w,
            )
          : BorderSide.none,
      bottom: [
                '1',
                '2',
                '3',
                '4',
                '5',
                '6',
                '7',
                '8',
                '9',
              ].contains(point) ||
              (safeAreaPadding.bottom > 0 && point == '0')
          ? BorderSide(
              color: Utils.getPrimaryColorDarken(context),
              width: GENERAL_BORDER_WIDTH.w,
            )
          : BorderSide.none,
      top: [
        '1',
        '2',
        '3',
      ].contains(point)
          ? BorderSide(
              color: Utils.getPrimaryColorDarken(context),
              width: GENERAL_BORDER_WIDTH.w,
            )
          : BorderSide.none,
    );
  }
}
