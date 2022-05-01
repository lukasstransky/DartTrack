import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/models/player_statistics/player_game_statistics_x01.dart';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class DetailedLeg extends StatefulWidget {
  const DetailedLeg({Key? key, required this.leg, required this.game})
      : super(key: key);

  final String leg;
  final Game? game;

  @override
  State<DetailedLeg> createState() => _DetailedLegState();
}

class _DetailedLegState extends State<DetailedLeg> {
  num _currentPoints = 0;

  @override
  void initState() {
    super.initState();

    _currentPoints = getPointsOrCustom();
  }

  num getPointsOrCustom() {
    return widget.game!.getGameSettings.getCustomPoints != -1
        ? widget.game!.getGameSettings.getCustomPoints
        : widget.game!.getGameSettings.getPoints;
  }

  String getCurrentValue(
      num score, num i, PlayerGameStatisticsX01 playerGameStatisticsX01) {
    _currentPoints -= score;
    String result = _currentPoints.toString();

    if (i ==
        playerGameStatisticsX01.getAllScoresPerLeg[widget.leg].length - 1) {
      _currentPoints = _currentPoints = getPointsOrCustom();
    }
    return result;
  }

  String getAverageForLeg(PlayerGameStatisticsX01 playerGameStatisticsX01) {
    num result = 0;
    for (num score in playerGameStatisticsX01.getAllScoresPerLeg[widget.leg]) {
      result += score;
    }
    int legIndex = int.parse(widget.leg.substring(widget.leg.length - 1)) - 1;
    result /= (playerGameStatisticsX01.getThrownDartsPerLeg[legIndex] / 3);

    return result.toStringAsFixed(2);
  }

  String getThrownDartsForLeg(PlayerGameStatisticsX01 playerGameStatisticsX01) {
    int legIndex = int.parse(widget.leg.substring(widget.leg.length - 1)) - 1;
    return playerGameStatisticsX01.getThrownDartsPerLeg[legIndex].toString();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (PlayerGameStatisticsX01 playerGameStatisticsX01
                in widget.game!.getPlayerGameStatistics)
              Padding(
                padding: EdgeInsets.all(2.w),
                child: Container(
                  width: 43.w,
                  child: Column(
                    children: [
                      Text(
                        playerGameStatisticsX01.getPlayer.getName,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15.sp),
                      ),
                      for (num i = 0;
                          i <
                              playerGameStatisticsX01
                                  .getAllScoresPerLeg[widget.leg].length;
                          i++) ...[
                        if (i == 0)
                          Padding(
                            padding: EdgeInsets.only(bottom: 5),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Center(
                                      child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      "Score",
                                      style: TextStyle(fontSize: 13.sp),
                                    ),
                                  )),
                                ),
                                Expanded(
                                  child: Center(
                                      child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      "Remaining",
                                      style: TextStyle(fontSize: 13.sp),
                                    ),
                                  )),
                                ),
                              ],
                            ),
                          ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                child: Center(
                                  child: Text(
                                    playerGameStatisticsX01
                                        .getAllScoresPerLeg[widget.leg]
                                        .elementAt(i)
                                        .toString(),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                child: Center(
                                  child: Text(
                                    getCurrentValue(
                                        playerGameStatisticsX01
                                            .getAllScoresPerLeg[widget.leg]
                                            .elementAt(i),
                                        i,
                                        playerGameStatisticsX01),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                      const Divider(
                        height: 15,
                        thickness: 1,
                        indent: 20,
                        endIndent: 0,
                        color: Colors.black,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Center(
                              child: Text("Avg."),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text("Darts"),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                  getAverageForLeg(playerGameStatisticsX01)),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(getThrownDartsForLeg(
                                  playerGameStatisticsX01)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
