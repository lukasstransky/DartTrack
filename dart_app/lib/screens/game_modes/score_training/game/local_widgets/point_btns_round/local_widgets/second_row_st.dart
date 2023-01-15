import 'package:dart_app/screens/game_modes/score_training/game/local_widgets/point_btns_round/local_widgets/point_btn_round_st.dart';
import 'package:flutter/material.dart';

class SecondRowBtnsRoundScoreTraining extends StatelessWidget {
  const SecondRowBtnsRoundScoreTraining({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: PointBtnRoundScoreTraining(
              point: '4',
            ),
          ),
          Expanded(
            child: PointBtnRoundScoreTraining(
              point: '5',
            ),
          ),
          Expanded(
            child: PointBtnRoundScoreTraining(
              point: '6',
            ),
          ),
        ],
      ),
    );
  }
}
