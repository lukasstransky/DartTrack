import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_statistics_x01.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class RoundedScoresOdd extends StatelessWidget {
  const RoundedScoresOdd({Key? key, required this.gameX01}) : super(key: key);

  final GameX01 gameX01;

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
              color: Colors.white,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: PADDING_TOP_STATISTICS),
          child: Row(
            children: [
              Column(
                children: [
                  for (int i = 10; i <= 170; i += 20)
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
                                '${i}+',
                                style: TextStyle(
                                  fontSize: FONTSIZE_STATISTICS.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Utils.getTextColorDarken(context),
                                ),
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
                    for (int i = 10; i <= 170; i += 20)
                      Container(
                        width: WIDTH_DATA_STATISTICS.w,
                        padding: EdgeInsets.only(top: 5),
                        child: Text(
                          stats.getRoundedScoresOdd[i].toString(),
                          style: TextStyle(
                              fontSize: FONTSIZE_STATISTICS.sp,
                              color: stats.getHighestScore() >= 10 &&
                                      Utils.getMostOccurringValue(
                                              stats.getRoundedScoresOdd) ==
                                          stats.getRoundedScoresOdd[i]
                                  ? Theme.of(context).colorScheme.secondary
                                  : Colors.white,
                              fontWeight: stats.getHighestScore() >= 10 &&
                                      Utils.getMostOccurringValue(
                                              stats.getRoundedScoresOdd) ==
                                          stats.getRoundedScoresOdd[i]
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
