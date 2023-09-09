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
    final GameScoreTraining_P game = context.read<GameScoreTraining_P>();

    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Utils.getPrimaryColorDarken(context),
                  width: 1.w,
                ),
                right: BorderSide(
                  color: Utils.getPrimaryColorDarken(context),
                  width: GENERAL_BORDER_WIDTH.w,
                ),
                left: game.getSafeAreaPadding.left > 0 &&
                        Utils.isLandscape(context)
                    ? BorderSide(
                        color: Utils.getPrimaryColorDarken(context),
                        width: GENERAL_BORDER_WIDTH.w,
                      )
                    : BorderSide.none,
                bottom: game.getSafeAreaPadding.bottom > 0 &&
                        Utils.isLandscape(context)
                    ? BorderSide(
                        color: Utils.getPrimaryColorDarken(context),
                        width: GENERAL_BORDER_WIDTH.w,
                      )
                    : BorderSide.none,
              ),
            ),
            child: PlayerEntry(
              playerStats: game.getPlayerGameStatistics[0],
            ),
          ),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Utils.getPrimaryColorDarken(context),
                  width: GENERAL_BORDER_WIDTH.w,
                ),
                bottom: game.getSafeAreaPadding.bottom > 0 &&
                        Utils.isLandscape(context)
                    ? BorderSide(
                        color: Utils.getPrimaryColorDarken(context),
                        width: GENERAL_BORDER_WIDTH.w,
                      )
                    : BorderSide.none,
              ),
            ),
            child: PlayerEntry(
              playerStats: game.getPlayerGameStatistics[1],
            ),
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
    final double PADDING_TOP = 1.h;

    return Container(
      color: _getBackgroundColor(context),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 2.h, left: 1.w, right: 1.w),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                playerStats.getPlayer.getName,
                style: TextStyle(
                  color: Utils.getTextColorDarken(context),
                  fontWeight: FontWeight.bold,
                  fontSize: Theme.of(context).textTheme.titleLarge!.fontSize,
                ),
              ),
            ),
          ),
          Text(
            'Average',
            style: TextStyle(
              color: Utils.getTextColorDarken(context),
              fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            playerStats.getAverage(),
            style: TextStyle(
              color: Colors.white,
              fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              top: PADDING_TOP,
            ),
            child: Text(
              'Highest score',
              style: TextStyle(
                color: Utils.getTextColorDarken(context),
                fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            playerStats.getHighestScore().toString(),
            style: TextStyle(
              color: Colors.white,
              fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              top: PADDING_TOP,
            ),
            child: Text(
              'Thrown darts',
              style: TextStyle(
                color: Utils.getTextColorDarken(context),
                fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            playerStats.getThrownDarts.toString(),
            style: TextStyle(
              color: Colors.white,
              fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              top: PADDING_TOP,
            ),
            child: Text(
              '${isRoundMode ? 'Rounds' : 'Points'} left',
              style: TextStyle(
                color: Utils.getTextColorDarken(context),
                fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            playerStats.getRoundsOrPointsValue(isRoundMode),
            style: TextStyle(
              color: Colors.white,
              fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
            ),
          ),
        ],
      ),
    );
  }
}
