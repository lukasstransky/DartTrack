import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/services/firestore/firestore_service_games.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class CustomAppBarX01Game extends StatelessWidget with PreferredSizeWidget {
  _resetValuesAndNavigateToHome(BuildContext context, GameX01 gameX01) {
    gameX01.reset();
    Navigator.of(context).pushNamed('/home');
  }

  _showDialogForSavingGame(BuildContext context, GameX01 gameX01) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context1) => AlertDialog(
        contentPadding: EdgeInsets.only(
            bottom: DIALOG_CONTENT_PADDING_BOTTOM,
            top: DIALOG_CONTENT_PADDING_TOP,
            left: DIALOG_CONTENT_PADDING_LEFT,
            right: DIALOG_CONTENT_PADDING_RIGHT),
        title: const Text('End Game'),
        content: const Text(
            'Would you like to save the game for finishing it later or end it completely?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Continue'),
          ),
          TextButton(
            onPressed: () => {
              Navigator.of(context).pop(),
              _resetValuesAndNavigateToHome(context, gameX01)
            },
            child: const Text('End'),
          ),
          TextButton(
            onPressed: () async => {
              Navigator.of(context, rootNavigator: true).pop(),
              await context
                  .read<FirestoreServiceGames>()
                  .postOpenGame(context.read<GameX01>(), context),
              _resetValuesAndNavigateToHome(context, gameX01),
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gameX01 = context.read<GameX01>();
    final gameSettingsX01 = context.read<GameSettingsX01>();

    return AppBar(
      centerTitle: true,
      title: Column(
        children: [
          Text(
            gameSettingsX01.getGameMode(),
            style: TextStyle(fontSize: 12.sp),
          ),
          Text(
            gameSettingsX01.getGameModeDetails(false),
            style: TextStyle(
                fontSize: gameSettingsX01.getSuddenDeath ? 8.sp : 10.sp),
          )
        ],
      ),
      leading: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              _showDialogForSavingGame(context, gameX01);
            },
            icon: Icon(Icons.close_sharp),
          )
        ],
      ),
      actions: [
        IconButton(
          onPressed: () => {
            Navigator.of(context).pushNamed('/statisticsX01', arguments: {
              'game': context.read<GameX01>(),
            }),
          },
          icon: Icon(Icons.bar_chart_rounded),
        ),
        IconButton(
          onPressed: () =>
              Navigator.of(context).pushNamed('/inGameSettingsX01'),
          icon: Icon(Icons.settings),
        )
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
