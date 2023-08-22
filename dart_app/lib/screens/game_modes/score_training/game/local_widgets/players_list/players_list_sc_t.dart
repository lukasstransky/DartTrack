import 'package:dart_app/models/games/game_score_training_p.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats.dart';
import 'package:dart_app/screens/game_modes/score_training/game/local_widgets/players_list/local_widgets/multiple_player_stats_sc_t.dart';
import 'package:dart_app/screens/game_modes/score_training/game/local_widgets/players_list/local_widgets/one_players_stats_sc_t.dart';
import 'package:dart_app/screens/game_modes/score_training/game/local_widgets/players_list/local_widgets/two_player_stats_sc_t.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:sizer/sizer.dart';

class PlayersListScoreTraining extends StatelessWidget {
  const PlayersListScoreTraining({Key? key}) : super(key: key);

  _getWidget(int length) {
    if (length == 1) {
      return OnePlayerStatsScoreTraining();
    } else if (length == 2) {
      return TwoPlayerStatsScoreTraining();
    } else {
      return MulitplePlayerStatsScoreTraining();
    }
  }

  double _getHeight(BuildContext context) {
    if (ResponsiveBreakpoints.of(context).isMobile) {
      return 35.h;
    }
    return 45.h;
  }

  @override
  Widget build(BuildContext context) {
    return Selector<GameScoreTraining_P, List<PlayerOrTeamGameStats>>(
      selector: (_, game) => game.getPlayerGameStatistics,
      shouldRebuild: (previous, next) => true,
      builder: (_, stats, __) => Container(
        height: _getHeight(context),
        child: _getWidget(stats.length),
      ),
    );
  }
}
