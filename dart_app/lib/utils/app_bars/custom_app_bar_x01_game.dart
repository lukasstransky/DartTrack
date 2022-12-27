import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/services/firestore/firestore_service_games.dart';
import 'package:dart_app/utils/utils.dart';

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
        backgroundColor: Theme.of(context).colorScheme.primary,
        contentPadding: EdgeInsets.only(
            bottom: DIALOG_CONTENT_PADDING_BOTTOM,
            top: DIALOG_CONTENT_PADDING_TOP,
            left: DIALOG_CONTENT_PADDING_LEFT,
            right: DIALOG_CONTENT_PADDING_RIGHT),
        title: const Text(
          'End Game',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Would you like to save the game for finishing it later or end it completely?',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Continue',
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
            style: ButtonStyle(
              backgroundColor:
                  Utils.getPrimaryMaterialStateColorDarken(context),
            ),
          ),
          TextButton(
            onPressed: () => {
              Navigator.of(context).pop(),
              _resetValuesAndNavigateToHome(context, gameX01)
            },
            child: Text(
              'End',
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
            style: ButtonStyle(
              backgroundColor:
                  Utils.getPrimaryMaterialStateColorDarken(context),
            ),
          ),
          TextButton(
            onPressed: () async => {
              Navigator.of(context, rootNavigator: true).pop(),
              await context
                  .read<FirestoreServiceGames>()
                  .postOpenGame(context.read<GameX01>(), context),
              _resetValuesAndNavigateToHome(context, gameX01),
            },
            child: Text(
              'Save',
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
            style: ButtonStyle(
              backgroundColor:
                  Utils.getPrimaryMaterialStateColorDarken(context),
            ),
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
            icon: Icon(
              Icons.close_sharp,
              color: Theme.of(context).colorScheme.secondary,
            ),
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
          icon: Icon(
            Icons.bar_chart_rounded,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        IconButton(
          onPressed: () =>
              Navigator.of(context).pushNamed('/inGameSettingsX01'),
          icon: Icon(
            Icons.settings,
            color: Theme.of(context).colorScheme.secondary,
          ),
        )
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
