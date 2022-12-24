import 'package:dart_app/constants.dart';
import 'package:dart_app/models/bot.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_statistics_x01.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:sizer/sizer.dart';

class DisplayTeamOrPlayerNames extends StatelessWidget {
  const DisplayTeamOrPlayerNames({Key? key, required this.gameX01})
      : super(key: key);

  final GameX01 gameX01;

  bool _hasPlayerOrTeamWonTheGame(PlayerOrTeamGameStatisticsX01 stats,
      GameX01 gameX01, GameSettingsX01 gameSettingsX01) {
    if (Utils.playerStatsDisplayedInTeamMode(gameX01, gameSettingsX01)) {
      return false;
    }

    if (gameSettingsX01.getSetsEnabled) {
      if (gameSettingsX01.getSets == stats.getSetsWon) {
        return true;
      }
    } else {
      if (gameSettingsX01.getLegs == stats.getLegsWon) {
        return true;
      }
    }

    return false;
  }

  Row _getBotWithLevel(int level, BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'Bot',
          style: TextStyle(
            fontSize: FONTSIZE_STATISTICS.sp,
            fontWeight: FontWeight.bold,
            color: Utils.getTextColorDarken(context),
          ),
        ),
        Container(
          transform: Matrix4.translationValues(0.0, -1.0, 0.0),
          child: Text(
            ' (Lvl. ${level})',
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
              color: Utils.getTextColorDarken(context),
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final GameSettingsX01 gameSettingsX01 = gameX01.getGameSettings;

    return Row(
      children: [
        for (PlayerOrTeamGameStatisticsX01 stats
            in Utils.getPlayersOrTeamStatsList(gameX01, gameSettingsX01))
          Container(
            width: WIDTH_DATA_STATISTICS.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  transform: Matrix4.translationValues(
                      _hasPlayerOrTeamWonTheGame(
                              stats, gameX01, gameSettingsX01)
                          ? -25.0
                          : 0.0,
                      0.0,
                      0.0),
                  child: Row(
                    children: [
                      if (_hasPlayerOrTeamWonTheGame(
                              stats, gameX01, gameSettingsX01) &&
                          !Utils.playerStatsDisplayedInTeamMode(
                              gameX01, gameSettingsX01))
                        Padding(
                          padding: EdgeInsets.only(right: 5),
                          child: Icon(
                            Entypo.trophy,
                            size: 14.sp,
                            color: Color(0xffFFD700),
                          ),
                        ),
                      if (Utils.playerStatsDisplayedInTeamMode(
                          gameX01, gameSettingsX01)) ...[
                        Column(
                          children: [
                            if (stats.getPlayer is Bot) ...[
                              _getBotWithLevel(
                                  stats.getPlayer.getLevel, context)
                            ] else ...[
                              Text(
                                stats.getPlayer.getName,
                                style: TextStyle(
                                  fontSize: FONTSIZE_STATISTICS.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Utils.getTextColorDarken(context),
                                ),
                              ),
                            ],
                            Text(
                              '${gameSettingsX01.findTeamForPlayer(stats.getPlayer.getName, gameSettingsX01).getName}',
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: Utils.getTextColorDarken(context),
                              ),
                            )
                          ],
                        )
                      ] else ...[
                        if (Utils.teamStatsDisplayed(
                            gameX01, gameSettingsX01)) ...[
                          Text(
                            stats.getTeam.getName,
                            style: TextStyle(
                              fontSize: FONTSIZE_STATISTICS.sp,
                              fontWeight: FontWeight.bold,
                              color: Utils.getTextColorDarken(context),
                            ),
                          ),
                        ] else ...[
                          if (stats.getPlayer is Bot) ...[
                            _getBotWithLevel(stats.getPlayer.getLevel, context)
                          ] else ...[
                            Text(
                              stats.getPlayer.getName,
                              style: TextStyle(
                                fontSize: FONTSIZE_STATISTICS.sp,
                                fontWeight: FontWeight.bold,
                                color: Utils.getTextColorDarken(context),
                              ),
                            ),
                          ],
                        ],
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
