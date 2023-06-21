import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_cricket_p.dart';
import 'package:dart_app/models/games/game_cricket_p.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats_cricket.dart';
import 'package:dart_app/screens/game_modes/shared/finish/stats_card/local_widgets/name_and_ranking.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class PlayerOrTeamEntryFinishCricket extends StatelessWidget {
  const PlayerOrTeamEntryFinishCricket({
    Key? key,
    required this.i,
    required this.game,
    required this.stats,
    required this.isOpenGame,
  }) : super(key: key);

  final int i;
  final GameCricket_P game;
  final PlayerOrTeamGameStatsCricket stats;
  final bool isOpenGame;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: (i == game.getPlayerGameStatistics.length - 1 ||
                i == game.getTeamGameStatistics.length - 1)
            ? 1.h
            : 0,
      ),
      child: Row(
        children: [
          NameAndRanking(
            i: i,
            game: game,
            stats: stats,
            isOpenGame: isOpenGame,
          ),
          ScoringStats(
            stats: stats,
            settings: game.getGameSettings,
            isOpenGame: isOpenGame,
          ),
        ],
      ),
    );
  }
}

class ScoringStats extends StatelessWidget {
  const ScoringStats({
    Key? key,
    required this.stats,
    required this.settings,
    required this.isOpenGame,
  }) : super(key: key);

  final PlayerOrTeamGameStatsCricket stats;
  final GameSettingsCricket_P settings;
  final bool isOpenGame;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(left: 4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (settings.getSetsEnabled) ...[
              Row(
                children: [
                  Text(
                    'Sets: ${stats.getSetsWon} ',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.white,
                    ),
                  ),
                  if (isOpenGame)
                    Text(
                      'Legs: ${stats.getLegsWon}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white,
                      ),
                    ),
                ],
              ),
            ] else
              Text(
                'Legs: ${stats.getLegsWon}',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.white,
                ),
              ),
            Text(
              'MPR: ${stats.getMarksPerRound()}',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.white,
              ),
            ),
            if (settings.getMode != CricketMode.NoScore)
              Text(
                'Total points: ${stats.getTotalPoints.toString()}',
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
