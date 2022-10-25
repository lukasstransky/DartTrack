import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_statistics_x01.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class ThreeDartAvg extends StatelessWidget {
  const ThreeDartAvg({Key? key, required this.gameX01}) : super(key: key);

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
              child: Text('3-Dart Avg.',
                  style: TextStyle(fontSize: FONTSIZE_STATISTICS.sp)),
            ),
          ),
          for (PlayerOrTeamGameStatisticsX01 stats
              in Utils.getPlayersOrTeamStatsList(gameX01, gameSettingsX01))
            Container(
              width: WIDTH_DATA_STATISTICS.w,
              child: Text(
                stats.getAverage(),
                style: TextStyle(fontSize: FONTSIZE_STATISTICS.sp),
              ),
            ),
        ],
      ),
    );
  }
}
