import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/three_darts/local_widgets/point_btn_three_darts_x01.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SixToTenX01 extends StatelessWidget {
  const SixToTenX01({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GameX01_P gameX01 = context.read<GameX01_P>();

    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: gameX01.shouldPointBtnBeDisabled('6')
                ? PointBtnThreeDartX01(
                    point: '6',
                    activeBtn: false,
                  )
                : PointBtnThreeDartX01(
                    point: '6',
                    activeBtn: true,
                  ),
          ),
          Expanded(
            child: gameX01.shouldPointBtnBeDisabled('7')
                ? PointBtnThreeDartX01(
                    point: '7',
                    activeBtn: false,
                  )
                : PointBtnThreeDartX01(
                    point: '7',
                    activeBtn: true,
                  ),
          ),
          Expanded(
            child: gameX01.shouldPointBtnBeDisabled('8')
                ? PointBtnThreeDartX01(
                    point: '8',
                    activeBtn: false,
                  )
                : PointBtnThreeDartX01(
                    point: '8',
                    activeBtn: true,
                  ),
          ),
          Expanded(
            child: gameX01.shouldPointBtnBeDisabled('9')
                ? PointBtnThreeDartX01(
                    point: '9',
                    activeBtn: false,
                  )
                : PointBtnThreeDartX01(
                    point: '9',
                    activeBtn: true,
                  ),
          ),
          Expanded(
            child: gameX01.shouldPointBtnBeDisabled('10')
                ? PointBtnThreeDartX01(
                    point: '10',
                    activeBtn: false,
                  )
                : PointBtnThreeDartX01(
                    point: '10',
                    activeBtn: true,
                  ),
          ),
        ],
      ),
    );
  }
}
