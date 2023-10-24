import 'package:dart_app/constants.dart';
import 'package:dart_app/models/bot.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/player_stats_in_game/player_or_team_stats_in_game_x01.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class TwoPlayerOrTeamStatsX01 extends StatelessWidget {
  const TwoPlayerOrTeamStatsX01({Key? key, required this.isSingleMode})
      : super(key: key);

  final bool isSingleMode;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Utils.isLandscape(context) ? null : _calcHeight(context),
      child: Selector<GameX01_P, List<PlayerOrTeamGameStats>>(
        selector: (_, gameX01) => isSingleMode
            ? gameX01.getPlayerGameStatistics
            : gameX01.getTeamGameStatistics,
        shouldRebuild: (previous, next) => true,
        builder: (_, stats, __) => ListView.builder(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemCount: stats.length,
          itemBuilder: (BuildContext context, int index) {
            Bot.submitPointsForBot(context);

            return PlayerOrTeamStatsInGameX01(
                currPlayerOrTeamGameStatsX01:
                    stats[index] as PlayerOrTeamGameStatsX01);
          },
        ),
      ),
    );
  }

  double _calcHeight(BuildContext context) {
    final GameSettingsX01_P gameSettingsX01_P =
        context.read<GameSettingsX01_P>();

    if (Utils.isMobile(context)) {
      if (gameSettingsX01_P.getSingleOrTeam == SingleOrTeamEnum.Team) {
        return 42.h;
      } else {
        return 40.h;
      }
    } else {
      // tablet
      if (gameSettingsX01_P.getSingleOrTeam == SingleOrTeamEnum.Team) {
        return 47.h;
      } else {
        return 45.h;
      }
    }
  }
}
