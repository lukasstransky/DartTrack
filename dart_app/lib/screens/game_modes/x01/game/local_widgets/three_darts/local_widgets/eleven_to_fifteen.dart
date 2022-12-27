import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/three_darts/local_widgets/point_btn_three_darts.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ElevenToFifteen extends StatelessWidget {
  const ElevenToFifteen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GameX01 gameX01 = context.read<GameX01>();

    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: gameX01.shouldPointBtnBeDisabled('11')
                ? PointBtnThreeDart(
                    point: '11',
                    activeBtn: false,
                  )
                : PointBtnThreeDart(
                    point: '11',
                    activeBtn: true,
                  ),
          ),
          Expanded(
            child: gameX01.shouldPointBtnBeDisabled('12')
                ? PointBtnThreeDart(
                    point: '12',
                    activeBtn: false,
                  )
                : PointBtnThreeDart(
                    point: '12',
                    activeBtn: true,
                  ),
          ),
          Expanded(
            child: gameX01.shouldPointBtnBeDisabled('13')
                ? PointBtnThreeDart(
                    point: '13',
                    activeBtn: false,
                  )
                : PointBtnThreeDart(
                    point: '13',
                    activeBtn: true,
                  ),
          ),
          Expanded(
            child: gameX01.shouldPointBtnBeDisabled('14')
                ? PointBtnThreeDart(
                    point: '14',
                    activeBtn: false,
                  )
                : PointBtnThreeDart(
                    point: '14',
                    activeBtn: true,
                  ),
          ),
          Expanded(
            child: gameX01.shouldPointBtnBeDisabled('15')
                ? PointBtnThreeDart(
                    point: '15',
                    activeBtn: false,
                  )
                : PointBtnThreeDart(
                    point: '15',
                    activeBtn: true,
                  ),
          ),
        ],
      ),
    );
  }
}
