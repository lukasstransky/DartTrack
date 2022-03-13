import 'package:dart_app/models/games/game_x01_model.dart';
import 'package:dart_app/other/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RevertBtnWidget extends StatelessWidget {
  const RevertBtnWidget({Key? key}) : super(key: key);

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
        child: Icon(Icons.undo, color: Colors.black),
        onPressed: () {
          if (gameX01.getRevertPossible) {
            gameX01.revertPoints();
          }
        });
  }
}
