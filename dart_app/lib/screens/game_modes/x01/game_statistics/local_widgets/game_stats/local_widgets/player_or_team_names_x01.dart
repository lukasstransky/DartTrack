import 'package:dart_app/constants.dart';
import 'package:dart_app/models/bot.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats_x01.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:sizer/sizer.dart';

class PlayerOrTeamNamesX01 extends StatelessWidget {
  const PlayerOrTeamNamesX01({Key? key, required this.gameX01})
      : super(key: key);

  final GameX01_P gameX01;

  Flexible _getBotWithLevel(
      PlayerOrTeamGameStatsX01 stats, BuildContext context) {
    return Flexible(
      child: Column(
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'Bot - lvl. ${stats.getPlayer.getLevel}',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
                color: Utils.getTextColorDarken(context),
              ),
            ),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              ' (${stats.getPlayer.getPreDefinedAverage.round() - BOT_AVG_SLIDER_VALUE_RANGE}-${stats.getPlayer.getPreDefinedAverage.round() + BOT_AVG_SLIDER_VALUE_RANGE} avg.)',
              style: TextStyle(
                fontSize: 8.sp,
                fontWeight: FontWeight.bold,
                color: Utils.getTextColorDarken(context),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final GameSettingsX01_P gameSettingsX01 = gameX01.getGameSettings;

    return Row(
      children: [
        for (PlayerOrTeamGameStatsX01 stats
            in Utils.getPlayersOrTeamStatsListStatsScreen(
                gameX01, gameSettingsX01))
          Container(
            width: WIDTH_DATA_STATISTICS.w,
            padding: EdgeInsets.only(right: 1.w),
            child: Row(
              children: [
                if (Utils.hasPlayerOrTeamWonTheGame(
                    stats, gameX01, gameSettingsX01))
                  Padding(
                    padding: EdgeInsets.only(right: 1.w),
                    child: Icon(
                      Entypo.trophy,
                      size: 14.sp,
                      color: Color(0xffFFD700),
                    ),
                  ),
                if (Utils.playerStatsDisplayedInTeamMode(
                    gameX01, gameSettingsX01)) ...[
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (stats.getPlayer is Bot) ...[
                          _getBotWithLevel(stats, context)
                        ] else ...[
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              stats.getPlayer.getName,
                              style: TextStyle(
                                fontSize: FONTSIZE_STATISTICS.sp,
                                fontWeight: FontWeight.bold,
                                color: Utils.getTextColorDarken(context),
                              ),
                            ),
                          ),
                        ],
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            '(${gameSettingsX01.findTeamForPlayer(stats.getPlayer.getName).getName})',
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: Utils.getTextColorDarken(context),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ] else ...[
                  if (stats.getPlayer is Bot) ...[
                    _getBotWithLevel(stats, context)
                  ] else ...[
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          Utils.teamStatsDisplayed(gameX01, gameSettingsX01)
                              ? stats.getTeam.getName
                              : stats.getPlayer.getName,
                          style: TextStyle(
                            fontSize: FONTSIZE_STATISTICS.sp,
                            fontWeight: FontWeight.bold,
                            color: Utils.getTextColorDarken(context),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ],
            ),
          ),
      ],
    );
  }
}
