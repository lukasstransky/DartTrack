import 'package:dart_app/models/firestore/score_training/stats_firestore_score_training_p.dart';
import 'package:dart_app/models/games/score_training/game_score_training_p.dart';
import 'package:dart_app/screens/game_modes/score_training/finish/local_widgets/stats_card_score_training/stats_card_sc_t.dart';
import 'package:dart_app/screens/game_modes/shared/finish_screen_btns/buttons/finish_screen_btns.dart';
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
    context.read<StatsFirestoreScoreTraining_P>().gamesLoaded = false;
    super.initState();
  }

  _saveDataToFirestore() async {
    final gameScoreTraining_P = context.read<GameScoreTraining_P>();

    //todo comment out
    //if (context.read<GameSettingsX01>().isCurrentUserInPlayers(context)) {
    g_gameId = await context
        .read<FirestoreServiceGames>()
        .postGame(gameScoreTraining_P);
    await context
        .read<FirestoreServicePlayerStats>()
        .postPlayerGameStatistics(gameScoreTraining_P, g_gameId, context);
    //}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWithHeart(
        title: 'Finished Game',
        mode: 'Score Training',
        isFinishScreen: true,
        showHeart: true,
      ),
      body: Center(
        child: Container(
          width: 90.w,
          child: Column(
            children: [
              StatsCardScoreTraining(
                isFinishScreen: true,
                gameScoreTraining_P: context.read<GameScoreTraining_P>(),
                isOpenGame: false,
              ),
              FinishScreenBtns(gameMode: 'Score Training'),
            ],
          ),
        ),
      ),
    );
  }
}
