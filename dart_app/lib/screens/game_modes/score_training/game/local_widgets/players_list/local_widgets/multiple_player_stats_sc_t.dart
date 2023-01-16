import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/score_training/game_settings_score_training_p.dart';
import 'package:dart_app/models/games/score_training/game_score_training_p.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_statistics.dart';
import 'package:dart_app/models/player_statistics/score_training/player_game_statistics_score_training.dart';
import 'package:dart_app/utils/globals.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class MulitplePlayerStatsScoreTraining extends StatelessWidget {
  const MulitplePlayerStatsScoreTraining({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const int fontSize = 13;
    final bool isRoundMode =
        context.read<GameSettingsScoreTraining_P>().getMode ==
            ScoreTrainingModeEnum.MaxRounds;

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                width: 25.w,
                alignment: Alignment.center,
                child: Text(
                  'Name',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: fontSize.sp,
                  ),
                ),
              ),
              Container(
                width: 25.w,
                alignment: Alignment.center,
                child: Text(
                  'Avg.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: fontSize.sp,
                  ),
                ),
              ),
              Container(
                width: 25.w,
                alignment: Alignment.center,
                child: Text(
                  'Score',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: fontSize.sp,
                  ),
                ),
              ),
              Container(
                width: 25.w,
                alignment: Alignment.center,
                child: Text(
                  isRoundMode ? 'Rounds left' : 'Points left',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: fontSize.sp,
                  ),
                ),
              ),
            ],
          ),
          Divider(
            height: 1,
            thickness: 1,
            color: Colors.white,
          ),
          Selector<GameScoreTraining_P, List<PlayerOrTeamGameStatistics>>(
            selector: (_, gameScoreTraining_P) =>
                gameScoreTraining_P.getPlayerGameStatistics,
            shouldRebuild: (previous, next) => true,
            builder: (_, playerStats, __) => ListView.builder(
              scrollDirection: Axis.vertical,
              controller: newScrollControllerScoreTrainingPlayerEntries(),
              itemCount: playerStats.length,
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    PlayerEntry(
                      playerStats: playerStats[index]
                          as PlayerGameStatisticsScoreTraining,
                    ),
                    index != playerStats.length - 1
                        ? Divider(
                            height: 1,
                            thickness: 1,
                            color: Colors.white,
                          )
                        : SizedBox.shrink(),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PlayerEntry extends StatelessWidget {
  const PlayerEntry({
    Key? key,
    required this.playerStats,
  }) : super(key: key);

  final PlayerGameStatisticsScoreTraining playerStats;

  Color _getBackgroundColor(BuildContext context) {
    if (Player.samePlayer(
        context.read<GameScoreTraining_P>().getCurrentPlayerToThrow,
        this.playerStats.getPlayer)) {
      return Utils.lighten(Theme.of(context).colorScheme.primary, 20);
    }

    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    const int fontSize = 13;

    return Container(
      color: _getBackgroundColor(context),
      height: 5.h,
      child: Row(
        children: [
          Container(
            width: 25.w,
            alignment: Alignment.center,
            child: Text(
              playerStats.getPlayer.getName,
              style: TextStyle(
                color: Utils.getTextColorDarken(context),
                fontWeight: FontWeight.bold,
                fontSize: fontSize.sp,
              ),
            ),
          ),
          Container(
            width: 25.w,
            alignment: Alignment.center,
            child: Text(
              playerStats.getAverage().toString(),
              style: TextStyle(
                color: Utils.getTextColorDarken(context),
                fontWeight: FontWeight.bold,
                fontSize: fontSize.sp,
              ),
            ),
          ),
          Container(
            width: 25.w,
            alignment: Alignment.center,
            child: Text(
              playerStats.getCurrentScore.toString(),
              style: TextStyle(
                color: Utils.getTextColorDarken(context),
                fontWeight: FontWeight.bold,
                fontSize: fontSize.sp,
              ),
            ),
          ),
          Container(
            width: 25.w,
            alignment: Alignment.center,
            child: Text(
              playerStats.getRoundsOrPointsLeft.toString(),
              style: TextStyle(
                color: Utils.getTextColorDarken(context),
                fontWeight: FontWeight.bold,
                fontSize: fontSize.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
