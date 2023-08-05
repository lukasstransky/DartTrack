import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_single_double_training_p.dart';
import 'package:dart_app/utils/globals.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class AmountOfRoundsForTargetNumberSingleDoubleTraining extends StatefulWidget {
  const AmountOfRoundsForTargetNumberSingleDoubleTraining({Key? key})
      : super(key: key);

  @override
  State<AmountOfRoundsForTargetNumberSingleDoubleTraining> createState() =>
      _AmountOfRoundsForTargetNumberSingleDoubleTrainingState();
}

class _AmountOfRoundsForTargetNumberSingleDoubleTrainingState
    extends State<AmountOfRoundsForTargetNumberSingleDoubleTraining> {
  @override
  void initState() {
    super.initState();
    newTextControllerAmountOfRoundsGameSettingsSdt();
  }

  _showDialogForRoundsOrPoints(BuildContext context) {
    final settings = context.read<GameSettingsSingleDoubleTraining_P>();
    final String backupString = amountOfRoundsController
        .text; // in case text was changed and cancel pressed

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => Form(
        key: settings.getFormKeyAmountOfRounds,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DIALOG_SHAPE_ROUNDING),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          contentPadding: dialogContentPadding,
          title: Text(
            'Enter rounds',
            style: TextStyle(
              color: Colors.white,
              fontSize: DIALOG_TITLE_FONTSIZE.sp,
            ),
          ),
          content: Container(
            margin: EdgeInsets.only(
              left: 10.w,
              right: 10.w,
            ),
            child: TextFormField(
              textAlign: TextAlign.center,
              controller: amountOfRoundsController,
              validator: (value) {
                if (value!.isEmpty) {
                  return ('Please enter a value!');
                } else if (int.parse(value) < MIN_ROUNDS_SINGLE_TRAINING ||
                    int.parse(value) > MAX_ROUNDS_SINGLE_TRAINING) {
                  return 'Valid values: ${MIN_ROUNDS_SCORE_TRAINING}-${MAX_ROUNDS_SINGLE_TRAINING}';
                }
                return null;
              },
              autofocus: true,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(
                    MAX_ROUNDS_SINGLE_TRAINING_NUMBERS),
              ],
              style: TextStyle(
                color: Colors.white,
                fontSize: DIALOG_CONTENT_FONTSIZE.sp,
              ),
              decoration: InputDecoration(
                hintText:
                    '${MIN_ROUNDS_SINGLE_TRAINING}-${MAX_ROUNDS_SINGLE_TRAINING}',
                fillColor:
                    Utils.darken(Theme.of(context).colorScheme.primary, 10),
                filled: true,
                hintStyle: TextStyle(
                  color: Utils.getPrimaryColorDarken(context),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Utils.handleVibrationFeedback(context);
                Navigator.of(context).pop();
                Future.delayed(Duration(milliseconds: 300), () {
                  amountOfRoundsController.text = backupString;
                });
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
                backgroundColor:
                    Utils.getPrimaryMaterialStateColorDarken(context),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(DIALOG_BTN_SHAPE_ROUNDING),
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Utils.handleVibrationFeedback(context);
                _submitNewRoundsOrPoints(context, settings);
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
                backgroundColor:
                    Utils.getPrimaryMaterialStateColorDarken(context),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(DIALOG_BTN_SHAPE_ROUNDING),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _submitNewRoundsOrPoints(
      BuildContext context, GameSettingsSingleDoubleTraining_P settings) {
    if (!settings.getFormKeyAmountOfRounds.currentState!.validate()) {
      return;
    }
    settings.getFormKeyAmountOfRounds.currentState!.save();

    settings.setAmountOfRounds = int.parse(amountOfRoundsController.text);
    settings.notify();

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Selector<GameSettingsSingleDoubleTraining_P, bool>(
      selector: (_, setttings) => setttings.getIsTargetNumberEnabled,
      builder: (_, isTargetNumberEnabled, __) => isTargetNumberEnabled
          ? Container(
              margin: EdgeInsets.only(top: 1.h),
              width: 90.w,
              child: Row(
                children: [
                  Container(
                    width: 35.w,
                    alignment: Alignment.centerLeft,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'Game will end after ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: DEFAULT_FONT_SIZE.sp,
                        ),
                      ),
                    ),
                  ),
                  Selector<GameSettingsSingleDoubleTraining_P, int>(
                    selector: (_, settings) => settings.getAmountOfRounds,
                    builder: (_, amountOfRounds, __) => Container(
                      width: 20.w,
                      child: ElevatedButton(
                        onPressed: () {
                          Utils.handleVibrationFeedback(context);
                          _showDialogForRoundsOrPoints(context);
                        },
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            amountOfRounds.toString(),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: DEFAULT_FONT_SIZE.sp,
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
                                width: GAME_SETTINGS_BTN_BORDER_WITH.w,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                          ),
                          backgroundColor:
                              Utils.getPrimaryMaterialStateColorDarken(context),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 35.w,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'rounds are played.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: DEFAULT_FONT_SIZE.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : SizedBox.shrink(),
    );
  }
}
