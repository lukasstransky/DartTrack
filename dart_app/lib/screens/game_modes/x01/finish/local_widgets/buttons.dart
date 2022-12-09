import 'package:dart_app/models/games/helper/revert_helper.dart';
import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/services/firestore/firestore_service_player_stats.dart';
import 'package:dart_app/services/firestore/firestore_service_games.dart';
import 'package:dart_app/utils/globals.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class Buttons extends StatefulWidget {
  @override
  State<Buttons> createState() => _ButtonsState();
}

class _ButtonsState extends State<Buttons> {
  _newGameBtnClicked(BuildContext context, GameX01 gameX01) async {
    gameX01.reset();
    Navigator.of(context).pushNamed(
      '/gameX01',
      arguments: {'openGame': false},
    );
  }

  _undoLastThrowBtnClicked(BuildContext context) async {
    await context
        .read<FirestoreServiceGames>()
        .deleteGame(context.read<GameX01>(), context);

    Navigator.of(context).pushNamed(
      '/gameX01',
      arguments: {'openGame': false},
    );
    Revert.revertPoints(context);
  }

  @override
  Widget build(BuildContext context) {
    final GameX01 gameX01 = context.read<GameX01>();

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 30),
          child: Container(
            width: 40.w,
            height: 6.h,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context)
                  .pushNamed('/statisticsX01', arguments: {'game': gameX01}),
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  'Statistics',
                  style: TextStyle(fontSize: 15.sp),
                ),
              ),
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                ),
                backgroundColor: MaterialStateProperty.all(
                    Theme.of(context).colorScheme.primary),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Container(
            width: 40.w,
            height: 6.h,
            child: ElevatedButton(
              onPressed: () => _newGameBtnClicked(context, gameX01),
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text('New Game', style: TextStyle(fontSize: 15.sp)),
              ),
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                ),
                backgroundColor: MaterialStateProperty.all(
                    Theme.of(context).colorScheme.primary),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Container(
            width: 40.w,
            height: 6.h,
            child: ElevatedButton(
              onPressed: () => _undoLastThrowBtnClicked(context),
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child:
                    Text('Undo Last Throw', style: TextStyle(fontSize: 15.sp)),
              ),
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                ),
                backgroundColor: MaterialStateProperty.all(
                  Colors.red,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
