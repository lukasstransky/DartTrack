import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_score_training_p.dart';
import 'package:dart_app/models/games/game_score_training_p.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats.dart';
import 'package:dart_app/models/player_statistics/player_game_stats_score_training.dart';
import 'package:dart_app/utils/globals.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class MulitplePlayerStatsScoreTraining extends StatefulWidget {
  const MulitplePlayerStatsScoreTraining({Key? key}) : super(key: key);

  @override
  State<MulitplePlayerStatsScoreTraining> createState() =>
      _MulitplePlayerStatsScoreTrainingState();
}

class _MulitplePlayerStatsScoreTrainingState
    extends State<MulitplePlayerStatsScoreTraining> {
  @override
  void initState() {
    super.initState();
    newScrollControllerScoreTrainingPlayerEntries();
  }

  @override
  Widget build(BuildContext context) {
    final bool isRoundMode =
        context.read<GameSettingsScoreTraining_P>().getMode ==
            ScoreTrainingModeEnum.MaxRounds;

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 0.5.h),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: SMALL_BORDER_WIDTH.w,
                  color: Colors.white,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Name',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize:
                            Theme.of(context).textTheme.titleSmall!.fontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Score',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize:
                            Theme.of(context).textTheme.titleSmall!.fontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        isRoundMode ? 'Rounds left' : 'Points left',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize:
                              Theme.of(context).textTheme.titleSmall!.fontSize,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Selector<GameScoreTraining_P, List<PlayerOrTeamGameStats>>(
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
                      playerStats:
                          playerStats[index] as PlayerGameStatsScoreTraining,
                    ),
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

  final PlayerGameStatsScoreTraining playerStats;

  @override
  Widget build(BuildContext context) {
    final GameScoreTraining_P game = context.read<GameScoreTraining_P>();

    return Container(
      height: 5.h,
      decoration: BoxDecoration(
        color: Utils.getBackgroundColorForPlayer(context, game, playerStats),
        border: Border(
          bottom: BorderSide(
            width: SMALL_BORDER_WIDTH.w,
            color: Colors.white,
          ),
          left: game.getSafeAreaPadding.left > 0
              ? BorderSide(
                  width: SMALL_BORDER_WIDTH.w,
                  color: Colors.white,
                )
              : BorderSide.none,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(left: 0.5.w),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  playerStats.getPlayer.getName,
                  style: TextStyle(
                    color: Utils.getTextColorDarken(context),
                    fontWeight: FontWeight.bold,
                    fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Text(
                playerStats.getCurrentScore.toString(),
                style: TextStyle(
                  color: Utils.getTextColorDarken(context),
                  fontWeight: FontWeight.bold,
                  fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              child: Text(
                playerStats.getRoundsOrPointsValue(
                    context.read<GameSettingsScoreTraining_P>().getMode ==
                        ScoreTrainingModeEnum.MaxRounds),
                style: TextStyle(
                  color: Utils.getTextColorDarken(context),
                  fontWeight: FontWeight.bold,
                  fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
