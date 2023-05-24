import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats_x01.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class PlayerTeamCard extends StatelessWidget {
  const PlayerTeamCard({Key? key, required this.stats}) : super(key: key);

  final PlayerOrTeamGameStatsX01 stats;

  @override
  Widget build(BuildContext context) {
    final GameSettingsX01_P gameSettingsX01_P =
        context.read<GameSettingsX01_P>();
    final bool showLegBeginnerDartAsset =
        _showLegBeginnerDartAsset(context, stats);

    return Container(
      width: double.infinity,
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Utils.darken(Theme.of(context).colorScheme.primary, 15),
            width: 0.5.w,
          ),
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 0,
        color: _isCurrentPlayerTeamOnTheRow(context, gameSettingsX01_P, stats)
            ? Theme.of(context).colorScheme.primary
            : Utils.darken(Theme.of(context).colorScheme.primary, 15),
        child: Row(
          children: [
            CurrentPointsNameAndThrownDarts(
                showLegBeginnerDartAsset, context, gameSettingsX01_P),
            AverageAndLastThrow(context, gameSettingsX01_P),
            LegsSetsAmount(gameSettingsX01_P, context),
          ],
        ),
      ),
    );
  }

  bool _isCurrentPlayerTeamOnTheRow(BuildContext context,
      GameSettingsX01_P gameSettingsX01_P, PlayerOrTeamGameStatsX01 stats) {
    final GameX01_P gameX01_P = context.read<GameX01_P>();

    if (gameSettingsX01_P.getSingleOrTeam == SingleOrTeamEnum.Single &&
        Player.samePlayer(gameX01_P.getCurrentPlayerToThrow, stats.getPlayer)) {
      return true;
    } else if (gameSettingsX01_P.getSingleOrTeam == SingleOrTeamEnum.Team &&
        gameX01_P.getCurrentTeamToThrow.getName == stats.getTeam.getName) {
      return true;
    }

    return false;
  }

  Widget _chip(BuildContext context, String label) {
    return Chip(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      backgroundColor: Utils.getPrimaryColorDarken(context),
      label: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontSize: 10.sp,
        ),
      ),
    );
  }

  bool _showLegBeginnerDartAsset(
      BuildContext context, PlayerOrTeamGameStatsX01 stats) {
    final GameX01_P gameX01 = context.read<GameX01_P>();
    final GameSettingsX01_P gameSettingsX01 = context.read<GameSettingsX01_P>();

    if (gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Single) {
      return gameX01.getPlayerOrTeamLegStartIndex ==
          gameX01.getPlayerGameStatistics.indexOf(stats);
    }
    return gameX01.getPlayerOrTeamLegStartIndex ==
        gameX01.getTeamGameStatistics.indexOf(stats);
  }

  Expanded CurrentPointsNameAndThrownDarts(bool showLegBeginnerDartAsset,
      BuildContext context, GameSettingsX01_P gameSettingsX01_P) {
    return Expanded(
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 10.w,
                transform: Matrix4.translationValues(0.0, -1.25.h, 0.0),
                padding: EdgeInsets.only(left: 1.w),
                alignment: Alignment.topLeft,
                child: Image.asset('assets/dart_arrow.png',
                    color: showLegBeginnerDartAsset
                        ? Utils.getTextColorDarken(context)
                        : Colors.transparent),
              ),
              Expanded(
                child: Container(
                  transform: Matrix4.translationValues(0.0, 0.5.h, 0.0),
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        stats.getCurrentPoints.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 1.5.h),
                width: 10.w,
                child: Text(
                  '(${stats.getCurrentThrownDartsInLeg.toString()})',
                  style: TextStyle(
                    color: Utils.getTextColorDarken(context),
                    fontSize: 8.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 0.5.w),
                child: Text(
                  gameSettingsX01_P.getSingleOrTeam == SingleOrTeamEnum.Single
                      ? stats.getPlayer.getName
                      : stats.getTeam.getName,
                  style: TextStyle(
                    color: Utils.getTextColorDarken(context),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Expanded AverageAndLastThrow(
      BuildContext context, GameSettingsX01_P gameSettingsX01_P) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 2.w),
            child: Selector<GameSettingsX01_P, bool>(
              selector: (_, gameSettings) => gameSettings.getShowAverage,
              builder: (_, showAverage, __) => showAverage
                  ? Row(
                      children: [
                        Text(
                          'Average: ',
                          style: TextStyle(
                            color: Utils.getTextColorDarken(context),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${stats.getAverage()}',
                          style: TextStyle(
                            color: Utils.getTextColorDarken(context),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                  : SizedBox.shrink(),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 2.w),
            child: Row(
              children: [
                Text(
                  'Last throw: ',
                  style: TextStyle(
                    color: Utils.getTextColorDarken(context),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${stats.getAllScores.length == 0 ? '-' : stats.getAllScores[stats.getAllScores.length - 1].toString()}',
                  style: TextStyle(
                    color: Utils.getTextColorDarken(context),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container LegsSetsAmount(
      GameSettingsX01_P gameSettingsX01_P, BuildContext context) {
    return Container(
      width: 25.w,
      child: Column(
        children: [
          if (gameSettingsX01_P.getSetsEnabled)
            Container(
              padding: EdgeInsets.only(
                bottom: 0.5.h,
                top: 0.5.h,
              ),
              child: _chip(context, 'Sets ${stats.getSetsWon}'),
            ),
          Container(
            padding: EdgeInsets.only(
              bottom: gameSettingsX01_P.getSetsEnabled ? 0.5.h : 0,
            ),
            child: _chip(context, 'Legs ${stats.getLegsWon}'),
          ),
        ],
      ),
    );
  }
}
