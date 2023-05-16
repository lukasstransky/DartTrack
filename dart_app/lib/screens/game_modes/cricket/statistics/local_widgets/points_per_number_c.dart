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

class PointsPerNumberCricket extends StatelessWidget {
  const PointsPerNumberCricket({Key? key, required this.game})
      : super(key: key);

  final GameCricket_P game;

  @override
  Widget build(BuildContext context) {
    final GameSettingsCricket_P gameSettings = game.getGameSettings;

    return Container(
      padding: EdgeInsets.only(left: PADDING_LEFT_STATISTICS.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeadingGameStats(textValue: 'Points per number'),
          Row(
            children: [
              Column(
                children: [
                  for (int i = 15; i < 21; i++)
                    HeadingTextGameStats(textValue: i.toString()),
                  HeadingTextGameStats(textValue: 'Bull'),
                ],
              ),
              for (PlayerOrTeamGameStatsCricket stats
                  in Utils.getPlayersOrTeamStatsListStatsScreen(
                      game, gameSettings))
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int i = 15; i < 21; i++)
                      ValueTextGameStats(
                          textValue: stats.getPointsPerNumbers[i].toString()),
                    ValueTextGameStats(
                        textValue: stats.getPointsPerNumbers[25].toString()),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
