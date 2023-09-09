import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/multiple_player_team_stats/local_widgets/player_team_card_x01.dart';
import 'package:dart_app/utils/utils.dart';

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
  final ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GameX01_P gameX01 = context.read<GameX01_P>();
    final GameSettingsX01_P gameSettingsX01 = context.read<GameSettingsX01_P>();

    return Expanded(
      child: Container(
        height: Utils.isLandscape(context)
            ? null
            : _calcHeight(context, gameSettingsX01),
        child: Selector<GameX01_P, List<PlayerOrTeamGameStats>>(
          key: const Key('playerStatsList'),
          selector: (_, gameScoreTraining_P) => widget.isSingleMode
              ? gameScoreTraining_P.getPlayerGameStatistics
              : gameScoreTraining_P.getTeamGameStatistics,
          shouldRebuild: (previous, next) => true,
          builder: (_, playerOrTeamStats, __) {
            _scrollToTopBottomIfNeccessary(gameX01, gameSettingsX01);
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
      ),
    );
  }

  double _calcHeight(BuildContext context, GameSettingsX01_P gameSettingsX01) {
    if (Utils.isMobile(context)) {
      if (gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Team) {
        return 37.h;
      } else {
        return 35.h;
      }
    } else {
      // tablet
      if (gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Team) {
        return 47.h;
      } else {
        return 45.h;
      }
    }
  }

  void _scrollToTopBottomIfNeccessary(
      GameX01_P gameX01, GameSettingsX01_P gameSettingsX01) {
    final int index = gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Single
        ? gameSettingsX01.getPlayers.indexOf(gameX01.getCurrentPlayerToThrow)
        : gameSettingsX01.getTeams.indexOf(gameX01.getCurrentTeamToThrow);

    // if sets enabled -> card takes up more space
    if (gameSettingsX01.getSetsEnabled ? index == 3 : index == 4) {
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
