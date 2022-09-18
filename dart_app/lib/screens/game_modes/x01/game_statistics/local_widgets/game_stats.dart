import 'package:dart_app/constants.dart';
import 'package:dart_app/models/bot.dart';
import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/models/player_statistics/player_game_statistics_x01.dart';

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:sizer/sizer.dart';

class GameStats extends StatelessWidget {
  const GameStats({Key? key, required this.game}) : super(key: key);

  final Game? game;

  bool hasPlayerWonTheGame(PlayerGameStatisticsX01 playerGameStatisticsX01) {
    //check if sets are enabled
    if (game!.getGameSettings.getSetsEnabled) {
      if (game!.getGameSettings.getSets == playerGameStatisticsX01.getSetsWon) {
        return true;
      }
    } else {
      //leg mode
      if (game!.getGameSettings.getLegs == playerGameStatisticsX01.getLegsWon) {
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
          child: Row(
            children: [
              Container(
                width: WIDTH_HEADINGS_STATISTICS.w,
                child: Text(''),
              ),
              for (PlayerGameStatisticsX01 stats
                  in game!.getPlayerGameStatistics)
                Container(
                  width: WIDTH_DATA_STATISTICS.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        transform: Matrix4.translationValues(
                            hasPlayerWonTheGame(stats) ? -25.0 : 0.0, 0.0, 0.0),
                        child: Row(
                          children: [
                            if (hasPlayerWonTheGame(stats))
                              Padding(
                                padding: EdgeInsets.only(right: 5),
                                child: Icon(
                                  Entypo.trophy,
                                  size: 14.sp,
                                  color: Color(0xffFFD700),
                                ),
                              ),
                            if (stats.getPlayer is Bot) ...[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'Bot',
                                    style: TextStyle(
                                        fontSize: FONTSIZE_STATISTICS.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                    transform: Matrix4.translationValues(
                                        0.0, -1.0, 0.0),
                                    child: Text(
                                      ' (Lvl. ${stats.getPlayer.getLevel})',
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ] else ...[
                              Text(
                                stats.getPlayer.getName,
                                style: TextStyle(
                                    fontSize: FONTSIZE_STATISTICS.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            ]
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: PADDING_TOP_STATISTICS),
          child: Container(
            transform: Matrix4.translationValues(-10.0, 0.0, 0.0),
            child: Text(
              'Game',
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
                    child: Text(
                        game!.getGameSettings.getSetsEnabled
                            ? 'Sets Won'
                            : 'Legs Won',
                        style: TextStyle(fontSize: FONTSIZE_STATISTICS.sp)),
                  ),
                ),
              ),
              for (PlayerGameStatisticsX01 stats
                  in game!.getPlayerGameStatistics)
                Container(
                  width: WIDTH_DATA_STATISTICS.w,
                  child: Text(
                    game!.getGameSettings.getSetsEnabled
                        ? stats.getSetsWon.toString()
                        : stats.getLegsWon.toString(),
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
                      child: Text('Legs Won',
                          style: TextStyle(fontSize: FONTSIZE_STATISTICS.sp)),
                    ),
                  ),
                ),
                for (PlayerGameStatisticsX01 stats
                    in game!.getPlayerGameStatistics)
                  Container(
                    width: WIDTH_DATA_STATISTICS.w,
                    child: Text(
                      stats.getLegsWonTotal.toString(),
                      style: TextStyle(fontSize: FONTSIZE_STATISTICS.sp),
                    ),
                  ),
              ],
            ),
          )
      ],
    );
  }
}
