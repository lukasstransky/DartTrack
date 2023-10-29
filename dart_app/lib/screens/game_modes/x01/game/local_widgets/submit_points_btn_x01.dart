import 'package:dart_app/constants.dart';
import 'package:dart_app/models/bot.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/models/games/x01/helper/submit_x01_helper.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats_x01.dart';
import 'package:dart_app/models/settings_p.dart';
import 'package:dart_app/screens/game_modes/x01/shared.dart';
import 'package:dart_app/utils/globals.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class SubmitPointsBtnX01 extends StatelessWidget {
  const SubmitPointsBtnX01({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool shouldSubmitBtnBeEnabled = _shouldSubmitBtnBeEnabled(context);
    final GameSettingsX01_P gameSettingsX01 = context.read<GameSettingsX01_P>();

    final MaterialStateProperty<Color> _colorResult = shouldSubmitBtnBeEnabled
        ? MaterialStateProperty.all(Colors.green)
        : MaterialStateProperty.all(Utils.darken(Colors.green, 25));
    final MaterialStateProperty<Color> _colorResultOverlay =
        shouldSubmitBtnBeEnabled
            ? MaterialStateProperty.all(Utils.darken(Colors.green, 10))
            : MaterialStateProperty.all(Colors.transparent);
    final MaterialStateProperty<Color> _colorResultShadow =
        shouldSubmitBtnBeEnabled
            ? MaterialStateProperty.all(
                Utils.darken(Colors.green, 30).withOpacity(0.3))
            : MaterialStateProperty.all(Colors.transparent);

    return Selector<GameX01_P, SelectorModel>(
      selector: (_, gameX01_P) => SelectorModel(
        currentPointsSelected: gameX01_P.getCurrentPointsSelected,
        currentThreeDarts: gameX01_P.getCurrentThreeDarts,
      ),
      builder: (_, selectorModel, __) => Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Utils.getPrimaryColorDarken(context),
              width: GENERAL_BORDER_WIDTH.w,
            ),
            left: BorderSide(
              color: Utils.getPrimaryColorDarken(context),
              width: gameSettingsX01.getInputMethod == InputMethod.Round
                  ? GENERAL_BORDER_WIDTH.w
                  : 0,
            ),
            right: context.read<GameX01_P>().getSafeAreaPadding.right > 0
                ? BorderSide(
                    color: Utils.getPrimaryColorDarken(context),
                    width: GENERAL_BORDER_WIDTH.w,
                  )
                : BorderSide.none,
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
            shadowColor: _colorResultShadow,
            overlayColor: _colorResultOverlay,
          ),
          child: Icon(
            size: ICON_BUTTON_SIZE.h,
            Icons.arrow_forward,
            color: Utils.getTextColorDarken(context),
          ),
          onPressed: () {
            Utils.handleVibrationFeedback(context);
            _submitPointsBtnClicked(context);
          },
        ),
      ),
    );
  }

  bool _shouldSubmitBtnBeEnabled(BuildContext context) {
    final GameX01_P gameX01 = context.read<GameX01_P>();
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

  bool _shouldOnPressedBeEnabled(
      GameSettingsX01_P gameSettingsX01, GameX01_P gameX01) {
    if (gameSettingsX01.getInputMethod == InputMethod.ThreeDarts &&
        !gameSettingsX01.getAutomaticallySubmitPoints &&
        !(gameX01.getCurrentPlayerToThrow is Bot)) {
      return true;
    }
    return false;
  }

  _submitPointsBtnClicked(BuildContext context) {
    final GameX01_P gameX01 = context.read<GameX01_P>();
    final GameSettingsX01_P gameSettingsX01 = context.read<GameSettingsX01_P>();
    final PlayerOrTeamGameStatsX01 currentStats =
        Utils.getCurrentPlayerOrTeamStats(gameX01, gameSettingsX01);
    final int currentPoints = currentStats.getCurrentPoints;

    // prevent user from submitting points for bot
    if (gameX01.botSubmittedPoints && gameX01.getCurrentPlayerToThrow is Bot) {
      return;
    }

    if ((gameX01.getCurrentPointsSelected != 'Points' || currentPoints == 0) &&
        context.read<Settings_P>().getVibrationFeedbackEnabled) {
      HapticFeedback.lightImpact();
    }

    if (gameSettingsX01.getInputMethod == InputMethod.Round) {
      _submitPointsForInputMethodRound(
          gameX01.getCurrentPointsSelected, context);
    } else if (_shouldOnPressedBeEnabled(gameSettingsX01, gameX01)) {
      // if input method is three darts and points are not auto submitted (btn needs to be pressed)
      g_thrownDarts = g_thrownDarts == 0 ? 3 : g_thrownDarts;
      SubmitX01Helper.submitPoints(_getLastDartThrown(gameX01), context, false,
          g_thrownDarts, g_checkoutCount);
    }
  }

  String _getLastDartThrown(GameX01_P gameX01) {
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
    final GameX01_P gameX01 = context.read<GameX01_P>();
    final GameSettingsX01_P gameSettingsX01 = context.read<GameSettingsX01_P>();
    final PlayerOrTeamGameStatsX01 stats = gameX01.getCurrentPlayerGameStats();

    //double in, master in -> check for 1 -> invalid
    if ((gameSettingsX01.getModeIn == ModeOutIn.Double ||
            gameSettingsX01.getModeIn == ModeOutIn.Master) &&
        currentPointsSelected == '1' &&
        stats.getCurrentPoints == gameSettingsX01.getPointsOrCustom()) {
      Fluttertoast.showToast(
        msg: gameSettingsX01.getModeIn == ModeOutIn.Double
            ? 'Invalid score for double in!'
            : 'Invalid score for master in!',
        toastLength: Toast.LENGTH_SHORT,
        fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
      );
      gameX01.setCurrentPointsSelected = 'Points';
      gameX01.notify();
    } else {
      if (currentPointsSelected.isNotEmpty &&
          currentPointsSelected != 'Points') {
        if (gameX01.isCheckoutPossible()) {
          if (gameX01.finishedWithThreeDarts(currentPointsSelected)) {
            SubmitX01Helper.submitPoints(
                currentPointsSelected, context, false, 3, 1);
          } else {
            if (gameSettingsX01.getEnableCheckoutCounting &&
                gameSettingsX01.getCheckoutCountingFinallyDisabled == false) {
              final int count = gameX01
                  .getAmountOfCheckoutPossibilities(currentPointsSelected);

              if (count != -1) {
                showDialogForCheckout(count, currentPointsSelected, context);
              } else {
                SubmitX01Helper.submitPoints(currentPointsSelected, context);
              }
            } else if (gameX01.finishedLegSetOrGame(currentPointsSelected)) {
              showDialogForCheckout(-1, currentPointsSelected, context);
            } else {
              SubmitX01Helper.submitPoints(currentPointsSelected, context);
            }
          }
        } else {
          SubmitX01Helper.submitPoints(currentPointsSelected, context);
        }
      }
    }
  }
}

class SelectorModel {
  final String currentPointsSelected;
  final List<String> currentThreeDarts;

  SelectorModel({
    required this.currentPointsSelected,
    required this.currentThreeDarts,
  });
}
