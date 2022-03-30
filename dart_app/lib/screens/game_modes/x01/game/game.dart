import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/player_stats_in_game.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/points_btns_round.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/points_btns_threeDarts.dart';
import 'package:dart_app/utils/custom_app_bar_game_x01.dart';
import 'package:dart_app/utils/globals.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'dart:developer';

class Game extends StatefulWidget {
  static const routeName = "/gameX01";

  const Game({Key? key}) : super(key: key);

  @override
  GameState createState() => GameState();
}

class GameState extends State<Game> {
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
                child: ScrollablePositionedList.builder(
                  itemScrollController: scrollController,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: gameSettingsX01.getPlayers.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (gameX01.getPlayerGameStatistics.length > 0) {
                      return PlayerStatsInGame(
                        playerGameStatisticsX01:
                            gameX01.getPlayerGameStatistics[index],
                      );
                    }
                    return SizedBox.shrink();
                  },
                ),
              ),
            ),
            if (gameSettingsX01.getInputMethod == InputMethod.Round) ...[
              PointsBtnsRound()
            ] else ...[
              PointsBtnsThreeDarts(),
            ]
          ],
        ),
      ),
    );
  }
}
