import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_score_training_p.dart';
import 'package:dart_app/screens/game_modes/shared/settings_btn.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class ModeScoreTraining extends StatelessWidget {
  const ModeScoreTraining({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameSettingsScoreTraining_P =
        context.read<GameSettingsScoreTraining_P>();

    return Padding(
      padding: EdgeInsets.only(
        top: context.watch<GameSettingsScoreTraining_P>().getPlayers.length ==
                MAX_PLAYERS_SINGLE_DOUBLE_SCORE_TRAINING
            ? 1.h
            : 0,
      ),
      child: Center(
        child: Container(
          width: WIDTH_GAMESETTINGS.w,
          height: WIDGET_HEIGHT_GAMESETTINGS.h,
          child: Selector<GameSettingsScoreTraining_P, ScoreTrainingModeEnum>(
            selector: (_, gameSettingsScoreTraining_P) =>
                gameSettingsScoreTraining_P.getMode,
            builder: (_, scoreTrainingModeEnum, __) => Row(
              children: [
                SettingsBtn(
                  condition: gameSettingsScoreTraining_P.getMode ==
                      ScoreTrainingModeEnum.MaxRounds,
                  text: 'max. Rounds',
                  isLeftBtn: true,
                  onPressed:
                      context.read<GameSettingsScoreTraining_P>().switchMode,
                ),
                SettingsBtn(
                  condition: gameSettingsScoreTraining_P.getMode ==
                      ScoreTrainingModeEnum.MaxPoints,
                  text: 'max. Points',
                  isLeftBtn: false,
                  onPressed:
                      context.read<GameSettingsScoreTraining_P>().switchMode,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
