import 'package:dart_app/constants.dart';
import 'package:dart_app/models/bot.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats_x01.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:sizer/sizer.dart';

class DisplayTeamOrPlayerNamesX01 extends StatelessWidget {
  const DisplayTeamOrPlayerNamesX01({Key? key, required this.gameX01})
      : super(key: key);

  final GameX01_P gameX01;

  bool _hasPlayerOrTeamWonTheGame(PlayerOrTeamGameStatsX01 stats,
      GameX01_P gameX01, GameSettingsX01_P gameSettingsX01) {
    if (Utils.playerStatsDisplayedInTeamMode(gameX01, gameSettingsX01)) {
      return false;
    }

    // set mode
    if (gameSettingsX01.getSetsEnabled) {
      if (gameSettingsX01.getMode == BestOfOrFirstToEnum.BestOf &&
          ((stats.getSetsWon * 2) - 1) == gameSettingsX01.getSets) {
        return true;
      } else if (gameSettingsX01.getMode == BestOfOrFirstToEnum.FirstTo &&
          gameSettingsX01.getSets == stats.getSetsWon) {
        return true;
      } else if (gameSettingsX01.getMode == BestOfOrFirstToEnum.BestOf &&
          stats.getSetsWon == (gameSettingsX01.getSets / 2) + 1) {
        return true;
      }
    } else {
      // win by two legs difference
      if (gameSettingsX01.getWinByTwoLegsDifference) {
        if (gameSettingsX01.getSuddenDeath) {
          final int amountOfLegsForSuddenDeathWin = gameSettingsX01.getLegs +
              gameSettingsX01.getMaxExtraLegs +
              1; // + 1 = sudden death leg

          return stats.getLegsWon == amountOfLegsForSuddenDeathWin;
        } else {
          return gameX01.isLegDifferenceAtLeastTwo(
              stats, gameX01, gameSettingsX01);
        }
      } else {
        // leg mode
        if (gameSettingsX01.getMode == BestOfOrFirstToEnum.BestOf &&
            ((stats.getLegsWonTotal * 2) - 1) == gameSettingsX01.getLegs) {
          return true;
        } else if (gameSettingsX01.getMode == BestOfOrFirstToEnum.FirstTo &&
            stats.getLegsWonTotal >= gameSettingsX01.getLegs) {
          return true;
        } else if (gameSettingsX01.getDrawMode &&
            gameSettingsX01.getMode == BestOfOrFirstToEnum.BestOf &&
            stats.getLegsWonTotal == (gameSettingsX01.getLegs / 2) + 1) {
          return true;
        }
      }
    }

    return false;
  }

  Column _getBotWithLevel(
      PlayerOrTeamGameStatsX01 stats, BuildContext context) {
    return Column(
      children: [
        Text(
          'Bot - lvl. ${stats.getPlayer.getLevel}',
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.bold,
            color: Utils.getTextColorDarken(context),
          ),
        ),
        Text(
          ' (${stats.getPlayer.getPreDefinedAverage.round() - BOT_AVG_SLIDER_VALUE_RANGE}-${stats.getPlayer.getPreDefinedAverage.round() + BOT_AVG_SLIDER_VALUE_RANGE} avg.)',
          style: TextStyle(
            fontSize: 8.sp,
            fontWeight: FontWeight.bold,
            color: Utils.getTextColorDarken(context),
          ),
        )
      ],
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
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
                        _getBotWithLevel(stats, context)
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
                  if (stats.getPlayer is Bot) ...[
                    _getBotWithLevel(stats, context)
                  ] else ...[
                    Text(
                      Utils.teamStatsDisplayed(gameX01, gameSettingsX01)
                          ? stats.getTeam.getName
                          : stats.getPlayer.getName,
                      style: TextStyle(
                        fontSize: FONTSIZE_STATISTICS.sp,
                        fontWeight: FontWeight.bold,
                        color: Utils.getTextColorDarken(context),
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
