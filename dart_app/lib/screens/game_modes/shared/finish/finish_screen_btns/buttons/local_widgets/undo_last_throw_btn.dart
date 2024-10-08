import 'package:dart_app/constants.dart';
import 'package:dart_app/models/bot.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/games/game_cricket_p.dart';
import 'package:dart_app/models/games/game_score_training_p.dart';
import 'package:dart_app/models/games/game_single_double_training_p.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/models/games/x01/helper/revert_x01_helper.dart';
import 'package:dart_app/models/team.dart';
import 'package:dart_app/services/auth_service.dart';
import 'package:dart_app/services/firestore/firestore_service_games.dart';
import 'package:dart_app/utils/button_styles.dart';
import 'package:dart_app/utils/globals.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class UndoLastThrowBtn extends StatelessWidget {
  const UndoLastThrowBtn({
    Key? key,
    required this.gameMode,
  }) : super(key: key);

  final GameMode gameMode;

  bool _didBotFinishGame(GameX01_P gameX01, GameSettingsX01_P gameSettingsX01) {
    final String playerOrTeamWhoFinishedGame =
        gameX01.getLegSetWithPlayerOrTeamWhoFinishedIt.last;

    if (gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Single) {
      return playerOrTeamWhoFinishedGame.startsWith('Bot');
    } else {
      final Team teamWhoFinished = gameSettingsX01.getTeams
          .firstWhere((team) => team.getName == playerOrTeamWhoFinishedGame);
      final int indexOfCurrentPlayer = teamWhoFinished.getPlayers
          .indexOf(teamWhoFinished.getCurrentPlayerToThrow);

      if (indexOfCurrentPlayer == 0) {
        return teamWhoFinished.getPlayers[teamWhoFinished.getPlayers.length - 1]
            is Bot;
      } else {
        return teamWhoFinished.getPlayers[indexOfCurrentPlayer - 1] is Bot;
      }
    }
  }

  _undoLastThrowBtnClicked(BuildContext context) async {
    final bool isConnected = await Utils.hasInternetConnection();
    if (!isConnected) {
      return;
    }

    final FirestoreServiceGames firestoreServiceGames =
        await context.read<FirestoreServiceGames>();
    final GameSettingsX01_P gameSettingsX01 = context.read<GameSettingsX01_P>();
    final String username =
        context.read<AuthService>().getUsernameFromSharedPreferences() ?? '';

    if (gameMode == GameMode.X01) {
      final GameX01_P game = context.read<GameX01_P>();

      game.setShowLoadingSpinner = true;
      game.notify();

      Navigator.of(context).pushReplacementNamed('/gameX01');

      if (username != 'Guest') {
        await firestoreServiceGames.deleteGame(
          g_gameId,
          context,
          game.getTeamGameStatistics.length > 0 ? true : false,
          gameMode,
        );
      }

      if (_didBotFinishGame(game, gameSettingsX01)) {
        RevertX01Helper.revertPoints(game, gameSettingsX01);
        RevertX01Helper.revertPoints(game, gameSettingsX01);
      } else {
        RevertX01Helper.revertPoints(game, gameSettingsX01);
      }

      game.setShowLoadingSpinner = false;
      game.notify();
    } else if (gameMode == GameMode.ScoreTraining) {
      final GameScoreTraining_P game = context.read<GameScoreTraining_P>();

      game.setIsGameFinished = false;
      game.setShowLoadingSpinner = true;
      game.notify();

      Navigator.of(context).pushReplacementNamed('/gameScoreTraining');

      if (username != 'Guest') {
        await firestoreServiceGames.deleteGame(
          g_gameId,
          context,
          game.getTeamGameStatistics.length > 0 ? true : false,
          gameMode,
        );
      }

      game.revert();
      game.setShowLoadingSpinner = false;
      game.notify();
    } else if (gameMode == GameMode.SingleTraining ||
        gameMode == GameMode.DoubleTraining) {
      final GameSingleDoubleTraining_P game =
          context.read<GameSingleDoubleTraining_P>();

      game.setIsGameFinished = false;
      game.setShowLoadingSpinner = true;
      game.notify();

      Navigator.of(context).pushReplacementNamed(
        '/gameSingleDoubleTraining',
        arguments: {
          'mode': game.getName,
        },
      );

      if (username != 'Guest') {
        await firestoreServiceGames.deleteGame(
          g_gameId,
          context,
          false,
          gameMode,
        );
      }

      final bool isRandomMode =
          game.getGameSettings.getMode == ModesSingleDoubleTraining.Random;
      if (isRandomMode) {
        game.setRandomModeFinished = false;
      }
      game.revert(isRandomMode);
      game.setShowLoadingSpinner = false;
      game.notify();
    } else if (gameMode == GameMode.Cricket) {
      final GameCricket_P game = context.read<GameCricket_P>();

      game.setIsGameFinished = false;
      game.setShowLoadingSpinner = true;
      game.notify();

      Navigator.of(context).pushReplacementNamed('/gameCricket');

      if (username != 'Guest') {
        await firestoreServiceGames.deleteGame(
          g_gameId,
          context,
          game.getTeamGameStatistics.length > 0 ? true : false,
          gameMode,
        );
      }

      game.revert();
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
          onPressed: () {
            Utils.handleVibrationFeedback(context);
            _undoLastThrowBtnClicked(context);
          },
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'Undo last throw',
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
              ),
            ),
          ),
          style: ButtonStyles.anyColorBtnStyle(context, DANGER_ACTION_BTN_COLOR)
              .copyWith(
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
