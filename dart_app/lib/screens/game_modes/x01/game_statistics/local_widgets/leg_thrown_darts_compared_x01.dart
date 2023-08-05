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
    final double width =
        gameSettingsX01.playerOrTeamNameWithMoreThanEightChars() ? 30 : 25;
    final List<String> allLegSetStringsExceptCurrentOne =
        gameX01.getAllLegSetStringsExceptCurrentOne(gameX01, gameSettingsX01);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          transform: Matrix4.translationValues(-2.5.w, 0.0, 0.0),
          padding: EdgeInsets.only(
            top: PADDING_TOP_STATISTICS.h,
            bottom: 1.h,
          ),
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
                width: width.w,
                padding: EdgeInsets.only(
                  top: 0.5.h,
                  bottom: 0.5.h,
                  left: 1.w,
                  right: 1.w,
                ),
                alignment: Alignment.center,
                child:
                    gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Single
                        ? FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              stats.getPlayer is Bot
                                  ? 'Bot'
                                  : stats.getPlayer.getName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Utils.getTextColorDarken(context),
                                fontSize: 10.sp,
                              ),
                            ),
                          )
                        : FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              stats.getTeam.getName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Utils.getTextColorDarken(context),
                                fontSize: 10.sp,
                              ),
                            ),
                          ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 0.5.w,
                      color: Utils.getTextColorDarken(context),
                    ),
                  ),
                ),
              ),
              for (int i = 0; i < allLegSetStringsExceptCurrentOne.length; i++)
                Container(
                  width: gameSettingsX01.getSetsEnabled ? 25.w : 20.w,
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(
                    top: 0.5.h,
                    bottom: 0.5.h,
                    left: 1.w,
                    right: 1.w,
                  ),
                  child: Utils.getWinnerOfLeg(
                              allLegSetStringsExceptCurrentOne[i],
                              gameX01,
                              context,
                              i) ==
                          (Utils.teamStatsDisplayed(gameX01, gameSettingsX01)
                              ? stats.getTeam.getName
                              : stats.getPlayer.getName)
                      ? Text(
                          stats.getThrownDartsPerLeg[
                                  allLegSetStringsExceptCurrentOne[i]]
                              .toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.sp,
                          ),
                        )
                      : Text(
                          '-',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.sp,
                          ),
                        ),
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        width: 0.5.w,
                        color: Utils.getTextColorDarken(context),
                      ),
                      bottom: BorderSide(
                        width: 0.5.w,
                        color: Utils.getTextColorDarken(context),
                      ),
                    ),
                  ),
                ),
            ],
          ),

        Utils.setLegStrings(gameX01, gameSettingsX01, context, width),
      ],
    );
  }
}
