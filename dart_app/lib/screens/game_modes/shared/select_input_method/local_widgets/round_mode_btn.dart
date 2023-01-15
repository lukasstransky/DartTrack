import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/score_training/game_settings_score_training_p.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/games/score_training/game_score_training_p.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class RoundBtn extends StatelessWidget {
  const RoundBtn({Key? key, required this.mode}) : super(key: key);

  final String mode;

  _roundBtnClicked(BuildContext context, String mode) {
    if (mode == 'X01') {
      if (_getAmountOfThrownDarts(context) != 0) {
        Fluttertoast.showToast(
            msg: 'In order to switch, please finish the round!',
            toastLength: Toast.LENGTH_LONG);
      } else {
        final gameSettingsX01_P = context.read<GameSettingsX01_P>();

        context.read<GameX01_P>().setCurrentPointsSelected = 'Points';
        gameSettingsX01_P.setInputMethod = InputMethod.Round;
        gameSettingsX01_P.notify();
      }
    } else if (mode == 'Score Training') {
      if (_getAmountOfThrownDarts(context) != 0) {
        Fluttertoast.showToast(
            msg: 'In order to switch, please finish the round!',
            toastLength: Toast.LENGTH_LONG);
      } else {
        final gameSettingsScoreTraining_P =
            context.read<GameSettingsScoreTraining_P>();

        context.read<GameScoreTraining_P>().setCurrentPointsSelected = 'Points';
        gameSettingsScoreTraining_P.setInputMethod = InputMethod.Round;
        gameSettingsScoreTraining_P.notify();
      }
    }
  }

  int _getAmountOfThrownDarts(BuildContext context) {
    if (mode == 'X01') {
      return context.read<GameX01_P>().getAmountOfDartsThrown();
    } else if (mode == 'Score Training') {
      return context.read<GameScoreTraining_P>().getAmountOfDartsThrown();
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    bool isRoundSelected = false;
    if (mode == 'X01') {
      isRoundSelected =
          context.read<GameSettingsX01_P>().getInputMethod == InputMethod.Round
              ? true
              : false;
    } else if (mode == 'Score Training') {
      isRoundSelected =
          context.read<GameSettingsScoreTraining_P>().getInputMethod ==
                  InputMethod.Round
              ? true
              : false;
    }

    return Container(
      width: 50.w - 0.5,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Utils.getPrimaryColorDarken(context),
            width: 3,
          ),
          right: BorderSide(
            color: Utils.getPrimaryColorDarken(context),
            width: 3,
          ),
        ),
      ),
      child: ElevatedButton(
        child: Text(
          'Round',
          style: TextStyle(
            fontSize: 14.sp,
            color: isRoundSelected
                ? Theme.of(context).colorScheme.secondary
                : Utils.getTextColorDarken(context),
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () => _roundBtnClicked(context, mode),
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.zero,
              ),
            ),
          ),
          splashFactory: NoSplash.splashFactory,
          shadowColor: MaterialStateProperty.all(Colors.transparent),
          backgroundColor: isRoundSelected
              ? MaterialStateProperty.all(
                  Utils.darken(Theme.of(context).colorScheme.primary, 25))
              : MaterialStateProperty.all(
                  Theme.of(context).colorScheme.primary),
          overlayColor: isRoundSelected || _getAmountOfThrownDarts(context) != 0
              ? MaterialStateProperty.all(Colors.transparent)
              : Utils.getColorOrPressed(
                  Theme.of(context).colorScheme.primary,
                  Utils.darken(Theme.of(context).colorScheme.primary, 25),
                ),
        ),
      ),
    );
  }
}
