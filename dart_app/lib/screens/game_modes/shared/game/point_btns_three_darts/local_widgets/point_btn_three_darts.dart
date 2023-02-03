import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/game_score_training_p.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class PointBtnThreeDarts extends StatelessWidget {
  const PointBtnThreeDarts({
    Key? key,
    required this.pointValue,
    required this.mode,
  }) : super(key: key);

  final String pointValue;
  final GameMode mode;

  _pointBtnClicked(
      String pointValueWithDoubleOrTripplePrefix, BuildContext context) {
    if (_getAmountOfDartsThrown(context) == 3) {
      return;
    }

    if (mode == GameMode.ScoreTraining) {
      final gameScoreTraining_P = context.read<GameScoreTraining_P>();

      gameScoreTraining_P.submitPointsThreeDartsMode(pointValue,
          pointValueWithDoubleOrTripplePrefix, gameScoreTraining_P, context);
    }
  }

  int _getAmountOfDartsThrown(BuildContext context) {
    if (mode == GameMode.ScoreTraining) {
      return context.read<GameScoreTraining_P>().getAmountOfDartsThrown();
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    String pointValueWithDoubleOrTripplePrefix = '';
    if (mode == GameMode.ScoreTraining) {
      if (pointValue == 'Bust') {
        pointValueWithDoubleOrTripplePrefix = 'Bust';
      } else {
        pointValueWithDoubleOrTripplePrefix = Utils.appendTrippleOrDouble(
            context.read<GameScoreTraining_P>().getCurrentPointType,
            pointValue);
      }
    }

    return Container(
      decoration: BoxDecoration(
        border: Utils.getBorder(context, pointValue),
      ),
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
          ),
          backgroundColor: _getAmountOfDartsThrown(context) != 3
              ? MaterialStateProperty.all(Theme.of(context).colorScheme.primary)
              : MaterialStateProperty.all(
                  Utils.darken(Theme.of(context).colorScheme.primary, 25),
                ),
          overlayColor: _getAmountOfDartsThrown(context) != 3
              ? Utils.getColorOrPressed(
                  Theme.of(context).colorScheme.primary,
                  Utils.darken(Theme.of(context).colorScheme.primary, 25),
                )
              : MaterialStateProperty.all(Colors.transparent),
        ),
        child: FittedBox(
          child: Text(
            pointValueWithDoubleOrTripplePrefix,
            style: TextStyle(
              fontSize: 16.sp,
              color: Utils.getTextColorDarken(context),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        onPressed: () =>
            _pointBtnClicked(pointValueWithDoubleOrTripplePrefix, context),
      ),
    );
  }
}
