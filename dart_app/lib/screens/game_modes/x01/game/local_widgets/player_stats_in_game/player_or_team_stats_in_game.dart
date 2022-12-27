import 'package:dart_app/constants.dart';
import 'package:dart_app/models/bot.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_statistics_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/player_stats_in_game/local_widgets/finish_ways.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/player_stats_in_game/local_widgets/game_stats.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/player_stats_in_game/local_widgets/leg_beginner_asset.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/player_stats_in_game/local_widgets/sets_legs_score.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:provider/provider.dart';

class PlayerOrTeamStatsInGame extends StatelessWidget {
  const PlayerOrTeamStatsInGame(
      {Key? key, required this.currPlayerOrTeamGameStatsX01})
      : super(key: key);

  final PlayerOrTeamGameStatisticsX01? currPlayerOrTeamGameStatsX01;

  Color _getBackgroundColor(
      GameX01 gameX01, GameSettingsX01 gameSettingsX01, BuildContext context) {
    if (gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Single) {
      if (Player.samePlayer(gameX01.getCurrentPlayerToThrow,
          this.currPlayerOrTeamGameStatsX01!.getPlayer)) {
        return Utils.lighten(Theme.of(context).colorScheme.primary, 20);
      }
    } else {
      if (this.currPlayerOrTeamGameStatsX01!.getTeam == null) {
        return Colors.transparent;
      }
      if (this.currPlayerOrTeamGameStatsX01!.getTeam.getName ==
          gameX01.getCurrentTeamToThrow.getName) {
        return Colors.grey;
      }
    }

    return Colors.transparent;
  }

  bool _shouldDisplayRightBorder(GameX01 gameX01) {
    return gameX01.getPlayerGameStatistics
            .indexOf(currPlayerOrTeamGameStatsX01) !=
        gameX01.getPlayerGameStatistics.length - 1;
  }

  @override
  Widget build(BuildContext context) {
    final GameX01 gameX01 = context.read<GameX01>();
    final GameSettingsX01 gameSettingsX01 = context.read<GameSettingsX01>();
    final bool isSingleMode =
        gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Single;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Utils.getPrimaryColorDarken(context),
            width: 3,
          ),
          right: _shouldDisplayRightBorder(gameX01)
              ? BorderSide(
                  color: Utils.getPrimaryColorDarken(context),
                  width: 3,
                )
              : BorderSide.none,
        ),
      ),
      width: 50.w,
      child: Container(
        color: _getBackgroundColor(gameX01, gameSettingsX01, context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LegBeginnerDartAsset(
                currPlayerOrTeamGameStatsX01:
                    this.currPlayerOrTeamGameStatsX01),
            Container(
              transform: Matrix4.translationValues(
                  0.0, isSingleMode ? -15 : -25.0, 0.0),
              child: Column(
                children: [
                  if (isSingleMode) ...[
                    single(context),
                  ] else ...[
                    team(),
                  ],
                  SetsLegsScore(
                      currPlayerOrTeamGameStatsX01:
                          this.currPlayerOrTeamGameStatsX01),
                  Consumer<GameSettingsX01>(
                    builder: (_, gameSettings, __) => GameStats(
                        currPlayerOrTeamGameStatsX01:
                            this.currPlayerOrTeamGameStatsX01),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column team() {
    return Column(
      children: [
        Container(
          transform: Matrix4.translationValues(0.0, 5.0, 0.0),
          child: Column(
            children: [
              Text(
                currPlayerOrTeamGameStatsX01!.getTeam.getName,
                style: TextStyle(fontSize: 16.sp),
              ),
              Text(
                currPlayerOrTeamGameStatsX01!.getTeam.getCurrentPlayerToThrow
                        is Bot
                    ? 'Lvl. ${currPlayerOrTeamGameStatsX01!.getTeam.getCurrentPlayerToThrow.getLevel} Bot'
                    : currPlayerOrTeamGameStatsX01!
                        .getTeam.getCurrentPlayerToThrow.getName,
                style: TextStyle(fontSize: 13.sp),
              ),
            ],
          ),
        ),
        FinishWays(
            currPlayerOrTeamGameStatsX01: this.currPlayerOrTeamGameStatsX01),
        Text(
          currPlayerOrTeamGameStatsX01!.getCurrentPoints.toString(),
          style: TextStyle(fontSize: 50.sp),
        ),
      ],
    );
  }

  Column single(BuildContext context) {
    return Column(
      children: [
        FinishWays(
            currPlayerOrTeamGameStatsX01: this.currPlayerOrTeamGameStatsX01),
        Text(
          currPlayerOrTeamGameStatsX01!.getCurrentPoints.toString(),
          style: TextStyle(
            fontSize: 50.sp,
            color: Colors.white,
          ),
        ),
        Text(
          currPlayerOrTeamGameStatsX01!.getPlayer is Bot
              ? 'Lvl. ${currPlayerOrTeamGameStatsX01!.getPlayer.getLevel} Bot'
              : currPlayerOrTeamGameStatsX01!.getPlayer.getName,
          style: TextStyle(
            fontSize: 18.sp,
            color: Utils.getTextColorDarken(context),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
