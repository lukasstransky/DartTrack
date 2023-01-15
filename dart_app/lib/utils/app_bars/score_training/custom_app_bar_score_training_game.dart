import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/score_training/game_settings_score_training_p.dart';
import 'package:dart_app/models/games/score_training/game_score_training_p.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class CustomAppBarScoreTrainingGame extends StatelessWidget
    with PreferredSizeWidget {
  const CustomAppBarScoreTrainingGame({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameSettingsScoreTraining_P =
        context.read<GameSettingsScoreTraining_P>();

    return AppBar(
      elevation: 0,
      centerTitle: true,
      title: Column(
        children: [
          Text(
            'Score Training',
            style: TextStyle(fontSize: 12.sp),
          ),
          Text(
            '(${gameSettingsScoreTraining_P.getMaxRoundsOrPoints} ${gameSettingsScoreTraining_P.getMode == ScoreTrainingModeEnum.MaxRounds ? 'rounds' : 'points'})',
            style: TextStyle(fontSize: 10.sp),
          )
        ],
      ),
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: () => Utils.showDialogForSavingGame(
                context, context.read<GameScoreTraining_P>()),
            icon: Icon(
              Icons.close_sharp,
              color: Theme.of(context).colorScheme.secondary,
            ),
          )
        ],
      ),
      actions: [
        IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: () => Navigator.of(context).pushNamed(
              '/statisticsScoreTraining',
              arguments: {'game': context.read<GameScoreTraining_P>()}),
          icon: Icon(
            Icons.bar_chart_rounded,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
