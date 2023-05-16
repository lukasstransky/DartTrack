import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/game_single_double_training_p.dart';
import 'package:dart_app/models/player_statistics/player_game_stats_single_double_training.dart';
import 'package:dart_app/screens/game_modes/shared/game_stats/heading_text.dart';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class FieldHitsSingleDoubleTraining extends StatelessWidget {
  const FieldHitsSingleDoubleTraining({
    Key? key,
    required this.game,
  }) : super(key: key);

  final GameSingleDoubleTraining_P game;

  int _getScoredPointsForField(String hits) {
    int result = 0;
    hits.split('').forEach((hit) {
      switch (hit) {
        case 'S':
          result += 1;
          break;
        case 'D':
          result += game.getName == GameMode.DoubleTraining.name ||
                  game.getMode == GameMode.DoubleTraining
              ? 1
              : 2;
          break;
        case 'T':
          result += 3;
          break;
      }
    });

    return result;
  }

  bool _shouldHighlight(PlayerGameStatsSingleDoubleTraining stats, int field) {
    if (stats.getPointsForSpecificField(
            field, game.getMode == GameMode.DoubleTraining) ==
        stats.getHighestPoints) {
      if (stats.getHighestPoints != 0) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final bool isAscendingOrRandomMode =
        game.getGameSettings.getMode == ModesSingleDoubleTraining.Ascending ||
            game.getGameSettings.getMode == ModesSingleDoubleTraining.Random;
    final bool isTargetNumberEnabled =
        game.getGameSettings.getIsTargetNumberEnabled;

    int i = (isAscendingOrRandomMode || isTargetNumberEnabled) ? 1 : 20;

    return Container(
      padding: EdgeInsets.only(
        left: PADDING_LEFT_STATISTICS.w,
        top: PADDING_TOP_STATISTICS.h,
        bottom: PADDING_BOTTOM.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            transform: Matrix4.translationValues(-10.0, 0.0, 0.0),
            padding: EdgeInsets.only(top: 1.h),
            child: RichText(
              text: TextSpan(
                text: 'Field hits',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: FONTSIZE_HEADING_STATISTICS.sp,
                ),
                children: <TextSpan>[
                  if (isTargetNumberEnabled)
                    TextSpan(
                      text: ' (per round)',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12.sp,
                      ),
                    ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 1.h),
            child: Column(
              children: [
                for (i;
                    isTargetNumberEnabled
                        ? i < game.getGameSettings.getAmountOfRounds + 1
                        : (isAscendingOrRandomMode || isTargetNumberEnabled)
                            ? i < 21
                            : i > 0;
                    (isAscendingOrRandomMode || isTargetNumberEnabled)
                        ? i++
                        : i--)
                  Row(
                    children: [
                      HeadingTextGameStats(
                        textValue: '${i}.',
                      ),
                      for (PlayerGameStatsSingleDoubleTraining stats
                          in game.getPlayerGameStatistics)
                        Container(
                          padding:
                              EdgeInsets.only(top: PADDING_TOP_STATISTICS.h),
                          width: WIDTH_DATA_STATISTICS.w,
                          child: Row(
                            children: [
                              Container(
                                alignment: stats.getFieldHits[i]! != '-'
                                    ? Alignment.centerLeft
                                    : Alignment.center,
                                width: 10.w,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    '${stats.getFieldHits[i]!} ',
                                    style: TextStyle(
                                      fontSize: FONTSIZE_STATISTICS.sp,
                                      color: _shouldHighlight(stats, i)
                                          ? Theme.of(context)
                                              .colorScheme
                                              .secondary
                                          : Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                width: 20.w,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    ' ${stats.getFieldHits[i]! != '-' ? '(${_getScoredPointsForField(stats.getFieldHits[i]!)})' : ''}',
                                    style: TextStyle(
                                      fontSize: FONTSIZE_STATISTICS.sp,
                                      color: _shouldHighlight(stats, i)
                                          ? Theme.of(context)
                                              .colorScheme
                                              .secondary
                                          : Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
