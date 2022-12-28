import 'package:dart_app/models/bot.dart';
import 'package:dart_app/models/games/x01/helper/revert_helper.dart';
import 'package:dart_app/models/games/x01/game_x01.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RevertBtn extends StatelessWidget {
  const RevertBtn({Key? key}) : super(key: key);

  _revertBtnPressed(GameX01 gameX01, BuildContext context) {
    if (gameX01.getRevertPossible) {
      Revert.revertPoints(context);

      if (gameX01.getCurrentPlayerToThrow is Bot) {
        Revert.revertPoints(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final GameX01 gameX01 = context.read<GameX01>();

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Utils.getPrimaryColorDarken(context),
            width: 3,
          ),
          right: BorderSide(
            color: Utils.getPrimaryColorDarken(context),
            width: 3,
          ),
        ),
      ),
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
          ),
          shadowColor: MaterialStateProperty.all(Colors.transparent),
          backgroundColor: gameX01.getRevertPossible
              ? MaterialStateProperty.all(Colors.red)
              : MaterialStateProperty.all(Utils.darken(Colors.red, 25)),
          overlayColor: gameX01.getRevertPossible
              ? MaterialStateProperty.all(Utils.darken(Colors.red, 25))
              : MaterialStateProperty.all(Colors.transparent),
        ),
        child: Icon(
          Icons.undo,
          color: Utils.getTextColorDarken(context),
        ),
        onPressed: () => _revertBtnPressed(gameX01, context),
      ),
    );
  }
}
