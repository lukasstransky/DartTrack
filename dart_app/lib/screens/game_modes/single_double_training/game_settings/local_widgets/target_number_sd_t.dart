import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_single_double_training_p.dart';
import 'package:dart_app/utils/globals.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:sizer/sizer.dart';

class TargetNumberSingleDoubleTraining extends StatefulWidget {
  const TargetNumberSingleDoubleTraining({Key? key, required this.gameMode})
      : super(key: key);

  final GameMode gameMode;

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
    final String gameModePrefix =
        widget.gameMode == GameMode.DoubleTraining ? 'D' : '';

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DIALOG_SHAPE_ROUNDING),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        contentPadding: ResponsiveBreakpoints.of(context).isMobile
            ? DIALOG_CONTENT_PADDING_MOBILE
            : null,
        title: Text(
          'Target number explained',
          style: TextStyle(
            color: Colors.white,
            fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
          ),
        ),
        content: Text(
          'If this option is enabled, only darts on the selected target number are counted. \nFor example, when the target number is ${gameModePrefix}20, only hits on the ${gameModePrefix}20 field will be added to the total score.',
          style: TextStyle(
            color: Colors.white,
            fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Utils.handleVibrationFeedback(context);
              Navigator.of(context).pop();
            },
            child: Text(
              'Continue',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DIALOG_SHAPE_ROUNDING),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          contentPadding: ResponsiveBreakpoints.of(context).isMobile
              ? DIALOG_CONTENT_PADDING_MOBILE
              : null,
          title: Text(
            'Enter target number',
            style: TextStyle(
              color: Colors.white,
              fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
            ),
          ),
          content: Container(
            width: DIALOG_SMALL_WIDTH.w,
            margin: EdgeInsets.only(
              left: 10.w,
              right: 10.w,
            ),
            child: TextFormField(
              textAlign: TextAlign.center,
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
                fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
              ),
              decoration: InputDecoration(
                errorStyle: TextStyle(fontSize: DIALOG_ERROR_MSG_FONTSIZE.sp),
                hintText: '1-20',
                fillColor:
                    Utils.darken(Theme.of(context).colorScheme.primary, 10),
                filled: true,
                hintStyle: TextStyle(
                  fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
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
                  targetNumberTextController.text = backupString;
                });
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
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
                _submitTargetNumber(context);
              },
              child: Text(
                'Submit',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
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
    final GameSettingsSingleDoubleTraining_P settings =
        context.read<GameSettingsSingleDoubleTraining_P>();
    final double scaleFactorSwitch = Utils.getSwitchScaleFactor(context);
    final double textSwitchSpace = Utils.getResponsiveValue(
      context: context,
      mobileValue: 0,
      tabletValue: TEXT_SWITCH_SPACE_TABLET,
      otherValue: TEXT_SWITCH_SPACE_TABLET,
    );
    final double transformValue = Utils.getResponsiveValue(
      context: context,
      mobileValue: -2.5,
      tabletValue: -2.5,
      otherValue: -2.5,
    );
    final double selectedTargetNumberFontSize = Utils.getResponsiveValue(
      context: context,
      mobileValue: 10,
      tabletValue: 8,
      otherValue: 8,
    );

    return Container(
      width: WIDTH_GAMESETTINGS.w,
      child: Column(
        children: [
          Container(
            transform: Matrix4.translationValues(transformValue.w, 0.0, 0.0),
            child: Row(
              children: [
                IconButton(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onPressed: () {
                    Utils.handleVibrationFeedback(context);
                    _showDialogForInfoAboutTargetNumber(context);
                  },
                  icon: Icon(
                    size: ICON_BUTTON_SIZE.h,
                    Icons.info_outline,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                Text(
                  'Enable target number',
                  style: TextStyle(
                    color: Utils.getTextColorForGameSettingsPage(),
                    fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                  ),
                ),
                SizedBox(
                  width: textSwitchSpace.w,
                ),
                Selector<GameSettingsSingleDoubleTraining_P, bool>(
                  selector: (_, settings) => settings.getIsTargetNumberEnabled,
                  builder: (_, isTargetNumberEnabled, __) => Transform.scale(
                    scale: scaleFactorSwitch,
                    child: Switch(
                      thumbColor: MaterialStateProperty.all(
                          Theme.of(context).colorScheme.secondary),
                      value: isTargetNumberEnabled,
                      onChanged: (value) {
                        Utils.handleVibrationFeedback(context);
                        if (value) {
                          _showDialogForEnteringTargetNumber(context);
                        } else {
                          settings.resetTargetNumberToDefault();
                          settings.notify();
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),
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
                            '(Selected target number: ${widget.gameMode == GameMode.DoubleTraining ? 'D' : ''}',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: selectedTargetNumberFontSize.sp,
                            ),
                          ),
                          Text(
                            '${selectorModel.targetNumber.toString()})',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: selectedTargetNumberFontSize.sp,
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
