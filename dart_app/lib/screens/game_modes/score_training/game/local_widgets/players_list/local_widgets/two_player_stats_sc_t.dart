import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_score_training_p.dart';
import 'package:dart_app/models/games/game_score_training_p.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/models/player_statistics/player_game_stats_score_training.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class TwoPlayerStatsScoreTraining extends StatelessWidget {
  const TwoPlayerStatsScoreTraining({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final game = context.read<GameScoreTraining_P>();
    const double WIDTH = 50;

    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Utils.getPrimaryColorDarken(context),
                width: GENERAL_BORDER_WIDTH,
              ),
              right: BorderSide(
                color: Utils.getPrimaryColorDarken(context),
                width: GENERAL_BORDER_WIDTH,
              ),
            ),
          ),
          width: WIDTH.w,
          child: PlayerEntry(
            playerStats: game.getPlayerGameStatistics[0],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Utils.getPrimaryColorDarken(context),
                width: GENERAL_BORDER_WIDTH,
              ),
            ),
          ),
          width: WIDTH.w,
          child: PlayerEntry(
            playerStats: game.getPlayerGameStatistics[1],
          ),
        ),
      ],
    );
  }
}

class PlayerEntry extends StatelessWidget {
  const PlayerEntry({
    Key? key,
    required this.playerStats,
  }) : super(key: key);

  final PlayerGameStatsScoreTraining playerStats;

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
    final bool isRoundMode =
        context.read<GameSettingsScoreTraining_P>().getMode ==
            ScoreTrainingModeEnum.MaxRounds;
    const int FONTSIZE = 18;
    const double PADDING_TOP = 10;

    return Container(
      color: _getBackgroundColor(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            transform: Matrix4.translationValues(0.0, -20.0, 0.0),
            child: Text(
              playerStats.getPlayer.getName,
              style: TextStyle(
                color: Utils.getTextColorDarken(context),
                fontWeight: FontWeight.bold,
                fontSize: FONTSIZE.sp,
              ),
            ),
          ),
          Text(
            'Average',
            style: TextStyle(
              color: Colors.white,
              fontSize: FONTSIZE.sp,
            ),
          ),
          Text(
            playerStats.getAverage().toString(),
            style: TextStyle(
              color: Utils.getTextColorDarken(context),
              fontWeight: FontWeight.bold,
              fontSize: FONTSIZE.sp,
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              top: PADDING_TOP,
            ),
            child: Text(
              'Current points',
              style: TextStyle(
                color: Colors.white,
                fontSize: FONTSIZE.sp,
              ),
            ),
          ),
          Text(
            playerStats.getCurrentScore.toString(),
            style: TextStyle(
              color: Utils.getTextColorDarken(context),
              fontWeight: FontWeight.bold,
              fontSize: FONTSIZE.sp,
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              top: PADDING_TOP,
            ),
            child: Text(
              '${isRoundMode ? 'Rounds' : 'Points'} left:',
              style: TextStyle(
                color: Colors.white,
                fontSize: FONTSIZE.sp,
              ),
            ),
          ),
          Text(
            playerStats.getRoundsOrPointsLeft.toString(),
            style: TextStyle(
              color: Utils.getTextColorDarken(context),
              fontWeight: FontWeight.bold,
              fontSize: FONTSIZE.sp,
            ),
          ),
        ],
      ),
    );
  }
}
