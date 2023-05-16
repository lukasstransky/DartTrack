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
                  if (gameSettings.getMode != CricketMode.NoScore)
                    HeadingTextGameStats(textValue: 'Current points'),
                  if (gameSettings.getSetsEnabled)
                    HeadingTextGameStats(textValue: 'Sets'),
                  if (gameSettings.getLegs > 1)
                    HeadingTextGameStats(
                        textValue:
                            'Legs won ${gameSettings.getSetsEnabled ? 'total' : ''}'),
                  _getLegsWonHeadingForActiveSet(gameSettings, context),
                  HeadingTextGameStats(textValue: 'MPR'),
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
                    if (gameSettings.getMode != CricketMode.NoScore)
                      ValueTextGameStats(
                          textValue: stats.getCurrentPoints.toString()),
                    if (gameSettings.getSetsEnabled) ...[
                      ValueTextGameStats(
                          textValue: stats.getSetsWon.toString()),
                      ValueTextGameStats(
                          textValue: stats.getLegsWonTotal.toString()),
                    ],
                    if (gameSettings.getLegs > 1)
                      ValueTextGameStats(
                          textValue: stats.getLegsWon.toString()),
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

  _getLegsWonHeadingForActiveSet(
      GameSettingsCricket_P gameSettingsCricket, BuildContext context) {
    if (gameSettingsCricket.getSetsEnabled) {
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
                  text: 'Legs won ',
                  style: TextStyle(
                    fontSize: FONTSIZE_STATISTICS.sp,
                    fontWeight: FontWeight.bold,
                    color: Utils.getTextColorDarken(context),
                  ),
                ),
                TextSpan(
                  text: '(active set)',
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
    return SizedBox.shrink();
  }
}
