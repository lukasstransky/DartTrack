import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_cricket_p.dart';
import 'package:dart_app/models/game_settings/game_settings_score_training_p.dart';
import 'package:dart_app/models/games/game_cricket_p.dart';
import 'package:dart_app/models/games/game_score_training_p.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class SubmitBtn extends StatelessWidget {
  const SubmitBtn({
    Key? key,
    required this.mode,
    required this.safeAreaPadding,
  }) : super(key: key);

  final GameMode mode;
  final EdgeInsets safeAreaPadding;

  @override
  Widget build(BuildContext context) {
    final bool shouldSubmitBtnBeEnabled = _shouldSubmitBtnBeEnabled(context);
    final MaterialStateProperty<Color> _colorResult = shouldSubmitBtnBeEnabled
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
            width: GENERAL_BORDER_WIDTH.w,
          ),
          left: BorderSide(
            color: Utils.getPrimaryColorDarken(context),
            width: context.read<GameSettingsScoreTraining_P>().getInputMethod ==
                        InputMethod.Round ||
                    mode == GameMode.Cricket
                ? GENERAL_BORDER_WIDTH.w
                : 0,
          ),
          right: safeAreaPadding.right > 0
              ? BorderSide(
                  color: Utils.getPrimaryColorDarken(context),
                  width: GENERAL_BORDER_WIDTH.w,
                )
              : BorderSide.none,
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
          size: ICON_BUTTON_SIZE.h,
          Icons.arrow_forward,
          color: Utils.getTextColorDarken(context),
        ),
        onPressed: () {
          Utils.handleVibrationFeedback(context);
          _onPressed(shouldSubmitBtnBeEnabled, context);
        },
      ),
    );
  }

  _onPressed(bool shouldSubmitBtnBeEnabled, BuildContext context) {
    if (shouldSubmitBtnBeEnabled) {
      if (mode == GameMode.ScoreTraining) {
        context.read<GameScoreTraining_P>().submitPoints(context);
      } else if (mode == GameMode.Cricket) {
        final GameCricket_P gameCricket = context.read<GameCricket_P>();
        gameCricket.submit(context.read<GameSettingsCricket_P>(), context);
      }
    }
  }

  bool _shouldSubmitBtnBeEnabled(BuildContext context) {
    if (mode == GameMode.ScoreTraining) {
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
      final bool threeDarts = gameSettingsScoreTraining_P.getInputMethod ==
              InputMethod.ThreeDarts &&
          (gameScoreTraining_P.getCurrentThreeDarts[2] != 'Dart 3');

      if (round || threeDarts) {
        return true;
      }
    } else if (mode == GameMode.Cricket) {
      final GameCricket_P gameCricket = context.read<GameCricket_P>();

      // for bug -> when saving an open game
      if (gameCricket.getPlayerGameStatistics.isEmpty) {
        return false;
      }

      if (gameCricket.getCurrentThreeDarts[2] != 'Dart 3') {
        return true;
      }
    }

    return false;
  }
}
