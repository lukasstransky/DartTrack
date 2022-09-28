import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/models/games/helper/submit.dart';
import 'package:dart_app/models/player_statistics/player_game_statistics_x01.dart';
import 'package:dart_app/screens/game_modes/x01/shared.dart';
import 'package:dart_app/utils/globals.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class SubmitPointsBtn extends StatelessWidget {
  const SubmitPointsBtn({Key? key}) : super(key: key);

  bool _shouldSubmitBtnBeEnabled(BuildContext context) {
    final gameX01 = Provider.of<GameX01>(context, listen: false);
    final PlayerGameStatisticsX01 stats =
        gameX01.getCurrentPlayerGameStatistics();

    final bool round =
        gameX01.getGameSettings.getInputMethod == InputMethod.Round &&
            gameX01.getCurrentPointsSelected.isNotEmpty &&
            gameX01.getCurrentPointsSelected != 'Points';
    final bool threeDarts =
        gameX01.getGameSettings.getInputMethod == InputMethod.ThreeDarts &&
            (gameX01.getCurrentThreeDarts[2] != 'Dart 3' ||
                stats.getCurrentPoints == 0);

    if (round || threeDarts) {
      return true;
    }
    return false;
  }

  bool _shouldOnPressedBeEnabled(GameX01 gameX01) {
    if (gameX01.getGameSettings.getInputMethod == InputMethod.ThreeDarts &&
        !gameX01.getGameSettings.getAutomaticallySubmitPoints) {
      return true;
    }
    return false;
  }

  _submitPointsBtnClicked(GameX01 gameX01, BuildContext context) {
    if (gameX01.getGameSettings.getInputMethod == InputMethod.Round) {
      _submitPointsForInputMethodRound(
          gameX01, gameX01.getCurrentPointsSelected, context);
    } else if (_shouldOnPressedBeEnabled(gameX01)) {
      thrownDarts = thrownDarts == 0 ? 3 : thrownDarts;
      Submit.submitPoints(
          _getLastDartThrown(gameX01), context, thrownDarts, checkoutCount);
    }
  }

  String _getLastDartThrown(GameX01 gameX01) {
    final List<String> currentThreeDarts = gameX01.getCurrentThreeDarts;

    for (int i = 0; i < currentThreeDarts.length; i++) {
      if (currentThreeDarts[i].contains('Dart')) {
        if (i == 0) {
          return currentThreeDarts[0];
        }
        return currentThreeDarts[i - 1];
      }
    }

    return currentThreeDarts[2];
  }

  _submitPointsForInputMethodRound(
      GameX01 gameX01, String currentPointsSelected, BuildContext context) {
    final PlayerGameStatisticsX01 stats =
        gameX01.getCurrentPlayerGameStatistics();

    //double in -> check for 1, 3, 5 -> invalid
    if ((gameX01.getGameSettings.getModeIn == ModeOutIn.Double ||
            gameX01.getGameSettings.getModeIn == ModeOutIn.Master) &&
        _areInvalidDoubleInPoints(currentPointsSelected) &&
        stats.getCurrentPoints == gameX01.getGameSettings.getPointsOrCustom()) {
      Fluttertoast.showToast(msg: 'Invalid Score for Double In!');
      gameX01.setCurrentPointsSelected = 'Points';
      gameX01.notify();
    } else {
      if (currentPointsSelected.isNotEmpty &&
          currentPointsSelected != 'Points') {
        if (gameX01.isCheckoutPossible()) {
          if (gameX01.finishedWithThreeDarts(currentPointsSelected)) {
            Submit.submitPoints(currentPointsSelected, context, 3, 1);
          } else {
            if (gameX01.getGameSettings.getEnableCheckoutCounting &&
                gameX01.getGameSettings.getCheckoutCountingFinallyDisabled ==
                    false) {
              int count = gameX01
                  .getAmountOfCheckoutPossibilities(currentPointsSelected);
              if (count != -1) {
                showDialogForCheckout(
                    gameX01, count, currentPointsSelected, context);
              } else {
                Submit.submitPoints(currentPointsSelected, context);
              }
            } else if (gameX01.finishedLegSetOrGame(currentPointsSelected)) {
              showDialogForCheckout(
                  gameX01, -1, currentPointsSelected, context);
            } else {
              Submit.submitPoints(currentPointsSelected, context);
            }
          }
        } else {
          Submit.submitPoints(currentPointsSelected, context);
        }
      }
    }
  }

  bool _areInvalidDoubleInPoints(String pointsSelected) {
    if (pointsSelected == '1' ||
        pointsSelected == '3' ||
        pointsSelected == '5') {
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final MaterialStateProperty<Color> _colorResult =
        _shouldSubmitBtnBeEnabled(context)
            ? MaterialStateProperty.all(Colors.green)
            : MaterialStateProperty.all(Utils.darken(Colors.green, 25));

    return Consumer<GameX01>(
      builder: (_, gameX01, __) => ElevatedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            backgroundColor: _colorResult,
            shadowColor: MaterialStateProperty.all(Colors.transparent),
            overlayColor: _colorResult,
          ),
          child: const Icon(Icons.arrow_forward, color: Colors.black),
          onPressed: () => _submitPointsBtnClicked(gameX01, context)),
    );
  }
}
