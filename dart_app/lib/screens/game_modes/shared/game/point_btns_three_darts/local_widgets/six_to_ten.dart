import 'package:dart_app/constants.dart';
import 'package:dart_app/screens/game_modes/shared/game/point_btns_three_darts/local_widgets/point_btn_three_darts.dart';
import 'package:flutter/material.dart';

class SixToTenBtnsThreeDarts extends StatelessWidget {
  const SixToTenBtnsThreeDarts({Key? key, required this.mode})
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
              pointValue: '6',
              mode: mode,
            ),
          ),
          Expanded(
            child: PointBtnThreeDarts(
              pointValue: '7',
              mode: mode,
            ),
          ),
          Expanded(
            child: PointBtnThreeDarts(
              pointValue: '8',
              mode: mode,
            ),
          ),
          Expanded(
            child: PointBtnThreeDarts(
              pointValue: '9',
              mode: mode,
            ),
          ),
          Expanded(
            child: PointBtnThreeDarts(
              pointValue: '10',
              mode: mode,
            ),
          ),
        ],
      ),
    );
  }
}
