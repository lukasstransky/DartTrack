import 'package:dart_app/screens/game_modes/score_training/game/local_widgets/point_btns_round/local_widgets/point_btn_round_sc_t.dart';
import 'package:flutter/material.dart';

class FirstRowBtnsRoundScoreTraining extends StatelessWidget {
  const FirstRowBtnsRoundScoreTraining({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: PointBtnRoundScoreTraining(
              point: '1',
            ),
          ),
          Expanded(
            child: PointBtnRoundScoreTraining(
              point: '2',
            ),
          ),
          Expanded(
            child: PointBtnRoundScoreTraining(
              point: '3',
            ),
          ),
        ],
      ),
    );
  }
}
