import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_score_training_p.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/screens/game_modes/shared/overall/settings_btn.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class ModeScoreTraining extends StatelessWidget {
  const ModeScoreTraining({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GameSettingsScoreTraining_P settings =
        context.read<GameSettingsScoreTraining_P>();

    return Selector<GameSettingsScoreTraining_P, SelectorModel>(
      selector: (_, gameSettingsScoreTraining_P) => SelectorModel(
        mode: gameSettingsScoreTraining_P.getMode,
        players: gameSettingsScoreTraining_P.getPlayers,
      ),
      builder: (_, selectorModel, __) => Container(
        padding: EdgeInsets.only(top: 1.h),
        child: Center(
          child: Container(
            width: WIDTH_GAMESETTINGS.w,
            height: WIDGET_HEIGHT_GAMESETTINGS.h,
            child: Row(
              children: [
                SettingsBtn(
                  condition:
                      selectorModel.mode == ScoreTrainingModeEnum.MaxRounds,
                  text: 'Rounds',
                  isLeftBtn: true,
                  onPressed: () {
                    Utils.handleVibrationFeedback(context);
                    settings.getMode == ScoreTrainingModeEnum.MaxRounds
                        ? () {}
                        : settings.switchMode();
                  },
                ),
                SettingsBtn(
                  condition:
                      selectorModel.mode == ScoreTrainingModeEnum.MaxPoints,
                  text: 'Points',
                  isLeftBtn: false,
                  onPressed: () {
                    Utils.handleVibrationFeedback(context);
                    settings.getMode == ScoreTrainingModeEnum.MaxPoints
                        ? () {}
                        : settings.switchMode();
                  },
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
