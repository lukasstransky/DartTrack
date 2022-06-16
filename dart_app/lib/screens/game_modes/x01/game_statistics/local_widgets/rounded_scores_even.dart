import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/models/player_statistics/player_game_statistics_x01.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class RoundedScoresEven extends StatelessWidget {
  const RoundedScoresEven({Key? key, required this.game}) : super(key: key);

  final Game? game;

  bool _atLeastOneRoundedScoreValue(PlayerGameStatisticsX01 stats) {
    for (int value in stats.getRoundedScoresEven.values) {
      if (value != 0) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: PADDING_TOP_STATISTICS),
          child: Container(
            transform: Matrix4.translationValues(-10.0, 0.0, 0.0),
            child: Text(
              "Rounded Scores",
              style: TextStyle(
                  fontSize: FONTSIZE_HEADING_STATISTICS.sp,
                  color: Theme.of(context).primaryColor),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: PADDING_TOP_STATISTICS),
          child: Row(
            children: [
              Column(
                children: [
                  for (int i = 0; i <= 180; i += 20)
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Container(
                        width: WIDTH_HEADINGS_STATISTICS.w,
                        child: Row(
                          children: [
                            Container(
                              width: 12.w,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                      i == 180 ? "180" : i.toString() + "+",
                                      style: TextStyle(
                                          fontSize: FONTSIZE_STATISTICS.sp)),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              for (PlayerGameStatisticsX01 stats
                  in game!.getPlayerGameStatistics)
                Column(
                  children: [
                    for (int i = 0; i <= 180; i += 20)
                      Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: Container(
                          width: WIDTH_DATA_STATISTICS.w,
                          child: Text(
                            stats.getRoundedScoresEven[i].toString(),
                            style: TextStyle(
                                fontSize: FONTSIZE_STATISTICS.sp,
                                fontWeight: _atLeastOneRoundedScoreValue(
                                            stats) &&
                                        Utils.getMostOccurringValue(
                                                stats.getRoundedScoresEven) ==
                                            stats.getRoundedScoresEven[i]
                                    ? FontWeight.bold
                                    : FontWeight.normal),
                          ),
                        ),
                      ),
                  ],
                )
            ],
          ),
        ),
      ],
    );
  }
}
