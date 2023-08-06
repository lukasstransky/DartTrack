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
        contentPadding: dialogContentPadding,
        title: Text(
          'Target number explained',
          style: TextStyle(
            color: Colors.white,
            fontSize: DIALOG_TITLE_FONTSIZE.sp,
          ),
        ),
        content: Text(
          'If this option is enabled, only darts on the selected target number are counted. \nFor example, when the target number is ${gameModePrefix}20, only hits on the ${gameModePrefix}20 field will be added to the total score.',
          style: TextStyle(
            color: Colors.white,
            fontSize: DIALOG_CONTENT_FONTSIZE.sp,
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
          contentPadding: dialogContentPadding,
          title: Text(
            'Enter target number',
            style: TextStyle(
              color: Colors.white,
              fontSize: DIALOG_TITLE_FONTSIZE.sp,
            ),
          ),
          content: Container(
            width: DIALOG_WIDTH.w,
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
                fontSize: DIALOG_CONTENT_FONTSIZE.sp,
              ),
              decoration: InputDecoration(
                hintText: '1-20',
                fillColor:
                    Utils.darken(Theme.of(context).colorScheme.primary, 10),
                filled: true,
                hintStyle: TextStyle(
                  fontSize: 12.sp,
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
                _submitTargetNumber(context);
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

    late double scaleFactorSwitch;
    if (ResponsiveBreakpoints.of(context).isMobile) {
      scaleFactorSwitch = SWTICH_SCALE_FACTOR_MOBILE;
    } else if (ResponsiveBreakpoints.of(context).isTablet ||
        ResponsiveBreakpoints.of(context).isDesktop) {
      scaleFactorSwitch = SWTICH_SCALE_FACTOR_TABLET;
    } else {
      scaleFactorSwitch = SWTICH_SCALE_FACTOR_TABLET;
    }

    return Container(
      width: 90.w,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 8.w,
                transform: Matrix4.translationValues(-2.5.w, 0.0, 0.0),
                child: IconButton(
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
              ),
              Text(
                'Enable target number',
                style: TextStyle(
                  color: Utils.getTextColorForGameSettingsPage(),
                  fontSize: DEFAULT_FONT_SIZE.sp,
                ),
              ),
              Selector<GameSettingsSingleDoubleTraining_P, bool>(
                selector: (_, settings) => settings.getIsTargetNumberEnabled,
                builder: (_, isTargetNumberEnabled, __) => Transform.scale(
                  scale: scaleFactorSwitch,
                  child: Switch(
                    thumbColor: MaterialStateProperty.all(
                        Theme.of(context).colorScheme.secondary),
                    activeColor: Theme.of(context).colorScheme.secondary,
                    inactiveThumbColor: Theme.of(context).colorScheme.secondary,
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
