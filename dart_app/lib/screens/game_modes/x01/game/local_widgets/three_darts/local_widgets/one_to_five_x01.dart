import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/three_darts/local_widgets/point_btn_three_darts_x01.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OneToFiveX01 extends StatelessWidget {
  const OneToFiveX01({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GameX01_P gameX01 = context.read<GameX01_P>();

    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: gameX01.shouldPointBtnBeDisabled('1')
                ? PointBtnThreeDartX01(
                    point: '1',
                    activeBtn: false,
                  )
                : PointBtnThreeDartX01(
                    point: '1',
                    activeBtn: true,
                  ),
          ),
          Expanded(
            child: gameX01.shouldPointBtnBeDisabled('2')
                ? PointBtnThreeDartX01(
                    point: '2',
                    activeBtn: false,
                  )
                : PointBtnThreeDartX01(
                    point: '2',
                    activeBtn: true,
                  ),
          ),
          Expanded(
            child: gameX01.shouldPointBtnBeDisabled('3')
                ? PointBtnThreeDartX01(
                    point: '3',
                    activeBtn: false,
                  )
                : PointBtnThreeDartX01(
                    point: '3',
                    activeBtn: true,
                  ),
          ),
          Expanded(
            child: gameX01.shouldPointBtnBeDisabled('4')
                ? PointBtnThreeDartX01(
                    point: '4',
                    activeBtn: false,
                  )
                : PointBtnThreeDartX01(
                    point: '4',
                    activeBtn: true,
                  ),
          ),
          Expanded(
            child: gameX01.shouldPointBtnBeDisabled('5')
                ? PointBtnThreeDartX01(
                    point: '5',
                    activeBtn: false,
                  )
                : PointBtnThreeDartX01(
                    point: '5',
                    activeBtn: true,
                  ),
          ),
        ],
      ),
    );
  }
}
