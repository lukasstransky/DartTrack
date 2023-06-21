import 'package:dart_app/constants.dart';
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
            stats: playerStats,
            isOpenGame: isOpenGame,
            isDraw: isDraw,
          ),
          ScoringStats(
            playerStats: playerStats,
            isRoundMode:
                game.getGameSettings.getMode == ScoreTrainingModeEnum.MaxRounds,
          ),
        ],
      ),
    );
  }
}

class ScoringStats extends StatelessWidget {
  const ScoringStats({
    Key? key,
    required this.playerStats,
    required this.isRoundMode,
  }) : super(key: key);

  final PlayerGameStatsScoreTraining playerStats;
  final bool isRoundMode;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(left: 4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isRoundMode) AverageText(),
            Text(
              'Total score: ${playerStats.getCurrentScore}',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.white,
                fontWeight: isRoundMode ? null : FontWeight.bold,
              ),
            ),
            if (!isRoundMode) AverageText(),
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

  Text AverageText() {
    return Text(
      'Average: ${playerStats.getAverage()}',
      style: TextStyle(
        fontSize: 12.sp,
        color: Colors.white,
        fontWeight: isRoundMode ? FontWeight.bold : null,
      ),
    );
  }
}
