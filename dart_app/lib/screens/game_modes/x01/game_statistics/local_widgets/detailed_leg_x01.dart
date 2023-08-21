import 'package:dart_app/models/bot.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats_x01.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class DetailedLegX01 extends StatefulWidget {
  const DetailedLegX01(
      {Key? key,
      required this.setLegString,
      required this.winnerOfLeg,
      required this.gameX01})
      : super(key: key);

  final String setLegString;
  final String winnerOfLeg;
  final GameX01_P gameX01;

  @override
  State<DetailedLegX01> createState() => _DetailedLegX01State();
}

class _DetailedLegX01State extends State<DetailedLegX01> {
  int _currentPoints = 0;

  @override
  initState() {
    super.initState();

    _currentPoints = context.read<GameSettingsX01_P>().getPointsOrCustom();
  }

  @override
  Widget build(BuildContext context) {
    final GameSettingsX01_P gameSettingsX01 = widget.gameX01.getGameSettings;
    final dynamic playersOrTeamsList =
        Utils.getPlayersOrTeamStatsListStatsScreen(
            widget.gameX01, gameSettingsX01);
    final bool twoPlayersOrTeams = playersOrTeamsList.length == 2;

    return twoPlayersOrTeams
        ? LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (PlayerOrTeamGameStatsX01 playerOrTeamGameStatsX01
                      in playersOrTeamsList)
                    Container(
                      width: constraints.maxWidth / playersOrTeamsList.length,
                      child: bodyData(
                          playerOrTeamGameStatsX01, gameSettingsX01, context),
                    )
                ],
              ),
            ),
          )
        : SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (PlayerOrTeamGameStatsX01 playerOrTeamGameStatsX01
                      in playersOrTeamsList)
                    Container(
                      width: 43.w,
                      padding: EdgeInsets.all(2.w),
                      child: bodyData(
                          playerOrTeamGameStatsX01, gameSettingsX01, context),
                    ),
                ],
              ),
            ),
          );
  }

  Column bodyData(PlayerOrTeamGameStatsX01 playerOrTeamGameStatsX01,
      GameSettingsX01_P gameSettingsX01, BuildContext context) {
    final double _fontSize = Utils.getResponsiveValue(
      context: context,
      mobileValue: 12,
      tabletValue: 10,
      otherValue: 10,
    );

    return Column(
      children: [
        Text(
          _getPlayerOrTeamName(
              playerOrTeamGameStatsX01, widget.gameX01, gameSettingsX01),
          style: TextStyle(
            fontSize: (_fontSize + 2).sp,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        for (int i = 0;
            i <
                (playerOrTeamGameStatsX01.getAllScoresPerLeg
                        .containsKey(widget.setLegString)
                    ? playerOrTeamGameStatsX01
                        .getAllScoresPerLeg[widget.setLegString].length
                    : 0);
            i++) ...[
          if (i == 0)
            Padding(
              padding: EdgeInsets.only(
                bottom: 1.h,
                top: 0.5.h,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Score',
                          style: TextStyle(
                            fontSize: _fontSize.sp,
                            color: Utils.getTextColorDarken(context),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Left',
                          style: TextStyle(
                            fontSize: _fontSize.sp,
                            color: Utils.getTextColorDarken(context),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Row(
            children: [
              Expanded(
                child: Container(
                  child: Center(
                    child: Text(
                      playerOrTeamGameStatsX01
                          .getAllScoresPerLeg[widget.setLegString]
                          .elementAt(i)
                          .toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: _fontSize.sp,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: Center(
                    child: Text(
                      _getCurrentValue(
                          playerOrTeamGameStatsX01
                              .getAllScoresPerLeg[widget.setLegString]
                              .elementAt(i),
                          i,
                          playerOrTeamGameStatsX01),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: _fontSize.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (i ==
                  playerOrTeamGameStatsX01
                          .getAllScoresPerLeg[widget.setLegString].length -
                      1 &&
              _emptyRowNeeded(
                  playerOrTeamGameStatsX01
                      .getAllScoresPerLeg[widget.setLegString].length,
                  widget.gameX01,
                  gameSettingsX01))
            Row(
              children: [
                Expanded(
                  child: Center(
                    child: Text(''),
                  ),
                ),
              ],
            ),
        ],
        Divider(
          height: 1.5.h,
          thickness: 1.5,
          indent: 10,
          endIndent: 10,
          color: Utils.getTextColorDarken(context),
        ),
        Row(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  'Avg.',
                  style: TextStyle(
                    color: Utils.getTextColorDarken(context),
                    fontWeight: FontWeight.bold,
                    fontSize: _fontSize.sp,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'Darts',
                  style: TextStyle(
                    color: Utils.getTextColorDarken(context),
                    fontWeight: FontWeight.bold,
                    fontSize: _fontSize.sp,
                  ),
                ),
              ),
            )
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  Utils.getAverageForLeg(
                      playerOrTeamGameStatsX01, widget.setLegString),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: _fontSize.sp,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  _getThrownDartsForLeg(playerOrTeamGameStatsX01),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: _fontSize.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _getCurrentValue(
      int score, int i, PlayerOrTeamGameStatsX01 playerOrTeamGameStatsX01) {
    _currentPoints -= score;
    final String result = _currentPoints.toString();

    if (i ==
        playerOrTeamGameStatsX01
                .getAllScoresPerLeg[widget.setLegString].length -
            1) {
      _currentPoints = _currentPoints =
          context.read<GameSettingsX01_P>().getPointsOrCustom();
    }

    return result;
  }

  String _getThrownDartsForLeg(
      PlayerOrTeamGameStatsX01 playerOrTeamGameStatsX01) {
    return playerOrTeamGameStatsX01.getThrownDartsPerLeg[widget.setLegString]
        .toString();
  }

  bool _emptyRowNeeded(
      int dartsToCheck, GameX01_P gameX01, GameSettingsX01_P gameSettingsX01) {
    int mostDarts = 0;
    for (PlayerOrTeamGameStatsX01 playerOrTeamGameStatsX01
        in Utils.getPlayersOrTeamStatsListStatsScreen(
            gameX01, gameSettingsX01)) {
      final bool isValueForKeyAvailable = playerOrTeamGameStatsX01
          .getAllScoresPerLeg
          .containsKey(widget.setLegString);

      if (isValueForKeyAvailable) {
        if (playerOrTeamGameStatsX01
                .getAllScoresPerLeg[widget.setLegString].length >
            mostDarts) {
          mostDarts = playerOrTeamGameStatsX01
              .getAllScoresPerLeg[widget.setLegString].length;
        }
      }
    }

    return mostDarts > dartsToCheck ? true : false;
  }

  String _getPlayerOrTeamName(PlayerOrTeamGameStatsX01 stats, GameX01_P gameX01,
      GameSettingsX01_P gameSettingsX01) {
    if (Utils.teamStatsDisplayed(gameX01, gameSettingsX01))
      return stats.getTeam.getName;

    if (stats.getPlayer is Bot) return 'Bot';

    return stats.getPlayer.getName;
  }
}
