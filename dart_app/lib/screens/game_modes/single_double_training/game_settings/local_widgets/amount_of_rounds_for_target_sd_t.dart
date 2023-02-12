import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_single_double_training_p.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class AmountOfRoundsForTargetNumberSingleDoubleTraining
    extends StatelessWidget {
  const AmountOfRoundsForTargetNumberSingleDoubleTraining({Key? key})
      : super(key: key);

  _showDialogForRoundsOrPoints(BuildContext context) {
    final settings = context.read<GameSettingsSingleDoubleTraining_P>();

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => Form(
        key: settings.getFormKeyAmountOfRounds,
        child: AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.primary,
          contentPadding: EdgeInsets.only(
              bottom: DIALOG_CONTENT_PADDING_BOTTOM,
              top: DIALOG_CONTENT_PADDING_TOP,
              left: DIALOG_CONTENT_PADDING_LEFT,
              right: DIALOG_CONTENT_PADDING_RIGHT),
          title: Text(
            'Enter max. rounds',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          content: Container(
            margin: EdgeInsets.only(
              left: 10.w,
              right: 10.w,
            ),
            child: TextFormField(
              controller: settings.getAmountOfRoundsController,
              validator: (value) {
                if (value!.isEmpty) {
                  return ('Please enter a value!');
                } else if (int.parse(value) < MIN_ROUNDS_SINGLE_TRAINING ||
                    int.parse(value) > MAX_ROUNDS_SINGLE_TRAINING) {
                  return 'Valid values: ${MIN_ROUNDS_SCORE_TRAINING} - ${MAX_ROUNDS_SINGLE_TRAINING}';
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
              ),
              decoration: InputDecoration(
                hintText: 'max. ${MAX_ROUNDS_SINGLE_TRAINING}',
                fillColor:
                    Utils.darken(Theme.of(context).colorScheme.primary, 10),
                filled: true,
                hintStyle: TextStyle(
                  color: Utils.getPrimaryColorDarken(context),
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                settings.setAmountOfRoundsController =
                    new TextEditingController(
                        text: DEFUALT_ROUNDS_FOR_TARGET_NUMBER.toString());
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              style: ButtonStyle(
                backgroundColor:
                    Utils.getPrimaryMaterialStateColorDarken(context),
              ),
            ),
            TextButton(
              onPressed: () => _submitNewRoundsOrPoints(context, settings),
              child: Text(
                'Submit',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              style: ButtonStyle(
                backgroundColor:
                    Utils.getPrimaryMaterialStateColorDarken(context),
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

    settings.setAmountOfRounds =
        int.parse(settings.getAmountOfRoundsController.text);
    settings.notify();

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Selector<GameSettingsSingleDoubleTraining_P, bool>(
      selector: (_, setttings) => setttings.getIsTargetNumberEnabled,
      builder: (_, isTargetNumberEnabled, __) => isTargetNumberEnabled
          ? Container(
              margin: EdgeInsets.only(top: 10),
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
                        ),
                      ),
                    ),
                  ),
                  Selector<GameSettingsSingleDoubleTraining_P, int>(
                    selector: (_, settings) => settings.getAmountOfRounds,
                    builder: (_, amountOfRounds, __) => Container(
                      width: 20.w,
                      child: ElevatedButton(
                        onPressed: () => _showDialogForRoundsOrPoints(context),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            amountOfRounds.toString(),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
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
                                width: GAME_SETTINGS_BTN_BORDER_WITH,
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
