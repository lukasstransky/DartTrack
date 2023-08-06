import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_score_training_p.dart';
import 'package:dart_app/utils/globals.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class RoundsOrPointsInputScoreTraining extends StatefulWidget {
  const RoundsOrPointsInputScoreTraining({Key? key}) : super(key: key);

  @override
  State<RoundsOrPointsInputScoreTraining> createState() =>
      _RoundsOrPointsInputScoreTrainingState();
}

class _RoundsOrPointsInputScoreTrainingState
    extends State<RoundsOrPointsInputScoreTraining> {
  @override
  void initState() {
    super.initState();
    newTextControllerMaxRoundsOrPointsGameSettingsSct(
        DEFAULT_ROUNDS_SCORE_TRAINING.toString());
  }

  _showDialogForRoundsOrPoints(BuildContext context) {
    final gameSettingsScoreTraining_P =
        context.read<GameSettingsScoreTraining_P>();
    final bool isMaxRoundsMode =
        gameSettingsScoreTraining_P.getMode == ScoreTrainingModeEnum.MaxRounds
            ? true
            : false;
    final String backupString = maxRoundsOrPointsTextController
        .text; // in case of changing input and canceling

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => Form(
        key: gameSettingsScoreTraining_P.getFormKeyMaxRoundsOrPoints,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DIALOG_SHAPE_ROUNDING),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          contentPadding: dialogContentPadding,
          title: Text(
            isMaxRoundsMode ? 'Enter rounds' : 'Enter points',
            style: TextStyle(
              color: Colors.white,
              fontSize: DIALOG_TITLE_FONTSIZE.sp,
            ),
          ),
          content: Container(
            width: DIALOG_WIDTH.w,
            margin: EdgeInsets.only(
              left: isMaxRoundsMode ? 10.w : 7.w,
              right: isMaxRoundsMode ? 10.w : 7.w,
            ),
            child: TextFormField(
              textAlign: TextAlign.center,
              controller: maxRoundsOrPointsTextController,
              validator: (value) {
                if (value!.isEmpty) {
                  return ('Please enter a value!');
                } else if (int.parse(value) <
                        (isMaxRoundsMode
                            ? MIN_ROUNDS_SCORE_TRAINING
                            : MIN_POINTS_SCORE_TRAINING) ||
                    int.parse(value) >
                        (isMaxRoundsMode
                            ? MAX_ROUNDS_SCORE_TRAINING
                            : MAX_POINTS_SCORE_TRAINING)) {
                  return (isMaxRoundsMode
                      ? 'Valid values: ${MIN_ROUNDS_SCORE_TRAINING}-${MAX_ROUNDS_SCORE_TRAINING}'
                      : 'Valid values: ${MIN_POINTS_SCORE_TRAINING}-${MAX_POINTS_SCORE_TRAINING}');
                }
                return null;
              },
              autofocus: true,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(
                  isMaxRoundsMode
                      ? MAX_ROUNDS_SCORE_TRAINING_NUMBERS
                      : MAX_POINTS_SCORE_TRAINING_NUMBERS,
                ),
              ],
              style: TextStyle(
                color: Colors.white,
                fontSize: DIALOG_CONTENT_FONTSIZE.sp,
              ),
              decoration: InputDecoration(
                hintText:
                    '${isMaxRoundsMode ? '${MIN_ROUNDS_SCORE_TRAINING}-${MAX_ROUNDS_SCORE_TRAINING}' : '${MIN_POINTS_SCORE_TRAINING}-${MAX_POINTS_SCORE_TRAINING}'}',
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
                  maxRoundsOrPointsTextController.text = backupString;
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
                _submitNewRoundsOrPoints(context);
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

  _submitNewRoundsOrPoints(BuildContext context) {
    final gameSettingsScoreTraining_P =
        context.read<GameSettingsScoreTraining_P>();

    if (!gameSettingsScoreTraining_P.getFormKeyMaxRoundsOrPoints.currentState!
        .validate()) {
      return;
    }
    gameSettingsScoreTraining_P.getFormKeyMaxRoundsOrPoints.currentState!
        .save();

    gameSettingsScoreTraining_P.setMaxRoundsOrPoints =
        int.parse(maxRoundsOrPointsTextController.text);
    gameSettingsScoreTraining_P.notify();

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Selector<GameSettingsScoreTraining_P, SelectorModel>(
            selector: (_, gameSettings) => SelectorModel(
              maxRoundsOrPoints: gameSettings.getMaxRoundsOrPoints,
              mode: gameSettings.getMode,
            ),
            builder: (_, selectorModel, __) => Container(
              width: 20.w,
              child: ElevatedButton(
                onPressed: () {
                  Utils.handleVibrationFeedback(context);
                  _showDialogForRoundsOrPoints(context);
                },
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    selectorModel.maxRoundsOrPoints.toString(),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize: DEFAULT_FONT_SIZE.sp,
                    ),
                  ),
                ),
                style: ButtonStyle(
                  splashFactory: NoSplash.splashFactory,
                  shadowColor: MaterialStateProperty.all(Colors.transparent),
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
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
          Selector<GameSettingsScoreTraining_P, ScoreTrainingModeEnum>(
            selector: (_, gameSettingsScoreTraining_P) =>
                gameSettingsScoreTraining_P.getMode,
            builder: (_, scoreTrainingModeEnum, __) => Container(
              width: 35.w,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  scoreTrainingModeEnum == ScoreTrainingModeEnum.MaxRounds
                      ? ' rounds are played.'
                      : ' points are reached.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: DEFAULT_FONT_SIZE.sp,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SelectorModel {
  final int maxRoundsOrPoints;
  final ScoreTrainingModeEnum mode;

  SelectorModel({
    required this.maxRoundsOrPoints,
    required this.mode,
  });
}
