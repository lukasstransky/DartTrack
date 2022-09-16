import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/player_stats_in_game.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/points_btns_round.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/points_btns_threeDarts.dart';
import 'package:dart_app/utils/app_bars/custom_app_bar_x01_game.dart';
import 'package:dart_app/utils/globals.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class Game extends StatefulWidget {
  static const routeName = '/gameX01';

  const Game({Key? key}) : super(key: key);

  @override
  GameState createState() => GameState();
}

class GameState extends State<Game> {
  @override
  void initState() {
    super.initState();
    newItemScrollController();
  }

  @override
  void didChangeDependencies() {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    if (arguments.isNotEmpty && !arguments['openGame']) {
      Provider.of<GameX01>(context, listen: false)
          .init(Provider.of<GameSettingsX01>(context, listen: false));
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
