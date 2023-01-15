import 'package:dart_app/models/games/score_training/game_score_training_p.dart';
import 'package:dart_app/screens/game_modes/score_training/game/local_widgets/point_btns_round/local_widgets/submit_revert_btn_and_current_score/local_widgets/current_points_st.dart';
import 'package:dart_app/screens/game_modes/score_training/game/local_widgets/point_btns_round/local_widgets/submit_revert_btn_and_current_score/local_widgets/submit_points_btn_st.dart';
import 'package:dart_app/screens/game_modes/shared/game/revert_btn.dart';
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
          SubmitPointsBtnScoreTraining(),
        ],
      ),
    );
  }
}
