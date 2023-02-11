import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_score_training_p.dart';
import 'package:dart_app/models/games/game_score_training_p.dart';
import 'package:dart_app/models/player_statistics/player_game_stats_score_training.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class OnePlayerStatsScoreTraining extends StatelessWidget {
  const OnePlayerStatsScoreTraining({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PlayerGameStatsScoreTraining playerStats =
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
                playerStats.getAverage(),
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
                playerStats.getRoundsOrPointsValue(isRoundMode),
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
                'Highest score:',
                style: TextStyle(
                  color: Utils.getTextColorDarken(context),
                  fontWeight: FontWeight.bold,
                  fontSize: FONTSIZE.sp,
                ),
              ),
              Text(
                playerStats.getHighestScore().toString(),
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
