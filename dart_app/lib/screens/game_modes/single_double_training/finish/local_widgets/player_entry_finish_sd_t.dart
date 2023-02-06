import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/game_single_double_training_p.dart';
import 'package:dart_app/models/player_statistics/player_game_stats_single_double_training.dart';
import 'package:dart_app/screens/game_modes/shared/finish/stats_card/local_widgets/name_and_ranking.dart';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class PlayerEntryFinishSingleDoubleTraining extends StatelessWidget {
  const PlayerEntryFinishSingleDoubleTraining({
    Key? key,
    required this.i,
    required this.game,
    required this.playerStats,
    required this.isOpenGame,
    required this.isDraw,
  }) : super(key: key);

  final int i;
  final GameSingleDoubleTraining_P game;
  final PlayerGameStatsSingleDoubleTraining playerStats;
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
          ScoreStats(
            playerStats: playerStats,
            game: game,
          ),
        ],
      ),
    );
  }
}

class ScoreStats extends StatelessWidget {
  const ScoreStats({
    Key? key,
    required this.playerStats,
    required this.game,
  }) : super(key: key);

  final PlayerGameStatsSingleDoubleTraining playerStats;
  final GameSingleDoubleTraining_P game;

  @override
  Widget build(BuildContext context) {
    final bool isSingleTraining = game.getMode == GameMode.SingleTraining;

    return Expanded(
      child: Container(
        padding: EdgeInsets.only(
          left: 4.w,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isSingleTraining)
              Text(
                'Singles: ${playerStats.getSingleHits}',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.white,
                ),
              ),
            if (!isSingleTraining)
              Text(
                'Doubles: ${playerStats.getDoubleHits}',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.white,
                ),
              ),
            if (isSingleTraining)
              Text(
                'Tripples: ${playerStats.getTrippleHits}',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.white,
                ),
              ),
            Text(
              'Missed: ${playerStats.getMissedHits}',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.white,
              ),
            ),
            Text(
              'Total points: ${playerStats.getTotalPoints}',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
