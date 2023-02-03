import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/game_single_double_training_p.dart';
import 'package:dart_app/screens/game_modes/shared/game/point_btns_three_darts/local_widgets/thrown_darts.dart';
import 'package:dart_app/screens/game_modes/shared/game/revert_btn.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class RevertBtnAndThrownDarts extends StatelessWidget {
  const RevertBtnAndThrownDarts({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final game = context.read<GameSingleDoubleTraining_P>();

    return Container(
      height: THROWN_DARTS_WIDGET_HEIGHT.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Selector<GameSingleDoubleTraining_P, bool>(
            selector: (_, game) => game.getRevertPossible,
            builder: (_, revertPossible, __) => RevertBtn(game_p: game),
          ),
          Container(
            width: 75.w,
            child: ThrownDarts(mode: game.getMode),
          ),
        ],
      ),
    );
  }
}
