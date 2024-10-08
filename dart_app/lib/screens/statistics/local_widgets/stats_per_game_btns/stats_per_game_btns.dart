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
          padding: EdgeInsets.only(bottom: 1.h, top: 1.h),
          child: Text(
            'Statistics per game',
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
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
