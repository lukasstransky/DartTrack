import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/models/player_statistics/player_game_statistics_x01.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

//HERE ARE METHODS DEFINED THAT ARE NEEDED BY MULTIPLE WIDGETS
//instead of defining & passing callbacks...

//shows a dialog for selecting the amount of checkout possibilities for the current throw
//finishCount is only transfered when the input method is three darts (there I know the finish count)
showDialogForCheckout(GameX01 gameX01, int checkoutPossibilities,
    String currentPointsSelected, BuildContext context) {
  String threeDartsCalculated = '';
  int selectedCheckoutCount = 0;
  int selectedFinishCount = 3;

  if (gameX01.getGameSettings.getInputMethod == InputMethod.ThreeDarts) {
    threeDartsCalculated = gameX01.getCurrentThreeDartsCalculated();
    selectedFinishCount = gameX01.getAmountOfDartsThrown();
  } else {
    if (gameX01.finishedLegSetOrGame(currentPointsSelected)) {
      if (gameX01.getGameSettings.getModeOut == ModeOutIn.Master) {
        selectedFinishCount =
            gameX01.isTrippleField(int.parse(currentPointsSelected)) ? 1 : 2;
      } else {
        selectedFinishCount =
            gameX01.isDoubleField(currentPointsSelected) ? 1 : 2;
      }
    }
  }

  final String pointsThrown =
      gameX01.getGameSettings.getInputMethod == InputMethod.ThreeDarts
          ? threeDartsCalculated
          : currentPointsSelected;
  selectedCheckoutCount = gameX01.finishedLegSetOrGame(pointsThrown) ? 1 : 0;

  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => AlertDialog(
      contentPadding: EdgeInsets.only(
          bottom: DIALOG_CONTENT_PADDING_BOTTOM,
          top: DIALOG_CONTENT_PADDING_TOP,
          left: DIALOG_CONTENT_PADDING_LEFT,
          right: DIALOG_CONTENT_PADDING_RIGHT),
      title: gameX01.getGameSettings.getEnableCheckoutCounting
          ? Text('Checkout Counting')
          : Text('Finish Counting'),
      content: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (gameX01.getGameSettings.getEnableCheckoutCounting &&
                  gameX01.getGameSettings.getCheckoutCountingFinallyDisabled ==
                      false)
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Darts on Double:')),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (gameX01.getGameSettings.getEnableCheckoutCounting &&
                      gameX01.getGameSettings
                              .getCheckoutCountingFinallyDisabled ==
                          false) ...[
                    if (!gameX01.finishedLegSetOrGame(
                        gameX01.getGameSettings.getInputMethod ==
                                InputMethod.ThreeDarts
                            ? threeDartsCalculated
                            : currentPointsSelected))
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(5),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() => selectedCheckoutCount = 0);
                            },
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: const Text('0'),
                            ),
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                ),
                              ),
                              backgroundColor: selectedCheckoutCount == 0
                                  ? MaterialStateProperty.all(
                                      Theme.of(context).colorScheme.primary)
                                  : MaterialStateProperty.all<Color>(
                                      Colors.grey),
                              shadowColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              overlayColor: selectedCheckoutCount == 0
                                  ? MaterialStateProperty.all(
                                      Colors.transparent)
                                  : MaterialStateProperty.all(
                                      Theme.of(context).colorScheme.primary),
                            ),
                          ),
                        ),
                      ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.all(5),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() => selectedCheckoutCount = 1);
                          },
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: const Text('1'),
                          ),
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                            ),
                            backgroundColor: selectedCheckoutCount == 1
                                ? MaterialStateProperty.all(
                                    Theme.of(context).colorScheme.primary)
                                : MaterialStateProperty.all<Color>(Colors.grey),
                            shadowColor:
                                MaterialStateProperty.all(Colors.transparent),
                            overlayColor: selectedCheckoutCount == 1
                                ? MaterialStateProperty.all(Colors.transparent)
                                : MaterialStateProperty.all(
                                    Theme.of(context).colorScheme.primary),
                          ),
                        ),
                      ),
                    ),
                    if (checkoutPossibilities >= 2)
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(5),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() => selectedCheckoutCount = 2);
                              if (selectedFinishCount < 2) {
                                selectedFinishCount = 2;
                              }
                            },
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: const Text('2'),
                            ),
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                ),
                              ),
                              backgroundColor: selectedCheckoutCount == 2
                                  ? MaterialStateProperty.all(
                                      Theme.of(context).colorScheme.primary)
                                  : MaterialStateProperty.all<Color>(
                                      Colors.grey),
                              shadowColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              overlayColor: selectedCheckoutCount == 2
                                  ? MaterialStateProperty.all(
                                      Colors.transparent)
                                  : MaterialStateProperty.all(
                                      Theme.of(context).colorScheme.primary),
                            ),
                          ),
                        ),
                      ),
                    if (checkoutPossibilities == 3)
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(5),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() => selectedCheckoutCount = 3);
                              if (selectedFinishCount < 3) {
                                selectedFinishCount = 3;
                              }
                            },
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: const Text('3'),
                            ),
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                ),
                              ),
                              backgroundColor: selectedCheckoutCount == 3
                                  ? MaterialStateProperty.all(
                                      Theme.of(context).colorScheme.primary)
                                  : MaterialStateProperty.all<Color>(
                                      Colors.grey),
                              shadowColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              overlayColor: selectedCheckoutCount == 3
                                  ? MaterialStateProperty.all(
                                      Colors.transparent)
                                  : MaterialStateProperty.all(
                                      Theme.of(context).colorScheme.primary),
                            ),
                          ),
                        ),
                      ),
                  ],
                ],
              ),
              if (gameX01.getGameSettings.getInputMethod == InputMethod.Round &&
                  gameX01.finishedLegSetOrGame(currentPointsSelected)) ...[
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Darts for Finish:')),
                Row(
                  children: [
                    if (gameX01.isDoubleField(currentPointsSelected) ||
                        (gameX01.getGameSettings.getModeOut ==
                                ModeOutIn.Master &&
                            gameX01.isTrippleField(
                                int.parse(currentPointsSelected))))
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(5),
                          child: ElevatedButton(
                            onPressed: () {
                              if (selectedCheckoutCount <= 1)
                                setState(() => selectedFinishCount = 1);
                            },
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: const Text('1'),
                            ),
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                ),
                              ),
                              backgroundColor: selectedCheckoutCount > 1
                                  ? MaterialStateProperty.all(
                                      Utils.darken(Colors.grey, 25))
                                  : selectedFinishCount == 1
                                      ? MaterialStateProperty.all(
                                          Theme.of(context).colorScheme.primary)
                                      : MaterialStateProperty.all<Color>(
                                          Colors.grey),
                              shadowColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              overlayColor: selectedFinishCount == 1 ||
                                      selectedCheckoutCount > 1
                                  ? MaterialStateProperty.all(
                                      Colors.transparent)
                                  : MaterialStateProperty.all(
                                      Theme.of(context).colorScheme.primary),
                            ),
                          ),
                        ),
                      ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.all(5),
                        child: ElevatedButton(
                          onPressed: () {
                            if (selectedCheckoutCount <= 2)
                              setState(() => selectedFinishCount = 2);
                          },
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: const Text('2'),
                          ),
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                            ),
                            backgroundColor: selectedCheckoutCount > 2
                                ? MaterialStateProperty.all(
                                    Utils.darken(Colors.grey, 25))
                                : selectedFinishCount == 2
                                    ? MaterialStateProperty.all(
                                        Theme.of(context).colorScheme.primary)
                                    : MaterialStateProperty.all<Color>(
                                        Colors.grey),
                            shadowColor:
                                MaterialStateProperty.all(Colors.transparent),
                            overlayColor: selectedFinishCount == 2 ||
                                    selectedCheckoutCount > 2
                                ? MaterialStateProperty.all(Colors.transparent)
                                : MaterialStateProperty.all(
                                    Theme.of(context).colorScheme.primary),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.all(5),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() => selectedFinishCount = 3);
                          },
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: const Text('3'),
                          ),
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                            ),
                            backgroundColor: selectedFinishCount == 3
                                ? MaterialStateProperty.all(
                                    Theme.of(context).colorScheme.primary)
                                : MaterialStateProperty.all<Color>(Colors.grey),
                            shadowColor:
                                MaterialStateProperty.all(Colors.transparent),
                            overlayColor: selectedFinishCount == 3
                                ? MaterialStateProperty.all(Colors.transparent)
                                : MaterialStateProperty.all(
                                    Theme.of(context).colorScheme.primary),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          );
        },
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            if (gameX01.getGameSettings.getInputMethod ==
                InputMethod.ThreeDarts) {
              int amount = gameX01.getAmountOfDartsThrown();
              gameX01.getCurrentThreeDarts[amount - 1] =
                  'Dart ' + amount.toString();
              gameX01.revertSomeStats(int.parse(currentPointsSelected));
            } else {
              gameX01.setCurrentPointsSelected = 'Points';
            }

            gameX01.notify();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            //gameX01.addToCheckoutCount(selectedCheckoutCount);
            gameX01.submitPoints(
                currentPointsSelected,
                context,
                selectedFinishCount,
                selectedCheckoutCount); //submit is called because of the checkout dialog -> otherwise points would be immediately subtracted and shown on ui
          },
          child: const Text('Submit'),
        ),
      ],
    ),
  );
}

