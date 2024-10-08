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
          borderRadius: BorderRadius.circular(CARD_SHAPE_ROUNDING),
        ),
        elevation: 0,
        color: _isCurrentPlayerTeamOnTheRow(context, gameSettingsX01_P, stats)
            ? Theme.of(context).colorScheme.primary
            : Utils.darken(Theme.of(context).colorScheme.primary, 15),
        child: Container(
          padding: EdgeInsets.only(bottom: 1.h, top: 1.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CurrentPointsNameAndThrownDarts(
                  showLegBeginnerDartAsset, context, gameSettingsX01_P),
              AverageAndLastThrow(context, gameSettingsX01_P),
            ],
          ),
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
    final double _fontSizePoints = 20;

    return Expanded(
      child: Row(
        children: [
          Container(
            transform: Matrix4.translationValues(0.0, -2.h, 0.0),
            padding: EdgeInsets.fromLTRB(1.w, 0, 1.w, 0),
            child: Image.asset('assets/dart_arrow.png',
                width: 8.w,
                color: showLegBeginnerDartAsset
                    ? Utils.getTextColorDarken(context)
                    : Colors.transparent),
          ),
          Expanded(
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
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        gameSettingsX01_P.getSingleOrTeam ==
                                SingleOrTeamEnum.Single
                            ? stats.getPlayer.getName
                            : stats.getTeam.getName,
                        overflow: TextOverflow.clip,
                        style: TextStyle(
                          color: Utils.getTextColorDarken(context),
                          fontSize: _fontSizeName.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget AverageAndLastThrow(
      BuildContext context, GameSettingsX01_P gameSettingsX01_P) {
    return Expanded(
      child: Column(
        children: [
          Selector<GameSettingsX01_P, SelectorModel>(
            selector: (_, gameSettings) => SelectorModel(
                showAvg: gameSettings.getShowAverage,
                showLastThrow: gameSettings.getShowLastThrow,
                showThrownDarts: gameSettings.getShowThrownDartsPerLeg),
            builder: (_, selectorModel, __) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                selectorModel.showAvg
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Avg.: ',
                            style: TextStyle(
                              color: Utils.getTextColorDarken(context),
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .fontSize,
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
                selectorModel.showLastThrow
                    ? FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          children: [
                            Text(
                              'Last throw: ',
                              style: TextStyle(
                                color: Utils.getTextColorDarken(context),
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .fontSize,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                '${stats.getAllScores.length == 0 ? '-' : stats.getAllScores[stats.getAllScores.length - 1].toString()}',
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
                        ),
                      )
                    : SizedBox.shrink(),
                selectorModel.showThrownDarts
                    ? Row(
                        children: [
                          Text(
                            'Thrown darts: ',
                            style: TextStyle(
                              color: Utils.getTextColorDarken(context),
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .fontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              '${stats.getCurrentThrownDartsInLeg.toString()}',
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
                if (gameSettingsX01_P.getSetsEnabled)
                  Row(
                    children: [
                      Text(
                        'Sets: ',
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
                          '${stats.getSetsWon}',
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
                  ),
                Row(
                  children: [
                    Text(
                      'Legs: ',
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
                        '${stats.getLegsWon}',
                        style: TextStyle(
                          color: Utils.getTextColorDarken(context),
                          fontSize:
                              Theme.of(context).textTheme.bodyMedium!.fontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SelectorModel {
  final bool showAvg;
  final bool showLastThrow;
  final bool showThrownDarts;

  SelectorModel({
    required this.showAvg,
    required this.showLastThrow,
    required this.showThrownDarts,
  });
}
