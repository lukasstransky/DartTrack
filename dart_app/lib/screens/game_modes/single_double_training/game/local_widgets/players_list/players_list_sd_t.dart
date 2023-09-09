import 'package:dart_app/models/games/game_single_double_training_p.dart';
import 'package:dart_app/models/player_statistics/player_game_stats_single_double_training.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats.dart';
import 'package:dart_app/screens/game_modes/single_double_training/game/local_widgets/players_list/local_widgets/multiple_player_stats_sd_t.dart';
import 'package:dart_app/screens/game_modes/single_double_training/game/local_widgets/players_list/local_widgets/player_entry_game_sd_t.dart';
import 'package:dart_app/screens/game_modes/single_double_training/game/local_widgets/players_list/local_widgets/two_player_stats_sd_t.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class PlayersListSingleDoubleTraining extends StatelessWidget {
  const PlayersListSingleDoubleTraining({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<GameSingleDoubleTraining_P, List<PlayerOrTeamGameStats>>(
      selector: (_, game) => game.getPlayerGameStatistics,
      shouldRebuild: (previous, next) => true,
      builder: (_, stats, __) => Container(
        height: Utils.isLandscape(context) ? null : _calcHeight(context),
        child: _getWidget(stats),
      ),
    );
  }

  Widget _getWidget(List<PlayerOrTeamGameStats> stats) {
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

  double _calcHeight(BuildContext context) {
    if (Utils.isMobile(context)) {
      return 40.h;
    } else {
      // tablet
      return 50.h;
    }
  }
}
