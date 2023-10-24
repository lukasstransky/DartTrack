import 'package:dart_app/constants.dart';
import 'package:dart_app/models/firestore/open_games_firestore.dart';
import 'package:dart_app/models/firestore/stats_firestore_c.dart';
import 'package:dart_app/models/game_settings/game_settings_cricket_p.dart';
import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/models/games/game_cricket_p.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats_cricket.dart';
import 'package:dart_app/screens/game_modes/shared/finish/finish_screen_btns/buttons/finish_screen_btns.dart';
import 'package:dart_app/screens/game_modes/shared/finish/stats_card/stats_card.dart';
import 'package:dart_app/services/firestore/firestore_service_games.dart';
import 'package:dart_app/services/firestore/firestore_service_player_stats.dart';
import 'package:dart_app/utils/app_bars/custom_app_bar_with_heart.dart';
import 'package:dart_app/utils/globals.dart';
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
  @override
  void initState() {
    _saveDataToFirestore();
    super.initState();
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
        body: SingleChildScrollView(
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
      ),
    );
  }

  _saveDataToFirestore() async {
    final GameCricket_P gameCricket = context.read<GameCricket_P>();
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
