import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/game_x01_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:developer';

//HERE ARE METHODS DEFINED THAT ARE NEEDED BY MULTIPLE WIDGETS
//instead of defining & passing callbacks...

//shows a dialog for selecting the amount of checkout possibilities for the current throw
//finishCount is only transfered when the input method is three darts (there I know the finish count)
showDialogForCheckout(GameX01 gameX01, int checkoutPossibilities,
    String currentPointsSelected, BuildContext context) {
  int selectedCheckoutCount =
      gameX01.finishedLegSetOrGame(currentPointsSelected) ? 1 : 0;
  int selectedFinishCount = 0;
  if (gameX01.getGameSettings.getInputMethod == InputMethod.Round) {
    selectedFinishCount = gameX01.isDoubleField(currentPointsSelected)
        ? 1
        : 2; //how many darts a player needed for finising
  } else {
    selectedFinishCount = gameX01.getAmountOfDartsThrown();
  }

  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => AlertDialog(
      title: gameX01.getGameSettings.getEnableCheckoutCounting
          ? Text("Checkout Counting")
          : Text("Finish Counting"),
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
                    child: Text("Darts on Double:")),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (gameX01.getGameSettings.getEnableCheckoutCounting &&
                      gameX01.getGameSettings
                              .getCheckoutCountingFinallyDisabled ==
                          false) ...[
                    if (!gameX01.finishedLegSetOrGame(currentPointsSelected))
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(5),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() => selectedCheckoutCount = 0);
                            },
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: const Text("0"),
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
                            child: const Text("1"),
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
                            },
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: const Text("2"),
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
                            },
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: const Text("3"),
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
                    child: Text("Darts for Finish:")),
                Row(
                  children: [
                    if (gameX01.isDoubleField(currentPointsSelected))
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(5),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() => selectedFinishCount = 1);
                            },
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: const Text("1"),
                            ),
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                ),
                              ),
                              backgroundColor: selectedFinishCount == 1
                                  ? MaterialStateProperty.all(
                                      Theme.of(context).colorScheme.primary)
                                  : MaterialStateProperty.all<Color>(
                                      Colors.grey),
                            ),
                          ),
                        ),
                      ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.all(5),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() => selectedFinishCount = 2);
                          },
                          child: FittedBox(
                            fit: BoxFit.fitWidth,
                            child: const Text("2"),
                          ),
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                              ),
                            ),
                            backgroundColor: selectedFinishCount == 2
                                ? MaterialStateProperty.all(
                                    Theme.of(context).colorScheme.primary)
                                : MaterialStateProperty.all<Color>(Colors.grey),
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
                            child: const Text("3"),
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
            gameX01.setCurrentPointsSelected = "Points";
            gameX01.notify();
          },
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            gameX01.addToCheckoutCount(selectedCheckoutCount);
            gameX01.submitPoints(currentPointsSelected, context,
                selectedFinishCount); //submit is called because of the checkout dialog -> otherwise points would be immediately subtracted and shown on ui
          },
          child: const Text("Submit"),
        ),
      ],
    ),
  );
}

submitPointsForInputMethodRound(
    GameX01 gameX01, String currentPointsSelected, BuildContext context) {
  //double in -> check for 1, 3, 5 -> invalid
  if (gameX01.getGameSettings.getModeIn == SingleOrDouble.DoubleField &&
      gameX01.checkIfInvalidDoubleInPointsSubmitted(currentPointsSelected)) {
    Fluttertoast.showToast(msg: "Invalid Score for Double In!");
    gameX01.setCurrentPointsSelected = "Points";
    gameX01.notify();
  } else {
    if (currentPointsSelected.isNotEmpty && currentPointsSelected != "Points") {
      if (gameX01.checkoutPossible()) {
        if (gameX01.finishedWithThreeDarts(currentPointsSelected)) {
          gameX01.submitPoints(currentPointsSelected, context);
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

submitPointsForInputMethodThreeDarts(
    GameX01 gameX01, String scoredPoint, BuildContext context) {
  //calculate points based on single, double, tripple

  int parsedPoints;
  if (scoredPoint == "Bull") {
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
  if (gameX01.getAmountOfDartsThrown() != 3) {
    gameX01.submitOnlyPoints(parsedPoints);
  }

  if (gameX01.checkoutPossible()) {
    //finished with 3 darts (only high finish) -> show no dialog
    if (gameX01.getCurrentThreeDarts[2] != "Dart 3" &&
        gameX01.finishedWithThreeDarts(currentThreeDarts)) {
      gameX01.submitPoints(scoredPoint, context);
      submitAlreadyCalled = true;
      //finished with first dart -> show no dialog
    } else if (gameX01.getAmountOfDartsThrown() == 1 &&
        gameX01.finishedLegSetOrGame(currentThreeDarts)) {
      gameX01.submitPoints(scoredPoint, context, 1);
      if (gameX01.isCheckoutCountingEnabled()) {
        gameX01.addToCheckoutCount(1);
      }
      submitAlreadyCalled = true;
    } else {
      if (gameX01.isCheckoutCountingEnabled()) {
        //only show dialog if checkout counting is enabled -> to select darts on finish is not needed in three darts method
        if (gameX01.finishedLegSetOrGame(currentThreeDarts)) {
          submitAlreadyCalled = true;
          showDialogForCheckout(gameX01, -1, scoredPoint, context);
        } else if (gameX01.getAmountOfDartsThrown() == 3) {
          //if not finished -> get checkout possibilities
          int count = gameX01.getAmountOfCheckoutPossibilities(scoredPoint);
          log(count.toString());
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
    gameX01.submitPoints(scoredPoint, context, 1);
  }
}
