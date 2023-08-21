import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/screens/game_modes/x01/game_statistics/local_widgets/scoring_stats/local_widgets/all_thrown_darts_stats_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game_statistics/local_widgets/scoring_stats/local_widgets/first_nine_avg_stats_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game_statistics/local_widgets/scoring_stats/local_widgets/highest_score_stats_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game_statistics/local_widgets/scoring_stats/local_widgets/three_dart_avg_stats_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game_statistics/local_widgets/scoring_stats/local_widgets/thrown_darts_per_leg_stats_x01.dart';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ScoringStatsX01 extends StatefulWidget {
  const ScoringStatsX01({Key? key, required this.gameX01}) : super(key: key);

  final GameX01_P gameX01;

  @override
  State<ScoringStatsX01> createState() => _ScoringStatsX01State();
}

class _ScoringStatsX01State extends State<ScoringStatsX01> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(top: PADDING_TOP_STATISTICS.h),
          transform: Matrix4.translationValues(-2.5.w, 0.0, 0.0),
          child: Text(
            'Scoring',
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.titleLarge!.fontSize,
              color: Colors.white,
            ),
          ),
        ),
        ThreeDartAvgStatsX01(gameX01: widget.gameX01),
        FirstNineAvgStatsX01(gameX01: widget.gameX01),
        HighestScoreStatsX01(gameX01: widget.gameX01),
        if (!widget.gameX01.getIsGameFinished)
          ThrownDartsPerLegStatsX01(gameX01: widget.gameX01),
        AllThrownDartsStatsX01(gameX01: widget.gameX01)
      ],
    );
  }
}
