import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/multiple_player_team_stats/local_widgets/player_team_card_x01.dart';
import 'package:dart_app/utils/globals.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class MultiplePlayerTeamStatsX01 extends StatefulWidget {
  MultiplePlayerTeamStatsX01({Key? key, required this.isSingleMode})
      : super(key: key);

  final bool isSingleMode;

  @override
  State<MultiplePlayerTeamStatsX01> createState() =>
      _MultiplePlayerTeamStatsX01State();
}

class _MultiplePlayerTeamStatsX01State
    extends State<MultiplePlayerTeamStatsX01> {
  @override
  void initState() {
    super.initState();
    newScrollControllerGameX01MultiplePlayers();
  }

  @override
  void dispose() {
    scrollControllerGameX01MultiplePlayers.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35.h,
      child: Selector<GameX01_P, List<PlayerOrTeamGameStats>>(
        key: const Key('playerStatsList'),
        selector: (_, gameScoreTraining_P) => widget.isSingleMode
            ? gameScoreTraining_P.getPlayerGameStatistics
            : gameScoreTraining_P.getTeamGameStatistics,
        shouldRebuild: (previous, next) => true,
        builder: (_, playerOrTeamStats, __) {
          return ListView.builder(
            controller: newScrollControllerGameX01MultiplePlayers(),
            scrollDirection: Axis.vertical,
            itemCount: playerOrTeamStats.length,
            shrinkWrap: true,
            padding: EdgeInsets.all(0.0),
            itemBuilder: (BuildContext context, int index) {
              return PlayerTeamCard(
                stats: playerOrTeamStats[index] as PlayerOrTeamGameStatsX01,
              );
            },
          );
        },
      ),
    );
  }
}
