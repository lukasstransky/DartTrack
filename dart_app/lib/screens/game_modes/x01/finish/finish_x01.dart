import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/screens/game_modes/shared/finish/finish_screen_btns/buttons/finish_screen_btns.dart';
import 'package:dart_app/screens/game_modes/x01/finish/local_widgets/stats_card/stats_card_x01.dart';
import 'package:dart_app/services/firestore/firestore_service_games.dart';
import 'package:dart_app/services/firestore/firestore_service_player_stats.dart';
import 'package:dart_app/utils/app_bars/custom_app_bar_with_heart.dart';
import 'package:dart_app/utils/globals.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class FinishX01 extends StatefulWidget {
  static const routeName = '/finishX01';

  @override
  State<FinishX01> createState() => _FinishX01State();
}

class _FinishX01State extends State<FinishX01> {
  @override
  void initState() {
    super.initState();

    _saveDataToFirestore(context);
  }

  _saveDataToFirestore(BuildContext context) async {
    final GameX01_P gameX01 = context.read<GameX01_P>();

    if (context.read<GameSettingsX01_P>().isCurrentUserInPlayers(context)) {
      g_gameId = await context
          .read<FirestoreServiceGames>()
          .postGame(gameX01, context);
      await context
          .read<FirestoreServicePlayerStats>()
          .postPlayerGameStatistics(gameX01, g_gameId, context);
    }

    if (gameX01.getIsOpenGame && mounted) {
      await context
          .read<FirestoreServiceGames>()
          .deleteOpenGame(gameX01.getGameId, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // ignore gestures
      child: Scaffold(
        appBar: CustomAppBarWithHeart(
          title: 'Finished game',
          mode: 'X01',
          isFinishScreen: true,
          showHeart: true,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: Container(
              width: 90.w,
              child: Column(
                children: [
                  StatsCardX01(
                    isFinishScreen: true,
                    gameX01: context.read<GameX01_P>(),
                    isOpenGame: false,
                  ),
                  FinishScreenBtns(gameMode: GameMode.X01),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
