import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/screens/game_modes/x01/shared.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SubmitPointsBtn extends StatelessWidget {
  const SubmitPointsBtn({Key? key}) : super(key: key);

  bool shouldSubmitBtnBeEnabled(GameX01 gameX01) {
    if ((gameX01.getGameSettings.getInputMethod == InputMethod.Round &&
            gameX01.getCurrentPointsSelected.isNotEmpty &&
            gameX01.getCurrentPointsSelected != "Points") ||
        (gameX01.getGameSettings.getInputMethod == InputMethod.ThreeDarts &&
            gameX01.getCurrentThreeDarts[2] != "Dart 3")) {
      return true;
    }
    return false;
  }

  bool shouldOnPressedBeEnabled(GameX01 gameX01) {
    if (gameX01.getGameSettings.getInputMethod == InputMethod.ThreeDarts &&
        !gameX01.getGameSettings.getAutomaticallySubmitPoints) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameX01>(
      builder: (_, gameX01, __) => ElevatedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            backgroundColor: shouldSubmitBtnBeEnabled(gameX01)
                ? MaterialStateProperty.all(Colors.green)
                : MaterialStateProperty.all(Utils.darken(Colors.green, 25)),
            shadowColor: MaterialStateProperty.all(Colors.transparent),
            overlayColor: shouldSubmitBtnBeEnabled(gameX01)
                ? MaterialStateProperty.all(Utils.darken(Colors.green, 25))
                : MaterialStateProperty.all(Colors.transparent),
          ),
          child: Icon(Icons.arrow_forward, color: Colors.black),
          onPressed: () {
            if (gameX01.getGameSettings.getInputMethod == InputMethod.Round) {
              submitPointsForInputMethodRound(
                  gameX01, gameX01.getCurrentPointsSelected, context);
            } /*else if (shouldOnPressedBeEnabled(gameX01)) {
              submitPointsForInputMethodThreeDarts(
                  gameX01, gameX01.getLastThrownDart(), context);
              gameX01.resetCurrentThreeDarts();
            }*/
          }),
    );
  }
}
