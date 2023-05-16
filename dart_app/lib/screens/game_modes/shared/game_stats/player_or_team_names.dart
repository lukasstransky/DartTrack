import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/models/games/game_cricket_p.dart';
import 'package:dart_app/models/games/game_score_training_p.dart';
import 'package:dart_app/models/games/game_single_double_training_p.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:sizer/sizer.dart';

class PlayerOrTeamNames extends StatelessWidget {
  const PlayerOrTeamNames({
    Key? key,
    required this.game,
  }) : super(key: key);

  final Game_P game;

  @override
  Widget build(BuildContext context) {
    // currently only cricket supports team mode besides single/double, score training
    final dynamic _playerOrTeamStatsList = game is GameCricket_P
        ? Utils.getPlayersOrTeamStatsListStatsScreen(game, game.getGameSettings)
        : game.getPlayerGameStatistics;

    return Row(
      children: [
        if (game is GameSingleDoubleTraining_P || game is GameScoreTraining_P)
          Container(
              width: WIDTH_HEADINGS_STATISTICS.w + PADDING_LEFT_STATISTICS.w),
        for (PlayerOrTeamGameStats stats in _playerOrTeamStatsList)
          Container(
            width: WIDTH_DATA_STATISTICS.w,
            child: Row(
              children: [
                if (Utils.hasPlayerOrTeamWonTheGame(
                    stats, game, game.getGameSettings))
                  Padding(
                    padding: EdgeInsets.only(right: 1.w),
                    child: Icon(
                      Entypo.trophy,
                      size: 14.sp,
                      color: Color(0xffFFD700),
                    ),
                  ),
                if (game is GameCricket_P) ...[
                  if (Utils.playerStatsDisplayedInTeamMode(
                      game, game.getGameSettings)) ...[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          stats.getPlayer.getName,
                          style: TextStyle(
                            fontSize: FONTSIZE_STATISTICS.sp,
                            fontWeight: FontWeight.bold,
                            color: Utils.getTextColorDarken(context),
                          ),
                        ),
                        Text(
                          '(${game.getGameSettings.findTeamForPlayer(stats.getPlayer.getName).getName})',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: Utils.getTextColorDarken(context),
                          ),
                        )
                      ],
                    ),
                  ] else ...[
                    Text(
                      Utils.teamStatsDisplayed(game, game.getGameSettings)
                          ? stats.getTeam.getName
                          : stats.getPlayer.getName,
                      style: TextStyle(
                        fontSize: FONTSIZE_STATISTICS.sp,
                        fontWeight: FontWeight.bold,
                        color: Utils.getTextColorDarken(context),
                      ),
                    ),
                  ]
                ] else ...[
                  Text(
                    stats.getPlayer.getName,
                    style: TextStyle(
                      fontSize: FONTSIZE_STATISTICS.sp,
                      color: Utils.getTextColorDarken(context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }
}
