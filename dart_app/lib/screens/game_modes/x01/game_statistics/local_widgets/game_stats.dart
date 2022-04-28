import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/models/player_statistics/player_game_statistics_x01.dart';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class GameStats extends StatelessWidget {
  const GameStats({Key? key, required this.game}) : super(key: key);

  final Game? game;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: EdgeInsets.only(top: 10),
        child: Row(
          children: [
            Container(
              width: WIDTH_HEADINGS_STATISTICS.w,
              child: Text(""),
            ),
            for (PlayerGameStatisticsX01 stats in game!.getPlayerGameStatistics)
              Container(
                width: WIDTH_DATA_STATISTICS.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(stats.getPlayer.getName,
                        style: TextStyle(
                            fontSize: FONTSIZE_STATISTICS.sp,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
          ],
        ),
      ),
      Padding(
        padding: EdgeInsets.only(top: 10),
        child: Container(
          transform: Matrix4.translationValues(-10.0, 0.0, 0.0),
          child: Text(
            "Game",
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
            Container(
              width: WIDTH_HEADINGS_STATISTICS.w,
              child: Align(
                alignment: Alignment.centerLeft,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text("Legs Won",
                      style: TextStyle(fontSize: FONTSIZE_STATISTICS.sp)),
                ),
              ),
            ),
            for (PlayerGameStatisticsX01 stats in game!.getPlayerGameStatistics)
              Container(
                width: WIDTH_DATA_STATISTICS.w,
                child: Text(
                  stats.getLegsWon.toString(),
                  style: TextStyle(fontSize: FONTSIZE_STATISTICS.sp),
                ),
              ),
          ],
        ),
      ),
      if (game!.getGameSettings.getSetsEnabled)
        Padding(
          padding: EdgeInsets.only(top: PADDING_TOP_STATISTICS),
          child: Row(
            children: [
              Container(
                width: WIDTH_HEADINGS_STATISTICS.w,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text("Sets Won",
                        style: TextStyle(fontSize: FONTSIZE_STATISTICS.sp)),
                  ),
                ),
              ),
              for (PlayerGameStatisticsX01 stats
                  in game!.getPlayerGameStatistics)
                Container(
                  width: WIDTH_DATA_STATISTICS.w,
                  child: Text(
                    stats.getSetsWon.toString(),
                    style: TextStyle(fontSize: FONTSIZE_STATISTICS.sp),
                  ),
                ),
            ],
          ),
        ),
    ]);
  }
}
