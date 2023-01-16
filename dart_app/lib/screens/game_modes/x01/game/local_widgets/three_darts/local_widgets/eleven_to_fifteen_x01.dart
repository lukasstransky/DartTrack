import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/three_darts/local_widgets/point_btn_three_darts_x01.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ElevenToFifteenX01 extends StatelessWidget {
  const ElevenToFifteenX01({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GameX01_P gameX01 = context.read<GameX01_P>();

    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: gameX01.shouldPointBtnBeDisabled('11')
                ? PointBtnThreeDartX01(
                    point: '11',
                    activeBtn: false,
                  )
                : PointBtnThreeDartX01(
                    point: '11',
                    activeBtn: true,
                  ),
          ),
          Expanded(
            child: gameX01.shouldPointBtnBeDisabled('12')
                ? PointBtnThreeDartX01(
                    point: '12',
                    activeBtn: false,
                  )
                : PointBtnThreeDartX01(
                    point: '12',
                    activeBtn: true,
                  ),
          ),
          Expanded(
            child: gameX01.shouldPointBtnBeDisabled('13')
                ? PointBtnThreeDartX01(
                    point: '13',
                    activeBtn: false,
                  )
                : PointBtnThreeDartX01(
                    point: '13',
                    activeBtn: true,
                  ),
          ),
          Expanded(
            child: gameX01.shouldPointBtnBeDisabled('14')
                ? PointBtnThreeDartX01(
                    point: '14',
                    activeBtn: false,
                  )
                : PointBtnThreeDartX01(
                    point: '14',
                    activeBtn: true,
                  ),
          ),
          Expanded(
            child: gameX01.shouldPointBtnBeDisabled('15')
                ? PointBtnThreeDartX01(
                    point: '15',
                    activeBtn: false,
                  )
                : PointBtnThreeDartX01(
                    point: '15',
                    activeBtn: true,
                  ),
          ),
        ],
      ),
    );
  }
}
