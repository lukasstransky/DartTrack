import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/models/player_statistics/player_game_statistics_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/player_stats_in_game.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/round/points_btns_round.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/three_darts/points_btns_threeDarts.dart';
import 'package:dart_app/utils/app_bars/custom_app_bar_x01_game.dart';
import 'package:dart_app/utils/globals.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class Game extends StatefulWidget {
  static const routeName = '/gameX01';

  @override
  GameState createState() => GameState();
}

class GameState extends State<Game> {
  @override
  initState() {
    super.initState();
    newItemScrollController();
  }

  _init() {
    final GameX01 gameX01 = Provider.of<GameX01>(context, listen: false);
    final GameSettingsX01 gameSettingsX01 =
        Provider.of<GameSettingsX01>(context, listen: false);

    gameX01.setGameSettings = gameSettingsX01;
    gameX01.setCurrentPlayerToThrow = gameSettingsX01.getPlayers[0];
    gameX01.setPlayerGameStatistics = [];

    //if game is finished -> undo last throw -> will call init again
    if (gameSettingsX01.getPlayers.length !=
        gameX01.getPlayerGameStatistics.length) {
      gameX01.setInit = true;
      final int points = gameSettingsX01.getPointsOrCustom();

      for (Player player in gameSettingsX01.getPlayers) {
        gameX01.getPlayerGameStatistics.add(new PlayerGameStatisticsX01(
            mode: 'X01',
            player: player,
            currentPoints: points,
            dateTime: gameX01.getDateTime));
      }

      if (gameSettingsX01.getInputMethod == InputMethod.ThreeDarts)
        gameX01.setCurrentPointType = PointType.Single;
    }

    for (PlayerGameStatisticsX01 stats in gameX01.getPlayerGameStatistics) {
      stats.setStartingPoints = stats.getCurrentPoints;
    }
  }

  @override
  didChangeDependencies() {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    if (arguments.isNotEmpty && !arguments['openGame']) {
      _init();
    }
    super.didChangeDependencies();
  }

  /*_showDialogForSuddenDeath() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
contentPadding:
              EdgeInsets.only(bottom: DIALOG_CONTENT_PADDING_BOTTOM, top: DIALOG_CONTENT_PADDING_TOP, left: DIALOG_CONTENT_PADDING_LEFT, right: DIALOG_CONTENT_PADDING_RIGHT),
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
      appBar: CustomAppBarX01Game(),
      body: Consumer2<GameX01, GameSettingsX01>(
        builder: (_, gameX01, gameSettingsX01, __) => gameX01
                .getPlayerGameStatistics.isEmpty
            ? SizedBox.shrink()
            : Column(
                children: [
                  Container(
                    height: 35.h,
                    child: ScrollablePositionedList.builder(
                      itemScrollController: newItemScrollController(),
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
