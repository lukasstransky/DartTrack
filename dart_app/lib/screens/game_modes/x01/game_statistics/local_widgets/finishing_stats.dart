import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/models/player_statistics/player_game_statistics_x01.dart';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class FinishingStats extends StatelessWidget {
  const FinishingStats({Key? key, required this.game}) : super(key: key);

  final Game? game;

  String _getDartsPerLeg(PlayerGameStatisticsX01 stats) {
    if (stats.getLegsWonTotal == 0) return '-';

    int dartsPerLeg = 0;
    int games = 0;

    stats.getCheckouts.keys.forEach((key) {
      dartsPerLeg += stats.getThrownDartsPerLeg[key] as int;
      games++;
    });

    return (dartsPerLeg / games).toStringAsFixed(2);
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
              'Finishing',
              style: TextStyle(
                  fontSize: FONTSIZE_HEADING_STATISTICS.sp,
                  color: Theme.of(context).primaryColor),
            ),
          ),
        ),
        if (game!.getGameSettings.getEnableCheckoutCounting) ...[
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
                      child: Text('Checkout %',
                          style: TextStyle(fontSize: FONTSIZE_STATISTICS.sp)),
                    ),
                  ),
                ),
                for (PlayerGameStatisticsX01 stats
                    in game!.getPlayerGameStatistics)
                  Container(
                      width: WIDTH_DATA_STATISTICS.w,
                      child: Text(
                        stats.getCheckoutQuoteInPercent(),
                        style: TextStyle(fontSize: FONTSIZE_STATISTICS.sp),
                      )),
              ],
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
                      child: Text('Checkout Darts',
                          style: TextStyle(fontSize: FONTSIZE_STATISTICS.sp)),
                    ),
                  ),
                ),
                for (PlayerGameStatisticsX01 stats
                    in game!.getPlayerGameStatistics)
                  Container(
                      width: WIDTH_DATA_STATISTICS.w,
                      child: Text(
                          stats.getCheckoutCount != 0
                              ? '${stats.getLegsWonTotal.toString()}/${stats.getCheckoutCount.toString()}'
                              : '-',
                          style: TextStyle(fontSize: FONTSIZE_STATISTICS.sp))),
              ],
            ),
          ),
        ],
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
                    child: Text('Highest Finish',
                        style: TextStyle(fontSize: FONTSIZE_STATISTICS.sp)),
                  ),
                ),
              ),
              for (PlayerGameStatisticsX01 stats
                  in game!.getPlayerGameStatistics)
                Container(
                  width: WIDTH_DATA_STATISTICS.w,
                  child: Text(
                    stats.getHighestCheckout() != 0
                        ? stats.getHighestCheckout().toString()
                        : '-',
                    style: TextStyle(fontSize: FONTSIZE_STATISTICS.sp),
                  ),
                ),
            ],
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
                    child: Text('Best Leg',
                        style: TextStyle(fontSize: FONTSIZE_STATISTICS.sp)),
                  ),
                ),
              ),
              for (PlayerGameStatisticsX01 stats
                  in game!.getPlayerGameStatistics)
                Container(
                  width: WIDTH_DATA_STATISTICS.w,
                  child: Text(stats.getBestLeg(),
                      style: TextStyle(fontSize: FONTSIZE_STATISTICS.sp)),
                ),
            ],
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
                    child: Text('Worst Leg',
                        style: TextStyle(fontSize: FONTSIZE_STATISTICS.sp)),
                  ),
                ),
              ),
              for (PlayerGameStatisticsX01 stats
                  in game!.getPlayerGameStatistics)
                Container(
                  width: WIDTH_DATA_STATISTICS.w,
                  child: Text(
                    stats.getWorstLeg(),
                    style: TextStyle(fontSize: FONTSIZE_STATISTICS.sp),
                  ),
                ),
            ],
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
                    child: RichText(
                      text: TextSpan(
                        style: new TextStyle(
                          fontSize: FONTSIZE_STATISTICS.sp,
                          color: Colors.black,
                        ),
                        children: <TextSpan>[
                          new TextSpan(text: 'Darts/Leg'),
                          new TextSpan(
                              text: ' (Avg.)',
                              style: new TextStyle(fontSize: 8.sp)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              for (PlayerGameStatisticsX01 stats
                  in game!.getPlayerGameStatistics)
                Container(
                  width: WIDTH_DATA_STATISTICS.w,
                  child: Text(
                    _getDartsPerLeg(stats),
                    style: new TextStyle(
                      fontSize: FONTSIZE_STATISTICS.sp,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
