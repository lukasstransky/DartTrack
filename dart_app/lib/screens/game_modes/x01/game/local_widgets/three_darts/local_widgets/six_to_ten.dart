import 'package:dart_app/models/games/x01/game_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/three_darts/local_widgets/point_btn_three_darts.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SixToTen extends StatelessWidget {
  const SixToTen({
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
            child: gameX01.shouldPointBtnBeDisabled('6')
                ? PointBtnThreeDart(
                    point: '6',
                    activeBtn: false,
                  )
                : PointBtnThreeDart(
                    point: '6',
                    activeBtn: true,
                  ),
          ),
          Expanded(
            child: gameX01.shouldPointBtnBeDisabled('7')
                ? PointBtnThreeDart(
                    point: '7',
                    activeBtn: false,
                  )
                : PointBtnThreeDart(
                    point: '7',
                    activeBtn: true,
                  ),
          ),
          Expanded(
            child: gameX01.shouldPointBtnBeDisabled('8')
                ? PointBtnThreeDart(
                    point: '8',
                    activeBtn: false,
                  )
                : PointBtnThreeDart(
                    point: '8',
                    activeBtn: true,
                  ),
          ),
          Expanded(
            child: gameX01.shouldPointBtnBeDisabled('9')
                ? PointBtnThreeDart(
                    point: '9',
                    activeBtn: false,
                  )
                : PointBtnThreeDart(
                    point: '9',
                    activeBtn: true,
                  ),
          ),
          Expanded(
            child: gameX01.shouldPointBtnBeDisabled('10')
                ? PointBtnThreeDart(
                    point: '10',
                    activeBtn: false,
                  )
                : PointBtnThreeDart(
                    point: '10',
                    activeBtn: true,
                  ),
          ),
        ],
      ),
    );
  }
}
