import 'package:dart_app/models/bot.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/models/games/game_score_training_p.dart';
import 'package:dart_app/models/games/game_single_double_training_p.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/models/games/x01/helper/revert_x01_helper.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../../constants.dart';

class RevertBtn extends StatelessWidget {
  const RevertBtn({
    Key? key,
    required this.game_p,
  }) : super(key: key);

  final Game_P game_p;

  _revertBtnPressed(BuildContext context) {
    if (!game_p.getRevertPossible) {
      return;
    }

    if (game_p is GameX01_P) {
      if (context.read<GameSettingsX01_P>().getVibrationFeedbackEnabled) {
        HapticFeedback.lightImpact();
      }

      RevertX01Helper.revertPoints(context);

      if (game_p.getCurrentPlayerToThrow is Bot) {
        RevertX01Helper.revertPoints(context);
      }
    } else if (game_p is GameScoreTraining_P) {
      (game_p as GameScoreTraining_P).revert(context);
    } else if (game_p is GameSingleDoubleTraining_P) {
      (game_p as GameSingleDoubleTraining_P).revert(context, false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 25.w,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Utils.getPrimaryColorDarken(context),
            width: GENERAL_BORDER_WIDTH.w,
          ),
          right: BorderSide(
            color: Utils.getPrimaryColorDarken(context),
            width: GENERAL_BORDER_WIDTH.w,
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
          shadowColor: MaterialStateProperty.all(Colors.transparent),
          backgroundColor: game_p.getRevertPossible
              ? MaterialStateProperty.all(Colors.red)
              : MaterialStateProperty.all(Utils.darken(Colors.red, 25)),
          overlayColor: game_p.getRevertPossible
              ? MaterialStateProperty.all(Utils.darken(Colors.red, 25))
              : MaterialStateProperty.all(Colors.transparent),
        ),
        child: Icon(
          Icons.undo,
          color: Utils.getTextColorDarken(context),
        ),
        onPressed: () => _revertBtnPressed(context),
      ),
    );
  }
}
