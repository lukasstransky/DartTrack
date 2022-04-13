import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/models/player_statistics/player_game_statistics_x01.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class FinishingStats extends StatelessWidget {
  const FinishingStats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameX01 = Provider.of<GameX01>(context, listen: false);
    final gameSettingsX01 =
        Provider.of<GameSettingsX01>(context, listen: false);
    final points = gameSettingsX01.getCustomPoints != -1
        ? gameSettingsX01.getCustomPoints
        : gameSettingsX01.getPoints;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: PADDING_TOP_STATISTICS),
          child: Container(
            transform: Matrix4.translationValues(-10.0, 0.0, 0.0),
            child: Text(
              "Finishing",
              style: TextStyle(
                  fontSize: FONTSIZE_HEADING_STATISTICS.sp,
                  color: Theme.of(context).primaryColor),
            ),
          ),
        ),
        if (gameSettingsX01.getEnableCheckoutCounting) ...[
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
                      child: Text("Checkout %",
                          style: TextStyle(fontSize: FONTSIZE_STATISTICS.sp)),
                    ),
                  ),
                ),
                for (PlayerGameStatisticsX01 stats
                    in gameX01.getPlayerGameStatistics)
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
                      child: Text("Checkout Darts",
                          style: TextStyle(fontSize: FONTSIZE_STATISTICS.sp)),
                    ),
                  ),
                ),
                for (PlayerGameStatisticsX01 stats
                    in gameX01.getPlayerGameStatistics)
                  Container(
                    width: WIDTH_DATA_STATISTICS.w,
                    child: stats.getCheckoutCount != 0
                        ? Text(
                            stats.getLegsWon.toString() +
                                "/" +
                                stats.getCheckoutCount.toString(),
                            style: TextStyle(fontSize: FONTSIZE_STATISTICS.sp))
                        : Text(
                            "-",
                            style: TextStyle(fontSize: FONTSIZE_STATISTICS.sp),
                          ),
                  ),
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
                    child: Text("Highest Finish",
                        style: TextStyle(fontSize: FONTSIZE_STATISTICS.sp)),
                  ),
                ),
              ),
              for (PlayerGameStatisticsX01 stats
                  in gameX01.getPlayerGameStatistics)
                Container(
                  width: WIDTH_DATA_STATISTICS.w,
                  child: Text(
                    stats.getHighestCheckout() != 0
                        ? stats.getHighestCheckout().toString()
                        : "-",
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
                    child: Text("Best Leg",
                        style: TextStyle(fontSize: FONTSIZE_STATISTICS.sp)),
                  ),
                ),
              ),
              for (PlayerGameStatisticsX01 stats
                  in gameX01.getPlayerGameStatistics)
                Container(
                  width: WIDTH_DATA_STATISTICS.w,
                  child: Text(stats.getBestLeg(points as num),
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
                    child: Text("Worst Leg",
                        style: TextStyle(fontSize: FONTSIZE_STATISTICS.sp)),
                  ),
                ),
              ),
              for (PlayerGameStatisticsX01 stats
                  in gameX01.getPlayerGameStatistics)
                Container(
                  width: WIDTH_DATA_STATISTICS.w,
                  child: Text(
                    stats.getWorstLeg(points as num),
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
                              text: ' (avg.)',
                              style: new TextStyle(fontSize: 8.sp)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              for (PlayerGameStatisticsX01 stats
                  in gameX01.getPlayerGameStatistics)
                Container(
                  width: WIDTH_DATA_STATISTICS.w,
                  child: Text(
                    stats.getDartsPerLeg(points as num),
                    style: new TextStyle(
                      fontSize: FONTSIZE_STATISTICS.sp,
                    ),
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
                    child: Text("all Checkouts",
                        style: TextStyle(fontSize: FONTSIZE_STATISTICS.sp)),
                  ),
                ),
              ),
              for (PlayerGameStatisticsX01 stats
                  in gameX01.getPlayerGameStatistics)
                Container(
                  width: WIDTH_DATA_STATISTICS.w,
                  child: Text(
                      stats.getCheckouts.isNotEmpty
                          ? stats.getCheckouts.toString()
                          : "-",
                      style: TextStyle(fontSize: 12.sp)),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
