import 'package:dart_app/constants.dart';
import 'package:dart_app/models/bot.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats_x01.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class LegThrownDartsComparedX01 extends StatelessWidget {
  const LegThrownDartsComparedX01({Key? key, required this.gameX01})
      : super(key: key);

  final GameX01_P gameX01;

  @override
  Widget build(BuildContext context) {
    final GameSettingsX01_P gameSettingsX01 = gameX01.getGameSettings;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          transform: Matrix4.translationValues(-10.0, 0.0, 0.0),
          padding: EdgeInsets.only(top: PADDING_TOP_STATISTICS, bottom: 10),
          alignment: Alignment.center,
          child: Text(
            'Darts per leg',
            style: TextStyle(
              fontSize: FONTSIZE_HEADING_STATISTICS.sp,
              color: Colors.white,
            ),
          ),
        ),

        //players thrown darts per leg
        for (PlayerOrTeamGameStatsX01 stats
            in Utils.getPlayersOrTeamStatsListStatsScreen(
                gameX01, gameSettingsX01))
          Row(
            children: [
              Container(
                width: 20.w,
                padding: EdgeInsets.all(5),
                alignment: Alignment.center,
                child:
                    gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Single
                        ? Text(
                            stats.getPlayer is Bot
                                ? 'Bot'
                                : stats.getPlayer.getName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Utils.getTextColorDarken(context),
                            ),
                          )
                        : Text(
                            stats.getTeam.getName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Utils.getTextColorDarken(context),
                            ),
                          ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 1.0,
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
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(5),
                  child: Utils.getWinnerOfLeg(setLegString, gameX01, context) ==
                          (Utils.teamStatsDisplayed(gameX01, gameSettingsX01)
                              ? stats.getTeam.getName
                              : stats.getPlayer.getName)
                      ? Text(
                          stats.getThrownDartsPerLeg[setLegString].toString(),
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        )
                      : Text('-',
                          style: TextStyle(
                            color: Colors.white,
                          )),
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        width: 1.0,
                        color: Utils.getTextColorDarken(context),
                      ),
                      bottom: BorderSide(
                        width: 1.0,
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
