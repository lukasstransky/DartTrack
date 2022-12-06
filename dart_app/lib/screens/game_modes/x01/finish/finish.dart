import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/screens/game_modes/x01/finish/local_widgets/buttons.dart';
import 'package:dart_app/screens/game_modes/x01/finish/local_widgets/stats_card/stats_card_x01.dart';
import 'package:dart_app/services/firestore/firestore_service_games.dart';
import 'package:dart_app/services/firestore/firestore_service_player_stats.dart';
import 'package:dart_app/utils/app_bars/custom_app_bar_with_heart.dart';
import 'package:dart_app/utils/globals.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class Finish extends StatefulWidget {
  static const routeName = '/finishX01';

  @override
  State<Finish> createState() => _FinishState();
}

class _FinishState extends State<Finish> {
  @override
  void initState() {
    super.initState();

    _saveDataToFirestore(context);
  }

  _saveDataToFirestore(BuildContext context) async {
    final GameSettingsX01 gameSettingsX01 = context.read<GameSettingsX01>();
    final GameX01 gameX01 = context.read<GameX01>();
    //todo comment out
    //if (gameSettingsX01.isCurrentUserInPlayers(context)) {
    g_gameId = await context.read<FirestoreServiceGames>().postGame(gameX01);
    await context
        .read<FirestoreServicePlayerStats>()
        .postPlayerGameStatistics(gameX01, g_gameId, context);
    //}

    if (gameX01.getIsOpenGame) {
      await context
          .read<FirestoreServiceGames>()
          .deleteOpenGame(gameX01.getGameId, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          CustomAppBarWithHeart(title: 'Finished Game', isFinishScreen: true),
      body: Center(
        child: Container(
          width: 90.w,
          child: Column(
            children: [
              StatsCardX01(
                isFinishScreen: true,
                gameX01: context.read<GameX01>(),
                openGame: false,
              ),
              Buttons(),
            ],
          ),
        ),
      ),
    );
  }
}
