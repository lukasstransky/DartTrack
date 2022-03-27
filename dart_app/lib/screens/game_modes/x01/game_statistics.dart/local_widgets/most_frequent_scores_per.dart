import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/models/player_statistics/player_game_statistics_x01.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class MostFrequentScoresPerDart extends StatelessWidget {
  const MostFrequentScoresPerDart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameX01 = Provider.of<GameX01>(context, listen: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: PADDING_TOP_STATISTICS),
          child: Container(
            transform: Matrix4.translationValues(-10.0, 0.0, 0.0),
            child: Text(
              "Most Frequent Scores Per Dart",
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
                  for (int i = 0; i < 5; i++)
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Container(
                        width: WIDTH_HEADINGS_STATISTICS.w,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text((i + 1).toString() + ".",
                                style: TextStyle(
                                    fontSize: FONTSIZE_STATISTICS.sp)),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              for (PlayerGameStatisticsX01 stats
                  in gameX01.getPlayerGameStatistics)
                Column(
                  children: [
                    for (int i = 0; i < 5; i++)
                      Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: Container(
                          width: WIDTH_DATA_STATISTICS.w,
                          child: stats
                                      .getAllScoresPerDartAsStringCountSorted()
                                      .keys
                                      .length >
                                  i
                              ? Text(
                                  stats
                                          .getAllScoresPerDartAsStringCountSorted()
                                          .keys
                                          .elementAt(i)
                                          .toString() +
                                      " (" +
                                      stats
                                          .getAllScoresPerDartAsStringCountSorted()
                                          .values
                                          .elementAt(i)
                                          .toString() +
                                      "x)",
                                  style: TextStyle(
                                      fontSize: FONTSIZE_STATISTICS.sp))
                              : Text("-",
                                  style: TextStyle(
                                      fontSize: FONTSIZE_STATISTICS.sp)),
                        ),
                      ),
                  ],
                )
            ],
          ),
        ),
        SizedBox(
          height: 5.h,
        ),
      ],
    );
  }
}
