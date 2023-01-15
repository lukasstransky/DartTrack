import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/three_darts/local_widgets/point_btn_three_darts.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SixteenToTwenty extends StatelessWidget {
  const SixteenToTwenty({
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
            child: gameX01.shouldPointBtnBeDisabled('16')
                ? PointBtnThreeDart(
                    point: '16',
                    activeBtn: false,
                  )
                : PointBtnThreeDart(
                    point: '16',
                    activeBtn: true,
                  ),
          ),
          Expanded(
            child: gameX01.shouldPointBtnBeDisabled('17')
                ? PointBtnThreeDart(
                    point: '17',
                    activeBtn: false,
                  )
                : PointBtnThreeDart(
                    point: '17',
                    activeBtn: true,
                  ),
          ),
          Expanded(
            child: gameX01.shouldPointBtnBeDisabled('18')
                ? PointBtnThreeDart(
                    point: '18',
                    activeBtn: false,
                  )
                : PointBtnThreeDart(
                    point: '18',
                    activeBtn: true,
                  ),
          ),
          Expanded(
            child: gameX01.shouldPointBtnBeDisabled('19')
                ? PointBtnThreeDart(
                    point: '19',
                    activeBtn: false,
                  )
                : PointBtnThreeDart(
                    point: '19',
                    activeBtn: true,
                  ),
          ),
          Expanded(
            child: gameX01.shouldPointBtnBeDisabled('20')
                ? PointBtnThreeDart(
                    point: '20',
                    activeBtn: false,
                  )
                : PointBtnThreeDart(
                    point: '20',
                    activeBtn: true,
                  ),
          ),
        ],
      ),
    );
  }
}
