import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/game_score_training_p.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class PointBtnRoundScoreTraining extends StatelessWidget {
  const PointBtnRoundScoreTraining({Key? key, required this.point})
      : super(key: key);

  final String point;

  _getBorder(BuildContext context) {
    final EdgeInsets safeAreaPadding =
        context.read<GameScoreTraining_P>().getSafeAreaPadding;

    return Border(
      left: [
                '0',
                '2',
                '5',
                '8',
              ].contains(point) ||
              (Utils.isLandscape(context) && ['1', '4', '7'].contains(point))
          ? BorderSide(
              color: Utils.getPrimaryColorDarken(context),
              width: GENERAL_BORDER_WIDTH.w,
            )
          : BorderSide.none,
      right: [
                '0',
                '2',
                '5',
                '8',
              ].contains(point) ||
              (safeAreaPadding.right > 0 && ['3', '6', '9'].contains(point))
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
              ('0' == point && safeAreaPadding.bottom > 0)
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

  bool _invalidInput(BuildContext context) {
    final gameScoreTraining_P = context.read<GameScoreTraining_P>();
    if (gameScoreTraining_P.getCurrentPointsSelected == 'Points') {
      return false;
    }
    if (gameScoreTraining_P.getCurrentPointsSelected == '0') {
      return true;
    }
    final int result =
        int.parse(gameScoreTraining_P.getCurrentPointsSelected + point);

    if (result > 180 || BOGEY_NUMBERS.contains(result)) {
      return true;
    }
    return false;
  }

  _pointBtnPressed(BuildContext context) {
    if (_invalidInput(context)) {
      return;
    }

    final gameScoreTraining_P = context.read<GameScoreTraining_P>();

    if (gameScoreTraining_P.getCurrentPointsSelected == 'Points') {
      gameScoreTraining_P.setCurrentPointsSelected = point;
    } else {
      final String result =
          gameScoreTraining_P.getCurrentPointsSelected + point;
      gameScoreTraining_P.setCurrentPointsSelected = result;
    }

    gameScoreTraining_P.notify();
  }

  @override
  Widget build(BuildContext context) {
    final double _fontSize = Utils.getResponsiveValue(
      context: context,
      mobileValue: 30,
      tabletValue: 20,
    );

    return Container(
      decoration: BoxDecoration(
        border: _getBorder(context),
      ),
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
          ),
          backgroundColor: _invalidInput(context)
              ? MaterialStateProperty.all(
                  Utils.darken(Theme.of(context).colorScheme.primary, 25))
              : MaterialStateProperty.all(
                  Theme.of(context).colorScheme.primary),
          overlayColor: _invalidInput(context)
              ? MaterialStateProperty.all(Colors.transparent)
              : Utils.getColorOrPressed(
                  Theme.of(context).colorScheme.primary,
                  Utils.darken(Theme.of(context).colorScheme.primary, 10),
                ),
        ),
        child: FittedBox(
          child: Text(
            point,
            style: TextStyle(
              fontSize: _fontSize.sp,
              color: Utils.getTextColorDarken(context),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        onPressed: () {
          Utils.handleVibrationFeedback(context);
          _pointBtnPressed(context);
        },
      ),
    );
  }
}
