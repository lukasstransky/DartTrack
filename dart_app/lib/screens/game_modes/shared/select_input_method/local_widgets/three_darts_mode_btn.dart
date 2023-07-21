import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_score_training_p.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class ThreeDartsBtn extends StatelessWidget {
  const ThreeDartsBtn({Key? key, required this.mode}) : super(key: key);

  final GameMode mode;

  _threeDartsBtnClicked(BuildContext context, GameMode mode) {
    if (mode == GameMode.X01) {
      final gameSettingsX01_P = context.read<GameSettingsX01_P>();

      gameSettingsX01_P.setInputMethod = InputMethod.ThreeDarts;
      gameSettingsX01_P.notify();
      context.read<GameX01_P>().setCurrentPointsSelected = 'Points';
    } else if (mode == GameMode.ScoreTraining) {
      final gameSettingsScoreTraining_P =
          context.read<GameSettingsScoreTraining_P>();

      gameSettingsScoreTraining_P.setInputMethod = InputMethod.ThreeDarts;
      gameSettingsScoreTraining_P.notify();
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isThreeDartsSelected = false;
    if (mode == GameMode.X01) {
      isThreeDartsSelected = context.read<GameSettingsX01_P>().getInputMethod ==
              InputMethod.ThreeDarts
          ? true
          : false;
    } else if (mode == GameMode.ScoreTraining) {
      isThreeDartsSelected =
          context.read<GameSettingsScoreTraining_P>().getInputMethod ==
                  InputMethod.ThreeDarts
              ? true
              : false;
    }

    return Container(
      width: 50.w - 0.125.w,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Utils.getPrimaryColorDarken(context),
            width: GENERAL_BORDER_WIDTH.w,
          ),
        ),
      ),
      child: ElevatedButton(
        child: Text(
          '3-Darts',
          style: TextStyle(
            fontSize: 14.sp,
            color: isThreeDartsSelected
                ? Theme.of(context).colorScheme.secondary
                : Utils.getTextColorDarken(context),
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () {
          Utils.handleVibrationFeedback(context);
          _threeDartsBtnClicked(context, mode);
        },
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
          backgroundColor: isThreeDartsSelected
              ? MaterialStateProperty.all(
                  Utils.darken(Theme.of(context).colorScheme.primary, 25))
              : MaterialStateProperty.all(
                  Theme.of(context).colorScheme.primary),
          overlayColor: isThreeDartsSelected
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
