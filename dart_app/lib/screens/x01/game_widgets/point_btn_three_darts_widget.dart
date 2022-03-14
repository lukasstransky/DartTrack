import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/game_x01_model.dart';
import 'package:dart_app/other/utils.dart';
import 'package:dart_app/screens/x01/shared.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'dart:developer';

class PointBtnThreeDartwWidget extends StatelessWidget {
  const PointBtnThreeDartwWidget({Key? key, this.point, this.activeBtn})
      : super(key: key);

  final String? point;
  final bool? activeBtn;

  @override
  Widget build(BuildContext context) {
    final gameX01 = Provider.of<GameX01>(context, listen: false);

    //append T or D (tripple, double)
    String text = "";
    if (point != "Bull" && point != "25" && point != "0") {
      if (gameX01.getCurrentPointType == PointType.Double) {
        text = "D ";
      } else if (gameX01.getCurrentPointType == PointType.Tripple) {
        text = "T ";
      }
    }
    text += point as String;

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
        overlayColor: activeBtn as bool && gameX01.getCanBePressed
            ? Utils.getColor(
                Theme.of(context).colorScheme.primary,
                Utils.darken(Theme.of(context).colorScheme.primary, 15),
              )
            : MaterialStateProperty.all(Colors.transparent),
      ),
      child: FittedBox(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.black,
          ),
        ),
      ),
      onPressed: () {
        if (activeBtn as bool) {
          gameX01.updateCurrentThreeDarts(text);
          if (gameX01.getCurrentThreeDarts[2] != "Dart 3" &&
              gameX01.getGameSettings.getAutomaticallySubmitPoints) {
            gameX01.setCanBePressed = false;
            submitPointsForInputMethodThreeDarts(
                gameX01, point as String, context);
            gameX01.setCanBePressed = true;
          } else {
            submitPointsForInputMethodThreeDarts(
                gameX01, point as String, context);
          }
        }
      },
    );
  }
}
