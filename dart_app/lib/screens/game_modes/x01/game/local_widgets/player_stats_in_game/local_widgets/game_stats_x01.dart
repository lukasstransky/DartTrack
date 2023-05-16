import 'package:dart_app/constants.dart';
import 'package:dart_app/models/bot.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats_x01.dart';
import 'package:dart_app/utils/globals.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class GameStatsX01 extends StatelessWidget {
  const GameStatsX01({Key? key, required this.currentStats}) : super(key: key);

  final PlayerOrTeamGameStatsX01? currentStats;

  String _getLastThrow(List<int> allScores) {
    if (allScores.length == 0) {
      return '-';
    }

    return allScores[allScores.length - 1].toString();
  }

  bool _isCurrentPlayerBot() {
    return (currentStats!.getTeam != null &&
            currentStats!.getTeam.getCurrentPlayerToThrow is Bot) ||
        currentStats!.getPlayer is Bot;
  }

  bool getPlayerTeamStartIndex(
      GameX01_P gameX01, GameSettingsX01_P gameSettingsX01) {
    final bool isSingleMode =
        gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Single;

    int index = -1;
    if (isSingleMode &&
        gameX01.getPlayerOrTeamLegStartIndex ==
            gameSettingsX01.getPlayers.length - 1) {
      index = 0;
    } else if (!isSingleMode &&
        gameX01.getPlayerOrTeamLegStartIndex ==
            gameSettingsX01.getTeams.length - 1) {
      index = 0;
    } else {
      index = gameX01.getPlayerOrTeamLegStartIndex + 1;
    }

    if (isSingleMode) {
      return index == gameX01.getPlayerGameStatistics.indexOf(currentStats);
    }
    return index == gameX01.getTeamGameStatistics.indexOf(currentStats);
  }

  @override
  Widget build(BuildContext context) {
    final GameSettingsX01_P gameSettingsX01 = context.read<GameSettingsX01_P>();
    final GameX01_P gameX01 = context.read<GameX01_P>();
    final String setLegString =
        Utils.getCurrentSetLegAsString(gameX01, gameSettingsX01);
    final bool isCurrentPlayerBeginnerOfLeg =
        getPlayerTeamStartIndex(gameX01, gameSettingsX01);

    if (_isCurrentPlayerBot() &&
        (currentStats!.getAllScoresPerLeg.containsKey(setLegString) ||
            isCurrentPlayerBeginnerOfLeg)) {
      g_average = currentStats!.getAverage();
      g_last_throw = _getLastThrow(currentStats!.getAllScores);
      g_thrown_darts = currentStats!.getCurrentThrownDartsInLeg == 0
          ? '-'
          : currentStats!.getCurrentThrownDartsInLeg.toString();
    }

    return Padding(
      padding: EdgeInsets.only(top: 0.5.h),
      child: Selector<GameSettingsX01_P, SelectorModel>(
        selector: (_, gameSettingsX01) => SelectorModel(
          showAverage: gameSettingsX01.getShowAverage,
          showLastThrow: gameSettingsX01.getShowLastThrow,
          showThrownDartsPerLeg: gameSettingsX01.getShowThrownDartsPerLeg,
        ),
        builder: (_, selectorModel, __) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (selectorModel.showAverage)
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'Average: ${_isCurrentPlayerBot() ? g_average : currentStats!.getAverage()}',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Utils.getTextColorDarken(context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (selectorModel.showLastThrow)
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'Last throw: ${_isCurrentPlayerBot() ? g_last_throw : _getLastThrow(currentStats!.getAllScores)}',
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Utils.getTextColorDarken(context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (selectorModel.showThrownDartsPerLeg)
              currentStats!.getCurrentThrownDartsInLeg != 0
                  ? FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'Thrown darts: ${_isCurrentPlayerBot() ? g_thrown_darts : currentStats!.getCurrentThrownDartsInLeg.toString()}',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Utils.getTextColorDarken(context),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  : FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'Thrown darts: ${_isCurrentPlayerBot() ? g_thrown_darts : '-'}',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Utils.getTextColorDarken(context),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
          ],
        ),
      ),
    );
  }
}

class SelectorModel {
  final bool showAverage;
  final bool showLastThrow;
  final bool showThrownDartsPerLeg;

  SelectorModel({
    required this.showAverage,
    required this.showLastThrow,
    required this.showThrownDartsPerLeg,
  });
}
