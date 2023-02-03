import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/game_single_double_training_p.dart';
import 'package:dart_app/models/player_statistics/player_game_stats_single_double_training.dart';
import 'package:dart_app/screens/game_modes/shared/game_stats/heading_text.dart';
import 'package:dart_app/screens/game_modes/shared/game_stats/section_heading_text.dart';
import 'package:dart_app/screens/game_modes/shared/game_stats/value_text.dart';

import 'package:flutter/material.dart';

class MainStatsSingleDoubleTraining extends StatelessWidget {
  const MainStatsSingleDoubleTraining({Key? key, required this.game})
      : super(key: key);

  final GameSingleDoubleTraining_P game;

  @override
  Widget build(BuildContext context) {
    final bool isSingleMode = game.getMode == GameMode.SingleTraining;

    return Padding(
      padding: EdgeInsets.only(left: PADDING_LEFT_STATISTICS),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeadingGameStats(textValue: 'Game'),
          Row(
            children: [
              Column(
                children: [
                  Container(
                    child: HeadingTextGameStats(
                      textValue: 'Total points',
                    ),
                  ),
                  if (isSingleMode)
                    HeadingTextGameStats(
                      textValue: 'Single hits',
                    ),
                  HeadingTextGameStats(
                    textValue: 'Double hits',
                  ),
                  if (isSingleMode)
                    HeadingTextGameStats(
                      textValue: 'Tripple hits',
                    ),
                  HeadingTextGameStats(
                    textValue: 'Missed',
                  ),
                ],
              ),
              for (PlayerGameStatsSingleDoubleTraining stats
                  in game.getPlayerGameStatistics)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ValueTextGameStats(
                        textValue: stats.getTotalPoints.toString()),
                    if (isSingleMode)
                      ValueTextGameStats(
                          textValue: stats.getSingleHits.toString()),
                    ValueTextGameStats(
                        textValue: stats.getDoubleHits.toString()),
                    if (isSingleMode)
                      ValueTextGameStats(
                          textValue: stats.getTrippleHits.toString()),
                    ValueTextGameStats(
                        textValue: stats.getMissedHits.toString()),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
