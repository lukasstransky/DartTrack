import 'package:dart_app/screens/statistics/local_widgets/stats_per_game_btns/local_widgets/stats_cricket_btn.dart';
import 'package:dart_app/screens/statistics/local_widgets/stats_per_game_btns/local_widgets/stats_double_training_btn.dart';
import 'package:dart_app/screens/statistics/local_widgets/stats_per_game_btns/local_widgets/stats_score_training_btn.dart';
import 'package:dart_app/screens/statistics/local_widgets/stats_per_game_btns/local_widgets/stats_single_training_btn.dart';
import 'package:dart_app/screens/statistics/local_widgets/stats_per_game_btns/local_widgets/stats_x01_btn.dart';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class StatsPerGameBtns extends StatelessWidget {
  const StatsPerGameBtns({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Text(
            'Stats per Game',
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.white,
            ),
          ),
        ),
        StatsX01Btn(),
        StatsCricketBtn(),
        StatsSingleTrainingBtn(),
        StatsDoubleTrainingBtn(),
        StatsScoreTrainingBtn(),
      ],
    );
  }
}
