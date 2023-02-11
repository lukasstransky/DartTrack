import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/game_score_training_p.dart';
import 'package:dart_app/screens/game_modes/score_training/game_statistics/local_widgets/game_stats_score_training/local_widgets/highest_score_stats_sc_t.dart';
import 'package:dart_app/screens/game_modes/score_training/game_statistics/local_widgets/game_stats_score_training/local_widgets/score_stats_sc_t.dart';
import 'package:dart_app/screens/game_modes/score_training/game_statistics/local_widgets/game_stats_score_training/local_widgets/three_dart_avg_stats_sc_t.dart';
import 'package:dart_app/screens/game_modes/score_training/game_statistics/local_widgets/game_stats_score_training/local_widgets/thrown_darts_stats_sc_t.dart';
import 'package:dart_app/screens/game_modes/shared/game_stats/section_heading_text.dart';

import 'package:flutter/material.dart';

class MainStatsScoreTraining extends StatelessWidget {
  const MainStatsScoreTraining({
    Key? key,
    required this.gameScoreTraining_P,
  }) : super(key: key);

  final GameScoreTraining_P gameScoreTraining_P;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: PADDING_LEFT_STATISTICS,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeadingGameStats(textValue: 'Game'),
          ThreeDartsAvgStatsScoreTraining(
              gameScoreTraining_P: gameScoreTraining_P),
          HighestScoreStatsScoreTraining(
              gameScoreTraining_P: gameScoreTraining_P),
          ThrownDartsStatsScoreTraining(
              gameScoreTraining_P: gameScoreTraining_P),
          ScoreStatsScoreTraining(gameScoreTraining_P: gameScoreTraining_P),
        ],
      ),
    );
  }
}
