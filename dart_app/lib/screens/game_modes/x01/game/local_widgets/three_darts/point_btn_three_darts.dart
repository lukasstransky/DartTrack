import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/models/games/helper/submit_helper.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_statistics_x01.dart';
import 'package:dart_app/screens/game_modes/x01/shared.dart';
import 'package:dart_app/utils/globals.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class PointBtnThreeDart extends StatelessWidget {
  const PointBtnThreeDart({Key? key, this.point, this.activeBtn})
      : super(key: key);

  final String? point;
  final bool? activeBtn;

  String _appendTrippleOrDouble(GameX01 gameX01) {
    String text = '';
    if (point != 'Bull' && point != '25' && point != '0') {
      if (gameX01.getCurrentPointType == PointType.Double) {
        text = 'D';
      } else if (gameX01.getCurrentPointType == PointType.Tripple) {
        text = 'T';
      }
    }
    text += point as String;

    return text;
  }

  _pointBtnClicked(String pointBtnText, BuildContext context) {
    final GameX01 gameX01 = context.read<GameX01>();
    final GameSettingsX01 gameSettingsX01 = context.read<GameSettingsX01>();

    if (activeBtn as bool && gameX01.getCanBePressed) {
      _updateCurrentThreeDarts(gameX01, pointBtnText);

      if (gameX01.getCurrentThreeDarts[2] != 'Dart 3' &&
          gameSettingsX01.getAutomaticallySubmitPoints) {
        gameX01.setCanBePressed = false;
        _submitPointsForInputMethodThreeDarts(
            point as String, pointBtnText, context);
        gameX01.setCanBePressed = true;
      } else {
        _submitPointsForInputMethodThreeDarts(
            point as String, pointBtnText, context);
      }
    }
  }

  _updateCurrentThreeDarts(GameX01 gameX01, String points) {
    final List<String> currentThreeDarts = gameX01.getCurrentThreeDarts;

    if (currentThreeDarts[0] == 'Dart 1') {
      currentThreeDarts[0] = points;
    } else if (currentThreeDarts[1] == 'Dart 2') {
      currentThreeDarts[1] = points;
    } else if (currentThreeDarts[2] == 'Dart 3') {
      currentThreeDarts[2] = points;
    }

    gameX01.notify();
  }

  //calculate points based on single, double, tripple
  String _calculatePoints(String scoredPoint, GameX01 gameX01) {
    int points;

    if (scoredPoint == 'Bull') {
      points = 50;
    } else {
      points = int.parse(scoredPoint);

      if (gameX01.getCurrentPointType == PointType.Double)
        points = points * 2;
      else if (gameX01.getCurrentPointType == PointType.Tripple)
        points = points * 3;
    }

    return points.toString();
  }

  // scoredField -> e.g. 20
  // scoredFieldWithPointType -> e.g. T20
  _submitPointsForInputMethodThreeDarts(
      String scoredField, String scoredFieldWithPointType, BuildContext context,
      [bool shouldSubmitTeamStats = false]) {
    final GameX01 gameX01 = context.read<GameX01>();
    final GameSettingsX01 gameSettingsX01 = context.read<GameSettingsX01>();

    late final PlayerOrTeamGameStatisticsX01 currentStats;
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

    final String scoredPoints = _calculatePoints(scoredField, gameX01);
    final int scoredPointsParsed = int.parse(scoredPoints);

    Submit.submitStatsForThreeDartsMode(
        gameX01,
        gameSettingsX01,
        scoredPointsParsed,
        scoredFieldWithPointType,
        shouldSubmitTeamStats,
        currentStats);

    final String currentThreeDarts = gameX01.getCurrentThreeDartsCalculated();
    final int amountOfDartsThrown = gameX01.getAmountOfDartsThrown();
    final bool finished = gameX01.finishedLegSetOrGame(currentThreeDarts);

    bool submitAlreadyCalled = false;
    if (!shouldSubmitTeamStats) {
      checkoutCount = 0;
    }
    if (gameX01.isCheckoutPossible() && !shouldSubmitTeamStats) {
      // finished with 3 darts (high finish) -> show no dialog
      if (amountOfDartsThrown == 3 &&
          gameX01.finishedWithThreeDarts(currentThreeDarts)) {
        if (!gameSettingsX01.getAutomaticallySubmitPoints) {
          checkoutCount = 1;
        } else {
          Submit.submitPoints(scoredPoints, context, false, 3, 1);
          submitAlreadyCalled = true;
        }

        // finished with first dart -> show no dialog
      } else if (amountOfDartsThrown == 1 && finished) {
        if (!gameSettingsX01.getAutomaticallySubmitPoints) {
          checkoutCount = 1;
          thrownDarts = 1;
        } else {
          Submit.submitPoints(scoredPoints, context, false, 1, 1);
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
              checkoutCount = 1;
              thrownDarts = amountOfDartsThrown;
            } else {
              Submit.submitPoints(
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
      Submit.submitPoints(scoredField, context);
    }

    if (!shouldSubmitTeamStats &&
        gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Team) {
      _submitPointsForInputMethodThreeDarts(
          scoredField, scoredFieldWithPointType, context, true);
    }
  }

  bool _isCheckoutCountingEnabled(GameSettingsX01 gameSettingsX01) {
    if (gameSettingsX01.getEnableCheckoutCounting &&
        gameSettingsX01.getCheckoutCountingFinallyDisabled == false) {
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final gameX01 = context.read<GameX01>();
    final String pointBtnText = _appendTrippleOrDouble(gameX01);

    return ElevatedButton(
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
                Utils.darken(Theme.of(context).colorScheme.primary, 15),
              )
            : MaterialStateProperty.all(Colors.transparent),
      ),
      child: FittedBox(
        child: Text(
          pointBtnText,
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.black,
          ),
        ),
      ),
      onPressed: () => _pointBtnClicked(pointBtnText, context),
    );
  }
}
