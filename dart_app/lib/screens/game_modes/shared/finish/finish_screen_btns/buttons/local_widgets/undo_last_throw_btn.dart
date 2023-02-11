import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/game_score_training_p.dart';
import 'package:dart_app/models/games/game_single_double_training_p.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/models/games/x01/helper/revert_x01_helper.dart';
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

  _undoLastThrowBtnClicked(BuildContext context) async {
    final firestoreServiceGames = await context.read<FirestoreServiceGames>();

    if (gameMode == GameMode.X01) {
      final game = context.read<GameX01_P>();

      game.setShowLoadingSpinner = true;
      game.notify();

      Navigator.of(context).pushNamed(
        '/gameX01',
        arguments: {'openGame': false},
      );

      await firestoreServiceGames.deleteGame(g_gameId, context,
          game.getTeamGameStatistics.length > 0 ? true : false);

      RevertX01Helper.revertPoints(context);
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
          'mode': game.getMode,
        },
      );

      await firestoreServiceGames.deleteGame(
        g_gameId,
        context,
        false,
      );

      game.revert(context);
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
