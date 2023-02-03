import 'package:dart_app/models/games/game_score_training_p.dart';
import 'package:dart_app/screens/game_modes/score_training/game/local_widgets/point_btns_round/local_widgets/first_row_sc_t.dart';
import 'package:dart_app/screens/game_modes/score_training/game/local_widgets/point_btns_round/local_widgets/fourht_row_sc_t.dart';
import 'package:dart_app/screens/game_modes/score_training/game/local_widgets/point_btns_round/local_widgets/second_row_sc_t.dart';
import 'package:dart_app/screens/game_modes/score_training/game/local_widgets/point_btns_round/local_widgets/submit_revert_btn_and_current_score/submit_revert_btn_and_points_sc_t.dart';
import 'package:dart_app/screens/game_modes/score_training/game/local_widgets/point_btns_round/local_widgets/third_row_sc_t.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PointBtnsRoundScoreTraining extends StatelessWidget {
  const PointBtnsRoundScoreTraining({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Selector<GameScoreTraining_P, String>(
        selector: (_, gameScoreTraining_P) =>
            gameScoreTraining_P.getCurrentPointsSelected,
        builder: (_, currentPointsSelected, __) => Column(
          children: [
            SubmitRevertBtnAndPointsScoreTraining(),
            FirstRowBtnsRoundScoreTraining(),
            SecondRowBtnsRoundScoreTraining(),
            ThirdRowBtnsRoundScoreTraining(),
            FourthRowBtnsRoundScoreTraining(),
          ],
        ),
      ),
    );
  }
}
