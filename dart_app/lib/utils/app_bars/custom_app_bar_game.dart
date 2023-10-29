import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_cricket_p.dart';
import 'package:dart_app/models/game_settings/game_settings_score_training_p.dart';
import 'package:dart_app/models/game_settings/game_settings_single_double_training_p.dart';
import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/models/games/game_cricket_p.dart';
import 'package:dart_app/models/games/game_score_training_p.dart';
import 'package:dart_app/models/games/game_single_double_training_p.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:dart_app/utils/utils_dialogs.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class CustomAppBarGame extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBarGame({Key? key, required this.mode}) : super(key: key);

  final GameMode mode;

  @override
  Widget build(BuildContext context) {
    dynamic settings = _getSettingsBasedOnMode(context);

    return AppBar(
      elevation: 0,
      centerTitle: true,
      title: _getTitleColumn(context, settings),
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            splashColor:
                Utils.darken(Theme.of(context).colorScheme.primary, 10),
            splashRadius: SPLASH_RADIUS,
            highlightColor:
                Utils.darken(Theme.of(context).colorScheme.primary, 10),
            onPressed: () => _crossIconPressed(context),
            icon: Icon(
              size: ICON_BUTTON_SIZE.h,
              Icons.close_sharp,
              color: Theme.of(context).colorScheme.secondary,
            ),
          )
        ],
      ),
      actions: [
        IconButton(
          splashColor: Utils.darken(Theme.of(context).colorScheme.primary, 10),
          splashRadius: SPLASH_RADIUS,
          highlightColor:
              Utils.darken(Theme.of(context).colorScheme.primary, 10),
          onPressed: () => _statsIconPressed(context),
          icon: Icon(
            size: ICON_BUTTON_SIZE.h,
            Icons.bar_chart_rounded,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ],
    );
  }

  Column _getTitleColumn(BuildContext context, dynamic settings) {
    if (Utils.isMobile(context)) {
      return Column(
        children: [
          Text(
            _getHeader(settings),
            style: TextStyle(
                fontSize: Theme.of(context).textTheme.titleSmall!.fontSize),
          ),
          Text(
            _getSubHeader(settings),
            style: TextStyle(fontSize: 10.sp),
          )
        ],
      );
    }

    return Column(
      children: [
        Text(
          "${_getHeader(settings)} - ${_getSubHeader(settings)}",
          style: TextStyle(
              fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  dynamic _getSettingsBasedOnMode(BuildContext context) {
    if (mode == GameMode.ScoreTraining) {
      return context.read<GameSettingsScoreTraining_P>();
    } else if (mode == GameMode.SingleTraining ||
        mode == GameMode.DoubleTraining) {
      return context.read<GameSettingsSingleDoubleTraining_P>();
    } else if (mode == GameMode.Cricket) {
      return context.read<GameSettingsCricket_P>();
    }
  }

  _getHeader(dynamic settings) {
    if (mode == GameMode.ScoreTraining) {
      return GameMode.ScoreTraining.name;
    } else if (mode == GameMode.SingleTraining) {
      return GameMode.SingleTraining.name;
    } else if (mode == GameMode.DoubleTraining) {
      return GameMode.DoubleTraining.name;
    } else if (mode == GameMode.Cricket) {
      return Utils.getBestOfOrFirstToString(settings);
    }
  }

  _getSubHeader(dynamic settings) {
    CricketMode test = CricketMode.CutThroat;
    test.name;
    if (mode == GameMode.ScoreTraining) {
      return '${settings.getMaxRoundsOrPoints} ${settings.getMode == ScoreTrainingModeEnum.MaxRounds ? 'rounds' : 'points'}';
    } else if (mode == GameMode.SingleTraining ||
        mode == GameMode.DoubleTraining) {
      if (settings.getIsTargetNumberEnabled) {
        return 'Target number';
      }
      return (settings.getMode as ModesSingleDoubleTraining).name;
    } else if (mode == GameMode.Cricket) {
      final CricketMode cricketMode = settings.getMode;
      return cricketMode.name;
    }
  }

  _crossIconPressed(BuildContext context) {
    Utils.handleVibrationFeedback(context);
    late Game_P game;
    if (mode == GameMode.ScoreTraining) {
      game = context.read<GameScoreTraining_P>();
    } else if (mode == GameMode.SingleTraining ||
        mode == GameMode.DoubleTraining) {
      game = context.read<GameSingleDoubleTraining_P>();
    } else if (mode == GameMode.Cricket) {
      game = context.read<GameCricket_P>();
    }

    UtilsDialogs.showDialogForSavingGame(context, game);
  }

  _statsIconPressed(BuildContext context) {
    Utils.handleVibrationFeedback(context);
    if (mode == GameMode.ScoreTraining) {
      Navigator.of(context).pushNamed('/statisticsScoreTraining',
          arguments: {'game': context.read<GameScoreTraining_P>()});
    } else if (mode == GameMode.SingleTraining ||
        mode == GameMode.DoubleTraining) {
      Navigator.of(context).pushNamed('/statisticsSingleDoubleTraining',
          arguments: {'game': context.read<GameSingleDoubleTraining_P>()});
    } else if (mode == GameMode.Cricket) {
      Navigator.of(context).pushNamed('/statisticsCricket',
          arguments: {'game': context.read<GameCricket_P>()});
    }
  }
}
