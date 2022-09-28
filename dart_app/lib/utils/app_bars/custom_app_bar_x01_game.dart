import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/services/firestore/firestore_service_games.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class CustomAppBarX01Game extends StatelessWidget with PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    final gameX01 = Provider.of<GameX01>(context, listen: false);
    final gameSettingsX01 =
        Provider.of<GameSettingsX01>(context, listen: false);

    _resetValuesAndNavigateToHome() {
      gameX01.reset();
      Navigator.of(context).pushNamed('/home');
    }

    _showDialogForSavingGame(BuildContext context) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
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
                _resetValuesAndNavigateToHome(),
              },
              child: const Text('End'),
            ),
            TextButton(
              onPressed: () async => {
                Navigator.of(context, rootNavigator: true).pop(),
                await context.read<FirestoreServiceGames>().postOpenGame(
                    Provider.of<GameX01>(context, listen: false), context),
                _resetValuesAndNavigateToHome(),
              },
              child: const Text('Save'),
            ),
          ],
        ),
      );
    }

    String _getGameModeDetails(bool showPoints) {
      String result = '';

      if (showPoints) {
        if (gameSettingsX01.getCustomPoints != -1)
          result += '${gameSettingsX01.getCustomPoints.toString()} / ';
        else
          result += '${gameSettingsX01.getPoints.toString()} / ';
      }

      switch (gameSettingsX01.getModeIn) {
        case ModeOutIn.Single:
          result += 'Single In / ';
          break;
        case ModeOutIn.Double:
          result += 'Double In / ';
          break;
        case ModeOutIn.Master:
          result += 'Master In / ';
          break;
      }

      switch (gameSettingsX01.getModeOut) {
        case ModeOutIn.Single:
          result += 'Single Out';
          break;
        case ModeOutIn.Double:
          result += 'Double Out';
          break;
        case ModeOutIn.Master:
          result += 'Master Out';
          break;
      }

      if (gameSettingsX01.getSuddenDeath)
        result +=
            ' / SD - after ${gameSettingsX01.getMaxExtraLegs.toString()} Legs';

      return result;
    }

    String _getGameMode() {
      final gameSettingsX01 =
          Provider.of<GameSettingsX01>(context, listen: false);
      final int sets = gameSettingsX01.getSets;
      final int legs = gameSettingsX01.getLegs;

      String result = '';

      if (gameSettingsX01.getMode == BestOfOrFirstToEnum.BestOf)
        result += 'Best Of ';
      else
        result += 'First To ';

      if (gameSettingsX01.getSetsEnabled) {
        if (sets > 1)
          result += '${sets.toString()} Sets - ';
        else
          result += '${sets.toString()} Set - ';
      }
      if (legs > 1)
        result += '${legs.toString()} Legs';
      else
        result += '${legs.toString()} Leg';

      return result;
    }

    return AppBar(
      centerTitle: true,
      title: Column(
        children: [
          Text(
            _getGameMode(),
            style: TextStyle(fontSize: 12.sp),
          ),
          Text(
            _getGameModeDetails(false),
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
              _showDialogForSavingGame(context);
            },
            icon: Icon(Icons.close_sharp),
          )
        ],
      ),
      actions: [
        IconButton(
          onPressed: () => {
            Navigator.of(context).pushNamed('/statisticsX01', arguments: {
              'game': Provider.of<GameX01>(context, listen: false),
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
