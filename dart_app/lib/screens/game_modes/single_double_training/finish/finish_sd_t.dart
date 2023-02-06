import 'package:dart_app/constants.dart';
import 'package:dart_app/models/firestore/stats_firestore_score_training_p.dart';
import 'package:dart_app/models/games/game_single_double_training_p.dart';
import 'package:dart_app/screens/game_modes/shared/finish/finish_screen_btns/buttons/finish_screen_btns.dart';
import 'package:dart_app/screens/game_modes/shared/finish/stats_card/stats_card.dart';
import 'package:dart_app/services/firestore/firestore_service_games.dart';
import 'package:dart_app/services/firestore/firestore_service_player_stats.dart';
import 'package:dart_app/utils/app_bars/custom_app_bar_with_heart.dart';
import 'package:dart_app/utils/globals.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class FinishSingleDoubleTraining extends StatefulWidget {
  static const routeName = '/finishSingleDoubleTraining';

  const FinishSingleDoubleTraining({Key? key}) : super(key: key);

  @override
  State<FinishSingleDoubleTraining> createState() =>
      _FinishSingleDoubleTrainingState();
}

class _FinishSingleDoubleTrainingState
    extends State<FinishSingleDoubleTraining> {
  GameMode _mode = GameMode.SingleTraining;

  @override
  void didChangeDependencies() {
    final Map arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    if (arguments.isNotEmpty) {
      _mode = arguments['mode'];
    }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _saveDataToFirestore();
    context.read<StatsFirestore_sdt_sct_P>().gamesLoaded = false;
    super.initState();
  }

  _saveDataToFirestore() async {
    final game = context.read<GameSingleDoubleTraining_P>();

    //todo comment out
    //if (context.read<GameSettingsX01>().isCurrentUserInPlayers(context)) {
    if (game.getMode == GameMode.DoubleTraining) {
      game.setName = 'Double training';
    }
    g_gameId = await context.read<FirestoreServiceGames>().postGame(game);
    await context
        .read<FirestoreServicePlayerStats>()
        .postPlayerGameStatistics(game, g_gameId, context);
    //}
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
        appBar: CustomAppBarWithHeart(
          title: 'Finished Game',
          mode: 'Single training',
          isFinishScreen: true,
          showHeart: true,
        ),
        body: Center(
          child: Container(
            width: 90.w,
            child: Column(
              children: [
                StatsCard(
                  isFinishScreen: true,
                  game: context.read<GameSingleDoubleTraining_P>(),
                  isOpenGame: false,
                ),
                FinishScreenBtns(gameMode: _mode),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
