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

class PlayerEntryFinishX01 extends StatefulWidget {
  const PlayerEntryFinishX01(
      {Key? key,
      required this.i,
      required this.gameX01,
      required this.openGame})
      : super(key: key);

  final int i;
  final GameX01_P gameX01;
  final bool openGame;

  @override
  State<PlayerEntryFinishX01> createState() => _PlayerEntryFinishX01State();
}

class _PlayerEntryFinishX01State extends State<PlayerEntryFinishX01> {
  List<PlayerOrTeamGameStatsX01> _playerStats = [];
  List<PlayerOrTeamGameStatsX01> _teamStats = [];

  @override
  void initState() {
    _playerStats = [...widget.gameX01.getPlayerGameStatistics];
    _playerStats.sort();
    _teamStats = [...widget.gameX01.getTeamGameStatistics];
    _teamStats.sort();

    super.initState();
  }

  bool _firstElementNoDrawOrOpenGame(GameX01_P gameX01, dynamic statsList) {
    return widget.i == 0 && !gameX01.isGameDraw(statsList) && !widget.openGame;
  }

  checkForSameAmountOfSetsLegs(int indexOfPlayerOrTeam, dynamic statsList) {
    if (indexOfPlayerOrTeam == 0) {
      return 1;
    } else if (indexOfPlayerOrTeam == 1) {
      return 2;
    }

    if (statsList.length != 0) {
      for (int i = 1; i < indexOfPlayerOrTeam; i++) {
        if (widget.gameX01.getGameSettings.getSetsEnabled) {
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
    }

    return indexOfPlayerOrTeam + 1;
  }

  @override
  Widget build(BuildContext context) {
    final List<PlayerOrTeamGameStats> statsList =
        Utils.getPlayersOrTeamStatsList(
            widget.gameX01,
            widget.gameX01.getGameSettings.getSingleOrTeam ==
                SingleOrTeamEnum.Team);
    final double _trophySize = Utils.getResponsiveValue(
      context: context,
      mobileValue: 14,
      tabletValue: 12,
    );
    final double _fontSizeNameFirst = Utils.getResponsiveValue(
      context: context,
      mobileValue: 14,
      tabletValue: 12,
    );

    return Padding(
      padding: EdgeInsets.only(
          left: 5.w,
          bottom: Utils.getPlayersOrTeamStatsList(
                              widget.gameX01,
                              widget.gameX01.getGameSettings.getSingleOrTeam ==
                                  SingleOrTeamEnum.Team)
                          .length -
                      1 ==
                  widget.i
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
                    widget.gameX01.isGameDraw(statsList) ||
                            widget.gameX01.getIsOpenGame
                        ? SizedBox.shrink()
                        : Container(
                            width: 5.w,
                            child: Text(
                              '${checkForSameAmountOfSetsLegs(widget.i, statsList)}.',
                              style: TextStyle(
                                fontSize: widget.i == 0 && !widget.openGame
                                    ? _fontSizeNameFirst.sp
                                    : Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .fontSize,
                                fontWeight: FontWeight.bold,
                                color: Utils.getTextColorDarken(context),
                              ),
                            ),
                          ),
                    if (_firstElementNoDrawOrOpenGame(
                        widget.gameX01, statsList))
                      Container(
                        padding: EdgeInsets.only(left: 2.w),
                        child: Icon(
                          Entypo.trophy,
                          size: _trophySize.sp,
                          color: Color(0xffFFD700),
                        ),
                      )
                    else if (widget.gameX01.isGameDraw(statsList))
                      Container(
                        padding: EdgeInsets.only(left: 5.w),
                      )
                    else
                      Container(
                        padding: widget.openGame
                            ? EdgeInsets.only(left: 1.w)
                            : EdgeInsets.only(left: 2.w),
                        child: Icon(
                          Entypo.trophy,
                          size: _trophySize.sp,
                          color: Utils.darken(
                              Theme.of(context).colorScheme.primary, 15),
                        ),
                      ),
                    DisplayTeamOrPlayerName(
                      playerStats: _playerStats,
                      teamStats: _teamStats,
                      i: widget.i,
                      singleOrTeamEnum:
                          widget.gameX01.getGameSettings.getSingleOrTeam,
                      isOpenGame: widget.openGame,
                    ),
                  ],
                ),
              ),
              PlayerStats(
                  gameX01: widget.gameX01,
                  i: widget.i,
                  openGame: widget.openGame),
            ],
          ),
        ],
      ),
    );
  }
}

