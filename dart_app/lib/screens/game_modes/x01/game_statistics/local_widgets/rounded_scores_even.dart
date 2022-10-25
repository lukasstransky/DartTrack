import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_statistics_x01.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class RoundedScoresEven extends StatelessWidget {
  const RoundedScoresEven({Key? key, required this.gameX01}) : super(key: key);

  final GameX01 gameX01;

  bool _atLeastOneRoundedScoreValue(PlayerOrTeamGameStatisticsX01 stats) {
    for (int value in stats.getRoundedScoresEven.values) {
      if (value != 0) return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final GameSettingsX01 gameSettingsX01 = gameX01.getGameSettings;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          transform: Matrix4.translationValues(-10.0, 0.0, 0.0),
          padding: EdgeInsets.only(top: PADDING_TOP_STATISTICS),
          child: Text(
            'Rounded Scores',
            style: TextStyle(
                fontSize: FONTSIZE_HEADING_STATISTICS.sp,
                color: Theme.of(context).primaryColor),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: PADDING_TOP_STATISTICS),
          child: Row(
            children: [
              Column(
                children: [
                  for (int i = 0; i <= 180; i += 20)
                    Container(
                      width: WIDTH_HEADINGS_STATISTICS.w,
                      padding: EdgeInsets.only(top: 5),
                      child: Row(
                        children: [
                          Container(
                            width: 12.w,
                            alignment: Alignment.centerRight,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                i == 180 ? '180' : '${i}+',
                                style:
                                    TextStyle(fontSize: FONTSIZE_STATISTICS.sp),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                ],
              ),
              for (PlayerOrTeamGameStatisticsX01 stats
                  in Utils.getPlayersOrTeamStatsList(gameX01, gameSettingsX01))
                Column(
                  children: [
                    for (int i = 0; i <= 180; i += 20)
                      Container(
                        width: WIDTH_DATA_STATISTICS.w,
                        padding: EdgeInsets.only(top: 5),
                        child: Text(
                          stats.getRoundedScoresEven[i].toString(),
                          style: TextStyle(
                              fontSize: FONTSIZE_STATISTICS.sp,
                              fontWeight: _atLeastOneRoundedScoreValue(stats) &&
                                      Utils.getMostOccurringValue(
                                              stats.getRoundedScoresEven) ==
                                          stats.getRoundedScoresEven[i]
                                  ? FontWeight.bold
                                  : FontWeight.normal),
                        ),
                      ),
                  ],
                )
            ],
          ),
        ),
      ],
    );
  }
}
