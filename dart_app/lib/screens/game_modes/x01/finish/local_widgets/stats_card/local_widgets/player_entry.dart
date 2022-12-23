import 'package:dart_app/constants.dart';
import 'package:dart_app/models/bot.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:sizer/sizer.dart';

class PlayerEntry extends StatelessWidget {
  const PlayerEntry(
      {Key? key,
      required this.i,
      required this.gameX01,
      required this.openGame})
      : super(key: key);

  final int i;
  final GameX01 gameX01;
  final bool openGame;

  bool _firstElementNoDrawOrOpenGame(GameX01 gameX01) {
    return i == 0 && !gameX01.isGameDraw() && !openGame;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: 5.w,
          bottom:
              Utils.getPlayersOrTeamStatsList(gameX01, gameX01.getGameSettings)
                              .length -
                          1 ==
                      i
                  ? 1.h
                  : 0),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40.w,
                child: Row(
                  children: [
                    gameX01.isGameDraw()
                        ? SizedBox.shrink()
                        : Text(
                            '${(i + 1)}.',
                            style: TextStyle(
                              fontSize: _firstElementNoDrawOrOpenGame(gameX01)
                                  ? 14.sp
                                  : 12.sp,
                              fontWeight: (i == 0 && !openGame)
                                  ? FontWeight.bold
                                  : null,
                              color: i == 0
                                  ? Utils.getTextColorDarken(context)
                                  : Colors.white,
                            ),
                          ),
                    if (_firstElementNoDrawOrOpenGame(gameX01))
                      Container(
                        padding: EdgeInsets.only(left: 3.w),
                        transform: Matrix4.translationValues(0.0, -2.0, 0.0),
                        child: Icon(
                          Entypo.trophy,
                          size: 12.sp,
                          color: Color(0xffFFD700),
                        ),
                      ),
                    DisplayTeamOrPlayerName(
                        gameX01: gameX01,
                        i: i,
                        firstElementNoDrawOrOpenGame:
                            _firstElementNoDrawOrOpenGame),
                  ],
                ),
              ),
              PlayerStats(gameX01: gameX01, i: i),
            ],
          ),
        ],
      ),
    );
  }
}

class DisplayTeamOrPlayerName extends StatelessWidget {
  const DisplayTeamOrPlayerName(
      {Key? key,
      required this.gameX01,
      required this.i,
      required this.firstElementNoDrawOrOpenGame})
      : super(key: key);

  final GameX01 gameX01;
  final int i;
  final Function firstElementNoDrawOrOpenGame;

  @override
  Widget build(BuildContext context) {
    if (gameX01.getGameSettings.getSingleOrTeam == SingleOrTeamEnum.Team)
      return Padding(
        padding: EdgeInsets.only(left: 3.w),
        child: Text(
          gameX01.getTeamGameStatistics[i].getTeam.getName,
          style: TextStyle(
              fontSize: firstElementNoDrawOrOpenGame(gameX01) ? 14.sp : 12.sp,
              color: i == 0 ? Utils.getTextColorDarken(context) : Colors.white,
              fontWeight: firstElementNoDrawOrOpenGame(gameX01)
                  ? FontWeight.bold
                  : null),
        ),
      );
    else if (gameX01.getPlayerGameStatistics[i].getPlayer is Bot)
      return Padding(
        padding: EdgeInsets.only(left: 3.w),
        child: Column(
          children: [
            Text(
              'Lvl. ${gameX01.getPlayerGameStatistics[i].getPlayer.getLevel} Bot',
              style: TextStyle(
                  fontSize:
                      firstElementNoDrawOrOpenGame(gameX01) ? 14.sp : 12.sp,
                  color:
                      i == 0 ? Utils.getTextColorDarken(context) : Colors.white,
                  fontWeight: firstElementNoDrawOrOpenGame(gameX01)
                      ? FontWeight.bold
                      : null),
            ),
            Text(
              ' (${gameX01.getPlayerGameStatistics[i].getPlayer.getPreDefinedAverage.round() - BOT_AVG_SLIDER_VALUE_RANGE}-${gameX01.getPlayerGameStatistics[i].getPlayer.getPreDefinedAverage.round() + BOT_AVG_SLIDER_VALUE_RANGE} avg.)',
              style: TextStyle(
                fontSize: 8.sp,
                color:
                    i == 0 ? Utils.getTextColorDarken(context) : Colors.white,
              ),
            ),
          ],
        ),
      );
    else
      return Padding(
        padding: EdgeInsets.only(left: 3.w),
        child: Text(
          gameX01.getPlayerGameStatistics[i].getPlayer.getName,
          style: TextStyle(
              fontSize: firstElementNoDrawOrOpenGame(gameX01) ? 14.sp : 12.sp,
              color: i == 0 ? Utils.getTextColorDarken(context) : Colors.white,
              fontWeight: firstElementNoDrawOrOpenGame(gameX01)
                  ? FontWeight.bold
                  : null),
        ),
      );
  }
}

class PlayerStats extends StatelessWidget {
  const PlayerStats({
    Key? key,
    required this.gameX01,
    required this.i,
  }) : super(key: key);

  final GameX01 gameX01;
  final int i;

  @override
  Widget build(BuildContext context) {
    final GameSettingsX01 gameSettingsX01 = gameX01.getGameSettings;

    return Container(
      width: 40.w,
      padding: EdgeInsets.only(left: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            gameSettingsX01.getSetsEnabled
                ? 'Sets: ${Utils.getPlayersOrTeamStatsList(gameX01, gameSettingsX01)[i].getSetsWon}'
                : 'Legs: ${Utils.getPlayersOrTeamStatsList(gameX01, gameSettingsX01)[i].getLegsWon}',
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.white,
            ),
          ),
          Text(
            'Average: ${Utils.getPlayersOrTeamStatsList(gameX01, gameSettingsX01)[i].getAverage()}',
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.white,
            ),
          ),
          if (gameSettingsX01.getEnableCheckoutCounting)
            Text(
              'Checkout: ${Utils.getPlayersOrTeamStatsList(gameX01, gameSettingsX01)[i].getCheckoutQuoteInPercent()}',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.white,
              ),
            ),
        ],
      ),
    );
  }
}
