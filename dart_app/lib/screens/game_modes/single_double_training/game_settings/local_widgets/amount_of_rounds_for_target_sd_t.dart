import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_single_double_training_p.dart';
import 'package:dart_app/utils/button_styles.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class AmountOfRoundsForTargetNumberSingleDoubleTraining
    extends StatelessWidget {
  const AmountOfRoundsForTargetNumberSingleDoubleTraining({Key? key})
      : super(key: key);

  _showDialogForRoundsOrPoints(BuildContext context) async {
    final settings = context.read<GameSettingsSingleDoubleTraining_P>();

    Utils.forcePortraitMode(context);

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
          contentPadding:
              Utils.isMobile(context) ? DIALOG_CONTENT_PADDING_MOBILE : null,
          title: Text(
            'Enter rounds',
            style: TextStyle(
              color: Colors.white,
              fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
            ),
          ),
          content: Container(
            width: DIALOG_SMALL_WIDTH.w,
            margin: EdgeInsets.only(
              left: 5.w,
              right: 5.w,
            ),
            child: AmountOfRoundsTextFormField(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Utils.handleVibrationFeedback(context);
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                ),
              ),
              style: ButtonStyles.darkPrimaryColorBtnStyle(context).copyWith(
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
                  fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                ),
              ),
              style: ButtonStyles.darkPrimaryColorBtnStyle(context).copyWith(
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

    await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
  }

  _submitNewRoundsOrPoints(
      BuildContext context, GameSettingsSingleDoubleTraining_P settings) {
    if (!settings.getFormKeyAmountOfRounds.currentState!.validate()) {
      return;
    }
    settings.getFormKeyAmountOfRounds.currentState!.save();

    settings.setAmountOfRounds =
        int.parse(settings.getAmountOfRoundsControllerValue);
    settings.notify();

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Selector<GameSettingsSingleDoubleTraining_P, bool>(
      selector: (_, setttings) => setttings.getIsTargetNumberEnabled,
      builder: (_, isTargetNumberEnabled, __) => isTargetNumberEnabled
          ? Container(
              margin: EdgeInsets.only(top: 2.h),
              width: WIDTH_GAMESETTINGS.w,
              child: Row(
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Game will end after ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize:
                            Theme.of(context).textTheme.bodyMedium!.fontSize,
                      ),
                    ),
                  ),
                  Selector<GameSettingsSingleDoubleTraining_P, int>(
                    selector: (_, settings) => settings.getAmountOfRounds,
                    builder: (_, amountOfRounds, __) => Container(
                      padding: EdgeInsets.only(
                        left: 1.w,
                        right: 2.w,
                      ),
                      width: 20.w,
                      height: WIDGET_HEIGHT_GAMESETTINGS.h,
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
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .fontSize,
                            ),
                          ),
                        ),
                        style: ButtonStyles.darkPrimaryColorBtnStyle(context)
                            .copyWith(
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
                        ),
                      ),
                    ),
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'rounds.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize:
                            Theme.of(context).textTheme.bodyMedium!.fontSize,
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

class AmountOfRoundsTextFormField extends StatefulWidget {
  AmountOfRoundsTextFormField({Key? key}) : super(key: key);

  @override
  State<AmountOfRoundsTextFormField> createState() =>
      _AmountOfRoundsTextFormFieldState();
}

class _AmountOfRoundsTextFormFieldState
    extends State<AmountOfRoundsTextFormField> {
  late TextEditingController amountOfRoundsController;

  @override
  void initState() {
    super.initState();
    amountOfRoundsController = new TextEditingController();
  }

  @override
  void dispose() {
    amountOfRoundsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    amountOfRoundsController.addListener(() {
      context
          .read<GameSettingsSingleDoubleTraining_P>()
          .setAmountOfRoundsControllerValue = amountOfRoundsController.text;
    });

    return TextFormField(
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
        LengthLimitingTextInputFormatter(MAX_ROUNDS_SINGLE_TRAINING_NUMBERS),
      ],
      style: TextStyle(
        color: Colors.white,
        fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
      ),
      decoration: InputDecoration(
        errorStyle: TextStyle(fontSize: DIALOG_ERROR_MSG_FONTSIZE.sp),
        hintText: '${MIN_ROUNDS_SINGLE_TRAINING}-${MAX_ROUNDS_SINGLE_TRAINING}',
        fillColor: Utils.darken(Theme.of(context).colorScheme.primary, 10),
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
    );
  }
}
