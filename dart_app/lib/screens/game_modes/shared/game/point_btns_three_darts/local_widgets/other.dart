import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_score_training_p.dart';
import 'package:dart_app/models/games/game_score_training_p.dart';
import 'package:dart_app/screens/game_modes/score_training/game/local_widgets/point_btns_round/local_widgets/submit_revert_btn_and_current_score/local_widgets/submit_points_btn_sc_t.dart';
import 'package:dart_app/screens/game_modes/shared/game/point_btns_three_darts/local_widgets/point_btn_three_darts.dart';
import 'package:dart_app/screens/game_modes/shared/game/revert_btn.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OtherBtns extends StatelessWidget {
  const OtherBtns({Key? key, required this.mode}) : super(key: key);

  final GameMode mode;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: RevertBtn(game_p: context.read<GameScoreTraining_P>()),
          ),
          Expanded(
            child: PointBtnThreeDarts(
              pointValue: '25',
              mode: mode,
            ),
          ),
          Expanded(
            child: PointBtnThreeDarts(
              pointValue: 'Bull',
              mode: mode,
            ),
          ),
          Expanded(
            child: PointBtnThreeDarts(
              pointValue: 'Bust',
              mode: mode,
            ),
          ),
          Expanded(
            child: PointBtnThreeDarts(
              pointValue: '0',
              mode: mode,
            ),
          ),
          if (!context
              .read<GameSettingsScoreTraining_P>()
              .getAutomaticallySubmitPoints)
            Expanded(
              child: SubmitPointsBtnScoreTraining(),
            ),
        ],
      ),
    );
  }
}
