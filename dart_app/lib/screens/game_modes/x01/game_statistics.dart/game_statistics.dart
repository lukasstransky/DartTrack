import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game_statistics.dart/local_widgets/finishing_stats.dart';
import 'package:dart_app/screens/game_modes/x01/game_statistics.dart/local_widgets/game_stats.dart';
import 'package:dart_app/screens/game_modes/x01/game_statistics.dart/local_widgets/most_frequent_scores.dart';
import 'package:dart_app/screens/game_modes/x01/game_statistics.dart/local_widgets/most_frequent_scores_per.dart';
import 'package:dart_app/screens/game_modes/x01/game_statistics.dart/local_widgets/rounded_scores.dart';
import 'package:dart_app/screens/game_modes/x01/game_statistics.dart/local_widgets/scoring_stats.dart';
import 'package:dart_app/utils/custom_app_bar.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameStatistics extends StatelessWidget {
  static const routeName = "/statisticsX01";

  const GameStatistics({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameSettingsX01 =
        Provider.of<GameSettingsX01>(context, listen: false);

    return Scaffold(
        appBar: CustomAppBar(true, "Statistics"),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: EdgeInsets.only(left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GameStats(),
                  ScoringStats(),
                  FinishingStats(),
                  RoundedScores(),
                  MostFrequentScores(),
                  if (gameSettingsX01.getInputMethod ==
                      InputMethod.ThreeDarts) ...[
                    MostFrequentScoresPerDart(),
                  ]
                ],
              ),
            ),
          ),
        ));
  }
}
