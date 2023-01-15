import 'package:dart_app/models/games/score_training/game_score_training_p.dart';
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

  final String gameMode;

  _undoLastThrowBtnClicked(BuildContext context) async {
    if (gameMode == 'X01') {
      await context.read<FirestoreServiceGames>().deleteGame(
          g_gameId,
          context,
          context.read<GameX01_P>().getTeamGameStatistics.length > 0
              ? true
              : false);

      Navigator.of(context).pushNamed(
        '/gameX01',
        arguments: {'openGame': false},
      );
      RevertX01Helper.revertPoints(context);
    } else if (gameMode == 'Score Training') {
      final gameScoreTraining_P = context.read<GameScoreTraining_P>();

      await context.read<FirestoreServiceGames>().deleteGame(g_gameId, context,
          gameScoreTraining_P.getTeamGameStatistics.length > 0 ? true : false);

      Navigator.of(context).pushNamed(
        '/gameScoreTraining',
        arguments: {'openGame': false},
      );
      gameScoreTraining_P.revert(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 1.h),
      child: Container(
        width: 40.w,
        height: 6.h,
        child: ElevatedButton(
          onPressed: () => _undoLastThrowBtnClicked(context),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'Undo Last Throw',
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
