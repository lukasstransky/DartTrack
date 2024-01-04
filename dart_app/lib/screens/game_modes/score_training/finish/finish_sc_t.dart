import 'dart:io';

import 'package:dart_app/constants.dart';
import 'package:dart_app/models/firestore/open_games_firestore.dart';
import 'package:dart_app/models/firestore/stats_firestore_sc_t.dart';
import 'package:dart_app/models/game_settings/game_settings_score_training_p.dart';
import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/models/games/game_score_training_p.dart';
import 'package:dart_app/models/player_statistics/player_game_stats_score_training.dart';
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

class FinishScoreTraining extends StatefulWidget {
  static const routeName = '/finishScoreTraining';

  const FinishScoreTraining({Key? key}) : super(key: key);

  @override
  State<FinishScoreTraining> createState() => _FinishScoreTrainingState();
}

class _FinishScoreTrainingState extends State<FinishScoreTraining> {
  // testing ads
  // final String _bannerAdUnitId = Platform.isAndroid
  //     ? 'ca-app-pub-8582367743573228/3195144599'
  //     : 'ca-app-pub-8582367743573228/5821307932';
  // real ads
  final String _bannerAdUnitId = Platform.isAndroid
      ? 'ca-app-pub-8582367743573228/3195144599'
      : 'ca-app-pub-8582367743573228/5821307932';

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
          mode: GameMode.ScoreTraining,
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
                  bannerAdEnum: BannerAdEnum.ScoreTrainingFinishScreen,
                  disposeInstant: true,
                ),
              ),
            Selector<GameScoreTraining_P, bool>(
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
                                    game: context.read<GameScoreTraining_P>(),
                                    isOpenGame: false,
                                  ),
                                  FinishScreenBtns(
                                      gameMode: GameMode.ScoreTraining),
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
    final GameScoreTraining_P gameScoreTraining =
        context.read<GameScoreTraining_P>();

    gameScoreTraining.setShowLoadingSpinner = true;
    gameScoreTraining.notify();

    final bool isConnected = await Utils.hasInternetConnection();
    if (!isConnected) {
      return;
    }

    final FirestoreServiceGames firestoreServiceGames =
        context.read<FirestoreServiceGames>();
    final OpenGamesFirestore openGamesFirestore =
        context.read<OpenGamesFirestore>();
    final StatsFirestoreScoreTraining_P statsFirestoreScoreTraining =
        context.read<StatsFirestoreScoreTraining_P>();
    final bool isCurrentUserInPlayers = context
        .read<GameSettingsScoreTraining_P>()
        .isCurrentUserInPlayers(context);

    if (isCurrentUserInPlayers) {
      g_gameId = await firestoreServiceGames.postGame(
          gameScoreTraining, openGamesFirestore);
      gameScoreTraining.setIsGameFinished = true;
      await context
          .read<FirestoreServicePlayerStats>()
          .postPlayerGameStatistics(gameScoreTraining, g_gameId, context);
    }

    if (gameScoreTraining.getIsOpenGame && mounted) {
      await firestoreServiceGames.deleteOpenGame(
          gameScoreTraining.getGameId, openGamesFirestore);
    }

    gameScoreTraining.setShowLoadingSpinner = false;
    gameScoreTraining.notify();

    // manually add game, stats to avoid fetching calls
    if (isCurrentUserInPlayers) {
      final Game_P game = gameScoreTraining.clone();
      game.setGameId = g_gameId;

      statsFirestoreScoreTraining.games.add(game);

      for (PlayerGameStatsScoreTraining stats
          in gameScoreTraining.getPlayerGameStatistics) {
        statsFirestoreScoreTraining.allPlayerGameStats.add(stats);
      }
    }
  }
}
