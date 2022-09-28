import 'package:dart_app/models/games/helper/revert.dart';
import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RevertBtn extends StatelessWidget {
  const RevertBtn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameX01 = Provider.of<GameX01>(context, listen: false);

    return ElevatedButton(
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
        child: const Icon(Icons.undo, color: Colors.black),
        onPressed: () {
          if (gameX01.getRevertPossible) {
            Revert.revertPoints(context);
          }
        });
  }
}
