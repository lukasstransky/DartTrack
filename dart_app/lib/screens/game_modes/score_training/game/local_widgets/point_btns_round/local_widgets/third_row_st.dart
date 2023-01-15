import 'package:dart_app/screens/game_modes/score_training/game/local_widgets/point_btns_round/local_widgets/point_btn_round_st.dart';
import 'package:flutter/material.dart';

class ThirdRowBtnsRoundScoreTraining extends StatelessWidget {
  const ThirdRowBtnsRoundScoreTraining({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: PointBtnRoundScoreTraining(
              point: '7',
            ),
          ),
          Expanded(
            child: PointBtnRoundScoreTraining(
              point: '8',
            ),
          ),
          Expanded(
            child: PointBtnRoundScoreTraining(
              point: '9',
            ),
          ),
        ],
      ),
    );
  }
}
