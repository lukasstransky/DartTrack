import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_single_double_training_p.dart';
import 'package:dart_app/utils/globals.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class TargetNumberSingleDoubleTraining extends StatefulWidget {
  const TargetNumberSingleDoubleTraining({Key? key}) : super(key: key);

  @override
  State<TargetNumberSingleDoubleTraining> createState() =>
      _TargetNumberSingleDoubleTrainingState();
}

class _TargetNumberSingleDoubleTrainingState
    extends State<TargetNumberSingleDoubleTraining> {
  @override
  void initState() {
    super.initState();
    newTextControllerTargetNumberGameSettingsSdt();
  }

  _showDialogForInfoAboutTargetNumber(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.primary,
        contentPadding: dialogContentPadding,
        title: Text(
          'Target number explained',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        content: Text(
          'If this option is enabled, only darts on the selected target number are counted. For example, if the target number is 20, only darts on the 20 field will be added to the total score.',
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
    final String backupString = targetNumberTextController
        .text; // in case text was changed and cancel pressed

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => Form(
        key: settings.getFormKeyTargetNumber,
        child: AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.primary,
          contentPadding: dialogContentPadding,
          title: Text(
            'Enter target number',
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
              controller: targetNumberTextController,
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
                Future.delayed(Duration(milliseconds: 300), () {
                  targetNumberTextController.text = backupString;
                });
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

    settings.setTargetNumber = int.parse(targetNumberTextController.text);
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
                'Enable target number',
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
          Selector<GameSettingsSingleDoubleTraining_P, SelectorModel>(
            selector: (_, gameSettingsSingleDoubleTraining) => SelectorModel(
              isTargetNumberEnabled:
                  gameSettingsSingleDoubleTraining.getIsTargetNumberEnabled,
              targetNumber: gameSettingsSingleDoubleTraining.getTargetNumber,
            ),
            builder: (_, selectorModel, __) =>
                selectorModel.isTargetNumberEnabled
                    ? Row(
                        children: [
                          Text(
                            '(Selected target number: ',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 10.sp,
                            ),
                          ),
                          Text(
                            '${selectorModel.targetNumber.toString()})',
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

class SelectorModel {
  final bool isTargetNumberEnabled;
  final int targetNumber;

  SelectorModel({
    required this.isTargetNumberEnabled,
    required this.targetNumber,
  });
}
