import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:sizer/sizer.dart';

class NameAndRanking extends StatelessWidget {
  const NameAndRanking({
    Key? key,
    required this.i,
    required this.game,
    required this.playerStats,
    required this.isOpenGame,
  }) : super(key: key);

  final int i;
  final Game_P game;
  final PlayerOrTeamGameStats playerStats;
  final bool isOpenGame;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(
          left: 5.w,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 5.w,
              child: Text(
                '${(i + 1)}.',
                style: TextStyle(
                  fontSize: i == 0 ? 14.sp : 12.sp,
                  fontWeight: FontWeight.bold,
                  color: Utils.getTextColorDarken(context),
                ),
              ),
            ),
            if (i == 0 &&
                !isOpenGame &&
                game.getPlayerGameStatistics.length > 1)
              Container(
                padding: EdgeInsets.only(left: 3.w),
                transform: Matrix4.translationValues(0.0, -2.0, 0.0),
                child: Icon(
                  Entypo.trophy,
                  size: 12.sp,
                  color: Color(0xffFFD700),
                ),
              ),
            Container(
              padding: EdgeInsets.only(left: 3.w),
              child: Text(
                playerStats.getPlayer.getName,
                style: TextStyle(
                  fontSize: i == 0 ? 14.sp : 12.sp,
                  color: Utils.getTextColorDarken(context),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
