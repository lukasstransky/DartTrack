import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats_x01.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ThreeDartAvgStatsX01 extends StatelessWidget {
  const ThreeDartAvgStatsX01({Key? key, required this.gameX01})
      : super(key: key);

  final GameX01_P gameX01;

  @override
  Widget build(BuildContext context) {
    final GameSettingsX01_P gameSettingsX01 = gameX01.getGameSettings;

    return Padding(
      padding: EdgeInsets.only(top: PADDING_TOP_STATISTICS),
      child: Row(
        children: [
          Container(
            width: 40.w,
            alignment: Alignment.centerLeft,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                '3-Dart avg.',
                style: TextStyle(
                  fontSize: FONTSIZE_STATISTICS.sp,
                  color: Utils.getTextColorDarken(context),
                  fontWeight: FontWeight.bold,
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
                stats.getAverage(gameSettingsX01),
                style: TextStyle(
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
