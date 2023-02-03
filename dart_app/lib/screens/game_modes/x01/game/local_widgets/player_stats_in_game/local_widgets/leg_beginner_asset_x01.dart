import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats_x01.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class LegBeginnerDartAssetX01 extends StatelessWidget {
  const LegBeginnerDartAssetX01(
      {Key? key, required this.currPlayerOrTeamGameStatsX01})
      : super(key: key);

  final PlayerOrTeamGameStatsX01? currPlayerOrTeamGameStatsX01;

  bool _showLegBeginnerDartAsset(BuildContext context) {
    final GameX01_P gameX01 = context.read<GameX01_P>();
    final GameSettingsX01_P gameSettingsX01 = context.read<GameSettingsX01_P>();

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
              color: Utils.getTextColorDarken(context),
            )
          : SizedBox.shrink(),
    );
  }
}
