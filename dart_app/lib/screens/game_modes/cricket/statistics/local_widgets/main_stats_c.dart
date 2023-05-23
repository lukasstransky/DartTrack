import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_cricket_p.dart';
import 'package:dart_app/models/games/game_cricket_p.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats_cricket.dart';
import 'package:dart_app/screens/game_modes/shared/game_stats/heading_text.dart';
import 'package:dart_app/screens/game_modes/shared/game_stats/section_heading_text.dart';
import 'package:dart_app/screens/game_modes/shared/game_stats/value_text.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class MainStatsCricket extends StatelessWidget {
  const MainStatsCricket({Key? key, required this.game}) : super(key: key);

  final GameCricket_P game;

  @override
  Widget build(BuildContext context) {
    final GameSettingsCricket_P gameSettings = game.getGameSettings;

    return Container(
      padding: EdgeInsets.only(left: PADDING_LEFT_STATISTICS.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeadingGameStats(textValue: 'Game'),
          Row(
            children: [
              Column(
                children: [
                  if (gameSettings.getMode != CricketMode.NoScore)
                    HeadingTextGameStats(textValue: 'Total points'),
                  if (gameSettings.getMode != CricketMode.NoScore &&
                      gameSettings.getLegs > 1 &&
                      !game.getIsGameFinished)
                    HeadingTextGameStats(textValue: 'Current points'),
                  if (gameSettings.getSetsEnabled) ...[
                    HeadingTextGameStats(textValue: 'Sets won'),
                    if (!game.getIsGameFinished)
                      _getHeader(context, 'Legs won ', '(active set)'),
                  ],
                  if (gameSettings.getLegs > 1)
                    HeadingTextGameStats(
                        textValue:
                            'Legs won ${gameSettings.getSetsEnabled ? 'total' : ''}'),
                  _getHeader(context, 'MPR ', '(marks per round)'),
                  HeadingTextGameStats(textValue: 'Thrown darts'),
                ],
              ),
              for (PlayerOrTeamGameStatsCricket stats
                  in Utils.getPlayersOrTeamStatsListStatsScreen(
                      game, gameSettings))
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (gameSettings.getMode != CricketMode.NoScore)
                      ValueTextGameStats(
                          textValue: stats.getTotalPoints.toString()),
                    if (gameSettings.getMode != CricketMode.NoScore &&
                        gameSettings.getLegs > 1 &&
                        !game.getIsGameFinished)
                      ValueTextGameStats(
                          textValue: stats.getCurrentPoints.toString()),
                    if (gameSettings.getSetsEnabled) ...[
                      ValueTextGameStats(
                          textValue: _getSetsWon(gameSettings, stats)),
                      if (!game.getIsGameFinished)
                        ValueTextGameStats(
                            textValue: _getLegsWon(gameSettings, stats)),
                      ValueTextGameStats(
                          textValue: _getLegsWonTotal(gameSettings, stats)),
                    ] else ...[
                      if (gameSettings.getLegs > 1)
                        ValueTextGameStats(
                            textValue: stats.getLegsWon.toString()),
                    ],
                    ValueTextGameStats(textValue: stats.getMarksPerRound()),
                    ValueTextGameStats(
                        textValue: stats.getThrownDarts.toString()),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  String _getSetsWon(
      GameSettingsCricket_P settings, PlayerOrTeamGameStatsCricket stats) {
    if (settings.getSingleOrTeam == SingleOrTeamEnum.Team &&
        !game.getAreTeamStatsDisplayed) {
      for (PlayerOrTeamGameStatsCricket teamStats
          in game.getTeamGameStatistics) {
        if (stats.getTeam.getName == teamStats.getTeam.getName) {
          return teamStats.getSetsWon.toString();
        }
      }
    }

    return stats.getSetsWon.toString();
  }

  String _getLegsWonTotal(
      GameSettingsCricket_P settings, PlayerOrTeamGameStatsCricket stats) {
    if (settings.getSingleOrTeam == SingleOrTeamEnum.Team &&
        !game.getAreTeamStatsDisplayed) {
      for (PlayerOrTeamGameStatsCricket teamStats
          in game.getTeamGameStatistics) {
        if (stats.getTeam.getName == teamStats.getTeam.getName) {
          return teamStats.getLegsWonTotal.toString();
        }
      }
    }

    return stats.getLegsWonTotal.toString();
  }

  String _getLegsWon(
      GameSettingsCricket_P settings, PlayerOrTeamGameStatsCricket stats) {
    if (settings.getSingleOrTeam == SingleOrTeamEnum.Team &&
        !game.getAreTeamStatsDisplayed) {
      for (PlayerOrTeamGameStatsCricket teamStats
          in game.getTeamGameStatistics) {
        if (stats.getTeam.getName == teamStats.getTeam.getName) {
          return teamStats.getLegsWon.toString();
        }
      }
    }

    return stats.getLegsWon.toString();
  }

  _getHeader(BuildContext context, String firstText, String secondText) {
    return Container(
      width: WIDTH_HEADINGS_STATISTICS.w,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(top: PADDING_TOP_STATISTICS.h),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: firstText,
                style: TextStyle(
                  fontSize: FONTSIZE_STATISTICS.sp,
                  fontWeight: FontWeight.bold,
                  color: Utils.getTextColorDarken(context),
                ),
              ),
              TextSpan(
                text: secondText,
                style: TextStyle(
                  fontSize: 8.sp,
                  fontWeight: FontWeight.bold,
                  color: Utils.getTextColorDarken(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
