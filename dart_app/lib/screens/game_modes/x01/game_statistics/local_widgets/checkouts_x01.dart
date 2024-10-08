import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats_x01.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CheckoutsX01 extends StatelessWidget {
  const CheckoutsX01({Key? key, required this.gameX01}) : super(key: key);

  final GameX01_P gameX01;

  String _getPlayerOrTeamName(bool isSingleMode, GameX01_P gameX01,
      GameSettingsX01_P gameSettingsX01, PlayerOrTeamGameStatsX01 stats) {
    if (isSingleMode ||
        Utils.playerStatsDisplayedInTeamMode(gameX01, gameSettingsX01)) {
      return stats.getPlayer.getName;
    }

    return stats.getTeam.getName;
  }

  bool _isSetLegFinished(
      String setLegString, GameSettingsX01_P gameSettingsX01) {
    if (setLegString !=
        Utils.getCurrentSetLegAsString(gameX01, gameSettingsX01)) {
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final GameSettingsX01_P gameSettingsX01 = gameX01.getGameSettings;
    final bool isSingleMode =
        gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Single;
    final List<String> allSetLegStrings =
        Utils.getPlayersOrTeamStatsListStatsScreen(gameX01, gameSettingsX01)[0]
            .getThrownDartsPerLeg
            .keys
            .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(top: PADDING_TOP_STATISTICS.h),
          transform: Matrix4.translationValues(-2.5.w, 0.0, 0.0),
          child: Text(
            'Checkouts',
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.titleLarge!.fontSize,
              color: Colors.white,
            ),
          ),
        ),
        //for (String setLegString in allSetLegStrings)
        for (int i = 0; i < allSetLegStrings.length; i++)
          if (_isSetLegFinished(allSetLegStrings[i], gameSettingsX01))
            Padding(
              padding: EdgeInsets.only(top: PADDING_TOP_STATISTICS.h),
              child: Row(
                children: [
                  Container(
                    width: WIDTH_HEADINGS_STATISTICS.w,
                    alignment: Alignment.centerLeft,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        allSetLegStrings[i],
                        style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.bodyMedium!.fontSize,
                          fontWeight: FontWeight.bold,
                          color: Utils.getTextColorDarken(context),
                        ),
                      ),
                    ),
                  ),
                  for (PlayerOrTeamGameStatsX01 stats
                      in Utils.getPlayersOrTeamStatsListStatsScreen(
                          gameX01, gameSettingsX01))
                    Container(
                      width: WIDTH_DATA_STATISTICS.w,
                      child: Text(
                        Utils.getWinnerOfLeg(
                                    allSetLegStrings[i], gameX01, context, i) ==
                                _getPlayerOrTeamName(isSingleMode, gameX01,
                                    gameSettingsX01, stats)
                            ? stats.getCheckouts[allSetLegStrings[i]].toString()
                            : '',
                        style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.bodyMedium!.fontSize,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ),
      ],
    );
  }
}
