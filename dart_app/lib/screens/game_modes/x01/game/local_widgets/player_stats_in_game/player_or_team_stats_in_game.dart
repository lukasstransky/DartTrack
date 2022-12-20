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

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:provider/provider.dart';

class PlayerOrTeamStatsInGame extends StatelessWidget {
  const PlayerOrTeamStatsInGame(
      {Key? key, required this.currPlayerOrTeamGameStatsX01})
      : super(key: key);

  final PlayerOrTeamGameStatisticsX01? currPlayerOrTeamGameStatsX01;

  Color _getBackgroundColor(GameX01 gameX01, GameSettingsX01 gameSettingsX01) {
    if (gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Single) {
      if (Player.samePlayer(gameX01.getCurrentPlayerToThrow,
          this.currPlayerOrTeamGameStatsX01!.getPlayer)) {
        return Colors.grey;
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

  @override
  Widget build(BuildContext context) {
    final GameX01 gameX01 = context.read<GameX01>();
    final GameSettingsX01 gameSettingsX01 = context.read<GameSettingsX01>();
    final bool isSingleMode =
        gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Single;
/* 
    if (gameX01.getCurrentPlayerToThrow is Bot) {
      final Bot bot = gameX01.getCurrentPlayerToThrow as Bot;
      Submit.submitPoints(bot.getNextScoredValue(gameX01), context);
    } */

    return Container(
      color: _getBackgroundColor(gameX01, gameSettingsX01),
      width: 50.w,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LegBeginnerDartAsset(
              currPlayerOrTeamGameStatsX01: this.currPlayerOrTeamGameStatsX01),
          Container(
            transform:
                Matrix4.translationValues(0.0, isSingleMode ? -15 : -25.0, 0.0),
            child: Column(
              children: [
                if (isSingleMode) single() else team(),
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

  Column single() {
    return Column(
      children: [
        FinishWays(
            currPlayerOrTeamGameStatsX01: this.currPlayerOrTeamGameStatsX01),
        Text(
          currPlayerOrTeamGameStatsX01!.getCurrentPoints.toString(),
          style: TextStyle(fontSize: 50.sp),
        ),
        Text(
          currPlayerOrTeamGameStatsX01!.getPlayer is Bot
              ? 'Lvl. ${currPlayerOrTeamGameStatsX01!.getPlayer.getLevel} Bot'
              : currPlayerOrTeamGameStatsX01!.getPlayer.getName,
          style: TextStyle(fontSize: 18.sp),
        ),
      ],
    );
  }
}
