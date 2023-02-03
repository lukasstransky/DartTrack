import 'package:dart_app/constants.dart';
import 'package:dart_app/screens/game_modes/shared/game/point_btns_three_darts/local_widgets/point_btn_three_darts.dart';
import 'package:flutter/material.dart';

class OneToFiveBtnsThreeDarts extends StatelessWidget {
  const OneToFiveBtnsThreeDarts({Key? key, required this.mode})
      : super(key: key);

  final GameMode mode;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: PointBtnThreeDarts(
              pointValue: '1',
              mode: mode,
            ),
          ),
          Expanded(
            child: PointBtnThreeDarts(
              pointValue: '2',
              mode: mode,
            ),
          ),
          Expanded(
            child: PointBtnThreeDarts(
              pointValue: '3',
              mode: mode,
            ),
          ),
          Expanded(
            child: PointBtnThreeDarts(
              pointValue: '4',
              mode: mode,
            ),
          ),
          Expanded(
            child: PointBtnThreeDarts(
              pointValue: '5',
              mode: mode,
            ),
          ),
        ],
      ),
    );
  }
}
