import 'package:dart_app/models/bot.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/models/games/x01/helper/submit_x01_helper.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/player_stats_in_game/player_or_team_stats_in_game_x01.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:sizer/sizer.dart';
import 'package:tuple/tuple.dart';

class TwoPlayerTeamStatsX01 extends StatelessWidget {
  const TwoPlayerTeamStatsX01({Key? key, required this.isSingleMode})
      : super(key: key);

  final bool isSingleMode;

  _submitPointsForBot(BuildContext context) {
    final GameX01_P gameX01 = context.read<GameX01_P>();

    if (!gameX01.getBotSubmittedPoints &&
        gameX01.getCurrentPlayerToThrow is Bot) {
      final Bot bot = gameX01.getCurrentPlayerToThrow as Bot;
      final Tuple3<String, int, int> tuple = bot.getNextScoredValue(gameX01);

      SubmitX01Helper.submitPoints(
          tuple.item1, context, false, tuple.item2, tuple.item3);
      gameX01.setBotSubmittedPoints = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    late double height;
    if (ResponsiveBreakpoints.of(context).isMobile) {
      height = 35.h;
    } else if (ResponsiveBreakpoints.of(context).isTablet) {
      height = 45.h;
    } else if (ResponsiveBreakpoints.of(context).isDesktop) {
    } else {
      height = 45.h;
    }

    return Container(
      height: height,
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
            _submitPointsForBot(context);

            return PlayerOrTeamStatsInGameX01(
              currPlayerOrTeamGameStatsX01:
                  stats[index] as PlayerOrTeamGameStatsX01,
            );
          },
        ),
      ),
    );
  }
}
