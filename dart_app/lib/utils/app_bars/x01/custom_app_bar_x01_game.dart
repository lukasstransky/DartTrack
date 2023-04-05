import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class CustomAppBarX01Game extends StatelessWidget with PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    final gameX01 = context.read<GameX01_P>();
    final gameSettingsX01 = context.read<GameSettingsX01_P>();

    return Selector<GameX01_P, bool>(
      selector: (context, gameX01) => gameX01.getShowLoadingSpinner,
      builder: (context, showLoadingSpinner, _) => AppBar(
        elevation: 0,
        centerTitle: true,
        title: Column(
          children: [
            Text(
              gameSettingsX01.getGameMode(),
              style: TextStyle(fontSize: 12.sp),
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
        ),
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: () => Utils.showDialogForSavingGame(context, gameX01),
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
              if (!showLoadingSpinner) {
                Navigator.of(context).pushNamed('/statisticsX01', arguments: {
                  'game': context.read<GameX01_P>(),
                });
              }
            },
            icon: Icon(
              Icons.bar_chart_rounded,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: () {
              if (!showLoadingSpinner) {
                Navigator.of(context).pushNamed('/inGameSettingsX01');
              }
            },
            icon: Icon(
              Icons.settings,
              color: Theme.of(context).colorScheme.secondary,
            ),
          )
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
