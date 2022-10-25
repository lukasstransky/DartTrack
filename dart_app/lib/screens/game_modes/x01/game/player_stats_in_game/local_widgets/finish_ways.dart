import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_statistics_x01.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class FinishWays extends StatelessWidget {
  const FinishWays({Key? key, required this.currPlayerOrTeamGameStatsX01})
      : super(key: key);

  final PlayerOrTeamGameStatisticsX01? currPlayerOrTeamGameStatsX01;

  bool _checkoutPossible(int currentPoints) {
    if (currentPoints <= 170 && !BOGEY_NUMBERS.contains(currentPoints))
      return true;

    return false;
  }

  String _getFinishWay(int currentPoints) {
    if (currentPoints != 0) return FINISH_WAYS[currentPoints]!.first;

    return '';
  }

  //for showing finish ways -> if one player is in finish area and the other one not -> text widget not centered
  bool _onePlayerInFinishArea(BuildContext context) {
    final GameX01 gameX01 = context.read<GameX01>();

    for (PlayerOrTeamGameStatisticsX01 stats in gameX01.getPlayerGameStatistics)
      if (stats.getCurrentPoints <= 170) return true;

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        transform: Matrix4.translationValues(0.0, 10.0, 0.0),
        child: _getTextWidget(context));
  }

  SizedBox _getTextWidget(BuildContext context) {
    final GameSettingsX01 gameSettingsX01 = context.read<GameSettingsX01>();

    if (!gameSettingsX01.getShowFinishWays) return SizedBox.shrink();

    if (_checkoutPossible(
        this.currPlayerOrTeamGameStatsX01!.getCurrentPoints)) {
      return SizedBox(
        height: 2.h,
        child: Text(
          _getFinishWay(currPlayerOrTeamGameStatsX01!.getCurrentPoints),
          style: TextStyle(
              color: Theme.of(context).colorScheme.primary, fontSize: 13.sp),
        ),
      );
    }

    if (BOGEY_NUMBERS
        .contains(currPlayerOrTeamGameStatsX01!.getCurrentPoints)) {
      return SizedBox(
        height: 2.h,
        child: Text(
          'No Finish possible!',
          style: TextStyle(
              color: Theme.of(context).colorScheme.primary, fontSize: 13.sp),
        ),
      );
    } else {
      SizedBox(
        height: 2.h,
        child: Text(
          '',
          style: TextStyle(
              color: Theme.of(context).colorScheme.primary, fontSize: 13.sp),
        ),
      );
    }

    if (!_onePlayerInFinishArea(context)) {
      return SizedBox.shrink();
    }
    return SizedBox(
      height: 2.h,
    );
  }
}
