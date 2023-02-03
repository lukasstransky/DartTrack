import 'package:dart_app/screens/game_modes/single_double_training/game/local_widgets/game_btns/double/local_widgets/double_hit_btn.dart';
import 'package:dart_app/screens/game_modes/single_double_training/game/local_widgets/game_btns/double/local_widgets/double_missed_btn.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class GameBtnsDoubleTraining extends StatelessWidget {
  const GameBtnsDoubleTraining({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 10.h,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DoubleMissedBtnDoubleTraining(),
            DoubleHitBtnDoubleTraining(),
          ],
        ),
      ),
    );
  }
}
