import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats_x01.dart';
import 'package:dart_app/screens/game_modes/shared/overall/custom_chip.dart';
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
          borderRadius: BorderRadius.circular(CARD_SHAPE_ROUNDING),
        ),
        elevation: 0,
        color: _isCurrentPlayerTeamOnTheRow(context, gameSettingsX01_P, stats)
            ? Theme.of(context).colorScheme.primary
            : Utils.darken(Theme.of(context).colorScheme.primary, 15),
        child: Row(
          children: [
            Container(
              transform: Matrix4.translationValues(0.0, -2.h, 0.0),
              padding: EdgeInsets.only(left: 1.w),
              child: Image.asset('assets/dart_arrow.png',
                  width: 8.w,
                  color: showLegBeginnerDartAsset
                      ? Utils.getTextColorDarken(context)
                      : Colors.transparent),
            ),
            CurrentPointsNameAndThrownDarts(
                showLegBeginnerDartAsset, context, gameSettingsX01_P),
            AverageAndLastThrow(
                context, gameSettingsX01_P, Utils.isLandscape(context)),
            if (!Utils.isLandscape(context))
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
    return CustomChip(
        label: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
          ),
        ),
        color: Utils.getPrimaryColorDarken(context));
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

  Widget CurrentPointsNameAndThrownDarts(bool showLegBeginnerDartAsset,
      BuildContext context, GameSettingsX01_P gameSettingsX01_P) {
    final double _fontSizeName = Utils.getResponsiveValue(
      context: context,
      mobileValue: 14,
      tabletValue: 12,
    );
    final double _fontSizePoints = Utils.getResponsiveValue(
      context: context,
      mobileValue: 25,
      tabletValue: 20,
    );

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  stats.getCurrentPoints.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: _fontSizePoints.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                '(${stats.getCurrentThrownDartsInLeg.toString()})',
                style: TextStyle(
                  color: Utils.getTextColorDarken(context),
                  fontSize: 8.sp,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
          Container(
            padding: EdgeInsets.only(bottom: 0.5.w),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                gameSettingsX01_P.getSingleOrTeam == SingleOrTeamEnum.Single
                    ? stats.getPlayer.getName
                    : stats.getTeam.getName,
                style: TextStyle(
                  color: Utils.getTextColorDarken(context),
                  fontSize: _fontSizeName.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget AverageAndLastThrow(BuildContext context,
      GameSettingsX01_P gameSettingsX01_P, bool isLandscape) {
    return Expanded(
      child: Column(
        children: [
          Selector<GameSettingsX01_P, bool>(
            selector: (_, gameSettings) => gameSettings.getShowAverage,
            builder: (_, showAverage, __) => showAverage
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Avg.: ',
                        style: TextStyle(
                          color: Utils.getTextColorDarken(context),
                          fontSize:
                              Theme.of(context).textTheme.bodyMedium!.fontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '${stats.getAverage()}',
                          style: TextStyle(
                            color: Utils.getTextColorDarken(context),
                            fontSize: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .fontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                : SizedBox.shrink(),
          ),
          Row(
            children: [
              Text(
                'Last throw: ',
                style: TextStyle(
                  color: Utils.getTextColorDarken(context),
                  fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  '${stats.getAllScores.length == 0 ? '-' : stats.getAllScores[stats.getAllScores.length - 1].toString()}',
                  style: TextStyle(
                    color: Utils.getTextColorDarken(context),
                    fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          if (isLandscape) ...[
            Container(
              alignment: Alignment.centerLeft,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'Legs: ${stats.getLegsWon}',
                  style: TextStyle(
                    color: Utils.getTextColorDarken(context),
                    fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            if (gameSettingsX01_P.getSetsEnabled)
              Container(
                alignment: Alignment.centerLeft,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Sets: ${stats.getSetsWon}',
                    style: TextStyle(
                      color: Utils.getTextColorDarken(context),
                      fontSize:
                          Theme.of(context).textTheme.bodyMedium!.fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ]
        ],
      ),
    );
  }

  Container LegsSetsAmount(
      GameSettingsX01_P gameSettingsX01_P, BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 1.w),
      child: Column(
        children: [
          if (gameSettingsX01_P.getSetsEnabled)
            Container(
              padding: EdgeInsets.only(
                bottom: 0.5.h,
                top: 0.5.h,
              ),
              child: _chip(context, 'Sets: ${stats.getSetsWon}'),
            ),
          Container(
            padding: EdgeInsets.only(
              bottom: gameSettingsX01_P.getSetsEnabled ? 0.5.h : 0,
            ),
            child: _chip(context, 'Legs: ${stats.getLegsWon}'),
          ),
        ],
      ),
    );
  }
}
