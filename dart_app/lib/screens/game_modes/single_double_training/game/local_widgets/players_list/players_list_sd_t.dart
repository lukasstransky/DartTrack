import 'package:dart_app/models/games/game_single_double_training_p.dart';
import 'package:dart_app/models/player_statistics/player_game_stats_single_double_training.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats.dart';
import 'package:dart_app/screens/game_modes/single_double_training/game/local_widgets/players_list/local_widgets/multiple_player_stats_sd_t.dart';
import 'package:dart_app/screens/game_modes/single_double_training/game/local_widgets/players_list/local_widgets/player_entry_game_sd_t.dart';
import 'package:dart_app/screens/game_modes/single_double_training/game/local_widgets/players_list/local_widgets/two_player_stats_sd_t.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:sizer/sizer.dart';

class PlayersListSingleDoubleTraining extends StatelessWidget {
  const PlayersListSingleDoubleTraining({Key? key}) : super(key: key);

  _getWidget(List<PlayerOrTeamGameStats> stats) {
    final int length = stats.length;

    if (length == 1) {
      return PlayerEntryGameSingleDoubleTraining(
        playerStats: stats[0] as PlayerGameStatsSingleDoubleTraining,
      );
    } else if (length == 2) {
      return TwoPlayerStatsSingleDoubleTraining();
    } else {
      return MulitplePlayerStatsSingleDoubleTraining();
    }
  }

  _getHeight(BuildContext context) {
    if (ResponsiveBreakpoints.of(context).isMobile) {
      return 40.h;
    } else if (ResponsiveBreakpoints.of(context).isTablet ||
        ResponsiveBreakpoints.of(context).isDesktop) {
      return 50.h;
    } else {
      return 50.h;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Selector<GameSingleDoubleTraining_P, List<PlayerOrTeamGameStats>>(
      selector: (_, game) => game.getPlayerGameStatistics,
      shouldRebuild: (previous, next) => true,
      builder: (_, stats, __) => Container(
        height: _getHeight(context),
        child: _getWidget(stats),
      ),
    );
  }
}
