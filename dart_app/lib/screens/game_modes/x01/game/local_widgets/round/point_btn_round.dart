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
    final GameX01 gameX01 = context.read<GameX01>();

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
        Utils.darken(Theme.of(context).colorScheme.primary, 25),
      );
    }

    return MaterialStateProperty.all(Colors.transparent);
  }

  _getBorder(BuildContext context) {
    final GameX01 gameX01 = context.read<GameX01>();
    const double borderWidth = 3;

    return Border(
      left: [
        '0',
        '2',
        '5',
        '8',
        gameX01.getGameSettings.getMostScoredPoints[1],
        gameX01.getGameSettings.getMostScoredPoints[3],
        gameX01.getGameSettings.getMostScoredPoints[5],
      ].contains(point)
          ? BorderSide(
              color: Utils.getPrimaryColorDarken(context),
              width: borderWidth,
            )
          : BorderSide.none,
      right: [
        '0',
        '2',
        '5',
        '8',
        gameX01.getGameSettings.getMostScoredPoints[0],
        gameX01.getGameSettings.getMostScoredPoints[2],
        gameX01.getGameSettings.getMostScoredPoints[4],
      ].contains(point)
          ? BorderSide(
              color: Utils.getPrimaryColorDarken(context),
              width: borderWidth,
            )
          : BorderSide.none,
      bottom: [
        '1',
        '2',
        '3',
        '4',
        '5',
        '6',
        '7',
        '8',
        '9',
        gameX01.getGameSettings.getMostScoredPoints[0],
        gameX01.getGameSettings.getMostScoredPoints[1],
        gameX01.getGameSettings.getMostScoredPoints[2],
        gameX01.getGameSettings.getMostScoredPoints[3],
        gameX01.getGameSettings.getMostScoredPoints[4],
        gameX01.getGameSettings.getMostScoredPoints[5],
      ].contains(point)
          ? BorderSide(
              color: Utils.getPrimaryColorDarken(context),
              width: borderWidth,
            )
          : BorderSide.none,
      top: [
        '1',
        '2',
        '3',
        gameX01.getGameSettings.getMostScoredPoints[0],
        gameX01.getGameSettings.getMostScoredPoints[1],
      ].contains(point)
          ? BorderSide(
              color: Utils.getPrimaryColorDarken(context),
              width: borderWidth,
            )
          : BorderSide.none,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: _getBorder(context),
      ),
      child: ElevatedButton(
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
              color: Utils.getTextColorDarken(context),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        onPressed: () => _pointBtnRoundClicked(context),
      ),
    );
  }
}
