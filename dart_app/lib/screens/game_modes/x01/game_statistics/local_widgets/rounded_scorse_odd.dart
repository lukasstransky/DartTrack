import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/models/player_statistics/player_game_statistics_x01.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class RoundedScoresOdd extends StatelessWidget {
  const RoundedScoresOdd({Key? key, required this.game}) : super(key: key);

  final Game? game;

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
                  for (int i = 10; i <= 170; i += 20)
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
                                  child: Text(i.toString() + "+",
                                      style: TextStyle(
                                        fontSize: FONTSIZE_STATISTICS.sp,
                                      )),
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
                    for (int i = 10; i <= 170; i += 20)
                      Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: Container(
                          width: WIDTH_DATA_STATISTICS.w,
                          child: Text(stats.getRoundedScoresOdd[i].toString(),
                              style: TextStyle(
                                  fontSize: FONTSIZE_STATISTICS.sp,
                                  fontWeight: stats.getHighestScore() >= 10 &&
                                          Utils.getMostOccurringValue(
                                                  stats.getRoundedScoresOdd) ==
                                              stats.getRoundedScoresOdd[i]
                                      ? FontWeight.bold
                                      : FontWeight.normal)),
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
