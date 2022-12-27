import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/three_darts/local_widgets/point_btn_three_darts.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OneToFive extends StatelessWidget {
  const OneToFive({
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
            child: gameX01.shouldPointBtnBeDisabled('1')
                ? PointBtnThreeDart(
                    point: '1',
                    activeBtn: false,
                  )
                : PointBtnThreeDart(
                    point: '1',
                    activeBtn: true,
                  ),
          ),
          Expanded(
            child: gameX01.shouldPointBtnBeDisabled('2')
                ? PointBtnThreeDart(
                    point: '2',
                    activeBtn: false,
                  )
                : PointBtnThreeDart(
                    point: '2',
                    activeBtn: true,
                  ),
          ),
          Expanded(
            child: gameX01.shouldPointBtnBeDisabled('3')
                ? PointBtnThreeDart(
                    point: '3',
                    activeBtn: false,
                  )
                : PointBtnThreeDart(
                    point: '3',
                    activeBtn: true,
                  ),
          ),
          Expanded(
            child: gameX01.shouldPointBtnBeDisabled('4')
                ? PointBtnThreeDart(
                    point: '4',
                    activeBtn: false,
                  )
                : PointBtnThreeDart(
                    point: '4',
                    activeBtn: true,
                  ),
          ),
          Expanded(
            child: gameX01.shouldPointBtnBeDisabled('5')
                ? PointBtnThreeDart(
                    point: '5',
                    activeBtn: false,
                  )
                : PointBtnThreeDart(
                    point: '5',
                    activeBtn: true,
                  ),
          ),
        ],
      ),
    );
  }
}
