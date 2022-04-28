import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/services/firestore_service.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class Buttons extends StatelessWidget {
  Buttons({Key? key}) : super(key: key);

  saveGameX01ToFirestore(BuildContext context) async {
    gameId = await context
        .read<FirestoreService>()
        .postGame(Provider.of<GameX01>(context, listen: false));
  }

  savePlayerGameStatisticsX01ToFirestore(BuildContext context) async {
    await context.read<FirestoreService>().postPlayerGameStatistics(
        Provider.of<GameX01>(context, listen: false), gameId, context);
  }

  String gameId = "";

  @override
  Widget build(BuildContext context) {
    final gameX01 = Provider.of<GameX01>(context, listen: false);
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 30),
          child: Container(
            width: 40.w,
            height: 6.h,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pushNamed("/statisticsX01",
                  arguments: {
                    'game': Provider.of<GameX01>(context, listen: false)
                  }),
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  "Statistics",
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
              onPressed: () => {
                saveGameX01ToFirestore(context),
                savePlayerGameStatisticsX01ToFirestore(context),
                gameX01.reset(),
                Navigator.of(context).pushNamed("/gameX01"),
              },
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text("New Game", style: TextStyle(fontSize: 15.sp)),
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
              onPressed: () => {
                Navigator.of(context).pushNamed("/gameX01"),
                gameX01.revertPoints(),
              },
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child:
                    Text("Undo Last Throw", style: TextStyle(fontSize: 15.sp)),
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
