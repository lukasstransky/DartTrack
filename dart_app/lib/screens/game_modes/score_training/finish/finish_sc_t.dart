import 'package:dart_app/constants.dart';
import 'package:dart_app/models/firestore/open_games_firestore.dart';
import 'package:dart_app/models/firestore/stats_firestore_sc_t.dart';
import 'package:dart_app/models/game_settings/game_settings_score_training_p.dart';
import 'package:dart_app/models/games/game_score_training_p.dart';
import 'package:dart_app/screens/game_modes/shared/finish/finish_screen_btns/buttons/finish_screen_btns.dart';
import 'package:dart_app/screens/game_modes/shared/finish/stats_card/stats_card.dart';
import 'package:dart_app/services/firestore/firestore_service_games.dart';
import 'package:dart_app/services/firestore/firestore_service_player_stats.dart';
import 'package:dart_app/utils/app_bars/custom_app_bar_with_heart.dart';
import 'package:dart_app/utils/globals.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class FinishScoreTraining extends StatefulWidget {
  static const routeName = '/finishScoreTraining';

  const FinishScoreTraining({Key? key}) : super(key: key);

  @override
  State<FinishScoreTraining> createState() => _FinishScoreTrainingState();
}

class _FinishScoreTrainingState extends State<FinishScoreTraining> {
  @override
  void initState() {
    _saveDataToFirestore();
    super.initState();
  }

  _saveDataToFirestore() async {
    final GameScoreTraining_P game = context.read<GameScoreTraining_P>();
    final FirestoreServiceGames firestoreServiceGames =
        context.read<FirestoreServiceGames>();
    final OpenGamesFirestore openGamesFirestore =
        context.read<OpenGamesFirestore>();

    if (context
        .read<GameSettingsScoreTraining_P>()
        .isCurrentUserInPlayers(context)) {
      g_gameId = await firestoreServiceGames.postGame(game, openGamesFirestore);
      game.getPlayerGameStatistics.sort();
      game.setIsGameFinished = true;
      await context
          .read<FirestoreServicePlayerStats>()
          .postPlayerGameStatistics(game, g_gameId, context);
    }

    if (game.getIsOpenGame && mounted) {
      await firestoreServiceGames.deleteOpenGame(
          game.getGameId, openGamesFirestore);
    }

    // to load data in stats tab again if new game was added
    context.read<StatsFirestoreScoreTraining_P>().loadGames = true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // ignore gestures
      child: Scaffold(
        appBar: CustomAppBarWithHeart(
          title: 'Finished game',
          mode: GameMode.ScoreTraining,
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
                  StatsCard(
                    isFinishScreen: true,
                    game: context.read<GameScoreTraining_P>(),
                    isOpenGame: false,
                  ),
                  FinishScreenBtns(gameMode: GameMode.ScoreTraining),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
