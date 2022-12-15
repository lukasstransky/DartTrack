import 'package:dart_app/models/games/helper/revert_helper.dart';
import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/services/firestore/firestore_service_games.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class Buttons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StatisticsBtn(),
        NewGameBtn(),
        UndoLastThrowBtn(),
      ],
    );
  }
}

class StatisticsBtn extends StatelessWidget {
  const StatisticsBtn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 3.h),
      child: Container(
        width: 40.w,
        height: 6.h,
        child: ElevatedButton(
          onPressed: () => Navigator.of(context).pushNamed('/statisticsX01',
              arguments: {'game': context.read<GameX01>()}),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'Statistics',
              style: TextStyle(fontSize: 12.sp),
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
    );
  }
}

class NewGameBtn extends StatelessWidget {
  const NewGameBtn({Key? key}) : super(key: key);

  _newGameBtnClicked(BuildContext context) async {
    context.read<GameX01>().reset();
    Navigator.of(context).pushNamed(
      '/gameX01',
      arguments: {'openGame': false},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 1.h),
      child: Container(
        width: 40.w,
        height: 6.h,
        child: ElevatedButton(
          onPressed: () => _newGameBtnClicked(context),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text('New Game', style: TextStyle(fontSize: 12.sp)),
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
    );
  }
}

class UndoLastThrowBtn extends StatelessWidget {
  const UndoLastThrowBtn({Key? key}) : super(key: key);

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
    return Padding(
      padding: EdgeInsets.only(top: 1.h),
      child: Container(
        width: 40.w,
        height: 6.h,
        child: ElevatedButton(
          onPressed: () => _undoLastThrowBtnClicked(context),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text('Undo Last Throw', style: TextStyle(fontSize: 12.sp)),
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
    );
  }
}
