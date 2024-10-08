import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats_x01.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class FinishWaysX01 extends StatelessWidget {
  const FinishWaysX01({Key? key, required this.currPlayerOrTeamGameStatsX01})
      : super(key: key);

  final PlayerOrTeamGameStatsX01? currPlayerOrTeamGameStatsX01;

  bool _checkoutPossible(int currentPoints) {
    if (currentPoints <= 170 && !BOGEY_NUMBERS.contains(currentPoints)) {
      return true;
    }

    return false;
  }

  String _getFinishWay(int currentPoints) {
    if (currentPoints != 0 && currentPoints != 1) {
      return FINISH_WAYS[currentPoints]!.first;
    }

    return '';
  }

  //for showing finish ways -> if one player is in finish area and the other one not -> text widget not centered
  bool _onePlayerInFinishArea(BuildContext context) {
    final GameX01_P gameX01 = context.read<GameX01_P>();
    final GameSettingsX01_P gameSettingsX01 = context.read<GameSettingsX01_P>();

    for (PlayerOrTeamGameStatsX01 stats in Utils.getPlayersOrTeamStatsList(
        gameX01, gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Team))
      if (stats.getCurrentPoints <= 170) {
        return true;
      }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        transform: Matrix4.translationValues(0.0, 1.h, 0.0),
        child: _getTextWidget(context));
  }

  SizedBox _getTextWidget(BuildContext context) {
    final GameSettingsX01_P gameSettingsX01 = context.read<GameSettingsX01_P>();

    if (!gameSettingsX01.getShowFinishWays) {
      return SizedBox.shrink();
    }

    if (_checkoutPossible(
        this.currPlayerOrTeamGameStatsX01!.getCurrentPoints)) {
      return SizedBox(
        height: 3.h,
        child: Text(
          _getFinishWay(currPlayerOrTeamGameStatsX01!.getCurrentPoints),
          style: TextStyle(
            color: Utils.getTextColorDarken(context),
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    if (BOGEY_NUMBERS
        .contains(currPlayerOrTeamGameStatsX01!.getCurrentPoints)) {
      return SizedBox(
        height: 3.h,
        child: Text(
          'No finish possible!',
          style: TextStyle(
            color: Utils.getTextColorDarken(context),
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    } else {
      SizedBox(
        height: 3.h,
        child: Text(
          '',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 12.sp,
          ),
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
