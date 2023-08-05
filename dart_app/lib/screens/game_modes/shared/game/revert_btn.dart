import 'package:dart_app/constants.dart';
import 'package:dart_app/models/bot.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/models/games/game_cricket_p.dart';
import 'package:dart_app/models/games/game_score_training_p.dart';
import 'package:dart_app/models/games/game_single_double_training_p.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/models/games/x01/helper/revert_x01_helper.dart';
import 'package:dart_app/models/settings_p.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class RevertBtn extends StatelessWidget {
  const RevertBtn({
    Key? key,
    required this.game_p,
  }) : super(key: key);

  final Game_P game_p;

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
        // selector for gameX01 in place because otherwise revert btn is still highlighted when reverting the last score
        child: Selector<GameX01_P, bool>(
          selector: (_, game) => game.getRevertPossible,
          builder: (_, revertPossible, __) => ElevatedButton(
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
              size: ICON_BUTTON_SIZE.h,
              color: Utils.getTextColorDarken(context),
            ),
            onPressed: () {
              Utils.handleVibrationFeedback(context);
              _revertBtnPressed(context);
            },
          ),
        ));
  }

  _revertBtnPressed(BuildContext context) {
    if (!game_p.getRevertPossible) {
      return;
    }

    if (game_p is GameX01_P) {
      final GameSettingsX01_P gameSettingsX01 =
          context.read<GameSettingsX01_P>();
      if (context.read<Settings_P>().getVibrationFeedbackEnabled) {
        HapticFeedback.lightImpact();
      }

      RevertX01Helper.revertPoints(game_p as GameX01_P, gameSettingsX01);
      if (game_p.getCurrentPlayerToThrow is Bot) {
        RevertX01Helper.revertPoints(game_p as GameX01_P, gameSettingsX01);
      }
    } else if (game_p is GameScoreTraining_P) {
      (game_p as GameScoreTraining_P).revert(context);
    } else if (game_p is GameSingleDoubleTraining_P) {
      (game_p as GameSingleDoubleTraining_P).revert(context, false);
    } else if (game_p is GameCricket_P) {
      (game_p as GameCricket_P).revert();
    }
  }
}
