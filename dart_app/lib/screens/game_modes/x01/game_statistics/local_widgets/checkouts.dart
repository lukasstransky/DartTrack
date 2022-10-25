import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_statistics_x01.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class Checkouts extends StatelessWidget {
  const Checkouts({Key? key, required this.gameX01}) : super(key: key);

  final GameX01 gameX01;

  String _getPlayerOrTeamName(bool isSingleMode, GameX01 gameX01,
      GameSettingsX01 gameSettingsX01, PlayerOrTeamGameStatisticsX01 stats) {
    if (isSingleMode ||
        Utils.playerStatsDisplayedInTeamMode(gameX01, gameSettingsX01))
      return stats.getPlayer.getName;

    return stats.getTeam.getName;
  }

  @override
  Widget build(BuildContext context) {
    final GameSettingsX01 gameSettingsX01 = gameX01.getGameSettings;
    final bool isSingleMode =
        gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Single;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(top: 10),
          transform: Matrix4.translationValues(-10.0, 0.0, 0.0),
          child: Text(
            'Checkouts',
            style: TextStyle(
                fontSize: FONTSIZE_HEADING_STATISTICS.sp,
                color: Theme.of(context).primaryColor),
          ),
        ),
        for (String setLegString
            in Utils.getPlayersOrTeamStatsList(gameX01, gameSettingsX01)[0]
                .getAllScoresPerLeg
                .keys)
          Padding(
            padding: EdgeInsets.only(top: PADDING_TOP_STATISTICS),
            child: Row(
              children: [
                Container(
                  width: WIDTH_HEADINGS_STATISTICS.w,
                  alignment: Alignment.centerLeft,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      setLegString,
                      style: TextStyle(fontSize: FONTSIZE_STATISTICS.sp),
                    ),
                  ),
                ),
                for (PlayerOrTeamGameStatisticsX01 stats
                    in Utils.getPlayersOrTeamStatsList(
                        gameX01, gameSettingsX01))
                  Container(
                    width: WIDTH_DATA_STATISTICS.w,
                    child: Text(
                      Utils.getWinnerOfLeg(setLegString, gameX01, context) ==
                              _getPlayerOrTeamName(
                                  isSingleMode, gameX01, gameSettingsX01, stats)
                          ? stats.getCheckouts[setLegString].toString()
                          : '',
                      style: TextStyle(fontSize: FONTSIZE_STATISTICS.sp),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
