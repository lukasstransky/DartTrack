import 'package:dart_app/constants.dart';
import 'package:dart_app/models/bot.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/models/games/helper/revert_helper.dart';
import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RevertBtn extends StatelessWidget {
  const RevertBtn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GameX01 gameX01 = context.read<GameX01>();
    final GameSettingsX01 gameSettingsX01 = context.read<GameSettingsX01>();

    return ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
              side: BorderSide(
                  color: Colors.black,
                  width: gameSettingsX01.getInputMethod == InputMethod.Round
                      ? 2
                      : 0),
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
        child: const Icon(Icons.undo, color: Colors.black),
        onPressed: () {
          if (gameX01.getRevertPossible) {
            Revert.revertPoints(context);

            if (gameX01.getCurrentPlayerToThrow is Bot) {
              Revert.revertPoints(context);
            }
          }
        });
  }
}
