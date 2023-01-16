import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/score_training/game_score_training_p.dart';
import 'package:dart_app/models/player_statistics/score_training/player_game_statistics_score_training.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ThreeDartsAvgStatsScoreTraining extends StatelessWidget {
  const ThreeDartsAvgStatsScoreTraining({
    Key? key,
    required this.gameScoreTraining_P,
  }) : super(key: key);

  final GameScoreTraining_P gameScoreTraining_P;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: PADDING_TOP_STATISTICS),
      child: Row(
        children: [
          Container(
            width: WIDTH_HEADINGS_STATISTICS.w,
            alignment: Alignment.centerLeft,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                '3-Dart Avg.',
                style: TextStyle(
                  fontSize: FONTSIZE_STATISTICS.sp,
                  color: Utils.getTextColorDarken(context),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          for (PlayerGameStatisticsScoreTraining stats
              in gameScoreTraining_P.getPlayerGameStatistics)
            Container(
              width: WIDTH_DATA_STATISTICS.w,
              child: Text(
                stats.getAverage().toString(),
                style: TextStyle(
                  fontSize: FONTSIZE_STATISTICS.sp,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