submitPointsForInputMethodRound(
    GameX01 gameX01, String currentPointsSelected, BuildContext context) {
  final PlayerGameStatisticsX01 stats =
      gameX01.getCurrentPlayerGameStatistics();

  //double in -> check for 1, 3, 5 -> invalid
  if ((gameX01.getGameSettings.getModeIn == ModeOutIn.Double ||
          gameX01.getGameSettings.getModeIn == ModeOutIn.Master) &&
      gameX01.areInvalidDoubleInPoints(currentPointsSelected) &&
      stats.getCurrentPoints == gameX01.getGameSettings.getPointsOrCustom()) {
    Fluttertoast.showToast(msg: 'Invalid Score for Double In!');
    gameX01.setCurrentPointsSelected = 'Points';
    gameX01.notify();
  } else {
    if (currentPointsSelected.isNotEmpty && currentPointsSelected != 'Points') {
      if (gameX01.checkoutPossible()) {
        if (gameX01.finishedWithThreeDarts(currentPointsSelected)) {
          gameX01.submitPoints(currentPointsSelected, context, 3, 1);
        } else {
          if (gameX01.getGameSettings.getEnableCheckoutCounting &&
              gameX01.getGameSettings.getCheckoutCountingFinallyDisabled ==
                  false) {
            int count =
                gameX01.getAmountOfCheckoutPossibilities(currentPointsSelected);
            if (count != -1) {
              showDialogForCheckout(
                  gameX01, count, currentPointsSelected, context);
            } else {
              gameX01.submitPoints(currentPointsSelected, context);
            }
          } else if (gameX01.finishedLegSetOrGame(currentPointsSelected)) {
            showDialogForCheckout(gameX01, -1, currentPointsSelected, context);
          } else {
            gameX01.submitPoints(currentPointsSelected, context);
          }
        }
      } else {
        gameX01.submitPoints(currentPointsSelected, context);
      }
    }
  }
}

