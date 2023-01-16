import 'package:dart_app/models/bot.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/models/games/x01/helper/submit_x01_helper.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_statistics.dart';
import 'package:dart_app/models/player_statistics/x01/player_or_team_game_statistics_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/player_stats_in_game/player_or_team_stats_in_game_x01.dart';
import 'package:dart_app/utils/globals.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:sizer/sizer.dart';
import 'package:tuple/tuple.dart';

class TeamPlayersListX01 extends StatelessWidget {
  const TeamPlayersListX01({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GameX01_P gameX01 = context.read<GameX01_P>();

    return Container(
      height: 35.h,
      child: Selector<GameX01_P, List<PlayerOrTeamGameStatistics>>(
        selector: (_, gameX01) => gameX01.getTeamGameStatistics,
        shouldRebuild: (previous, next) => true,
        builder: (_, teamStats, __) => ScrollablePositionedList.builder(
          itemScrollController: newItemScrollController(),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: teamStats.length,
          itemBuilder: (BuildContext context, int index) {
            if (!gameX01.getBotSubmittedPoints &&
                gameX01.getCurrentPlayerToThrow is Bot) {
              final Bot bot = gameX01.getCurrentPlayerToThrow as Bot;
              final Tuple3<String, int, int> tuple =
                  bot.getNextScoredValue(gameX01);

              SubmitX01Helper.submitPoints(
                  tuple.item1, context, false, tuple.item2, tuple.item3);
              gameX01.setBotSubmittedPoints = true;
            }

            return PlayerOrTeamStatsInGameX01(
              currPlayerOrTeamGameStatsX01:
                  teamStats[index] as PlayerOrTeamGameStatisticsX01,
            );
          },
        ),
      ),
    );
  }
}
