import 'package:dart_app/models/games/game_score_training_p.dart';
import 'package:dart_app/models/player_statistics/player_game_stats_score_training.dart';
import 'package:dart_app/screens/game_modes/shared/finish/stats_card/local_widgets/name_and_ranking.dart';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class PlayerEntryFinishScoreTraining extends StatelessWidget {
  const PlayerEntryFinishScoreTraining({
    Key? key,
    required this.i,
    required this.game,
    required this.playerStats,
    required this.isOpenGame,
    required this.isDraw,
  }) : super(key: key);

  final int i;
  final GameScoreTraining_P game;
  final PlayerGameStatsScoreTraining playerStats;
  final bool isOpenGame;
  final bool isDraw;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: (i == game.getPlayerGameStatistics.length - 1) ? 1.h : 0,
      ),
      child: Row(
        children: [
          NameAndRanking(
            i: i,
            game: game,
            playerStats: playerStats,
            isOpenGame: isOpenGame,
            isDraw: isDraw,
          ),
          ScoringStats(playerStats: playerStats),
        ],
      ),
    );
  }
}

class ScoringStats extends StatelessWidget {
  const ScoringStats({
    Key? key,
    required this.playerStats,
  }) : super(key: key);

  final PlayerGameStatsScoreTraining playerStats;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(
          left: 4.w,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Points: ${playerStats.getCurrentScore}',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.white,
              ),
            ),
            Text(
              'Average: ${playerStats.getAverage()}',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.white,
              ),
            ),
            Text(
              'Highest score: ${playerStats.getHighestScore()}',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
