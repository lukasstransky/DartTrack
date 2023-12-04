import 'package:dart_app/constants.dart';
import 'package:dart_app/models/bot.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/multiple_player_team_stats/local_widgets/player_team_card_x01.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  late ScrollController scrollController;

  @override
  void initState() {
    scrollController = new ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GameSettingsX01_P gameSettingsX01 = context.read<GameSettingsX01_P>();
    final GameX01_P gameX01 = context.read<GameX01_P>();

    return Expanded(
      child: Selector<GameX01_P, List<PlayerOrTeamGameStats>>(
        key: const Key('playerStatsList'),
        selector: (_, gameScoreTraining_P) => widget.isSingleMode
            ? gameScoreTraining_P.getPlayerGameStatistics
            : gameScoreTraining_P.getTeamGameStatistics,
        shouldRebuild: (previous, next) => true,
        builder: (_, playerOrTeamStats, __) {
          _scrollToTopBottomIfNeccessary(gameX01, gameSettingsX01);
          Bot.submitPointsForBot(context);

          return ListView.builder(
            controller: scrollController,
            scrollDirection: Axis.vertical,
            itemCount: playerOrTeamStats.length,
            shrinkWrap: true,
            padding: EdgeInsets.zero,
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

  void _scrollToTopBottomIfNeccessary(
      GameX01_P gameX01, GameSettingsX01_P gameSettingsX01) {
    final bool isSingleMode =
        gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Single;
    if ((isSingleMode && gameX01.getCurrentPlayerToThrow == null) ||
        (!isSingleMode && gameX01.getCurrentTeamToThrow == null)) {
      return;
    }
    final int index = isSingleMode
        ? gameSettingsX01.getPlayers.indexOf(gameX01.getCurrentPlayerToThrow)
        : gameSettingsX01.getTeams.indexOf(gameX01.getCurrentTeamToThrow);

    // if sets enabled -> card takes up more space
    if (gameSettingsX01.getSetsEnabled ? index == 4 : index == 4) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      });
    } else if (index == 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollController.animateTo(
          scrollController.position.minScrollExtent,
          duration: Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      });
    }
  }
}
