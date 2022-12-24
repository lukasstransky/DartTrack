import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_statistics_x01.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class DartsPerLegAvg extends StatelessWidget {
  const DartsPerLegAvg({Key? key, required this.gameX01}) : super(key: key);

  final GameX01 gameX01;

  String _getDartsPerLeg(PlayerOrTeamGameStatisticsX01 stats, GameX01 gameX01,
      GameSettingsX01 gameSettingsX01) {
    if (Utils.playerStatsDisplayedInTeamMode(gameX01, gameSettingsX01))
      stats = gameX01.getTeamStatsFromPlayer(stats.getPlayer.getName);

    if (stats.getLegsWonTotal == 0) return '-';

    int dartsPerLeg = 0;
    int games = 0;
    stats.getCheckouts.keys.forEach((key) {
      dartsPerLeg += stats.getThrownDartsPerLeg[key] as int;
      games++;
    });

    return (dartsPerLeg / games).toStringAsFixed(2);
  }

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
              child: RichText(
                text: TextSpan(
                  style: new TextStyle(
                    fontSize: FONTSIZE_STATISTICS.sp,
                    fontWeight: FontWeight.bold,
                    color: Utils.getTextColorDarken(context),
                  ),
                  children: <TextSpan>[
                    new TextSpan(text: 'Darts/Leg'),
                    new TextSpan(
                      text: ' (Avg.)',
                      style: new TextStyle(
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
          for (PlayerOrTeamGameStatisticsX01 stats
              in Utils.getPlayersOrTeamStatsList(gameX01, gameSettingsX01))
            Container(
              width: WIDTH_DATA_STATISTICS.w,
              child: Text(
                _getDartsPerLeg(stats, gameX01, gameSettingsX01),
                style: new TextStyle(
                  fontSize: FONTSIZE_STATISTICS.sp,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
