import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/game_score_training_p.dart';
import 'package:dart_app/screens/game_modes/shared/game/revert_btn.dart';
import 'package:dart_app/screens/game_modes/shared/game/submit_bnt.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class SubmitRevertBtnAndPointsScoreTraining extends StatelessWidget {
  const SubmitRevertBtnAndPointsScoreTraining({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 6.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Selector<GameScoreTraining_P, bool>(
            selector: (_, gameScoreTraining_P) =>
                gameScoreTraining_P.getRevertPossible,
            builder: (_, revertPossible, __) => RevertBtn(
              game_p: context.read<GameScoreTraining_P>(),
            ),
          ),
          CurrentPointsScoreTraining(),
          SubmitBtn(mode: GameMode.ScoreTraining),
        ],
      ),
    );
  }
}

class CurrentPointsScoreTraining extends StatelessWidget {
  const CurrentPointsScoreTraining({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double _fontSizeCurrentPoints = Utils.getResponsiveValue(
      context: context,
      mobileValue: 20,
      tabletValue: 18,
    );

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
                fontSize: _fontSizeCurrentPoints.sp,
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