submitPointsForInputMethodThreeDarts(GameX01 gameX01, String scoredPoint,
    String scoredPointAsString, BuildContext context) {
  PlayerGameStatisticsX01 stats = gameX01.getCurrentPlayerGameStatistics();
  if (stats.getPointsSelectedCount < 3) {
    stats.setPointsSelectedCount = stats.getPointsSelectedCount + 1;

    //calculate points based on single, double, tripple
    int parsedPoints;
    if (scoredPoint == 'Bull') {
      parsedPoints = 50;
    } else {
      parsedPoints = int.parse(scoredPoint);
      if (gameX01.getGameSettings.getInputMethod == InputMethod.ThreeDarts) {
        if (gameX01.getCurrentPointType == PointType.Double)
          parsedPoints = parsedPoints * 2;
        else if (gameX01.getCurrentPointType == PointType.Tripple)
          parsedPoints = parsedPoints * 3;
      }
    }

    scoredPoint = parsedPoints.toString();
    bool submitAlreadyCalled = false;
    String currentThreeDarts = gameX01.getCurrentThreeDartsCalculated();
    bool finished = gameX01.finishedLegSetOrGame(currentThreeDarts);
    int amountOfDartsThrown = gameX01.getAmountOfDartsThrown();

    if (!finished && gameX01.getAmountOfDartsThrown() != 3) {
      gameX01.submitOnlyPoints(parsedPoints, scoredPointAsString);
    } else {
      gameX01.submitSomeStats(parsedPoints, scoredPointAsString);
    }

    if (gameX01.checkoutPossible()) {
      //finished with 3 darts (only high finish) -> show no dialog
      if (amountOfDartsThrown == 3 &&
          gameX01.finishedWithThreeDarts(currentThreeDarts)) {
        gameX01.submitPoints(scoredPoint, context, 3, 1);
        submitAlreadyCalled = true;

        //finished with first dart -> show no dialog
      } else if (amountOfDartsThrown == 1 && finished) {
        gameX01.submitPoints(scoredPoint, context, 1, 1);
        submitAlreadyCalled = true;
      } else {
        //only show dialog if checkout counting is enabled -> to select darts on finish is not needed in three darts method
        if (gameX01.isCheckoutCountingEnabled()) {
          int count = gameX01.getAmountOfCheckoutPossibilities(scoredPoint);
          if (finished && count == 1) {
            gameX01.submitPoints(scoredPoint, context, amountOfDartsThrown, 1);
            submitAlreadyCalled = true;
          } else if (finished) {
            submitAlreadyCalled = true;
            showDialogForCheckout(gameX01, count, scoredPoint, context);
          } else if (gameX01.getAmountOfDartsThrown() == 3) {
            if (count != -1) {
              submitAlreadyCalled = true;
              showDialogForCheckout(gameX01, count, scoredPoint, context);
            }
          }
        }
      }
    }
    //needed because in the dialog the submit method is called (otherwise submit would get called 2x)
    if (!submitAlreadyCalled) {
      gameX01.submitPoints(scoredPoint, context);
    }
  }
}
