import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/game_single_double_training_p.dart';
import 'package:dart_app/models/player_statistics/player_game_stats_single_double_training.dart';
import 'package:dart_app/screens/game_modes/shared/game_stats/heading_text.dart';
import 'package:dart_app/screens/game_modes/shared/game_stats/section_heading_text.dart';
import 'package:dart_app/screens/game_modes/shared/game_stats/value_text.dart';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

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
                      Container(
                        padding: EdgeInsets.only(top: PADDING_TOP_STATISTICS),
                        width: WIDTH_DATA_STATISTICS.w,
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Container(
                              width: 7.w,
                              child: Text(
                                '${stats.getSingleHits}',
                                style: TextStyle(
                                  fontSize: FONTSIZE_STATISTICS.sp,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Container(
                              width: 15.w,
                              child: Text(
                                '(${stats.getSingleHitsPercentage()}%)',
                                style: TextStyle(
                                  fontSize: FONTSIZE_STATISTICS.sp,
                                  color: Colors.white70,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    Container(
                      padding: EdgeInsets.only(top: PADDING_TOP_STATISTICS),
                      width: WIDTH_DATA_STATISTICS.w,
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Container(
                            width: 7.w,
                            child: Text(
                              '${stats.getDoubleHits}',
                              style: TextStyle(
                                fontSize: FONTSIZE_STATISTICS.sp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Container(
                            width: 15.w,
                            child: Text(
                              '(${stats.getDoubleHitsPercentage()}%)',
                              style: TextStyle(
                                fontSize: FONTSIZE_STATISTICS.sp,
                                color: Colors.white70,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isSingleMode)
                      Container(
                        padding: EdgeInsets.only(top: PADDING_TOP_STATISTICS),
                        width: WIDTH_DATA_STATISTICS.w,
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Container(
                              width: 7.w,
                              child: Text(
                                '${stats.getTrippleHits}',
                                style: TextStyle(
                                  fontSize: FONTSIZE_STATISTICS.sp,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Container(
                              width: 15.w,
                              child: Text(
                                '(${stats.getTrippleHitsPercentage()}%)',
                                style: TextStyle(
                                  fontSize: FONTSIZE_STATISTICS.sp,
                                  color: Colors.white70,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    Container(
                      padding: EdgeInsets.only(top: PADDING_TOP_STATISTICS),
                      width: WIDTH_DATA_STATISTICS.w,
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Container(
                            width: 7.w,
                            child: Text(
                              '${stats.getMissedHits}',
                              style: TextStyle(
                                fontSize: FONTSIZE_STATISTICS.sp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Container(
                            width: 15.w,
                            child: Text(
                              '(${stats.getMissedHitsPercentage()}%)',
                              style: TextStyle(
                                fontSize: FONTSIZE_STATISTICS.sp,
                                color: Colors.white70,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
