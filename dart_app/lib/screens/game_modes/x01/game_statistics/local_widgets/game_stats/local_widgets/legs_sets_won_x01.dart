import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats_x01.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class LegSetsWonX01 extends StatelessWidget {
  const LegSetsWonX01({Key? key, required this.gameX01}) : super(key: key);

  final GameX01_P gameX01;

  String _getLegsSetsWon(GameX01_P gameX01, bool shouldReturnSets,
      PlayerOrTeamGameStatsX01 stats, GameSettingsX01_P gameSettingsX01) {
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
    final GameSettingsX01_P gameSettingsX01 = gameX01.getGameSettings;
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
                    setsEnabled ? 'Sets won' : 'Legs won',
                    style: TextStyle(
                      fontSize: FONTSIZE_STATISTICS.sp,
                      fontWeight: FontWeight.bold,
                      color: Utils.getTextColorDarken(context),
                    ),
                  ),
                ),
              ),
              for (PlayerOrTeamGameStatsX01 stats
                  in Utils.getPlayersOrTeamStatsListStatsScreen(
                      gameX01, gameSettingsX01))
                Container(
                  width: WIDTH_DATA_STATISTICS.w,
                  child: Text(
                    _getLegsSetsWon(
                        gameX01, setsEnabled, stats, gameSettingsX01),
                    style: TextStyle(
                      fontSize: FONTSIZE_STATISTICS.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (setsEnabled) ...[
          Padding(
            padding: EdgeInsets.only(top: PADDING_TOP_STATISTICS),
            child: Row(
              children: [
                Container(
                  width: WIDTH_HEADINGS_STATISTICS.w,
                  alignment: Alignment.centerLeft,
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
                ),
                for (PlayerOrTeamGameStatsX01 stats
                    in Utils.getPlayersOrTeamStatsListStatsScreen(
                        gameX01, gameSettingsX01))
                  Container(
                    width: WIDTH_DATA_STATISTICS.w,
                    child: Text(
                      stats.getLegsWon.toString(),
                      style: TextStyle(
                        fontSize: FONTSIZE_STATISTICS.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
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
                      'Legs won total',
                      style: TextStyle(
                        fontSize: FONTSIZE_STATISTICS.sp,
                        fontWeight: FontWeight.bold,
                        color: Utils.getTextColorDarken(context),
                      ),
                    ),
                  ),
                ),
                for (PlayerOrTeamGameStatsX01 stats
                    in Utils.getPlayersOrTeamStatsListStatsScreen(
                        gameX01, gameSettingsX01))
                  Container(
                    width: WIDTH_DATA_STATISTICS.w,
                    child: Text(
                      _getLegsSetsWon(gameX01, false, stats, gameSettingsX01),
                      style: TextStyle(
                        fontSize: FONTSIZE_STATISTICS.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          )
        ]
      ],
    );
  }
}
