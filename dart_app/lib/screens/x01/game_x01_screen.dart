import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/game_x01_model.dart';

import 'package:dart_app/models/game_settings/game_settings_x01_model.dart';
import 'package:dart_app/other/custom_app_bar_game_x01.dart';
import 'package:dart_app/screens/x01/game_widgets/player_stats_in_game_widget.dart';
import 'package:dart_app/screens/x01/game_widgets/points_btns_round_widget.dart';
import 'package:dart_app/screens/x01/game_widgets/points_btns_threeDarts_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'dart:developer';

class GameX01Screen extends StatefulWidget {
  static const routeName = "/gameX01";

  const GameX01Screen({Key? key}) : super(key: key);

  @override
  GameX01ScreenState createState() => GameX01ScreenState();
}

class GameX01ScreenState extends State<GameX01Screen> {
  @override
  void initState() {
    Provider.of<GameX01>(context, listen: false)
        .init(Provider.of<GameSettingsX01>(context, listen: false));
    super.initState();
  }

  /*_showDialogForSuddenDeath() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Sudden Death"),
        content: Text(
            "The 'Sudden Death' leg is reached. The player who wins this leg also wins the game."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Got It"),
          ),
        ],
      ),
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBarGameX01(),
      body: Consumer2<GameX01, GameSettingsX01>(
        builder: (_, gameX01, gameSettingsX01, __) => Column(
          children: [
            Container(
              height: 35.h,
              child: Container(
                height: 34.h,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: gameSettingsX01.getPlayers.length,
                  itemBuilder: (BuildContext context, int index) {
                    return PlayerStatsInGame(
                      playerGameStatisticsX01:
                          gameX01.getPlayerGameStatistics[index],
                    );
                  },
                ),
              ),
            ),
            if (gameSettingsX01.getInputMethod == InputMethod.Round) ...[
              PointsBtnsRoundWidget()
            ] else ...[
              PointsBtnsThreeDartsWidget(),
            ]
          ],
        ),
      ),
    );
  }
}
