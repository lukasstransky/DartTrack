import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_score_training_p.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/screens/game_modes/shared/settings_btn.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class ModeScoreTraining extends StatelessWidget {
  const ModeScoreTraining({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<GameSettingsScoreTraining_P, SelectorModel>(
      selector: (_, gameSettingsScoreTraining_P) => SelectorModel(
        mode: gameSettingsScoreTraining_P.getMode,
        players: gameSettingsScoreTraining_P.getPlayers,
      ),
      builder: (_, selectorModel, __) => Padding(
        padding: EdgeInsets.only(
          top: selectorModel.players.length ==
                  MAX_PLAYERS_SINGLE_DOUBLE_SCORE_TRAINING
              ? 1.h
              : 0,
        ),
        child: Center(
          child: Container(
            width: WIDTH_GAMESETTINGS.w,
            height: WIDGET_HEIGHT_GAMESETTINGS.h,
            child: Row(
              children: [
                SettingsBtn(
                  condition:
                      selectorModel.mode == ScoreTrainingModeEnum.MaxRounds,
                  text: 'max. Rounds',
                  isLeftBtn: true,
                  onPressed:
                      context.read<GameSettingsScoreTraining_P>().switchMode,
                ),
                SettingsBtn(
                  condition:
                      selectorModel.mode == ScoreTrainingModeEnum.MaxPoints,
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

class SelectorModel {
  final ScoreTrainingModeEnum mode;
  final List<Player> players;

  SelectorModel({
    required this.mode,
    required this.players,
  });
}
