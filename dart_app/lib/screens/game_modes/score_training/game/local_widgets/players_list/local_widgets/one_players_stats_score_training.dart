import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/score_training/game_settings_score_training_p.dart';
import 'package:dart_app/models/games/score_training/game_score_training_p.dart';
import 'package:dart_app/models/player_statistics/score_training/player_game_statistics_score_training.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class OnePlayerStatsScoreTraining extends StatelessWidget {
  const OnePlayerStatsScoreTraining({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PlayerGameStatisticsScoreTraining playerStats =
        context.read<GameScoreTraining_P>().getCurrentPlayerGameStats();
    final bool isRoundMode =
        context.read<GameSettingsScoreTraining_P>().getMode ==
            ScoreTrainingModeEnum.MaxRounds;
    const int WIDTH = 60;
    const int FONTSIZE = 18;

    const double PADDING_TOP = 20;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          transform: Matrix4.translationValues(0.0, -15.0, 0.0),
          child: Text(
            playerStats.getPlayer.getName,
            style: TextStyle(
              color: Utils.getTextColorDarken(context),
              fontWeight: FontWeight.bold,
              fontSize: 20.sp,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(
            top: PADDING_TOP,
          ),
          width: WIDTH.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Average:',
                style: TextStyle(
                  color: Utils.getTextColorDarken(context),
                  fontWeight: FontWeight.bold,
                  fontSize: FONTSIZE.sp,
                ),
              ),
              Text(
                playerStats.getAverage().toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: FONTSIZE.sp,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(
            top: PADDING_TOP,
          ),
          width: WIDTH.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isRoundMode ? 'Highest score:' : 'Total rounds:',
                style: TextStyle(
                  color: Utils.getTextColorDarken(context),
                  fontWeight: FontWeight.bold,
                  fontSize: FONTSIZE.sp,
                ),
              ),
              Text(
                isRoundMode
                    ? playerStats.getHighestScore().toString()
                    : (playerStats.getThrownDarts / 3).round().toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: FONTSIZE.sp,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(
            top: PADDING_TOP,
          ),
          width: WIDTH.w,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${isRoundMode ? 'Rounds' : 'Points'} left:',
                style: TextStyle(
                  color: Utils.getTextColorDarken(context),
                  fontWeight: FontWeight.bold,
                  fontSize: FONTSIZE.sp,
                ),
              ),
              Text(
                playerStats.getRoundsOrPointsLeft.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: FONTSIZE.sp,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
