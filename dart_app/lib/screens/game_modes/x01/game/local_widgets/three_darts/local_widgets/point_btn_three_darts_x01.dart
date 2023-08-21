import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/models/games/x01/helper/submit_x01_helper.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats_x01.dart';
import 'package:dart_app/models/settings_p.dart';
import 'package:dart_app/screens/game_modes/shared/game/point_btns_three_darts/utils_point_btns_three_darts.dart';
import 'package:dart_app/screens/game_modes/x01/shared.dart';
import 'package:dart_app/utils/globals.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class PointBtnThreeDartX01 extends StatelessWidget {
  const PointBtnThreeDartX01({Key? key, this.point, this.activeBtn})
      : super(key: key);

  final String? point;
  final bool? activeBtn;

  _pointBtnClicked(String pointBtnText, BuildContext context) {
    final GameX01_P gameX01 = context.read<GameX01_P>();
    final GameSettingsX01_P gameSettingsX01 = context.read<GameSettingsX01_P>();

    if (activeBtn as bool && gameX01.getCanBePressed) {
      if (context.read<Settings_P>().getVibrationFeedbackEnabled) {
        HapticFeedback.lightImpact();
      }

      UtilsPointBtnsThreeDarts.updateCurrentThreeDarts(
          gameX01.getCurrentThreeDarts, pointBtnText);
      gameX01.notify();

      if (gameX01.getCurrentThreeDarts[2] != 'Dart 3' &&
          gameSettingsX01.getAutomaticallySubmitPoints) {
        gameX01.setCanBePressed = false;
        gameX01.notify();
        _submitPointsForInputMethodThreeDarts(
            point as String, pointBtnText, context);
        gameX01.setCanBePressed = true;
        gameX01.notify();
      } else {
        _submitPointsForInputMethodThreeDarts(
            point as String, pointBtnText, context);
      }
    }
  }

  // scoredField -> e.g. 20
  // scoredFieldWithPointType -> e.g. T20
  _submitPointsForInputMethodThreeDarts(
      String scoredField, String scoredFieldWithPointType, BuildContext context,
      [bool shouldSubmitTeamStats = false]) {
    final GameX01_P gameX01 = context.read<GameX01_P>();
    final GameSettingsX01_P gameSettingsX01 = context.read<GameSettingsX01_P>();

    late final PlayerOrTeamGameStatsX01 currentStats;
    if (shouldSubmitTeamStats) {
      currentStats = gameX01.getCurrentTeamGameStats();
    } else {
      currentStats = gameX01.getCurrentPlayerGameStats();
    }

    if (currentStats.getPointsSelectedCount >= 3) {
      return;
    }

    currentStats.setPointsSelectedCount =
        currentStats.getPointsSelectedCount + 1;

    final String scoredPoints = UtilsPointBtnsThreeDarts.calculatePoints(
        scoredField, gameX01.getCurrentPointType);
    final int scoredPointsParsed = int.parse(scoredPoints);

    SubmitX01Helper.submitStatsForThreeDartsMode(
        gameX01,
        gameSettingsX01,
        scoredPointsParsed,
        scoredFieldWithPointType,
        shouldSubmitTeamStats,
        currentStats);

    final String currentThreeDarts =
        Utils.getCurrentThreeDartsCalculated(gameX01.getCurrentThreeDarts);
    final int amountOfDartsThrown = gameX01.getAmountOfDartsThrown();
    final bool finished = gameX01.finishedLegSetOrGame(currentThreeDarts);

    bool submitAlreadyCalled = false;
    if (!shouldSubmitTeamStats) {
      g_checkoutCount = 0;
    }
    if (gameX01.isCheckoutPossible() && !shouldSubmitTeamStats) {
      // finished with 3 darts (high finish) -> show no dialog
      if (amountOfDartsThrown == 3 &&
          gameX01.finishedWithThreeDarts(currentThreeDarts)) {
        if (!gameSettingsX01.getAutomaticallySubmitPoints) {
          g_checkoutCount = 1;
        } else {
          SubmitX01Helper.submitPoints(scoredPoints, context, false, 3, 1);
          submitAlreadyCalled = true;
        }

        // finished with first dart -> show no dialog
      } else if (amountOfDartsThrown == 1 && finished) {
        if (!gameSettingsX01.getAutomaticallySubmitPoints) {
          g_checkoutCount = 1;
          g_thrownDarts = 1;
        } else {
          SubmitX01Helper.submitPoints(scoredPoints, context, false, 1, 1);
          submitAlreadyCalled = true;
        }

        // 2 dart finish or 3 (no high finish)
      } else {
        // only show dialog if checkout counting is enabled -> to select darts on finish is not needed in three darts method
        if (_isCheckoutCountingEnabled(gameSettingsX01)) {
          final int count =
              gameX01.getAmountOfCheckoutPossibilities(scoredPoints);

          if (finished && count == 1) {
            if (!gameSettingsX01.getAutomaticallySubmitPoints) {
              g_checkoutCount = 1;
              g_thrownDarts = amountOfDartsThrown;
            } else {
              SubmitX01Helper.submitPoints(
                  scoredPoints, context, false, amountOfDartsThrown, 1);
              submitAlreadyCalled = true;
            }
          } else if (finished) {
            submitAlreadyCalled = true;
            showDialogForCheckout(count, scoredPoints, context);
          } else if (gameX01.getAmountOfDartsThrown() == 3) {
            if (count != -1) {
              submitAlreadyCalled = true;
              showDialogForCheckout(count, scoredPoints, context);
            }
          }
        }
      }
    }

    // needed because in the dialog the submit method is called (otherwise submit would get called 2x)
    if (!submitAlreadyCalled &&
        gameSettingsX01.getAutomaticallySubmitPoints &&
        !shouldSubmitTeamStats) {
      SubmitX01Helper.submitPoints(scoredField, context);
    }

    if (!shouldSubmitTeamStats &&
        gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Team) {
      _submitPointsForInputMethodThreeDarts(
          scoredField, scoredFieldWithPointType, context, true);
    }
  }

  bool _isCheckoutCountingEnabled(GameSettingsX01_P gameSettingsX01) {
    if (gameSettingsX01.getEnableCheckoutCounting &&
        gameSettingsX01.getCheckoutCountingFinallyDisabled == false) {
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final GameX01_P gameX01 = context.read<GameX01_P>();
    final String pointBtnText = Utils.appendTrippleOrDouble(
        gameX01.getCurrentPointType, point as String);

    return Container(
      decoration: BoxDecoration(
        border: Utils.getBorder(
          context,
          point as String,
          GameMode.X01,
          context.read<GameSettingsX01_P>().getAutomaticallySubmitPoints,
        ),
      ),
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
          ),
          backgroundColor: activeBtn as bool &&
                  gameX01.getAmountOfDartsThrown() != 3
              ? MaterialStateProperty.all(Theme.of(context).colorScheme.primary)
              : MaterialStateProperty.all(
                  Utils.darken(Theme.of(context).colorScheme.primary, 25)),
          overlayColor: activeBtn as bool &&
                  gameX01.getCanBePressed &&
                  gameX01.getAmountOfDartsThrown() != 3
              ? Utils.getColorOrPressed(
                  Theme.of(context).colorScheme.primary,
                  Utils.darken(Theme.of(context).colorScheme.primary, 25),
                )
              : MaterialStateProperty.all(Colors.transparent),
        ),
        child: FittedBox(
          child: Text(
            pointBtnText,
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
              color: Utils.getTextColorDarken(context),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        onPressed: () {
          Utils.handleVibrationFeedback(context);
          _pointBtnClicked(pointBtnText, context);
        },
      ),
    );
  }
}
