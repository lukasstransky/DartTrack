import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_single_double_training_p.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:tuple/tuple.dart';

class TargetNumberSingleDoubleTraining extends StatelessWidget {
  const TargetNumberSingleDoubleTraining({Key? key}) : super(key: key);

  _showDialogForInfoAboutTargetNumber(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.primary,
        contentPadding: EdgeInsets.only(
            bottom: DIALOG_CONTENT_PADDING_BOTTOM,
            top: DIALOG_CONTENT_PADDING_TOP,
            left: DIALOG_CONTENT_PADDING_LEFT,
            right: DIALOG_CONTENT_PADDING_RIGHT),
        title: Text(
          'Target Number explained',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        content: Text(
          'If this option is enabled, only darts on the selected target number are valid. For example, if the target number is 20, only darts on the 20 field will be added to the total score.',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Continue',
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
    );
  }

  _showDialogForEnteringTargetNumber(BuildContext context) {
    final settings = context.read<GameSettingsSingleDoubleTraining_P>();

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => Form(
        key: settings.getFormKeyTargetNumber,
        child: AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.primary,
          contentPadding: EdgeInsets.only(
            bottom: DIALOG_CONTENT_PADDING_BOTTOM,
            top: DIALOG_CONTENT_PADDING_TOP,
            left: DIALOG_CONTENT_PADDING_LEFT,
            right: DIALOG_CONTENT_PADDING_RIGHT,
          ),
          title: Text(
            'Enter Target Number',
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
              controller: settings.getTargetNumberController,
              validator: (value) {
                if (value!.isEmpty) {
                  return ('Please enter a value!');
                } else if (int.parse(value) < 1 || int.parse(value) > 20) {
                  return 'Valid values: 1-20';
                }

                return null;
              },
              autofocus: true,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(
                  TARGET_NUMBER_MAX_NUMBERS,
                ),
              ],
              style: TextStyle(
                color: Colors.white,
              ),
              decoration: InputDecoration(
                hintText: 'Enter a value',
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
              onPressed: () => {
                settings.resetTargetNumberToDefault(),
                settings.notify(),
                Navigator.of(context).pop(),
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
              onPressed: () => _submitTargetNumber(context),
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

  _submitTargetNumber(BuildContext context) {
    final settings = context.read<GameSettingsSingleDoubleTraining_P>();

    if (!settings.getFormKeyTargetNumber.currentState!.validate()) {
      return;
    }
    settings.getFormKeyTargetNumber.currentState!.save();

    settings.setTargetNumber =
        int.parse(settings.getTargetNumberController.text);
    settings.notify();
    settings.setIsTargetNumberEnabled = !settings.getIsTargetNumberEnabled;

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.read<GameSettingsSingleDoubleTraining_P>();

    return Container(
      width: 90.w,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 8.w,
                transform: Matrix4.translationValues(-10.0, 0.0, 0.0),
                child: IconButton(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onPressed: () => _showDialogForInfoAboutTargetNumber(context),
                  icon: Icon(
                    Icons.info_outline,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
              Text(
                'Enable Target Number',
                style: TextStyle(
                  color: Utils.getTextColorForGameSettingsPage(),
                ),
              ),
              Selector<GameSettingsSingleDoubleTraining_P, bool>(
                selector: (_, settings) => settings.getIsTargetNumberEnabled,
                builder: (_, isTargetNumberEnabled, __) => Switch(
                  thumbColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.secondary),
                  activeColor: Theme.of(context).colorScheme.secondary,
                  inactiveThumbColor: Theme.of(context).colorScheme.secondary,
                  value: isTargetNumberEnabled,
                  onChanged: (value) {
                    if (value) {
                      _showDialogForEnteringTargetNumber(context);
                    } else {
                      settings.resetTargetNumberToDefault();
                      settings.notify();
                    }
                  },
                ),
              ),
            ],
          ),
          Selector<GameSettingsSingleDoubleTraining_P, Tuple2<bool, int>>(
            selector: (_, settings) => Tuple2(
                settings.getIsTargetNumberEnabled, settings.getTargetNumber),
            builder: (_, tuple, __) => tuple.item1
                ? Row(
                    children: [
                      Text(
                        '(Selected Target Number: ',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 10.sp,
                        ),
                      ),
                      Text(
                        '${tuple.item2.toString()})',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 10.sp,
                        ),
                      ),
                    ],
                  )
                : SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
