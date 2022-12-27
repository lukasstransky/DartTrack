import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_statistics_x01.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class GameStats extends StatelessWidget {
  const GameStats({Key? key, required this.currPlayerOrTeamGameStatsX01})
      : super(key: key);

  final PlayerOrTeamGameStatisticsX01? currPlayerOrTeamGameStatsX01;

  String _getLastThrow(List<int> allScores) {
    if (allScores.length == 0) return '-';

    return allScores[allScores.length - 1].toString();
  }

  @override
  Widget build(BuildContext context) {
    final GameSettingsX01 gameSettingsX01 = context.read<GameSettingsX01>();

    return Padding(
      padding: EdgeInsets.only(top: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (gameSettingsX01.getShowAverage)
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'Average: ${currPlayerOrTeamGameStatsX01!.getAverage()}',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Utils.getTextColorDarken(context),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          if (gameSettingsX01.getShowLastThrow)
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'Last Throw: ${_getLastThrow(currPlayerOrTeamGameStatsX01!.getAllScores)}',
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Utils.getTextColorDarken(context),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          if (gameSettingsX01.getShowThrownDartsPerLeg)
            currPlayerOrTeamGameStatsX01!.getCurrentThrownDartsInLeg != 0
                ? FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Thrown Darts: ${currPlayerOrTeamGameStatsX01!.getCurrentThrownDartsInLeg.toString()}',
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
                      'Thrown Darts: -',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Utils.getTextColorDarken(context),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
        ],
      ),
    );
  }
}
