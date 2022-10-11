import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class PointBtnRound extends StatelessWidget {
  const PointBtnRound({this.point, this.activeBtn, this.mostScoredPointBtn});

  final String? point;
  final bool? activeBtn;
  //todo eventually remove
  final bool? mostScoredPointBtn;

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

  _pointBtnRoundClicked(BuildContext context) {
    this.activeBtn as bool
        ? _updateCurrentPointsSelected(context, point as String)
        : null;
  }

  _getBackgroundColor(BuildContext context) {
    if (this.activeBtn as bool && this.mostScoredPointBtn as bool) {
      return MaterialStateProperty.all(Theme.of(context).colorScheme.primary);
    } else if (this.activeBtn as bool) {
      return MaterialStateProperty.all(Theme.of(context).colorScheme.primary);
    }

    return MaterialStateProperty.all(
        Utils.darken(Theme.of(context).colorScheme.primary, 25));
  }

  _getOverlayColor(BuildContext context) {
    if (this.activeBtn as bool) {
      return Utils.getColorOrPressed(
        Theme.of(context).colorScheme.primary,
        Utils.darken(Theme.of(context).colorScheme.primary, 15),
      );
    }

    return MaterialStateProperty.all(Colors.transparent);
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
        backgroundColor: _getBackgroundColor(context),
        overlayColor: _getOverlayColor(context),
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
      onPressed: () => _pointBtnRoundClicked(context),
    );
  }
}
