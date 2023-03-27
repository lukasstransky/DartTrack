import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats_x01.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class DartsPerLegAvgX01 extends StatelessWidget {
  const DartsPerLegAvgX01({Key? key, required this.gameX01}) : super(key: key);

  final GameX01_P gameX01;

  String _getDartsPerLeg(PlayerOrTeamGameStatsX01 stats, GameX01_P gameX01,
      GameSettingsX01_P gameSettingsX01) {
    if (Utils.playerStatsDisplayedInTeamMode(gameX01, gameSettingsX01))
      stats = gameX01.getTeamStatsFromPlayer(stats.getPlayer.getName);

    if (stats.getLegsWonTotal == 0) {
      return '-';
    }
    int dartsPerLeg = 0;
    int games = 0;
    stats.getCheckouts.keys.forEach((key) {
      dartsPerLeg += stats.getThrownDartsPerLeg[key] as int;
      games++;
    });

    final String result = (dartsPerLeg / games).toStringAsFixed(2);
    final String decimalPlaces = result.substring(result.length - 2);

    if (decimalPlaces == '00') {
      return result.substring(0, result.length - 3);
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final GameSettingsX01_P gameSettingsX01 = gameX01.getGameSettings;

    return Padding(
      padding: EdgeInsets.only(top: PADDING_TOP_STATISTICS.h),
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
                    new TextSpan(text: 'Darts/leg'),
                    new TextSpan(
                      text: ' (avg.)',
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
          for (PlayerOrTeamGameStatsX01 stats
              in Utils.getPlayersOrTeamStatsListStatsScreen(
                  gameX01, gameSettingsX01))
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
