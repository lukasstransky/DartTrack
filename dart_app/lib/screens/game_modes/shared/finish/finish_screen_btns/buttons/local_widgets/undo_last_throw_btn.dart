import 'package:dart_app/constants.dart';
import 'package:dart_app/models/bot.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/games/game_score_training_p.dart';
import 'package:dart_app/models/games/game_single_double_training_p.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/models/games/x01/helper/revert_x01_helper.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats_x01.dart';
import 'package:dart_app/services/auth_service.dart';
import 'package:dart_app/services/firestore/firestore_service_games.dart';
import 'package:dart_app/utils/globals.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class UndoLastThrowBtn extends StatelessWidget {
  const UndoLastThrowBtn({
    Key? key,
    required this.gameMode,
  }) : super(key: key);

  final GameMode gameMode;

  _sortPlayerStatsBack(BuildContext context, GameX01_P gameX01_P) {
    final GameSettingsX01_P gameSettingsX01 = context.read<GameSettingsX01_P>();

    List<PlayerOrTeamGameStatsX01> newOrderedStats = [];
    for (Player player in gameSettingsX01.getPlayers) {
      final PlayerOrTeamGameStatsX01 stats = gameX01_P.getPlayerGameStatistics
          .where((element) => element.getPlayer.getName == player.getName)
          .first;
      newOrderedStats.add(stats);
    }

    gameX01_P.setPlayerGameStatistics = newOrderedStats;
  }

  bool _didBotFinishGame(GameX01_P gameX01, GameSettingsX01_P gameSettingsX01) {
    final String playerOrTeamWhoFinishedGame =
        gameX01.getLegSetWithPlayerOrTeamWhoFinishedIt.entries.last.value;

    if (gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Single) {
      return playerOrTeamWhoFinishedGame.startsWith('Bot');
    } else {
      return gameSettingsX01.getTeams
          .firstWhere((team) => team.getName == playerOrTeamWhoFinishedGame)
          .getCurrentPlayerToThrow is Bot;
    }
  }

  _undoLastThrowBtnClicked(BuildContext context) async {
    final firestoreServiceGames = await context.read<FirestoreServiceGames>();
    final String username =
        context.read<AuthService>().getUsernameFromSharedPreferences() ?? '';

    if (gameMode == GameMode.X01) {
      final game = context.read<GameX01_P>();

      game.setShowLoadingSpinner = true;
      game.notify();

      Navigator.of(context).pushNamed(
        '/gameX01',
        arguments: {'openGame': false},
      );

      if (username != 'Guest') {
        await firestoreServiceGames.deleteGame(g_gameId, context,
            game.getTeamGameStatistics.length > 0 ? true : false);
      }

      _sortPlayerStatsBack(context, game);

      if (_didBotFinishGame(game, context.read<GameSettingsX01_P>())) {
        RevertX01Helper.revertPoints(context);
        RevertX01Helper.revertPoints(context);
      } else {
        RevertX01Helper.revertPoints(context);
      }

      game.setShowLoadingSpinner = false;
      game.notify();
    } else if (gameMode == GameMode.ScoreTraining) {
      final game = context.read<GameScoreTraining_P>();

      game.setShowLoadingSpinner = true;
      game.notify();

      Navigator.of(context).pushNamed(
        '/gameScoreTraining',
        arguments: {'openGame': false},
      );

      await firestoreServiceGames.deleteGame(
        g_gameId,
        context,
        game.getTeamGameStatistics.length > 0 ? true : false,
      );

      game.revert(context);
      game.setShowLoadingSpinner = false;
      game.notify();
    } else if (gameMode == GameMode.SingleTraining ||
        gameMode == GameMode.DoubleTraining) {
      final game = context.read<GameSingleDoubleTraining_P>();

      game.setShowLoadingSpinner = true;
      game.notify();

      Navigator.of(context).pushNamed(
        '/gameSingleDoubleTraining',
        arguments: {
          'openGame': false,
          'mode': game.getName,
        },
      );

      await firestoreServiceGames.deleteGame(
        g_gameId,
        context,
        false,
      );

      final isRandomMode =
          game.getGameSettings.getMode == ModesSingleDoubleTraining.Random;
      if (isRandomMode) {
        game.setRandomModeFinished = false;
      }
      game.revert(context, isRandomMode);
      game.setShowLoadingSpinner = false;
      game.notify();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 1.h, bottom: 3.h),
      child: Container(
        width: 40.w,
        height: 6.h,
        child: ElevatedButton(
          onPressed: () => _undoLastThrowBtnClicked(context),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'Undo last throw',
              style: TextStyle(
                fontSize: 12.sp,
              ),
            ),
          ),
          style: ButtonStyle(
            splashFactory: NoSplash.splashFactory,
            shadowColor: MaterialStateProperty.all(Colors.transparent),
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
            ),
            backgroundColor: MaterialStateProperty.all(
              Color.fromARGB(255, 207, 87, 78),
            ),
          ),
        ),
      ),
    );
  }
}
