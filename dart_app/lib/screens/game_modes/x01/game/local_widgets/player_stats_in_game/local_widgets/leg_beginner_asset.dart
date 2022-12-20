import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_statistics_x01.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class LegBeginnerDartAsset extends StatelessWidget {
  const LegBeginnerDartAsset(
      {Key? key, required this.currPlayerOrTeamGameStatsX01})
      : super(key: key);

  final PlayerOrTeamGameStatisticsX01? currPlayerOrTeamGameStatsX01;

  bool _showLegBeginnerDartAsset(BuildContext context) {
    final GameX01 gameX01 = context.read<GameX01>();
    final GameSettingsX01 gameSettingsX01 = context.read<GameSettingsX01>();

    if (gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Single) {
      return gameX01.getPlayerOrTeamLegStartIndex ==
          gameX01.getPlayerGameStatistics.indexOf(currPlayerOrTeamGameStatsX01);
    }
    return gameX01.getPlayerOrTeamLegStartIndex ==
        gameX01.getTeamGameStatistics.indexOf(currPlayerOrTeamGameStatsX01);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 6.h,
      alignment: Alignment.topLeft,
      padding: EdgeInsets.only(left: 10),
      child: _showLegBeginnerDartAsset(context)
          ? Image.asset(
              'assets/dart_arrow.png',
            )
          : SizedBox.shrink(),
    );
  }
}
