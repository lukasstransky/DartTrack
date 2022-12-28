import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/games/x01/game_x01.dart';
import 'package:dart_app/models/games/x01/helper/submit_helper.dart';
import 'package:dart_app/models/player_statistics/x01/player_or_team_game_statistics_x01.dart';
import 'package:dart_app/screens/game_modes/x01/shared.dart';
import 'package:dart_app/utils/globals.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class SubmitPointsBtn extends StatelessWidget {
  const SubmitPointsBtn({Key? key}) : super(key: key);

  bool _shouldSubmitBtnBeEnabled(BuildContext context) {
    final GameX01 gameX01 = context.read<GameX01>();
    final GameSettingsX01_P gameSettingsX01 = context.read<GameSettingsX01_P>();

    // for bug -> when saving an open game
    if (gameX01.getPlayerGameStatistics.isEmpty) {
      return false;
    }

    final bool round = gameSettingsX01.getInputMethod == InputMethod.Round &&
        gameX01.getCurrentPointsSelected.isNotEmpty &&
        gameX01.getCurrentPointsSelected != 'Points';
    final bool threeDarts =
        gameSettingsX01.getInputMethod == InputMethod.ThreeDarts &&
            (gameX01.getCurrentThreeDarts[2] != 'Dart 3' ||
                gameX01.getCurrentPlayerGameStats().getCurrentPoints == 0);

    if (round || threeDarts) {
      return true;
    }
    return false;
  }

  bool _shouldOnPressedBeEnabled(GameSettingsX01_P gameSettingsX01) {
    if (gameSettingsX01.getInputMethod == InputMethod.ThreeDarts &&
        !gameSettingsX01.getAutomaticallySubmitPoints) {
      return true;
    }
    return false;
  }

  _submitPointsBtnClicked(BuildContext context) {
    final GameX01 gameX01 = context.read<GameX01>();
    final GameSettingsX01_P gameSettingsX01 = context.read<GameSettingsX01_P>();

    if (gameSettingsX01.getInputMethod == InputMethod.Round) {
      _submitPointsForInputMethodRound(
          gameX01.getCurrentPointsSelected, context);
    } else if (_shouldOnPressedBeEnabled(gameSettingsX01)) {
      // if input method is three darts and points are not auto submitted (btn needs to be pressed)
      g_thrownDarts = g_thrownDarts == 0 ? 3 : g_thrownDarts;
      Submit.submitPoints(_getLastDartThrown(gameX01), context, false,
          g_thrownDarts, g_checkoutCount);
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
      String currentPointsSelected, BuildContext context) {
    final GameX01 gameX01 = context.read<GameX01>();
    final GameSettingsX01_P gameSettingsX01 = context.read<GameSettingsX01_P>();
    final PlayerOrTeamGameStatisticsX01 stats =
        gameX01.getCurrentPlayerGameStats();

    //double in -> check for 1, 3, 5 -> invalid
    if ((gameSettingsX01.getModeIn == ModeOutIn.Double ||
            gameSettingsX01.getModeIn == ModeOutIn.Master) &&
        _areInvalidDoubleInPoints(currentPointsSelected) &&
        stats.getCurrentPoints == gameSettingsX01.getPointsOrCustom()) {
      Fluttertoast.showToast(msg: 'Invalid Score for Double In!');
      gameX01.setCurrentPointsSelected = 'Points';
      gameX01.notify();
    } else {
      if (currentPointsSelected.isNotEmpty &&
          currentPointsSelected != 'Points') {
        if (gameX01.isCheckoutPossible()) {
          if (gameX01.finishedWithThreeDarts(currentPointsSelected)) {
            Submit.submitPoints(currentPointsSelected, context, false, 3, 1);
          } else {
            if (gameSettingsX01.getEnableCheckoutCounting &&
                gameSettingsX01.getCheckoutCountingFinallyDisabled == false) {
              final int count = gameX01
                  .getAmountOfCheckoutPossibilities(currentPointsSelected);
              if (count != -1) {
                showDialogForCheckout(count, currentPointsSelected, context);
              } else {
                Submit.submitPoints(currentPointsSelected, context);
              }
            } else if (gameX01.finishedLegSetOrGame(currentPointsSelected)) {
              showDialogForCheckout(-1, currentPointsSelected, context);
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
            : MaterialStateProperty.all(
                Utils.darken(Colors.green, 25),
              );

    return Consumer2<GameX01, GameSettingsX01_P>(
      builder: (_, gameX01, gameSettingsX01, __) => Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Utils.getPrimaryColorDarken(context),
              width: 3,
            ),
            left: BorderSide(
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
            backgroundColor: _colorResult,
            shadowColor: MaterialStateProperty.all(Colors.transparent),
            overlayColor: _colorResult,
          ),
          child: Icon(
            Icons.arrow_forward,
            color: Utils.getTextColorDarken(context),
          ),
          onPressed: () => _submitPointsBtnClicked(context),
        ),
      ),
    );
  }
}
