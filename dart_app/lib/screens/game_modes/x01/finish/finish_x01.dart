import 'package:dart_app/constants.dart';
import 'package:dart_app/models/firestore/open_games_firestore.dart';
import 'package:dart_app/models/firestore/stats_firestore_x01_p.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats_x01.dart';
import 'package:dart_app/screens/game_modes/shared/finish/finish_screen_btns/buttons/finish_screen_btns.dart';
import 'package:dart_app/screens/game_modes/x01/finish/local_widgets/stats_card/stats_card_x01.dart';
import 'package:dart_app/services/auth_service.dart';
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

    Future.delayed(Duration.zero, () {
      _saveDataToFirestore(context);
    });
  }

  _saveDataToFirestore(BuildContext context) async {
    final GameX01_P gameX01 = context.read<GameX01_P>();
    final FirestoreServiceGames firestoreServiceGames =
        context.read<FirestoreServiceGames>();
    final OpenGamesFirestore openGamesFirestore =
        context.read<OpenGamesFirestore>();
    final StatsFirestoreX01_P statsFirestoreX01 =
        context.read<StatsFirestoreX01_P>();

    gameX01.setShowLoadingSpinner = true;
    gameX01.notify();

    if (context.read<GameSettingsX01_P>().isCurrentUserInPlayers(context)) {
      g_gameId =
          await firestoreServiceGames.postGame(gameX01, openGamesFirestore);
      gameX01.setIsGameFinished = true;
      await context
          .read<FirestoreServicePlayerStats>()
          .postPlayerGameStatistics(gameX01, g_gameId, context);
    }

    if (gameX01.getIsOpenGame && mounted) {
      await firestoreServiceGames.deleteOpenGame(
          gameX01.getGameId, openGamesFirestore);
    }

    gameX01.setShowLoadingSpinner = false;
    gameX01.notify();

    // manually add game, stats to avoid fetching calls
    final Game_P game = gameX01.clone();
    game.setGameId = g_gameId;
    statsFirestoreX01.games.add(game);
    statsFirestoreX01.filteredGames.add(game);

    final String currentUsername =
        context.read<AuthService>().getUsernameFromSharedPreferences() ?? '';
    for (PlayerOrTeamGameStatsX01 stats in gameX01.getPlayerGameStatistics) {
      stats.setGameId = g_gameId;
      statsFirestoreX01.allPlayerGameStats.add(stats);
      if (stats.getPlayer.getName == currentUsername) {
        statsFirestoreX01.getUserPlayerGameStats.add(stats);
        statsFirestoreX01.getUserFilteredPlayerGameStats.add(stats);
      }
    }

    if (gameX01.getGameSettings.getSingleOrTeam == SingleOrTeamEnum.Team) {
      for (PlayerOrTeamGameStatsX01 stats in gameX01.getTeamGameStatistics) {
        stats.setGameId = g_gameId;
        statsFirestoreX01.allTeamGameStats.add(stats);
        statsFirestoreX01.filteredTeamGameStats.add(stats);
      }
    }

    statsFirestoreX01.calculateX01Stats();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // ignore gestures
      child: Scaffold(
        appBar: CustomAppBarWithHeart(
          title: 'Finished game',
          mode: GameMode.X01,
          isFinishScreen: true,
          showHeart: true,
        ),
        body: Stack(
          children: [
            Selector<GameX01_P, bool>(
              selector: (_, game) => game.getShowLoadingSpinner,
              builder: (_, showLoadingSpinner, __) => showLoadingSpinner
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                  : SingleChildScrollView(
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
          ],
        ),
      ),
    );
  }
}
