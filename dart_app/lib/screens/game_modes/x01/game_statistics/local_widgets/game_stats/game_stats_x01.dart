import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/screens/game_modes/x01/game_statistics/local_widgets/game_stats/local_widgets/display_team_or_player_names_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game_statistics/local_widgets/game_stats/local_widgets/legs_sets_won_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game_statistics/local_widgets/game_stats/local_widgets/show_teams_or_players_stats_btn_x01.dart';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class GameStatsX01 extends StatelessWidget {
  const GameStatsX01({Key? key, required this.gameX01}) : super(key: key);

  final GameX01_P gameX01;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: PADDING_TOP_STATISTICS.h),
          child: Row(
            children: [
              ShowTeamsOrPlayersStatsBtnX01(gameX01: gameX01),
              DisplayTeamOrPlayerNamesX01(gameX01: gameX01),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: PADDING_TOP_STATISTICS.h),
          transform: Matrix4.translationValues(-10.0, 0.0, 0.0),
          child: Text(
            'Game',
            style: TextStyle(
              fontSize: FONTSIZE_HEADING_STATISTICS.sp,
              color: Colors.white,
            ),
          ),
        ),
        LegSetsWonX01(gameX01: gameX01),
      ],
    );
  }
}
