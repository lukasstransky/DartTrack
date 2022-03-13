import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01_model.dart';
import 'package:dart_app/models/games/game_x01_model.dart';
import 'package:dart_app/models/player_statistics/player_game_statistics_model.dart';
import 'package:dart_app/models/player_statistics/player_game_statistics_x01_model.dart';
import 'package:dart_app/other/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sizer/sizer.dart';
import 'package:provider/provider.dart';

class StatisticsX01Screen extends StatelessWidget {
  static const routeName = "/statisticsX01";

  const StatisticsX01Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameX01 = Provider.of<GameX01>(context, listen: false);
    final gameSettingsX01 =
        Provider.of<GameSettingsX01>(context, listen: false);
    final points = gameSettingsX01.getCustomPoints != -1
        ? gameSettingsX01.getCustomPoints
        : gameSettingsX01.getPoints;

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
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Row(
                      children: [
                        Container(
                          width: WIDTH_HEADINGS_STATISTICS.w,
                          child: Text(""),
                        ),
                        for (PlayerGameStatisticsX01 stats
                            in gameX01.getPlayerGameStatistics)
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
                                  style: TextStyle(
                                      fontSize: FONTSIZE_STATISTICS.sp)),
                            ),
                          ),
                        ),
                        for (PlayerGameStatisticsX01 stats
                            in gameX01.getPlayerGameStatistics)
                          Container(
                            width: WIDTH_DATA_STATISTICS.w,
                            child: Text(
                              stats.getLegsWon.toString(),
                              style:
                                  TextStyle(fontSize: FONTSIZE_STATISTICS.sp),
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (gameSettingsX01.getSetsEnabled)
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
                                    style: TextStyle(
                                        fontSize: FONTSIZE_STATISTICS.sp)),
                              ),
                            ),
                          ),
                          for (PlayerGameStatisticsX01 stats
                              in gameX01.getPlayerGameStatistics)
                            Container(
                              width: WIDTH_DATA_STATISTICS.w,
                              child: Text(
                                stats.getSetsWon.toString(),
                                style:
                                    TextStyle(fontSize: FONTSIZE_STATISTICS.sp),
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
                        "Scoring",
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
                              child: Text("3-Dart Avg.",
                                  style: TextStyle(
                                      fontSize: FONTSIZE_STATISTICS.sp)),
                            ),
                          ),
                        ),
                        for (PlayerGameStatisticsX01 stats
                            in gameX01.getPlayerGameStatistics)
                          Container(
                            width: WIDTH_DATA_STATISTICS.w,
                            child: Text(
                              stats.getAverage(),
                              style:
                                  TextStyle(fontSize: FONTSIZE_STATISTICS.sp),
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
                              child: Text("First Nine Avg.",
                                  style: TextStyle(
                                      fontSize: FONTSIZE_STATISTICS.sp)),
                            ),
                          ),
                        ),
                        for (PlayerGameStatisticsX01 stats
                            in gameX01.getPlayerGameStatistics)
                          Container(
                            width: WIDTH_DATA_STATISTICS.w,
                            child: Text(
                              stats.getFirstNinveAvg(),
                              style:
                                  TextStyle(fontSize: FONTSIZE_STATISTICS.sp),
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
                              child: Text("Highest Score",
                                  style: TextStyle(
                                      fontSize: FONTSIZE_STATISTICS.sp)),
                            ),
                          ),
                        ),
                        for (PlayerGameStatisticsX01 stats
                            in gameX01.getPlayerGameStatistics)
                          Container(
                            width: WIDTH_DATA_STATISTICS.w,
                            child: Text(
                              stats.getHighestScore() != 0
                                  ? stats.getHighestScore().toString()
                                  : "-",
                              style:
                                  TextStyle(fontSize: FONTSIZE_STATISTICS.sp),
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
                                    style: TextStyle(
                                        fontSize: FONTSIZE_STATISTICS.sp)),
                              ),
                            ),
                          ),
                          for (PlayerGameStatisticsX01 stats
                              in gameX01.getPlayerGameStatistics)
                            Container(
                                width: WIDTH_DATA_STATISTICS.w,
                                child: Text(
                                  stats.getCheckoutQuoteInPercent(),
                                  style: TextStyle(
                                      fontSize: FONTSIZE_STATISTICS.sp),
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
                                    style: TextStyle(
                                        fontSize: FONTSIZE_STATISTICS.sp)),
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
                                      style: TextStyle(
                                          fontSize: FONTSIZE_STATISTICS.sp))
                                  : Text(
                                      "-",
                                      style: TextStyle(
                                          fontSize: FONTSIZE_STATISTICS.sp),
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
                                  style: TextStyle(
                                      fontSize: FONTSIZE_STATISTICS.sp)),
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
                              style:
                                  TextStyle(fontSize: FONTSIZE_STATISTICS.sp),
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
                                  style: TextStyle(
                                      fontSize: FONTSIZE_STATISTICS.sp)),
                            ),
                          ),
                        ),
                        for (PlayerGameStatisticsX01 stats
                            in gameX01.getPlayerGameStatistics)
                          Container(
                            width: WIDTH_DATA_STATISTICS.w,
                            child: Text(stats.getBestLeg(points as num),
                                style: TextStyle(
                                    fontSize: FONTSIZE_STATISTICS.sp)),
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
                                  style: TextStyle(
                                      fontSize: FONTSIZE_STATISTICS.sp)),
                            ),
                          ),
                        ),
                        for (PlayerGameStatisticsX01 stats
                            in gameX01.getPlayerGameStatistics)
                          Container(
                            width: WIDTH_DATA_STATISTICS.w,
                            child: Text(
                              stats.getWorstLeg(points as num),
                              style:
                                  TextStyle(fontSize: FONTSIZE_STATISTICS.sp),
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
                                  style: TextStyle(
                                      fontSize: FONTSIZE_STATISTICS.sp)),
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
                  Padding(
                    padding: EdgeInsets.only(top: 10),
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
                                      style: TextStyle(
                                          fontSize: FONTSIZE_STATISTICS.sp)),
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
                                        style: TextStyle(
                                            fontSize: FONTSIZE_STATISTICS.sp)),
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
                                        style: TextStyle(
                                            fontSize: FONTSIZE_STATISTICS.sp)),
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
                                        style: TextStyle(
                                            fontSize: FONTSIZE_STATISTICS.sp)),
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
                                        style: TextStyle(
                                            fontSize: FONTSIZE_STATISTICS.sp)),
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
                                        style: TextStyle(
                                            fontSize: FONTSIZE_STATISTICS.sp)),
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
                                        style: TextStyle(
                                            fontSize: FONTSIZE_STATISTICS.sp)),
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
                                        style: TextStyle(
                                            fontSize: FONTSIZE_STATISTICS.sp)),
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
                              Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Container(
                                  width: WIDTH_DATA_STATISTICS.w,
                                  child: Text(
                                      stats.getRoundedScores[0].toString(),
                                      style: TextStyle(
                                          fontSize: FONTSIZE_STATISTICS.sp)),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Container(
                                  width: WIDTH_DATA_STATISTICS.w,
                                  child: Text(
                                      stats.getRoundedScores[40].toString(),
                                      style: TextStyle(
                                          fontSize: FONTSIZE_STATISTICS.sp)),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Container(
                                  width: WIDTH_DATA_STATISTICS.w,
                                  child: Text(
                                      stats.getRoundedScores[60].toString(),
                                      style: TextStyle(
                                          fontSize: FONTSIZE_STATISTICS.sp)),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Container(
                                  width: WIDTH_DATA_STATISTICS.w,
                                  child: Text(
                                      stats.getRoundedScores[80].toString(),
                                      style: TextStyle(
                                          fontSize: FONTSIZE_STATISTICS.sp)),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Container(
                                  width: WIDTH_DATA_STATISTICS.w,
                                  child: Text(
                                      stats.getRoundedScores[100].toString(),
                                      style: TextStyle(
                                          fontSize: FONTSIZE_STATISTICS.sp)),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Container(
                                  width: WIDTH_DATA_STATISTICS.w,
                                  child: Text(
                                      stats.getRoundedScores[120].toString(),
                                      style: TextStyle(
                                          fontSize: FONTSIZE_STATISTICS.sp)),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Container(
                                  width: WIDTH_DATA_STATISTICS.w,
                                  child: Text(
                                      stats.getRoundedScores[140].toString(),
                                      style: TextStyle(
                                          fontSize: FONTSIZE_STATISTICS.sp)),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Container(
                                  width: WIDTH_DATA_STATISTICS.w,
                                  child: Text(
                                      stats.getRoundedScores[160].toString(),
                                      style: TextStyle(
                                          fontSize: FONTSIZE_STATISTICS.sp)),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Container(
                                  width: WIDTH_DATA_STATISTICS.w,
                                  child: Text(
                                      stats.getRoundedScores[180].toString(),
                                      style: TextStyle(
                                          fontSize: FONTSIZE_STATISTICS.sp)),
                                ),
                              ),
                            ],
                          )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Container(
                      transform: Matrix4.translationValues(-10.0, 0.0, 0.0),
                      child: Text(
                        "Most Frequent Scores",
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
                            Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Container(
                                width: WIDTH_HEADINGS_STATISTICS.w,
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text("1.",
                                        style: TextStyle(
                                            fontSize: FONTSIZE_STATISTICS.sp)),
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
                                    child: Text("2.",
                                        style: TextStyle(
                                            fontSize: FONTSIZE_STATISTICS.sp)),
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
                                    child: Text("3.",
                                        style: TextStyle(
                                            fontSize: FONTSIZE_STATISTICS.sp)),
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
                                    child: Text("4.",
                                        style: TextStyle(
                                            fontSize: FONTSIZE_STATISTICS.sp)),
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
                                    child: Text("5.",
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
                              Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Container(
                                  width: WIDTH_DATA_STATISTICS.w,
                                  child: stats.getPreciseScores.length > 0
                                      ? Text(
                                          stats
                                                  .getPreciseScoresSorted()
                                                  .keys
                                                  .elementAt(0)
                                                  .toString() +
                                              " (" +
                                              stats
                                                  .getPreciseScoresSorted()
                                                  .values
                                                  .elementAt(0)
                                                  .toString() +
                                              "x)",
                                          style: TextStyle(
                                              fontSize: FONTSIZE_STATISTICS.sp))
                                      : Text("-",
                                          style: TextStyle(
                                              fontSize:
                                                  FONTSIZE_STATISTICS.sp)),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Container(
                                  width: WIDTH_DATA_STATISTICS.w,
                                  child: stats.getPreciseScores.length > 1
                                      ? Text(
                                          stats
                                                  .getPreciseScoresSorted()
                                                  .keys
                                                  .elementAt(1)
                                                  .toString() +
                                              " (" +
                                              stats
                                                  .getPreciseScoresSorted()
                                                  .values
                                                  .elementAt(1)
                                                  .toString() +
                                              "x)",
                                          style: TextStyle(
                                              fontSize: FONTSIZE_STATISTICS.sp))
                                      : Text("-",
                                          style: TextStyle(
                                              fontSize:
                                                  FONTSIZE_STATISTICS.sp)),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Container(
                                  width: WIDTH_DATA_STATISTICS.w,
                                  child: stats.getPreciseScores.length > 2
                                      ? Text(
                                          stats
                                                  .getPreciseScoresSorted()
                                                  .keys
                                                  .elementAt(2)
                                                  .toString() +
                                              " (" +
                                              stats
                                                  .getPreciseScoresSorted()
                                                  .values
                                                  .elementAt(2)
                                                  .toString() +
                                              "x)",
                                          style: TextStyle(
                                              fontSize: FONTSIZE_STATISTICS.sp))
                                      : Text("-",
                                          style: TextStyle(
                                              fontSize:
                                                  FONTSIZE_STATISTICS.sp)),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Container(
                                  width: WIDTH_DATA_STATISTICS.w,
                                  child: stats.getPreciseScores.length > 3
                                      ? Text(
                                          stats
                                                  .getPreciseScoresSorted()
                                                  .keys
                                                  .elementAt(3)
                                                  .toString() +
                                              " (" +
                                              stats
                                                  .getPreciseScoresSorted()
                                                  .values
                                                  .elementAt(3)
                                                  .toString() +
                                              "x)",
                                          style: TextStyle(
                                              fontSize: FONTSIZE_STATISTICS.sp))
                                      : Text("-",
                                          style: TextStyle(
                                              fontSize:
                                                  FONTSIZE_STATISTICS.sp)),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 5),
                                child: Container(
                                  width: WIDTH_DATA_STATISTICS.w,
                                  child: stats.getPreciseScores.length > 4
                                      ? Text(
                                          stats
                                                  .getPreciseScoresSorted()
                                                  .keys
                                                  .elementAt(4)
                                                  .toString() +
                                              " (" +
                                              stats
                                                  .getPreciseScoresSorted()
                                                  .values
                                                  .elementAt(4)
                                                  .toString() +
                                              "x)",
                                          style: TextStyle(
                                              fontSize: FONTSIZE_STATISTICS.sp))
                                      : Text("-",
                                          style: TextStyle(
                                              fontSize:
                                                  FONTSIZE_STATISTICS.sp)),
                                ),
                              ),
                            ],
                          )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
