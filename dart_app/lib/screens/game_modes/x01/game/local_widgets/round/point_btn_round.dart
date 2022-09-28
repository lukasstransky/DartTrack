import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class PointBtnRound extends StatelessWidget {
  const PointBtnRound({Key? key, this.point, this.activeBtn}) : super(key: key);

  final String? point;
  final bool? activeBtn;

  _updateCurrentPointsSelected(BuildContext context, String newPoints) {
    final GameX01 gameX01 = Provider.of<GameX01>(context, listen: false);

    if (gameX01.getCurrentPointsSelected == 'Points') {
      gameX01.setCurrentPointsSelected = newPoints;
    } else {
      final String result = gameX01.getCurrentPointsSelected + newPoints;
      gameX01.setCurrentPointsSelected = result;
    }

    gameX01.notify();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
        ),
        backgroundColor: activeBtn as bool
            ? MaterialStateProperty.all(Theme.of(context).colorScheme.primary)
            : MaterialStateProperty.all(
                Utils.darken(Theme.of(context).colorScheme.primary, 25)),
        overlayColor: activeBtn as bool
            ? Utils.getColorOrPressed(
                Theme.of(context).colorScheme.primary,
                Utils.darken(Theme.of(context).colorScheme.primary, 15),
              )
            : MaterialStateProperty.all(Colors.transparent),
      ),
      child: FittedBox(
        child: Text(
          point as String,
          style: TextStyle(
            fontSize: ROUND_BUTTON_TEXT_SIZE.sp,
            color: Colors.black,
          ),
        ),
      ),
      onPressed: () {
        activeBtn as bool
            ? _updateCurrentPointsSelected(context, point as String)
            : null;
      },
    );
  }
}
