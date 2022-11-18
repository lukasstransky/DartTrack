import 'package:dart_app/models/bot.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_statistics_x01.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class DetailedLeg extends StatefulWidget {
  const DetailedLeg(
      {Key? key,
      required this.setLegString,
      required this.winnerOfLeg,
      required this.gameX01})
      : super(key: key);

  final String setLegString;
  final String winnerOfLeg;
  final GameX01 gameX01;

  @override
  State<DetailedLeg> createState() => _DetailedLegState();
}

class _DetailedLegState extends State<DetailedLeg> {
  int _currentPoints = 0;

  @override
  initState() {
    super.initState();

    _currentPoints = context.read<GameSettingsX01>().getPointsOrCustom();
  }

  String _getCurrentValue(int score, int i,
      PlayerOrTeamGameStatisticsX01 playerOrTeamGameStatsX01) {
    _currentPoints -= score;
    final String result = _currentPoints.toString();

    if (i ==
        playerOrTeamGameStatsX01
                .getAllScoresPerLeg[widget.setLegString].length -
            1) {
      _currentPoints =
          _currentPoints = context.read<GameSettingsX01>().getPointsOrCustom();
    }

    return result;
  }

  String _getThrownDartsForLeg(
      PlayerOrTeamGameStatisticsX01 playerOrTeamGameStatsX01) {
    return playerOrTeamGameStatsX01.getThrownDartsPerLeg[widget.setLegString]
        .toString();
  }

  bool _emptyRowNeeded(
      int dartsToCheck, GameX01 gameX01, GameSettingsX01 gameSettingsX01) {
    int mostDarts = 0;
    for (PlayerOrTeamGameStatisticsX01 playerOrTeamGameStatsX01
        in Utils.getPlayersOrTeamStatsList(gameX01, gameSettingsX01)) {
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

  String _getPlayerOrTeamName(PlayerOrTeamGameStatisticsX01 stats,
      GameX01 gameX01, GameSettingsX01 gameSettingsX01) {
    if (Utils.teamStatsDisplayed(gameX01, gameSettingsX01))
      return stats.getTeam.getName;

    if (stats.getPlayer is Bot) return 'Bot';

    return stats.getPlayer.getName;
  }

  @override
  Widget build(BuildContext context) {
    final GameSettingsX01 gameSettingsX01 = widget.gameX01.getGameSettings;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (PlayerOrTeamGameStatisticsX01 playerOrTeamGameStatsX01
                in Utils.getPlayersOrTeamStatsList(
                    widget.gameX01, gameSettingsX01))
              Container(
                width: 43.w,
                padding: EdgeInsets.all(2.w),
                child: Column(
                  children: [
                    Text(
                      _getPlayerOrTeamName(playerOrTeamGameStatsX01,
                          widget.gameX01, gameSettingsX01),
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 15.sp),
                    ),
                    for (int i = 0;
                        i <
                            (playerOrTeamGameStatsX01.getAllScoresPerLeg
                                    .containsKey(widget.setLegString)
                                ? playerOrTeamGameStatsX01
                                    .getAllScoresPerLeg[widget.setLegString]
                                    .length
                                : 0);
                        i++) ...[
                      if (i == 0)
                        Padding(
                          padding: EdgeInsets.only(bottom: 10, top: 5),
                          child: Row(
                            children: [
                              Expanded(
                                child: Center(
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      'Score',
                                      style: TextStyle(fontSize: 11.sp),
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
                                      style: TextStyle(fontSize: 11.sp),
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
                                          .getAllScoresPerLeg[
                                              widget.setLegString]
                                          .elementAt(i),
                                      i,
                                      playerOrTeamGameStatsX01),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (i ==
                              playerOrTeamGameStatsX01
                                      .getAllScoresPerLeg[widget.setLegString]
                                      .length -
                                  1 &&
                          _emptyRowNeeded(
                              playerOrTeamGameStatsX01
                                  .getAllScoresPerLeg[widget.setLegString]
                                  .length,
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
                    const Divider(
                      height: 15,
                      thickness: 1,
                      indent: 10,
                      endIndent: 10,
                      color: Colors.black,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: Text('Avg.'),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text('Darts'),
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              Utils.getAverageForLeg(playerOrTeamGameStatsX01,
                                  widget.setLegString),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              _getThrownDartsForLeg(playerOrTeamGameStatsX01),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
