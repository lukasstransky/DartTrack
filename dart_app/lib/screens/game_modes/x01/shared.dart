import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/utils/globals.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';

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
              final int amount = gameX01.getAmountOfDartsThrown();

              gameX01.getCurrentThreeDarts[amount - 1] =
                  'Dart ${amount.toString()}';
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
            if (!gameX01.getGameSettings.getAutomaticallySubmitPoints) {
              checkoutCount = selectedCheckoutCount;
              thrownDarts = selectedFinishCount;
            } else {
              gameX01.submitPoints(
                  currentPointsSelected,
                  context,
                  selectedFinishCount,
                  selectedCheckoutCount); //submit is called because of the checkout dialog -> otherwise points would be immediately subtracted and shown on ui
            }

            Navigator.of(context).pop();
          },
          child: const Text('Submit'),
        ),
      ],
    ),
  );
}
