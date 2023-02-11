import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_score_training_p.dart';
import 'package:dart_app/models/games/game_score_training_p.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class SubmitPointsBtnScoreTraining extends StatelessWidget {
  const SubmitPointsBtnScoreTraining({Key? key}) : super(key: key);

  bool _shouldSubmitBtnBeEnabled(BuildContext context) {
    final GameScoreTraining_P gameScoreTraining_P =
        context.read<GameScoreTraining_P>();
    final GameSettingsScoreTraining_P gameSettingsScoreTraining_P =
        context.read<GameSettingsScoreTraining_P>();

    // for bug -> when saving an open game
    if (gameScoreTraining_P.getPlayerGameStatistics.isEmpty) {
      return false;
    }

    final bool round =
        gameSettingsScoreTraining_P.getInputMethod == InputMethod.Round &&
            gameScoreTraining_P.getCurrentPointsSelected.isNotEmpty &&
            gameScoreTraining_P.getCurrentPointsSelected != 'Points';
    final bool threeDarts =
        gameSettingsScoreTraining_P.getInputMethod == InputMethod.ThreeDarts &&
            (gameScoreTraining_P.getCurrentThreeDarts[2] != 'Dart 3');

    if (round || threeDarts) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final MaterialStateProperty<Color> _colorResult =
        _shouldSubmitBtnBeEnabled(context)
            ? MaterialStateProperty.all(Colors.green)
            : MaterialStateProperty.all(
                Utils.darken(Colors.green, 25),
              );

    return Container(
      width: 25.w,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Utils.getPrimaryColorDarken(context),
            width: 3,
          ),
          left: BorderSide(
            color: Utils.getPrimaryColorDarken(context),
            width: context.read<GameSettingsScoreTraining_P>().getInputMethod ==
                    InputMethod.Round
                ? 3
                : 0,
          ),
        ),
      ),
      child: ElevatedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            backgroundColor: _colorResult,
            shadowColor: MaterialStateProperty.all(Colors.transparent),
            overlayColor: _colorResult,
          ),
          child: Icon(
            Icons.arrow_forward,
            color: Utils.getTextColorDarken(context),
          ),
          onPressed: () {
            if (_shouldSubmitBtnBeEnabled(context)) {
              context.read<GameScoreTraining_P>().submitPoints(context);
            }
          }),
    );
  }
}
