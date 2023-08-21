import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:dart_app/utils/utils_dialogs.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:sizer/sizer.dart';

class CustomAppBarX01Game extends StatelessWidget
    implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    final gameX01 = context.read<GameX01_P>();
    final gameSettingsX01 = context.read<GameSettingsX01_P>();

    return Selector<GameX01_P, bool>(
      selector: (context, gameX01) => gameX01.getShowLoadingSpinner,
      builder: (context, showLoadingSpinner, _) => AppBar(
        elevation: 0,
        centerTitle: true,
        title: _getTitleColumn(gameSettingsX01, context),
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: () {
                Utils.handleVibrationFeedback(context);
                UtilsDialogs.showDialogForSavingGame(context, gameX01);
              },
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
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: () {
              Utils.handleVibrationFeedback(context);
              if (!showLoadingSpinner) {
                Navigator.of(context).pushNamed('/statisticsX01', arguments: {
                  'game': context.read<GameX01_P>(),
                });
              }
            },
            icon: Icon(
              size: ICON_BUTTON_SIZE.h,
              Icons.bar_chart_rounded,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: () {
              Utils.handleVibrationFeedback(context);
              if (!showLoadingSpinner) {
                Navigator.of(context).pushNamed('/inGameSettingsX01');
              }
            },
            icon: Icon(
              size: ICON_BUTTON_SIZE.h,
              Icons.settings,
              color: Theme.of(context).colorScheme.secondary,
            ),
          )
        ],
      ),
    );
  }

  Column _getTitleColumn(
      GameSettingsX01_P gameSettingsX01, BuildContext context) {
    if (ResponsiveBreakpoints.of(context).isMobile) {
      return Column(
        children: [
          Text(
            Utils.getBestOfOrFirstToString(gameSettingsX01),
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
            ),
          ),
          Text(
            gameSettingsX01.getGameModeDetails(false),
            style: TextStyle(fontSize: 10.sp),
          ),
          if (!gameSettingsX01.getSuddenDeath &&
              gameSettingsX01.getWinByTwoLegsDifference)
            Text(
              '(Win by two legs difference)',
              style: TextStyle(fontSize: 8.sp),
            ),
          if (gameSettingsX01.getSuddenDeath)
            Text(
              gameSettingsX01.getSuddenDeathInfo(),
              style: TextStyle(fontSize: 8.sp),
            ),
          if (gameSettingsX01.getDrawMode)
            Text(
              '(Draw enabled)',
              style: TextStyle(fontSize: 8.sp),
            ),
        ],
      );
    }

    return Column(
      children: [
        Text(
          "${Utils.getBestOfOrFirstToString(gameSettingsX01)} - ${gameSettingsX01.getGameModeDetails(false)}",
          style: TextStyle(
              fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
