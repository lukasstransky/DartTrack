import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/games/x01/helper/revert_x01_helper.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/models/games/x01/helper/submit_x01_helper.dart';
import 'package:dart_app/utils/globals.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

// HERE ARE METHODS DEFINED THAT ARE NEEDED BY MULTIPLE WIDGETS
// instead of defining & passing callbacks...

// shows a dialog for selecting the amount of checkout possibilities for the current throw
// finishCount is only transfered when the input method is three darts (there I know the finish count)
showDialogForCheckout(int checkoutPossibilities, String currentPointsSelected,
    BuildContext context) {
  final GameX01_P gameX01 = context.read<GameX01_P>();
  final GameSettingsX01_P gameSettingsX01 = context.read<GameSettingsX01_P>();

  String threeDartsCalculated = '';
  int selectedCheckoutCount = 0;
  int selectedFinishCount = 3;

  if (gameSettingsX01.getInputMethod == InputMethod.ThreeDarts) {
    threeDartsCalculated =
        Utils.getCurrentThreeDartsCalculated(gameX01.getCurrentThreeDarts);
    selectedFinishCount = gameX01.getAmountOfDartsThrown();
  } else {
    if (gameX01.finishedLegSetOrGame(currentPointsSelected)) {
      if (gameSettingsX01.getModeOut == ModeOutIn.Master) {
        selectedFinishCount =
            gameX01.isTrippleField(int.parse(currentPointsSelected)) ? 1 : 2;
      } else if (gameSettingsX01.getModeOut == ModeOutIn.Single &&
          currentPointsSelected == '1')
        selectedFinishCount = 1;
      else {
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
  final double borderWidth = 0.5.w;

  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DIALOG_SHAPE_ROUNDING),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      contentPadding: dialogContentPadding,
      title: Text(
        gameSettingsX01.getEnableCheckoutCounting &&
                !gameSettingsX01.getCheckoutCountingFinallyDisabled
            ? 'Checkout counting'
            : 'Finish counting',
        style: TextStyle(
          color: Colors.white,
          fontSize: DIALOG_TITLE_FONTSIZE.sp,
        ),
      ),
      content: Container(
        width: DIALOG_WIDTH.w,
        child: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (gameSettingsX01.getEnableCheckoutCounting &&
                    gameSettingsX01.getCheckoutCountingFinallyDisabled == false)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Darts on double:',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: DIALOG_CONTENT_FONTSIZE.sp,
                      ),
                    ),
                  ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (gameSettingsX01.getEnableCheckoutCounting &&
                        gameSettingsX01.getCheckoutCountingFinallyDisabled ==
                            false) ...[
                      if (!gameX01.finishedLegSetOrGame(
                          gameSettingsX01.getInputMethod ==
                                  InputMethod.ThreeDarts
                              ? threeDartsCalculated
                              : currentPointsSelected))
                        // button 0 for checkout darts
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(
                                top: 0.5.h,
                                bottom: 0.5.h,
                                left: 1.w,
                                right: 1.w),
                            child: ElevatedButton(
                              onPressed: () {
                                Utils.handleVibrationFeedback(context);
                                setState(() => selectedCheckoutCount = 0);
                              },
                              child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Text(
                                  '0',
                                  style: TextStyle(
                                    color: selectedCheckoutCount == 0
                                        ? Theme.of(context)
                                            .colorScheme
                                            .secondary
                                        : Colors.white,
                                    fontSize: DIALOG_CONTENT_FONTSIZE.sp,
                                  ),
                                ),
                              ),
                              style: ButtonStyle(
                                splashFactory: NoSplash.splashFactory,
                                shadowColor: MaterialStateProperty.all(
                                    Colors.transparent),
                                overlayColor: MaterialStateProperty.all(
                                    Colors.transparent),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    side: BorderSide(
                                      color:
                                          Utils.getPrimaryColorDarken(context),
                                      width: borderWidth,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10.0),
                                    ),
                                  ),
                                ),
                                backgroundColor: selectedCheckoutCount == 0
                                    ? Utils.getPrimaryMaterialStateColorDarken(
                                        context)
                                    : Utils.getColor(
                                        Theme.of(context).colorScheme.primary),
                              ),
                            ),
                          ),
                        ),
                      // button 1 for checkout darts
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(
                              top: 0.5.h, bottom: 0.5.h, left: 1.w, right: 1.w),
                          child: ElevatedButton(
                            onPressed: () {
                              Utils.handleVibrationFeedback(context);
                              setState(() => selectedCheckoutCount = 1);
                            },
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text(
                                '1',
                                style: TextStyle(
                                  color: selectedCheckoutCount == 1
                                      ? Theme.of(context).colorScheme.secondary
                                      : Colors.white,
                                  fontSize: DIALOG_CONTENT_FONTSIZE.sp,
                                ),
                              ),
                            ),
                            style: ButtonStyle(
                              splashFactory: NoSplash.splashFactory,
                              shadowColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              overlayColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: Utils.getPrimaryColorDarken(context),
                                    width: borderWidth,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                ),
                              ),
                              backgroundColor: selectedCheckoutCount == 1
                                  ? Utils.getPrimaryMaterialStateColorDarken(
                                      context)
                                  : Utils.getColor(
                                      Theme.of(context).colorScheme.primary),
                            ),
                          ),
                        ),
                      ),
                      if (checkoutPossibilities >= 2)
                        // button 2 for checkout darts
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(
                                top: 0.5.h,
                                bottom: 0.5.h,
                                left: 1.w,
                                right: 1.w),
                            child: ElevatedButton(
                              onPressed: () {
                                Utils.handleVibrationFeedback(context);
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
                                child: Text(
                                  '2',
                                  style: TextStyle(
                                    color: selectedCheckoutCount == 2
                                        ? Theme.of(context)
                                            .colorScheme
                                            .secondary
                                        : Colors.white,
                                    fontSize: DIALOG_CONTENT_FONTSIZE.sp,
                                  ),
                                ),
                              ),
                              style: ButtonStyle(
                                splashFactory: NoSplash.splashFactory,
                                shadowColor: MaterialStateProperty.all(
                                    Colors.transparent),
                                overlayColor: MaterialStateProperty.all(
                                    Colors.transparent),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    side: BorderSide(
                                      color:
                                          Utils.getPrimaryColorDarken(context),
                                      width: borderWidth,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10.0),
                                    ),
                                  ),
                                ),
                                backgroundColor: selectedCheckoutCount == 2
                                    ? Utils.getPrimaryMaterialStateColorDarken(
                                        context)
                                    : Utils.getColor(
                                        Theme.of(context).colorScheme.primary),
                              ),
                            ),
                          ),
                        ),
                      if (checkoutPossibilities == 3)
                        // button 3 for checkout darts
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(
                                top: 0.5.h,
                                bottom: 0.5.h,
                                left: 1.w,
                                right: 1.w),
                            child: ElevatedButton(
                              onPressed: () {
                                Utils.handleVibrationFeedback(context);
                                setState(() => selectedCheckoutCount = 3);
                                if (selectedFinishCount < 3) {
                                  selectedFinishCount = 3;
                                }
                              },
                              child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Text(
                                  '3',
                                  style: TextStyle(
                                    color: selectedCheckoutCount == 3
                                        ? Theme.of(context)
                                            .colorScheme
                                            .secondary
                                        : Colors.white,
                                    fontSize: DIALOG_CONTENT_FONTSIZE.sp,
                                  ),
                                ),
                              ),
                              style: ButtonStyle(
                                splashFactory: NoSplash.splashFactory,
                                shadowColor: MaterialStateProperty.all(
                                    Colors.transparent),
                                overlayColor: MaterialStateProperty.all(
                                    Colors.transparent),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    side: BorderSide(
                                      color:
                                          Utils.getPrimaryColorDarken(context),
                                      width: borderWidth,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10.0),
                                    ),
                                  ),
                                ),
                                backgroundColor: selectedCheckoutCount == 3
                                    ? Utils.getPrimaryMaterialStateColorDarken(
                                        context)
                                    : Utils.getColor(
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
                    child: Text(
                      'Darts for finish:',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: DIALOG_CONTENT_FONTSIZE.sp,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      if (_shouldDisplayOneFinishDartBtn(
                          currentPointsSelected, gameSettingsX01, gameX01))
                        // button 1 for finish darts
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(
                                top: 0.5.h,
                                bottom: 0.5.h,
                                left: 1.w,
                                right: 1.w),
                            child: ElevatedButton(
                              onPressed: () {
                                Utils.handleVibrationFeedback(context);
                                if (selectedCheckoutCount <= 1)
                                  setState(() => selectedFinishCount = 1);
                              },
                              child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Text(
                                  '1',
                                  style: TextStyle(
                                    color: selectedFinishCount == 1
                                        ? Theme.of(context)
                                            .colorScheme
                                            .secondary
                                        : Colors.white,
                                    fontSize: DIALOG_CONTENT_FONTSIZE.sp,
                                  ),
                                ),
                              ),
                              style: ButtonStyle(
                                splashFactory: NoSplash.splashFactory,
                                shadowColor: MaterialStateProperty.all(
                                    Colors.transparent),
                                overlayColor: MaterialStateProperty.all(
                                    Colors.transparent),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    side: BorderSide(
                                      color:
                                          Utils.getPrimaryColorDarken(context),
                                      width: borderWidth,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10.0),
                                    ),
                                  ),
                                ),
                                backgroundColor: selectedCheckoutCount > 1
                                    ? MaterialStateProperty.all(
                                        Utils.darken(Colors.grey, 25))
                                    : selectedFinishCount == 1
                                        ? Utils
                                            .getPrimaryMaterialStateColorDarken(
                                                context)
                                        : Utils.getColor(Theme.of(context)
                                            .colorScheme
                                            .primary),
                              ),
                            ),
                          ),
                        ),
                      // button 2 for finish darts
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(
                              top: 0.5.h, bottom: 0.5.h, left: 1.w, right: 1.w),
                          child: ElevatedButton(
                            onPressed: () {
                              Utils.handleVibrationFeedback(context);
                              if (selectedCheckoutCount < 2 ||
                                  selectedCheckoutCount == 2 && isDoubleField) {
                                setState(() => selectedFinishCount = 2);
                              }
                            },
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text(
                                '2',
                                style: TextStyle(
                                  color: selectedFinishCount == 2
                                      ? Theme.of(context).colorScheme.secondary
                                      : Colors.white,
                                  fontSize: DIALOG_CONTENT_FONTSIZE.sp,
                                ),
                              ),
                            ),
                            style: ButtonStyle(
                              splashFactory: NoSplash.splashFactory,
                              shadowColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              overlayColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: Utils.getPrimaryColorDarken(context),
                                    width: borderWidth,
                                  ),
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
                                      ? Utils
                                          .getPrimaryMaterialStateColorDarken(
                                              context)
                                      : Utils.getColor(Theme.of(context)
                                          .colorScheme
                                          .primary),
                            ),
                          ),
                        ),
                      ),
                      // button 3 for finish darts
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(
                              top: 0.5.h, bottom: 0.5.h, left: 1.w, right: 1.w),
                          child: ElevatedButton(
                            onPressed: () {
                              Utils.handleVibrationFeedback(context);
                              setState(() => selectedFinishCount = 3);
                            },
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Text(
                                '3',
                                style: TextStyle(
                                  color: selectedFinishCount == 3
                                      ? Theme.of(context).colorScheme.secondary
                                      : Colors.white,
                                  fontSize: DIALOG_CONTENT_FONTSIZE.sp,
                                ),
                              ),
                            ),
                            style: ButtonStyle(
                              splashFactory: NoSplash.splashFactory,
                              shadowColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              overlayColor:
                                  MaterialStateProperty.all(Colors.transparent),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: Utils.getPrimaryColorDarken(context),
                                    width: borderWidth,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                ),
                              ),
                              backgroundColor: selectedFinishCount == 3
                                  ? Utils.getPrimaryMaterialStateColorDarken(
                                      context)
                                  : Utils.getColor(
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
      ),
      actions: [
        TextButton(
          onPressed: () {
            Utils.handleVibrationFeedback(context);
            Navigator.of(context).pop();
            if (gameSettingsX01.getInputMethod == InputMethod.ThreeDarts) {
              final int amount = gameX01.getAmountOfDartsThrown();

              gameX01.getCurrentThreeDarts[amount - 1] =
                  'Dart ${amount.toString()}';
              RevertX01Helper.revertSomeStats(
                  context, int.parse(currentPointsSelected));
            } else {
              gameX01.setCurrentPointsSelected = 'Points';
            }

            gameX01.notify();
          },
          child: Text(
            'Cancel',
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: DIALOG_BTN_FONTSIZE.sp,
            ),
          ),
          style: ButtonStyle(
            splashFactory: NoSplash.splashFactory,
            shadowColor: MaterialStateProperty.all(Colors.transparent),
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            backgroundColor: Utils.getPrimaryMaterialStateColorDarken(context),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(DIALOG_BTN_SHAPE_ROUNDING),
              ),
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            Utils.handleVibrationFeedback(context);
            if (!gameSettingsX01.getAutomaticallySubmitPoints &&
                gameSettingsX01.getInputMethod == InputMethod.ThreeDarts) {
              g_checkoutCount = selectedCheckoutCount;
              g_thrownDarts = selectedFinishCount;
            } else {
              SubmitX01Helper.submitPoints(
                  currentPointsSelected,
                  context,
                  false,
                  selectedFinishCount,
                  selectedCheckoutCount); //submit is called because of the checkout dialog -> otherwise points would be immediately subtracted and shown on ui
            }

            Navigator.of(context).pop();
          },
          child: Text(
            'Submit',
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: DIALOG_BTN_FONTSIZE.sp,
            ),
          ),
          style: ButtonStyle(
            splashFactory: NoSplash.splashFactory,
            shadowColor: MaterialStateProperty.all(Colors.transparent),
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            backgroundColor: Utils.getPrimaryMaterialStateColorDarken(context),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(DIALOG_BTN_SHAPE_ROUNDING),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

_shouldDisplayOneFinishDartBtn(String currentPointsSelected,
    GameSettingsX01_P gameSettingsX01, GameX01_P gameX01) {
  return (currentPointsSelected == '1' &&
          gameSettingsX01.getModeOut == ModeOutIn.Single) ||
      gameX01.isDoubleField(currentPointsSelected) ||
      (gameSettingsX01.getModeOut == ModeOutIn.Master &&
          gameX01.isTrippleField(int.parse(currentPointsSelected)));
}
