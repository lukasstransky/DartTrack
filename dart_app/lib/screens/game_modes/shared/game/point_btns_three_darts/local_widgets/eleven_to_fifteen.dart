import 'package:dart_app/screens/game_modes/shared/game/point_btns_three_darts/local_widgets/point_btn_three_darts.dart';
import 'package:flutter/material.dart';

class ElevenToFifteenBtnsThreeDarts extends StatelessWidget {
  const ElevenToFifteenBtnsThreeDarts({Key? key, required this.mode})
      : super(key: key);

  final String mode;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: PointBtnThreeDarts(
              pointValue: '11',
              mode: mode,
            ),
          ),
          Expanded(
            child: PointBtnThreeDarts(
              pointValue: '12',
              mode: mode,
            ),
          ),
          Expanded(
            child: PointBtnThreeDarts(
              pointValue: '13',
              mode: mode,
            ),
          ),
          Expanded(
            child: PointBtnThreeDarts(
              pointValue: '14',
              mode: mode,
            ),
          ),
          Expanded(
            child: PointBtnThreeDarts(
              pointValue: '15',
              mode: mode,
            ),
          ),
        ],
      ),
    );
  }
}
