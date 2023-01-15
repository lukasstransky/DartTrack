import 'package:dart_app/models/games/score_training/game_score_training_p.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_statistics.dart';
import 'package:dart_app/screens/game_modes/score_training/game/local_widgets/players_list/local_widgets/multiple_player_stats_score_training.dart';
import 'package:dart_app/screens/game_modes/score_training/game/local_widgets/players_list/local_widgets/one_players_stats_score_training.dart';
import 'package:dart_app/screens/game_modes/score_training/game/local_widgets/players_list/local_widgets/two_player_stats_score_training.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class PlayersListScoreTraining extends StatelessWidget {
  const PlayersListScoreTraining({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<GameScoreTraining_P, List<PlayerOrTeamGameStatistics>>(
      selector: (_, gameScoreTraining_P) =>
          gameScoreTraining_P.getPlayerGameStatistics,
      shouldRebuild: (previous, next) => true,
      builder: (_, playerOrTeamGameStatistics, __) => Container(
        height: 35.h,
        child: playerOrTeamGameStatistics.length == 1
            ? OnePlayerStatsScoreTraining()
            : playerOrTeamGameStatistics.length == 2
                ? TwoPlayerStatsScoreTraining()
                : MulitplePlayerStatsScoreTraining(),
      ),
    );
  }
}
