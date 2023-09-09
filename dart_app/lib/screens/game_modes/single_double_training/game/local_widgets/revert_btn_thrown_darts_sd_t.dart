import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/game_single_double_training_p.dart';
import 'package:dart_app/screens/game_modes/shared/game/point_btns_three_darts/local_widgets/thrown_darts.dart';
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
      child: ThrownDarts(mode: game.getMode),
    );
  }
}
