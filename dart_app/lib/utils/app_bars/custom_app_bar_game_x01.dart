import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/services/firestore_service.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class CustomAppBarGameX01 extends StatelessWidget with PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    final gameX01 = Provider.of<GameX01>(context, listen: false);
    final gameSettingsX01 =
        Provider.of<GameSettingsX01>(context, listen: false);

    void _resetValuesAndNavigateToHome() {
      gameX01.reset();
      gameSettingsX01.resetValues();
      gameSettingsX01.notify();
      Navigator.of(context).pushNamed("/home");
    }

    void _showDialogForSavingGame(BuildContext context) {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("End Game"),
          content: const Text(
              "Would you like to save the game for finishing it later or end it completely?"),
          actions: [
            TextButton(
              onPressed: () => {
                Navigator.of(context).pop(),
              },
              child: const Text("Continue"),
            ),
            TextButton(
              onPressed: () async => {
                Navigator.of(context).pop(),
                await context.read<FirestoreService>().postOpenGame(
                    Provider.of<GameX01>(context, listen: false), context),
                _resetValuesAndNavigateToHome(),
              },
              child: const Text("Save"),
            ),
            TextButton(
              onPressed: () => {
                Navigator.of(context).pop(),
                _resetValuesAndNavigateToHome(),
              },
              child: const Text("End"),
            ),
          ],
        ),
      );
    }

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
              _showDialogForSavingGame(context);
            },
            icon: Icon(Icons.close_sharp),
          )
        ],
      ),
      actions: [
        IconButton(
          onPressed: () => {
            Navigator.of(context).pushNamed("/statisticsX01", arguments: {
              'game': Provider.of<GameX01>(context, listen: false),
            }),
          },
          icon: Icon(Icons.bar_chart_rounded),
        ),
        IconButton(
          onPressed: () =>
              Navigator.of(context).pushNamed("/inGameSettingsX01"),
          icon: Icon(Icons.settings),
        )
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
