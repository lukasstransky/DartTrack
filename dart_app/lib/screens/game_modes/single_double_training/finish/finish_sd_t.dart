import 'dart:io';

import 'package:dart_app/constants.dart';
import 'package:dart_app/models/firestore/open_games_firestore.dart';
import 'package:dart_app/models/firestore/stats_firestore_d_t.dart';
import 'package:dart_app/models/firestore/stats_firestore_s_t.dart';
import 'package:dart_app/models/game_settings/game_settings_single_double_training_p.dart';
import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/models/games/game_single_double_training_p.dart';
import 'package:dart_app/models/player_statistics/player_game_stats_single_double_training.dart';
import 'package:dart_app/models/user_p.dart';
import 'package:dart_app/screens/game_modes/shared/finish/finish_screen_btns/buttons/finish_screen_btns.dart';
import 'package:dart_app/screens/game_modes/shared/finish/stats_card/stats_card.dart';
import 'package:dart_app/services/firestore/firestore_service_games.dart';
import 'package:dart_app/services/firestore/firestore_service_player_stats.dart';
import 'package:dart_app/utils/ad_management/banner_ad_widget.dart';
import 'package:dart_app/utils/app_bars/custom_app_bar_with_heart.dart';
import 'package:dart_app/utils/globals.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
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
  final String _bannerAdUnitId = Platform.isAndroid
      ? 'ca-app-pub-8582367743573228/1658663658'
      : 'ca-app-pub-8582367743573228/7134389603';

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
    super.initState();

    Future.delayed(Duration.zero, () {
      _saveDataToFirestore(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // ignore gestures
      child: Scaffold(
        appBar: CustomAppBarWithHeart(
          title: 'Finished game',
          mode: GameMode.SingleTraining,
          isFinishScreen: true,
          showHeart: true,
        ),
        body: Stack(
          children: [
            if (context.read<User_P>().getAdsEnabled)
              Align(
                alignment: Alignment.topCenter,
                child: BannerAdWidget(
                  bannerAdUnitId: _bannerAdUnitId,
                  bannerAdEnum: BannerAdEnum.SingleDoubleTrainingFinishScreen,
                  disposeInstant: true,
                ),
              ),
            Selector<GameSingleDoubleTraining_P, bool>(
              selector: (_, game) => game.getShowLoadingSpinner,
              builder: (_, showLoadingSpinner, __) => showLoadingSpinner
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                  : Column(
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Center(
                            child: Container(
                              width: 90.w,
                              child: Column(
                                children: [
                                  StatsCard(
                                    isFinishScreen: true,
                                    game: context
                                        .read<GameSingleDoubleTraining_P>(),
                                    isOpenGame: false,
                                  ),
                                  FinishScreenBtns(gameMode: _mode),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  _saveDataToFirestore(BuildContext context) async {
    final GameSingleDoubleTraining_P gameSingleDoubleTraining =
        context.read<GameSingleDoubleTraining_P>();

    gameSingleDoubleTraining.setShowLoadingSpinner = true;
    gameSingleDoubleTraining.notify();

    final bool isConnected = await Utils.hasInternetConnection();
    if (!isConnected) {
      return;
    }

    final FirestoreServiceGames firestoreServiceGames =
        context.read<FirestoreServiceGames>();
    final OpenGamesFirestore openGamesFirestore =
        context.read<OpenGamesFirestore>();
    final StatsFirestoreSingleTraining_P statsFirestoreSingleTraining =
        context.read<StatsFirestoreSingleTraining_P>();
    final StatsFirestoreDoubleTraining_P statsFirestoreDoubleTraining =
        context.read<StatsFirestoreDoubleTraining_P>();

    if (context
        .read<GameSettingsSingleDoubleTraining_P>()
        .isCurrentUserInPlayers(context)) {
      if (gameSingleDoubleTraining.getMode == GameMode.DoubleTraining) {
        gameSingleDoubleTraining.setName = GameMode.DoubleTraining.name;
      }
      gameSingleDoubleTraining.setIsGameFinished = true;
      g_gameId = await context.read<FirestoreServiceGames>().postGame(
          gameSingleDoubleTraining, context.read<OpenGamesFirestore>());
      await context
          .read<FirestoreServicePlayerStats>()
          .postPlayerGameStatistics(
              gameSingleDoubleTraining, g_gameId, context);
    }

    if (gameSingleDoubleTraining.getIsOpenGame && mounted) {
      await firestoreServiceGames.deleteOpenGame(
          gameSingleDoubleTraining.getGameId, openGamesFirestore);
    }

    gameSingleDoubleTraining.setShowLoadingSpinner = false;
    gameSingleDoubleTraining.notify();

    // manually add game, stats to avoid fetching calls
    final Game_P game = gameSingleDoubleTraining.clone();
    game.setGameId = g_gameId;

    if (gameSingleDoubleTraining.getMode == GameMode.SingleTraining) {
      statsFirestoreSingleTraining.games.add(game);

      for (PlayerGameStatsSingleDoubleTraining stats
          in gameSingleDoubleTraining.getPlayerGameStatistics) {
        statsFirestoreSingleTraining.allPlayerGameStats.add(stats);
      }
    } else {
      statsFirestoreDoubleTraining.games.add(game);

      for (PlayerGameStatsSingleDoubleTraining stats
          in gameSingleDoubleTraining.getPlayerGameStatistics) {
        statsFirestoreDoubleTraining.allPlayerGameStats.add(stats);
      }
    }
  }
}
