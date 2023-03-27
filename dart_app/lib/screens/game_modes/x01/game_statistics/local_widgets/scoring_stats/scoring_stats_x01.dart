import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/screens/game_modes/x01/game_statistics/local_widgets/scoring_stats/local_widgets/first_nine_avg_stats_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game_statistics/local_widgets/scoring_stats/local_widgets/highest_score_stats_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game_statistics/local_widgets/scoring_stats/local_widgets/three_dart_avg_stats_x01.dart';

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
          transform: Matrix4.translationValues(-10.0, 0.0, 0.0),
          padding: EdgeInsets.only(top: 1.h),
          child: Text(
            'Scoring',
            style: TextStyle(
              fontSize: FONTSIZE_HEADING_STATISTICS.sp,
              color: Colors.white,
            ),
          ),
        ),
        ThreeDartAvgStatsX01(gameX01: widget.gameX01),
        FirstNineAvgStatsX01(gameX01: widget.gameX01),
        HighestScoreStatsX01(gameX01: widget.gameX01),
      ],
    );
  }
}
