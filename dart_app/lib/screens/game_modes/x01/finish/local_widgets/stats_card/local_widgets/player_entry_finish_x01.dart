import 'package:dart_app/constants.dart';
import 'package:dart_app/models/bot.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats_x01.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:sizer/sizer.dart';

class PlayerEntryFinishX01 extends StatelessWidget {
  const PlayerEntryFinishX01(
      {Key? key,
      required this.i,
      required this.gameX01,
      required this.openGame})
      : super(key: key);

  final int i;
  final GameX01_P gameX01;
  final bool openGame;

  bool _firstElementNoDrawOrOpenGame(GameX01_P gameX01, BuildContext context) {
    return i == 0 && !gameX01.isGameDraw(context) && !openGame;
  }

  checkForSameAmountOfSetsLegs(int indexOfPlayerOrTeam) {
    if (indexOfPlayerOrTeam == 0) {
      return 1;
    } else if (indexOfPlayerOrTeam == 1) {
      return 2;
    }

    final List<PlayerOrTeamGameStats> statsList =
        Utils.getPlayersOrTeamStatsList(gameX01, gameX01.getGameSettings);

    for (int i = 1; i < indexOfPlayerOrTeam; i++) {
      if (gameX01.getGameSettings.getSetsEnabled) {
        if ((statsList[i] as PlayerOrTeamGameStatsX01).getSetsWon ==
            (statsList[indexOfPlayerOrTeam] as PlayerOrTeamGameStatsX01)
                .getSetsWon) {
          return i + 1;
        }
      } else {
        if ((statsList[i] as PlayerOrTeamGameStatsX01).getLegsWonTotal ==
            (statsList[indexOfPlayerOrTeam] as PlayerOrTeamGameStatsX01)
                .getLegsWonTotal) {
          return i + 1;
        }
      }
    }

    return indexOfPlayerOrTeam + 1;
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
                    gameX01.isGameDraw(context)
                        ? SizedBox.shrink()
                        : Container(
                            width: 5.w,
                            child: Text(
                              '${checkForSameAmountOfSetsLegs(i)}.',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: Utils.getTextColorDarken(context),
                              ),
                            ),
                          ),
                    if (_firstElementNoDrawOrOpenGame(gameX01, context))
                      Container(
                        padding: EdgeInsets.only(left: 2.w, right: 1.w),
                        transform: Matrix4.translationValues(0.0, -2.0, 0.0),
                        child: Icon(
                          Entypo.trophy,
                          size: 14.sp,
                          color: Color(0xffFFD700),
                        ),
                      )
                    else if (gameX01.isGameDraw(context))
                      Container(
                        padding: EdgeInsets.only(left: 20),
                      )
                    else
                      Container(
                        padding: openGame
                            ? EdgeInsets.zero
                            : EdgeInsets.only(left: 2.w, right: 1.w),
                        transform: Matrix4.translationValues(0.0, -2.0, 0.0),
                        child: Icon(
                          Entypo.trophy,
                          size: 14.sp,
                          color: Utils.darken(
                              Theme.of(context).colorScheme.primary, 15),
                        ),
                      ),
                    DisplayTeamOrPlayerName(
                      gameX01: gameX01,
                      i: i,
                      firstElementNoDrawOrOpenGame:
                          _firstElementNoDrawOrOpenGame,
                    ),
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

  final GameX01_P gameX01;
  final int i;
  final Function firstElementNoDrawOrOpenGame;

  @override
  Widget build(BuildContext context) {
    if (gameX01.getGameSettings.getSingleOrTeam == SingleOrTeamEnum.Team)
      return Flexible(
        child: Padding(
          padding: EdgeInsets.only(left: 2.w),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              gameX01.getTeamGameStatistics[i].getTeam.getName,
              style: TextStyle(
                fontSize: 14.sp,
                color: Utils.getTextColorDarken(context),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    else if (gameX01.getPlayerGameStatistics[i].getPlayer is Bot)
      return Flexible(
        child: Container(
          padding: EdgeInsets.only(left: 2.w),
          child: Column(
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'Bot - lvl. ${gameX01.getPlayerGameStatistics[i].getPlayer.getLevel}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Utils.getTextColorDarken(context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  '(${gameX01.getPlayerGameStatistics[i].getPlayer.getPreDefinedAverage.round() - BOT_AVG_SLIDER_VALUE_RANGE}-${gameX01.getPlayerGameStatistics[i].getPlayer.getPreDefinedAverage.round() + BOT_AVG_SLIDER_VALUE_RANGE} avg.)',
                  style: TextStyle(
                    fontSize: 8.sp,
                    color: Utils.getTextColorDarken(context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    else
      return Flexible(
        child: Container(
          padding: EdgeInsets.only(left: 2.w),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              gameX01.getPlayerGameStatistics[i].getPlayer.getName,
              style: TextStyle(
                fontSize: 14.sp,
                color: Utils.getTextColorDarken(context),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
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

  final GameX01_P gameX01;
  final int i;

  @override
  Widget build(BuildContext context) {
    final GameSettingsX01_P gameSettingsX01 = gameX01.getGameSettings;

    return Container(
      width: 40.w,
      padding: EdgeInsets.only(left: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            gameSettingsX01.getSetsEnabled
                ? 'Sets: ${Utils.getPlayersOrTeamStatsListStatsScreen(gameX01, gameSettingsX01)[i].getSetsWon}'
                : 'Legs: ${Utils.getPlayersOrTeamStatsListStatsScreen(gameX01, gameSettingsX01)[i].getLegsWon}',
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.white,
            ),
          ),
          Text(
            'Average: ${Utils.getPlayersOrTeamStatsListStatsScreen(gameX01, gameSettingsX01)[i].getAverage(gameSettingsX01)}',
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.white,
            ),
          ),
          if (gameSettingsX01.getEnableCheckoutCounting)
            Text(
              'Checkout: ${Utils.getPlayersOrTeamStatsListStatsScreen(gameX01, gameSettingsX01)[i].getCheckoutQuoteInPercent()}',
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
