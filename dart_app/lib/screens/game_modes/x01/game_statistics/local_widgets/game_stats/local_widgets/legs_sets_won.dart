import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_statistics_x01.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class LegSetsWon extends StatelessWidget {
  const LegSetsWon({Key? key, required this.gameX01}) : super(key: key);

  final GameX01 gameX01;

  String _getLegsSetsWon(GameX01 gameX01, bool shouldReturnSets,
      PlayerOrTeamGameStatisticsX01 stats, GameSettingsX01 gameSettingsX01) {
    if (Utils.playerStatsDisplayedInTeamMode(gameX01, gameSettingsX01)) {
      stats = gameX01.getTeamStatsFromPlayer(stats.getPlayer.getName);
    }

    if (shouldReturnSets) {
      return stats.getSetsWon.toString();
    }

    return stats.getLegsWonTotal.toString();
  }

  @override
  Widget build(BuildContext context) {
    final GameSettingsX01 gameSettingsX01 = gameX01.getGameSettings;
    final bool setsEnabled = gameSettingsX01.getSetsEnabled;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: PADDING_TOP_STATISTICS),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.only(top: PADDING_TOP_STATISTICS),
                width: WIDTH_HEADINGS_STATISTICS.w,
                alignment: Alignment.centerLeft,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    setsEnabled ? 'Sets Won' : 'Legs Won',
                    style: TextStyle(fontSize: FONTSIZE_STATISTICS.sp),
                  ),
                ),
              ),
              for (PlayerOrTeamGameStatisticsX01 stats
                  in Utils.getPlayersOrTeamStatsList(gameX01, gameSettingsX01))
                Container(
                  width: WIDTH_DATA_STATISTICS.w,
                  child: Text(
                    _getLegsSetsWon(
                        gameX01, setsEnabled, stats, gameSettingsX01),
                    style: TextStyle(fontSize: FONTSIZE_STATISTICS.sp),
                  ),
                ),
            ],
          ),
        ),
        if (setsEnabled)
          Padding(
            padding: EdgeInsets.only(top: PADDING_TOP_STATISTICS),
            child: Row(
              children: [
                Container(
                  width: WIDTH_HEADINGS_STATISTICS.w,
                  alignment: Alignment.centerLeft,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text('Legs Won',
                        style: TextStyle(fontSize: FONTSIZE_STATISTICS.sp)),
                  ),
                ),
                for (PlayerOrTeamGameStatisticsX01 stats
                    in Utils.getPlayersOrTeamStatsList(
                        gameX01, gameSettingsX01))
                  Container(
                    width: WIDTH_DATA_STATISTICS.w,
                    child: Text(
                      _getLegsSetsWon(gameX01, false, stats, gameSettingsX01),
                      style: TextStyle(fontSize: FONTSIZE_STATISTICS.sp),
                    ),
                  ),
              ],
            ),
          )
      ],
    );
  }
}
