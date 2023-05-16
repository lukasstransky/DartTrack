import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_cricket_p.dart';
import 'package:dart_app/models/game_settings/game_settings_p.dart';
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
    required this.stats,
    required this.isOpenGame,
    this.isDraw = false,
  }) : super(key: key);

  final int i;
  final Game_P game;
  final PlayerOrTeamGameStats stats;
  final bool isOpenGame;
  final bool isDraw;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(left: 5.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            !isDraw
                ? Container(
                    width: 5.w,
                    child: Text(
                      '${(i + 1)}.',
                      style: TextStyle(
                        fontSize: i == 0 && !isOpenGame ? 14.sp : 12.sp,
                        fontWeight: FontWeight.bold,
                        color: Utils.getTextColorDarken(context),
                      ),
                    ),
                  )
                : SizedBox.shrink(),
            if (i == 0 && !isOpenGame && !isDraw)
              Container(
                padding: EdgeInsets.only(left: 3.w),
                transform: Matrix4.translationValues(0.0, -2.0, 0.0),
                child: Icon(
                  Entypo.trophy,
                  size: 12.sp,
                  color: Color(0xffFFD700),
                ),
              ),
            Flexible(
              child: Container(
                padding: EdgeInsets.only(left: 3.w),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    _getPlayerOrTeamName(game.getGameSettings, stats),
                    style: TextStyle(
                      fontSize: i == 0 && !isOpenGame ? 14.sp : 12.sp,
                      color: Utils.getTextColorDarken(context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _getPlayerOrTeamName(
    GameSettings_P gameSettings, PlayerOrTeamGameStats stats) {
  if (gameSettings is GameSettingsCricket_P &&
      gameSettings.getSingleOrTeam == SingleOrTeamEnum.Team) {
    return stats.getTeam.getName;
  }

  return stats.getPlayer.getName;
}
