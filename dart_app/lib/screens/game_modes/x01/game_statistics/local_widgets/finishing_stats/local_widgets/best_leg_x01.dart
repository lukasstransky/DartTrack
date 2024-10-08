import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats_x01.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class BestLegX01 extends StatelessWidget {
  const BestLegX01({Key? key, required this.gameX01}) : super(key: key);

  final GameX01_P gameX01;

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
              child: Text(
                'Best leg',
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
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
                Utils.playerStatsDisplayedInTeamMode(gameX01, gameSettingsX01)
                    ? gameX01
                        .getTeamStatsFromPlayer(stats.getPlayer.getName)
                        .getBestLeg()
                    : stats.getBestLeg(),
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
