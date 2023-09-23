import 'package:dart_app/models/player_statistics/player_or_team_game_stats_cricket.dart';
import 'package:dart_app/screens/game_modes/cricket/game/local_widgets/game_field/local_widgets/score_of_number_c.dart';

import 'package:flutter/material.dart';

class NumberScoresForPlayerOrTeam extends StatelessWidget {
  const NumberScoresForPlayerOrTeam({
    Key? key,
    required this.playerOrTeamStats,
    required this.i,
  }) : super(key: key);

  final PlayerOrTeamGameStatsCricket playerOrTeamStats;
  final int i;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          ScoreOfNumber(
            playerOrTeamStats: playerOrTeamStats,
            numberToCheck: 20,
            i: i,
          ),
          ScoreOfNumber(
            playerOrTeamStats: playerOrTeamStats,
            numberToCheck: 19,
            i: i,
          ),
          ScoreOfNumber(
            playerOrTeamStats: playerOrTeamStats,
            numberToCheck: 18,
            i: i,
          ),
          ScoreOfNumber(
            playerOrTeamStats: playerOrTeamStats,
            numberToCheck: 17,
            i: i,
          ),
          ScoreOfNumber(
            playerOrTeamStats: playerOrTeamStats,
            numberToCheck: 16,
            i: i,
          ),
          ScoreOfNumber(
            playerOrTeamStats: playerOrTeamStats,
            numberToCheck: 15,
            i: i,
          ),
          ScoreOfNumber(
            playerOrTeamStats: playerOrTeamStats,
            numberToCheck: 25,
            i: i,
          ),
        ],
      ),
    );
  }
}
