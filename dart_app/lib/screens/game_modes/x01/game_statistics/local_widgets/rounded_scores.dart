import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/models/player_statistics/player_game_statistics_x01.dart';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class RoundedScores extends StatelessWidget {
  const RoundedScores({Key? key, required this.game}) : super(key: key);

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
              "Scores",
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
                  Container(
                    width: WIDTH_HEADINGS_STATISTICS.w,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text("0+",
                            style: TextStyle(fontSize: FONTSIZE_STATISTICS.sp)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Container(
                      width: WIDTH_HEADINGS_STATISTICS.w,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text("20+",
                              style:
                                  TextStyle(fontSize: FONTSIZE_STATISTICS.sp)),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Container(
                      width: WIDTH_HEADINGS_STATISTICS.w,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text("40+",
                              style:
                                  TextStyle(fontSize: FONTSIZE_STATISTICS.sp)),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Container(
                      width: WIDTH_HEADINGS_STATISTICS.w,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text("60+",
                              style:
                                  TextStyle(fontSize: FONTSIZE_STATISTICS.sp)),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Container(
                      width: WIDTH_HEADINGS_STATISTICS.w,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text("80+",
                              style:
                                  TextStyle(fontSize: FONTSIZE_STATISTICS.sp)),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Container(
                      width: WIDTH_HEADINGS_STATISTICS.w,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text("100+",
                              style:
                                  TextStyle(fontSize: FONTSIZE_STATISTICS.sp)),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Container(
                      width: WIDTH_HEADINGS_STATISTICS.w,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text("120+",
                              style:
                                  TextStyle(fontSize: FONTSIZE_STATISTICS.sp)),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Container(
                      width: WIDTH_HEADINGS_STATISTICS.w,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text("140+",
                              style:
                                  TextStyle(fontSize: FONTSIZE_STATISTICS.sp)),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Container(
                      width: WIDTH_HEADINGS_STATISTICS.w,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text("160+",
                              style:
                                  TextStyle(fontSize: FONTSIZE_STATISTICS.sp)),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Container(
                      width: WIDTH_HEADINGS_STATISTICS.w,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text("180",
                              style:
                                  TextStyle(fontSize: FONTSIZE_STATISTICS.sp)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              for (PlayerGameStatisticsX01 stats
                  in game!.getPlayerGameStatistics)
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Container(
                        width: WIDTH_DATA_STATISTICS.w,
                        child: Text(stats.getRoundedScores[0].toString(),
                            style: TextStyle(fontSize: FONTSIZE_STATISTICS.sp)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Container(
                        width: WIDTH_DATA_STATISTICS.w,
                        child: Text(stats.getRoundedScores[20].toString(),
                            style: TextStyle(fontSize: FONTSIZE_STATISTICS.sp)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Container(
                        width: WIDTH_DATA_STATISTICS.w,
                        child: Text(stats.getRoundedScores[40].toString(),
                            style: TextStyle(fontSize: FONTSIZE_STATISTICS.sp)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Container(
                        width: WIDTH_DATA_STATISTICS.w,
                        child: Text(stats.getRoundedScores[60].toString(),
                            style: TextStyle(fontSize: FONTSIZE_STATISTICS.sp)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Container(
                        width: WIDTH_DATA_STATISTICS.w,
                        child: Text(stats.getRoundedScores[80].toString(),
                            style: TextStyle(fontSize: FONTSIZE_STATISTICS.sp)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Container(
                        width: WIDTH_DATA_STATISTICS.w,
                        child: Text(stats.getRoundedScores[100].toString(),
                            style: TextStyle(fontSize: FONTSIZE_STATISTICS.sp)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Container(
                        width: WIDTH_DATA_STATISTICS.w,
                        child: Text(stats.getRoundedScores[120].toString(),
                            style: TextStyle(fontSize: FONTSIZE_STATISTICS.sp)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Container(
                        width: WIDTH_DATA_STATISTICS.w,
                        child: Text(stats.getRoundedScores[140].toString(),
                            style: TextStyle(fontSize: FONTSIZE_STATISTICS.sp)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Container(
                        width: WIDTH_DATA_STATISTICS.w,
                        child: Text(stats.getRoundedScores[160].toString(),
                            style: TextStyle(fontSize: FONTSIZE_STATISTICS.sp)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Container(
                        width: WIDTH_DATA_STATISTICS.w,
                        child: Text(stats.getRoundedScores[180].toString(),
                            style: TextStyle(fontSize: FONTSIZE_STATISTICS.sp)),
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
