import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class PlayerNames extends StatelessWidget {
  const PlayerNames({
    Key? key,
    required this.game,
  }) : super(key: key);

  final Game_P game;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: PADDING_LEFT_STATISTICS.w,
        top: PADDING_TOP_STATISTICS.h,
      ),
      child: Row(
        children: [
          SizedBox(
            width: WIDTH_HEADINGS_STATISTICS.w,
          ),
          for (PlayerOrTeamGameStats stats in game.getPlayerGameStatistics)
            Container(
              width: WIDTH_DATA_STATISTICS.w,
              child: Text(
                stats.getPlayer.getName,
                style: TextStyle(
                  fontSize: FONTSIZE_STATISTICS.sp,
                  color: Utils.getTextColorDarken(context),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
