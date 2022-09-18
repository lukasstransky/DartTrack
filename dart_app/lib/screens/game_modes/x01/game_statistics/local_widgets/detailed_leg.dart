import 'package:dart_app/models/bot.dart';
import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/models/player_statistics/player_game_statistics_x01.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class DetailedLeg extends StatefulWidget {
  const DetailedLeg(
      {Key? key,
      required this.setLegString,
      required this.game,
      required this.winnerOfLeg})
      : super(key: key);

  final String setLegString;
  final Game? game;
  final String winnerOfLeg;

  @override
  State<DetailedLeg> createState() => _DetailedLegState();
}

class _DetailedLegState extends State<DetailedLeg> {
  int _currentPoints = 0;

  @override
  void initState() {
    super.initState();

    _currentPoints = getPointsOrCustom();
  }

  int getPointsOrCustom() {
    return widget.game!.getGameSettings.getCustomPoints != -1
        ? widget.game!.getGameSettings.getCustomPoints
        : widget.game!.getGameSettings.getPoints;
  }

  String getCurrentValue(
      int score, int i, PlayerGameStatisticsX01 playerGameStatisticsX01) {
    _currentPoints -= score;
    String result = _currentPoints.toString();

    if (i ==
        playerGameStatisticsX01.getAllScoresPerLeg[widget.setLegString].length -
            1) {
      _currentPoints = _currentPoints = getPointsOrCustom();
    }
    return result;
  }

  String getThrownDartsForLeg(PlayerGameStatisticsX01 playerGameStatisticsX01) {
    return playerGameStatisticsX01.getThrownDartsPerLeg[widget.setLegString]
        .toString();
  }

  bool emptyRowNeeded(int dartsToCheck) {
    int mostDarts = 0;
    for (PlayerGameStatisticsX01 playerGameStatisticsX01
        in widget.game!.getPlayerGameStatistics) {
      if (playerGameStatisticsX01
              .getAllScoresPerLeg[widget.setLegString].length >
          mostDarts) {
        mostDarts = playerGameStatisticsX01
            .getAllScoresPerLeg[widget.setLegString].length;
      }
    }

    return mostDarts > dartsToCheck ? true : false;
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
                        playerGameStatisticsX01.getPlayer is Bot
                            ? 'Bot'
                            : playerGameStatisticsX01.getPlayer.getName,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15.sp),
                      ),
                      for (int i = 0;
                          i <
                              playerGameStatisticsX01
                                  .getAllScoresPerLeg[widget.setLegString]
                                  .length;
                          i++) ...[
                        if (i == 0)
                          Padding(
                            padding: EdgeInsets.only(bottom: 10, top: 5),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Center(
                                      child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      'Score',
                                      style: TextStyle(fontSize: 11.sp),
                                    ),
                                  )),
                                ),
                                Expanded(
                                  child: Center(
                                      child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      'Left',
                                      style: TextStyle(fontSize: 11.sp),
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
                                        .getAllScoresPerLeg[widget.setLegString]
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
                                            .getAllScoresPerLeg[
                                                widget.setLegString]
                                            .elementAt(i),
                                        i,
                                        playerGameStatisticsX01),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (i ==
                                playerGameStatisticsX01
                                        .getAllScoresPerLeg[widget.setLegString]
                                        .length -
                                    1 &&
                            emptyRowNeeded(playerGameStatisticsX01
                                .getAllScoresPerLeg[widget.setLegString]
                                .length))
                          Row(
                            children: [
                              Expanded(
                                child: Center(
                                  child: Text(''),
                                ),
                              ),
                            ],
                          ),
                      ],
                      const Divider(
                        height: 15,
                        thickness: 1,
                        indent: 10,
                        endIndent: 10,
                        color: Colors.black,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Center(
                              child: Text('Avg.'),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text('Darts'),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(Utils.getAverageForLeg(
                                  playerGameStatisticsX01,
                                  widget.setLegString)),
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
