import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/models/games/helper/revert_helper.dart';
import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/models/games/helper/submit_helper.dart';
import 'package:dart_app/utils/globals.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// HERE ARE METHODS DEFINED THAT ARE NEEDED BY MULTIPLE WIDGETS
// instead of defining & passing callbacks...

// shows a dialog for selecting the amount of checkout possibilities for the current throw
// finishCount is only transfered when the input method is three darts (there I know the finish count)
showDialogForCheckout(int checkoutPossibilities, String currentPointsSelected,
    BuildContext context) {
  final GameX01 gameX01 = context.read<GameX01>();
  final GameSettingsX01 gameSettingsX01 = context.read<GameSettingsX01>();

  String threeDartsCalculated = '';
  int selectedCheckoutCount = 0;
  int selectedFinishCount = 3;

  if (gameSettingsX01.getInputMethod == InputMethod.ThreeDarts) {
    threeDartsCalculated = gameX01.getCurrentThreeDartsCalculated();
    selectedFinishCount = gameX01.getAmountOfDartsThrown();
  } else {
    if (gameX01.finishedLegSetOrGame(currentPointsSelected)) {
      if (gameSettingsX01.getModeOut == ModeOutIn.Master) {
        selectedFinishCount =
            gameX01.isTrippleField(int.parse(currentPointsSelected)) ? 1 : 2;
      } else {
        selectedFinishCount =
            gameX01.isDoubleField(currentPointsSelected) ? 1 : 2;
      }
    }
  }

  final String pointsThrown =
      gameSettingsX01.getInputMethod == InputMethod.ThreeDarts
          ? threeDartsCalculated
          : currentPointsSelected;
  selectedCheckoutCount = gameX01.finishedLegSetOrGame(pointsThrown) ? 1 : 0;
  final bool isDoubleField = gameX01.isDoubleField(pointsThrown);

  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => AlertDialog(
      contentPadding: EdgeInsets.only(
          bottom: DIALOG_CONTENT_PADDING_BOTTOM,
          top: DIALOG_CONTENT_PADDING_TOP,
          left: DIALOG_CONTENT_PADDING_LEFT,
          right: DIALOG_CONTENT_PADDING_RIGHT),
      title: gameSettingsX01.getEnableCheckoutCounting &&
              !gameSettingsX01.getCheckoutCountingFinallyDisabled
          ? Text('Checkout Counting')
          : Text('Finish Counting'),
      content: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (gameSettingsX01.getEnableCheckoutCounting &&
                  gameSettingsX01.getCheckoutCountingFinallyDisabled == false)
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Darts on Double:')),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (gameSettingsX01.getEnableCheckoutCounting &&
                      gameSettingsX01.getCheckoutCountingFinallyDisabled ==
                          false) ...[
                    if (!gameX01.finishedLegSetOrGame(
                        gameSettingsX01.getInputMethod == InputMethod.ThreeDarts
                            ? threeDartsCalculated
                            : currentPointsSelected))
                      // button 0 for checkout darts
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
                    // button 1 for checkout darts
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
                      // button 2 for checkout darts
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.all(5),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                selectedCheckoutCount = 2;
                                if (!isDoubleField) {
                                  selectedFinishCount = 3;
                                }
                                if (selectedFinishCount < 2) {
                                  selectedFinishCount = 2;
                                }
                              });
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
                      // button 3 for checkout darts
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
              if (gameSettingsX01.getInputMethod == InputMethod.Round &&
                  gameX01.finishedLegSetOrGame(currentPointsSelected)) ...[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Darts for Finish:'),
                ),
                Row(
                  children: [
                    if (gameX01.isDoubleField(currentPointsSelected) ||
                        (gameSettingsX01.getModeOut == ModeOutIn.Master &&
                            gameX01.isTrippleField(
                                int.parse(currentPointsSelected))))
                      // button 1 for finish darts
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
                    // button 2 for finish darts
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.all(5),
                        child: ElevatedButton(
                          onPressed: () {
                            if (selectedCheckoutCount < 2 ||
                                selectedCheckoutCount == 2 && isDoubleField) {
                              setState(() => selectedFinishCount = 2);
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
                            backgroundColor: selectedCheckoutCount > 2 ||
                                    (selectedCheckoutCount == 2 &&
                                        !isDoubleField)
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
                                    selectedCheckoutCount > 2 ||
                                    (selectedCheckoutCount == 2 &&
                                        !isDoubleField)
                                ? MaterialStateProperty.all(Colors.transparent)
                                : MaterialStateProperty.all(
                                    Theme.of(context).colorScheme.primary),
                          ),
                        ),
                      ),
                    ),
                    // button 3 for finish darts
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
            if (gameSettingsX01.getInputMethod == InputMethod.ThreeDarts) {
              final int amount = gameX01.getAmountOfDartsThrown();

              gameX01.getCurrentThreeDarts[amount - 1] =
                  'Dart ${amount.toString()}';
              Revert.revertSomeStats(context, int.parse(currentPointsSelected));
            } else {
              gameX01.setCurrentPointsSelected = 'Points';
            }

            gameX01.notify();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (!gameSettingsX01.getAutomaticallySubmitPoints &&
                gameSettingsX01.getInputMethod == InputMethod.ThreeDarts) {
              g_checkoutCount = selectedCheckoutCount;
              g_thrownDarts = selectedFinishCount;
            } else {
              Submit.submitPoints(
                  currentPointsSelected,
                  context,
                  false,
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
