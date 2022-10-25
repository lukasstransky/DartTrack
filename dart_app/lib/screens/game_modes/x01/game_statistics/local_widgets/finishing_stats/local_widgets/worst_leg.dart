import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_statistics_x01.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class WorstLeg extends StatelessWidget {
  const WorstLeg({Key? key, required this.gameX01}) : super(key: key);

  final GameX01 gameX01;

  @override
  Widget build(BuildContext context) {
    final GameSettingsX01 gameSettingsX01 = gameX01.getGameSettings;

    return Padding(
      padding: EdgeInsets.only(top: PADDING_TOP_STATISTICS),
      child: Row(
        children: [
          Container(
            width: WIDTH_HEADINGS_STATISTICS.w,
            alignment: Alignment.centerLeft,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'Worst Leg',
                style: TextStyle(fontSize: FONTSIZE_STATISTICS.sp),
              ),
            ),
          ),
          for (PlayerOrTeamGameStatisticsX01 stats
              in Utils.getPlayersOrTeamStatsList(gameX01, gameSettingsX01))
            Container(
              width: WIDTH_DATA_STATISTICS.w,
              child: Text(
                Utils.playerStatsDisplayedInTeamMode(gameX01, gameSettingsX01)
                    ? gameX01
                        .getTeamStatsFromPlayer(stats.getPlayer.getName)
                        .getWorstLeg()
                    : stats.getBestLeg(),
                style: TextStyle(fontSize: FONTSIZE_STATISTICS.sp),
              ),
            ),
        ],
      ),
    );
  }
}
