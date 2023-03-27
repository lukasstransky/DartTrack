import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/game_score_training_p.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class CurrentPointsScoreTraining extends StatelessWidget {
  const CurrentPointsScoreTraining({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50.w,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              width: GENERAL_BORDER_WIDTH.w,
              color: Utils.getPrimaryColorDarken(context),
            ),
          ),
        ),
        child: Center(
          child: Selector<GameScoreTraining_P, String>(
            selector: (_, gameScoreTraining_P) =>
                gameScoreTraining_P.getCurrentPointsSelected,
            builder: (_, currentPointsSelected, __) => Text(
              currentPointsSelected,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Utils.getTextColorDarken(context),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
