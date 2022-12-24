import 'package:dart_app/constants.dart';
import 'package:dart_app/models/bot.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_statistics_x01.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class LegAvgCompared extends StatelessWidget {
  const LegAvgCompared({Key? key, required this.gameX01}) : super(key: key);

  final GameX01 gameX01;

  @override
  Widget build(BuildContext context) {
    final GameSettingsX01 gameSettingsX01 = gameX01.getGameSettings;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          transform: Matrix4.translationValues(-10.0, 0.0, 0.0),
          padding: EdgeInsets.only(top: PADDING_TOP_STATISTICS, bottom: 10),
          alignment: Alignment.center,
          child: Text(
            'Averages per Leg',
            style: TextStyle(
              fontSize: FONTSIZE_HEADING_STATISTICS.sp,
              color: Colors.white,
            ),
          ),
        ),
        for (PlayerOrTeamGameStatisticsX01 stats
            in Utils.getPlayersOrTeamStatsList(gameX01, gameSettingsX01))
          Row(
            children: [
              Container(
                width: 20.w,
                padding: EdgeInsets.all(5),
                alignment: Alignment.center,
                child: Utils.teamStatsDisplayed(gameX01, gameSettingsX01)
                    ? Text(
                        stats.getTeam.getName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Utils.getTextColorDarken(context),
                        ),
                      )
                    : Text(
                        stats.getPlayer is Bot
                            ? 'Bot'
                            : stats.getPlayer.getName,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Utils.getTextColorDarken(context),
                        ),
                      ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 1.5,
                      color: Utils.getTextColorDarken(context),
                    ),
                  ),
                ),
              ),
              for (String setLegString
                  in gameX01.getAllLegSetStringsExceptCurrentOne(
                      gameX01, gameSettingsX01))
                Container(
                  width: 25.w,
                  padding: EdgeInsets.all(5),
                  alignment: Alignment.center,
                  child: Text(
                    Utils.getAverageForLeg(stats, setLegString),
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        width: 1.5,
                        color: Utils.getTextColorDarken(context),
                      ),
                      bottom: BorderSide(
                        width: 1.5,
                        color: Utils.getTextColorDarken(context),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        Utils.setLegStrings(gameX01, gameSettingsX01, context),
      ],
    );
  }
}
