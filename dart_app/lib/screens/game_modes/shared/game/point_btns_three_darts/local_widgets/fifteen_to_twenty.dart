import 'package:dart_app/constants.dart';
import 'package:dart_app/screens/game_modes/shared/game/point_btns_three_darts/local_widgets/point_btn_three_darts.dart';
import 'package:flutter/material.dart';

class FifteenToTwentyBtnsThreeDarts extends StatelessWidget {
  const FifteenToTwentyBtnsThreeDarts({Key? key, required this.mode})
      : super(key: key);

  final GameMode mode;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (mode == GameMode.Cricket)
            Expanded(
              child: PointBtnThreeDarts(
                pointValue: '15',
                mode: mode,
              ),
            ),
          Expanded(
            child: PointBtnThreeDarts(
              pointValue: '16',
              mode: mode,
            ),
          ),
          Expanded(
            child: PointBtnThreeDarts(
              pointValue: '17',
              mode: mode,
            ),
          ),
          Expanded(
            child: PointBtnThreeDarts(
              pointValue: '18',
              mode: mode,
            ),
          ),
          Expanded(
            child: PointBtnThreeDarts(
              pointValue: '19',
              mode: mode,
            ),
          ),
          Expanded(
            child: PointBtnThreeDarts(
              pointValue: '20',
              mode: mode,
            ),
          ),
        ],
      ),
    );
  }
}
