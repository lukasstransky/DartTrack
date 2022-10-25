import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game_statistics/local_widgets/game_stats/local_widgets/display_team_or_player_names.dart';
import 'package:dart_app/screens/game_modes/x01/game_statistics/local_widgets/game_stats/local_widgets/legs_sets_won.dart';
import 'package:dart_app/screens/game_modes/x01/game_statistics/local_widgets/game_stats/local_widgets/show_teams_or_players_stats_btn.dart';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class GameStats extends StatelessWidget {
  const GameStats({Key? key, required this.gameX01}) : super(key: key);

  final GameX01 gameX01;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: PADDING_TOP_STATISTICS),
          child: Row(
            children: [
              ShowTeamsOrPlayersStatsBtn(gameX01: gameX01),
              DisplayTeamOrPlayerNames(gameX01: gameX01),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: PADDING_TOP_STATISTICS),
          transform: Matrix4.translationValues(-10.0, 0.0, 0.0),
          child: Text(
            'Game',
            style: TextStyle(
                fontSize: FONTSIZE_HEADING_STATISTICS.sp,
                color: Theme.of(context).primaryColor),
          ),
        ),
        LegSetsWon(gameX01: gameX01),
      ],
    );
  }
}