class DisplayTeamOrPlayerName extends StatelessWidget {
  const DisplayTeamOrPlayerName({
    Key? key,
    required this.playerStats,
    required this.teamStats,
    required this.i,
    required this.singleOrTeamEnum,
    required this.isOpenGame,
  }) : super(key: key);

  final List<PlayerOrTeamGameStatsX01> playerStats;
  final List<PlayerOrTeamGameStatsX01> teamStats;
  final int i;
  final SingleOrTeamEnum singleOrTeamEnum;
  final bool isOpenGame;

  @override
  Widget build(BuildContext context) {
    final double _fontSizeNameFirst = Utils.getResponsiveValue(
      context: context,
      mobileValue: 14,
      tabletValue: 12,
    );

    if (singleOrTeamEnum == SingleOrTeamEnum.Team)
      return Flexible(
        child: Padding(
          padding: EdgeInsets.only(left: 2.w),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              teamStats[i].getTeam.getName,
              style: TextStyle(
                fontSize: i == 0 || isOpenGame
                    ? _fontSizeNameFirst.sp
                    : Theme.of(context).textTheme.bodyMedium!.fontSize,
                color: Utils.getTextColorDarken(context),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    else if (playerStats[i].getPlayer is Bot)
      return Flexible(
        child: Container(
          padding: EdgeInsets.only(left: 2.w),
          child: Column(
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'Bot - lvl. ${playerStats[i].getPlayer.getLevel}',
                  style: TextStyle(
                    fontSize: i == 0 || isOpenGame
                        ? _fontSizeNameFirst.sp
                        : Theme.of(context).textTheme.bodyMedium!.fontSize,
                    color: Utils.getTextColorDarken(context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  '(${playerStats[i].getPlayer.getPreDefinedAverage.round() - BOT_AVG_SLIDER_VALUE_RANGE} - ${playerStats[i].getPlayer.getPreDefinedAverage.round() + BOT_AVG_SLIDER_VALUE_RANGE} avg.)',
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
              playerStats[i].getPlayer.getName,
              style: TextStyle(
                fontSize: i == 0 || isOpenGame
                    ? _fontSizeNameFirst.sp
                    : Theme.of(context).textTheme.bodyMedium!.fontSize,
                color: Utils.getTextColorDarken(context),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
  }
}

class PlayerStats extends StatefulWidget {
  const PlayerStats({
    Key? key,
    required this.gameX01,
    required this.i,
    required this.openGame,
  }) : super(key: key);

  final GameX01_P gameX01;
  final int i;
  final bool openGame;

  @override
  State<PlayerStats> createState() => _PlayerStatsState();
}

class _PlayerStatsState extends State<PlayerStats> {
  List<PlayerOrTeamGameStatsX01> _playersOrTeamStatsList = [];

  @override
  void initState() {
    _playersOrTeamStatsList = [
      ...Utils.getPlayersOrTeamStatsListStatsScreen(
          widget.gameX01, widget.gameX01.getGameSettings)
    ];
    _playersOrTeamStatsList.sort();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final GameSettingsX01_P gameSettingsX01 = widget.gameX01.getGameSettings;
    final int legsWon = _playersOrTeamStatsList[widget.i].getLegsWon;

    return Container(
      width: 40.w,
      padding: EdgeInsets.only(left: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Text(
                gameSettingsX01.getSetsEnabled
                    ? 'Sets: ${_playersOrTeamStatsList[widget.i].getSetsWon}'
                    : 'Legs: ${legsWon}',
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              if (widget.openGame && gameSettingsX01.getSetsEnabled)
                Text(
                  'Legs: ${legsWon}',
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                    color: Colors.white,
                  ),
                ),
            ],
          ),
          Text(
            'Average: ${_playersOrTeamStatsList[widget.i].getAverage()}',
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
              color: Colors.white,
            ),
          ),
          if (gameSettingsX01.getEnableCheckoutCounting &&
              !gameSettingsX01.getCheckoutCountingFinallyDisabled)
            Text(
              'Checkout: ${_playersOrTeamStatsList[widget.i].getCheckoutQuoteInPercent()}',
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                color: Colors.white,
              ),
            ),
        ],
      ),
    );
  }
}
