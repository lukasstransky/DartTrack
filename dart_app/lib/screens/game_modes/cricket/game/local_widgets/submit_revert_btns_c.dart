import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/game_cricket_p.dart';
import 'package:dart_app/screens/game_modes/shared/game/point_btns_three_darts/local_widgets/point_btn_three_darts.dart';
import 'package:dart_app/screens/game_modes/shared/game/revert_btn.dart';
import 'package:dart_app/screens/game_modes/shared/game/submit_bnt.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubmitRevertnBtnsCricket extends StatelessWidget {
  const SubmitRevertnBtnsCricket({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<GameCricket_P, List<String>>(
      selector: (_, gameCricket) => gameCricket.getCurrentThreeDarts,
      shouldRebuild: (previous, next) => true,
      builder: (_, currentThreeDarts, __) => Expanded(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Selector<GameCricket_P, bool>(
                selector: (_, gameCricket) => gameCricket.getRevertPossible,
                builder: (_, revertPossible, __) => RevertBtn(
                  game_p: context.read<GameCricket_P>(),
                ),
              ),
            ),
            Expanded(
              child: Selector<GameCricket_P, List<String>>(
                selector: (_, gameCricket) => gameCricket.getCurrentThreeDarts,
                builder: (_, currentThreeDarts, __) => PointBtnThreeDarts(
                  pointValue: 'Bust',
                  mode: GameMode.Cricket,
                ),
              ),
            ),
            Expanded(
              child: PointBtnThreeDarts(
                pointValue: '0',
                mode: GameMode.Cricket,
              ),
            ),
            Expanded(
              child: Selector<GameCricket_P, PointType>(
                selector: (_, gameCricket) => gameCricket.getCurrentPointType,
                builder: (_, currentPointType, __) => PointBtnThreeDarts(
                  pointValue: 'Bull',
                  mode: GameMode.Cricket,
                ),
              ),
            ),
            Expanded(
              child: SubmitBtn(
                mode: GameMode.Cricket,
                safeAreaPadding:
                    context.read<GameCricket_P>().getSafeAreaPadding,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
