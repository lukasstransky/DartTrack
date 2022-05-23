import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/models/games/game_x01.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class CustomAppBarGameX01 extends StatelessWidget with PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    final gameX01 = Provider.of<GameX01>(context, listen: false);
    final gameSettingsX01 =
        Provider.of<GameSettingsX01>(context, listen: false);

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
              gameX01.reset();
              Navigator.of(context).pushNamed("/settingsX01");
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
