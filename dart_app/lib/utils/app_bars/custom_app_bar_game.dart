import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_score_training_p.dart';
import 'package:dart_app/models/game_settings/game_settings_single_double_training_p.dart';
import 'package:dart_app/models/games/game_score_training_p.dart';
import 'package:dart_app/models/games/game_single_double_training_p.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class CustomAppBarGame extends StatelessWidget with PreferredSizeWidget {
  const CustomAppBarGame({Key? key, required this.mode}) : super(key: key);

  final GameMode mode;

  dynamic _getSettingsBasedOnMode(BuildContext context) {
    if (mode == GameMode.ScoreTraining) {
      return context.read<GameSettingsScoreTraining_P>();
    } else if (mode == GameMode.SingleTraining ||
        mode == GameMode.DoubleTraining) {
      return context.read<GameSettingsSingleDoubleTraining_P>();
    }
  }

  _getHeader(dynamic settings) {
    if (mode == GameMode.ScoreTraining) {
      return 'Score Training';
    } else if (mode == GameMode.SingleTraining) {
      return 'Single Training';
    } else if (mode == GameMode.DoubleTraining) {
      return 'Double Training';
    }
  }

  _getSubHeader(dynamic settings) {
    if (mode == GameMode.ScoreTraining) {
      return '(${settings.getMaxRoundsOrPoints} ${settings.getMode == ScoreTrainingModeEnum.MaxRounds ? 'rounds' : 'points'})';
    } else if (mode == GameMode.SingleTraining ||
        mode == GameMode.DoubleTraining) {
      return (settings.getMode as ModesSingleDoubleTraining).name;
    }
  }

  @override
  Widget build(BuildContext context) {
    dynamic settings = _getSettingsBasedOnMode(context);

    return AppBar(
      elevation: 0,
      centerTitle: true,
      title: Column(
        children: [
          Text(
            _getHeader(settings),
            style: TextStyle(fontSize: 12.sp),
          ),
          Text(
            _getSubHeader(settings),
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
            onPressed: () {
              if (mode == GameMode.ScoreTraining) {
                return Utils.showDialogForSavingGame(
                    context, context.read<GameScoreTraining_P>());
              } else if (mode == GameMode.SingleTraining ||
                  mode == GameMode.DoubleTraining) {
                Utils.showDialogForSavingGame(
                    context, context.read<GameSingleDoubleTraining_P>());
              }
            },
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
          onPressed: () {
            if (mode == GameMode.ScoreTraining) {
              Navigator.of(context).pushNamed('/statisticsScoreTraining',
                  arguments: {'game': context.read<GameScoreTraining_P>()});
            } else if (mode == GameMode.SingleTraining ||
                mode == GameMode.DoubleTraining) {
              Navigator.of(context).pushNamed('/statisticsSingleDoubleTraining',
                  arguments: {
                    'game': context.read<GameSingleDoubleTraining_P>()
                  });
            }
          },
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
