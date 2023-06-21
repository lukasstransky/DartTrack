import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/screens/game_modes/x01/game_statistics/local_widgets/game_stats/local_widgets/player_or_team_names_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game_statistics/local_widgets/game_stats/local_widgets/legs_sets_won_x01.dart';
import 'package:dart_app/screens/game_modes/shared/game_stats/show_teams_or_players_stats_btn.dart';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class GameStatsX01 extends StatefulWidget {
  const GameStatsX01({Key? key, required this.gameX01}) : super(key: key);

  final GameX01_P gameX01;

  @override
  State<GameStatsX01> createState() => _GameStatsX01State();
}

class _GameStatsX01State extends State<GameStatsX01> {
  @override
  void dispose() {
    widget.gameX01.setAreTeamStatsDisplayed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: PADDING_TOP_STATISTICS.h),
          child: Row(
            children: [
              ShowTeamsOrPlayersStatsBtn(game: widget.gameX01),
              PlayerOrTeamNamesX01(gameX01: widget.gameX01),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: PADDING_TOP_STATISTICS.h),
          transform: Matrix4.translationValues(-2.5.w, 0.0, 0.0),
          child: Text(
            'Game',
            style: TextStyle(
              fontSize: FONTSIZE_HEADING_STATISTICS.sp,
              color: Colors.white,
            ),
          ),
        ),
        LegSetsWonX01(gameX01: widget.gameX01),
      ],
    );
  }
}
