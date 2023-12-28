import 'dart:io';

import 'package:dart_app/constants.dart';
import 'package:dart_app/models/firestore/open_games_firestore.dart';
import 'package:dart_app/models/firestore/stats_firestore_c.dart';
import 'package:dart_app/models/game_settings/game_settings_cricket_p.dart';
import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/models/games/game_cricket_p.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats_cricket.dart';
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

class FinishCricket extends StatefulWidget {
  static const routeName = '/finishCricket';

  const FinishCricket({Key? key}) : super(key: key);

  @override
  State<FinishCricket> createState() => _FinishCricketState();
}

class _FinishCricketState extends State<FinishCricket> {
  // testing ads
  final String _bannerAdUnitId = Platform.isAndroid
      ? 'ca-app-pub-8582367743573228/9129959568'
      : 'ca-app-pub-8582367743573228/2870591408';
  // real ads
  // final String _bannerAdUnitId = Platform.isAndroid
  //     ? 'ca-app-pub-8582367743573228/9129959568'
  //     : 'ca-app-pub-8582367743573228/2870591408';

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
          mode: GameMode.Cricket,
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
                  bannerAdEnum: BannerAdEnum.CricketFinishScreen,
                  disposeInstant: true,
                ),
              ),
            Selector<GameCricket_P, bool>(
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
                                    game: context.read<GameCricket_P>(),
                                    isOpenGame: false,
                                  ),
                                  FinishScreenBtns(gameMode: GameMode.Cricket),
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
    final GameCricket_P gameCricket = context.read<GameCricket_P>();

    gameCricket.setShowLoadingSpinner = true;
    gameCricket.notify();

    final bool isConnected = await Utils.hasInternetConnection();
    if (!isConnected) {
      return;
    }

    final FirestoreServiceGames firestoreServiceGames =
        context.read<FirestoreServiceGames>();
    final OpenGamesFirestore openGamesFirestore =
        context.read<OpenGamesFirestore>();
    final StatsFirestoreCricket_P statsFirestoreCricket =
        context.read<StatsFirestoreCricket_P>();

    if (context.read<GameSettingsCricket_P>().isCurrentUserInPlayers(context)) {
      g_gameId =
          await firestoreServiceGames.postGame(gameCricket, openGamesFirestore);
      gameCricket.setIsGameFinished = true;
      await context
          .read<FirestoreServicePlayerStats>()
          .postPlayerGameStatistics(gameCricket, g_gameId, context);
    }

    if (gameCricket.getIsOpenGame && mounted) {
      await firestoreServiceGames.deleteOpenGame(
          gameCricket.getGameId, openGamesFirestore);
    }

    gameCricket.setShowLoadingSpinner = false;
    gameCricket.notify();

    // manually add game, stats to avoid fetching calls
    final Game_P game = gameCricket.clone();
    game.setGameId = g_gameId;
    statsFirestoreCricket.games.add(game);

    for (PlayerOrTeamGameStatsCricket stats
        in gameCricket.getPlayerGameStatistics) {
      statsFirestoreCricket.allPlayerGameStats.add(stats);
    }

    if (gameCricket.getGameSettings.getSingleOrTeam == SingleOrTeamEnum.Team) {
      for (PlayerOrTeamGameStatsCricket stats
          in gameCricket.getTeamGameStatistics) {
        statsFirestoreCricket.allTeamGameStats.add(stats);
      }
    }
  }
}
