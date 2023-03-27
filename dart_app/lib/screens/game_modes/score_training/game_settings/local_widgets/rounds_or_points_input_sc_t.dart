import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_score_training_p.dart';
import 'package:dart_app/utils/globals.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:tuple/tuple.dart';

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
          backgroundColor: Theme.of(context).colorScheme.primary,
          contentPadding: dialogContentPadding,
          title: Text(
            isMaxRoundsMode ? 'Enter max. rounds' : 'Enter max. points',
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
              controller: maxRoundsOrPointsTextController,
              validator: (value) {
                if (value!.isEmpty) {
                  return ('Please enter a value!');
                } else if (int.parse(value) <
                    (isMaxRoundsMode
                        ? MIN_ROUNDS_SCORE_TRAINING
                        : MIN_POINTS_SCORE_TRAINING)) {
                  return (isMaxRoundsMode
                      ? 'Minimum rounds: ${MIN_ROUNDS_SCORE_TRAINING}'
                      : 'Minimum points: ${MIN_POINTS_SCORE_TRAINING}');
                } else if (int.parse(value) >
                    (isMaxRoundsMode
                        ? MAX_ROUNDS_SCORE_TRAINING
                        : MAX_POINTS_SCORE_TRAINING)) {
                  return (isMaxRoundsMode
                      ? 'Maximum rounds: ${MAX_ROUNDS_SCORE_TRAINING}'
                      : 'Maximum points: ${MAX_POINTS_SCORE_TRAINING}');
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
              ),
              decoration: InputDecoration(
                hintText:
                    'max. ${isMaxRoundsMode ? MAX_ROUNDS_SCORE_TRAINING : MAX_POINTS_SCORE_TRAINING}',
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
                Navigator.of(context).pop();
                Future.delayed(Duration(milliseconds: 300), () {
                  maxRoundsOrPointsTextController.text = backupString;
                });
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
              onPressed: () => _submitNewRoundsOrPoints(context),
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
                ),
              ),
            ),
          ),
          Selector<GameSettingsScoreTraining_P,
              Tuple2<int, ScoreTrainingModeEnum>>(
            selector: (_, gameSettingsScoreTraining_P) => Tuple2(
                gameSettingsScoreTraining_P.getMaxRoundsOrPoints,
                gameSettingsScoreTraining_P.getMode),
            builder: (_, tuple, __) => Container(
              width: 20.w,
              child: ElevatedButton(
                onPressed: () => _showDialogForRoundsOrPoints(context),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    tuple.item1.toString(),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
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
