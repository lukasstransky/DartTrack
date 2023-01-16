import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/score_training/game_score_training_p.dart';
import 'package:dart_app/screens/game_modes/score_training/game_statistics/local_widgets/game_stats_score_training/local_widgets/highest_score_stats_sc_t.dart';
import 'package:dart_app/screens/game_modes/score_training/game_statistics/local_widgets/game_stats_score_training/local_widgets/score_stats_sc_t.dart';
import 'package:dart_app/screens/game_modes/score_training/game_statistics/local_widgets/game_stats_score_training/local_widgets/three_dart_avg_stats_sc_t.dart';
import 'package:dart_app/screens/game_modes/score_training/game_statistics/local_widgets/game_stats_score_training/local_widgets/thrown_darts_stats_sc_t.dart';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class GameStatsScoreTraining extends StatelessWidget {
  const GameStatsScoreTraining({
    Key? key,
    required this.gameScoreTraining_P,
  }) : super(key: key);

  final GameScoreTraining_P gameScoreTraining_P;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          transform: Matrix4.translationValues(-10.0, 0.0, 0.0),
          padding: EdgeInsets.only(top: 10),
          child: Text(
            'Game',
            style: TextStyle(
              fontSize: FONTSIZE_HEADING_STATISTICS.sp,
              color: Colors.white,
            ),
          ),
        ),
        ScoreStatsScoreTraining(gameScoreTraining_P: gameScoreTraining_P),
        ThreeDartsAvgStatsScoreTraining(
            gameScoreTraining_P: gameScoreTraining_P),
        ThrownDartsStatsScoreTraining(gameScoreTraining_P: gameScoreTraining_P),
        HighestScoreStatsScoreTraining(
            gameScoreTraining_P: gameScoreTraining_P),
      ],
    );
  }
}
