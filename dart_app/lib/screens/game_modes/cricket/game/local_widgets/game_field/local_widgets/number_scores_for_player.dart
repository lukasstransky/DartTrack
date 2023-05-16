import 'package:dart_app/models/player_statistics/player_or_team_game_stats_cricket.dart';
import 'package:dart_app/screens/game_modes/cricket/game/local_widgets/game_field/local_widgets/score_of_number_c.dart';

import 'package:flutter/material.dart';

class NumberScoresForPlayerOrTeam extends StatelessWidget {
  const NumberScoresForPlayerOrTeam({
    Key? key,
    required this.playerOrTeamStats,
  }) : super(key: key);

  final PlayerOrTeamGameStatsCricket playerOrTeamStats;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          ScoreOfNumber(
            playerOrTeamStats: playerOrTeamStats,
            numberToCheck: 20,
          ),
          ScoreOfNumber(
            playerOrTeamStats: playerOrTeamStats,
            numberToCheck: 19,
          ),
          ScoreOfNumber(
            playerOrTeamStats: playerOrTeamStats,
            numberToCheck: 18,
          ),
          ScoreOfNumber(
            playerOrTeamStats: playerOrTeamStats,
            numberToCheck: 17,
          ),
          ScoreOfNumber(
            playerOrTeamStats: playerOrTeamStats,
            numberToCheck: 16,
          ),
          ScoreOfNumber(
            playerOrTeamStats: playerOrTeamStats,
            numberToCheck: 15,
          ),
          ScoreOfNumber(
            playerOrTeamStats: playerOrTeamStats,
            numberToCheck: 25,
          ),
        ],
      ),
    );
  }
}
