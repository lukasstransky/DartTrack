import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/utils/custom_app_bar_x01_finished.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'dart:developer';

class Finish extends StatelessWidget {
  static const routeName = "/finishX01";

  const Finish({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameSettingsX01 =
        Provider.of<GameSettingsX01>(context, listen: false);
    final gameX01 = Provider.of<GameX01>(context, listen: false);

    return Scaffold(
      appBar: CustomAppBarX01Finished("Finished Game"),
      body: Center(
        child: Container(
          width: 90.w,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 100),
                child: Card(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: 10, left: 10, right: 10, bottom: 5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              gameSettingsX01.getGameMode(),
                              style: TextStyle(
                                  fontSize: 16.sp, fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            Text(
                              gameX01.getFormattedDateTime(),
                              style: TextStyle(fontSize: 12.sp),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10, bottom: 10),
                        child: Text(
                            "X01 (" +
                                gameSettingsX01.getGameModeDetails(true) +
                                ")",
                            style: TextStyle(fontSize: 14.sp)),
                      ),
                      for (int i = 0;
                          i < gameX01.getPlayerGameStatistics.length;
                          i++)
                        Padding(
                          padding: EdgeInsets.only(
                            left: 20,
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    bottom: i !=
                                            gameX01.getPlayerGameStatistics
                                                    .length -
                                                1
                                        ? 0
                                        : 10),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 30.w,
                                      child: Text(
                                          (i + 1).toString() +
                                              ". " +
                                              gameX01.getPlayerGameStatistics[i]
                                                  .getPlayer.getName,
                                          style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: i == 0
                                                  ? FontWeight.bold
                                                  : null)),
                                    ),
                                    Container(
                                      width: 40.w,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              gameSettingsX01.getSetsEnabled
                                                  ? "Sets: " +
                                                      gameX01
                                                          .getPlayerGameStatistics[
                                                              i]
                                                          .getSetsWon
                                                          .toString()
                                                  : "Legs: " +
                                                      gameX01
                                                          .getPlayerGameStatistics[
                                                              i]
                                                          .getLegsWon
                                                          .toString(),
                                              style:
                                                  TextStyle(fontSize: 14.sp)),
                                          Text(
                                              "Average: " +
                                                  gameX01
                                                      .getPlayerGameStatistics[
                                                          i]
                                                      .getAverage(),
                                              style:
                                                  TextStyle(fontSize: 14.sp)),
                                          if (gameSettingsX01
                                              .getEnableCheckoutCounting)
                                            Text(
                                                "Checkout %: " +
                                                    gameX01
                                                        .getPlayerGameStatistics[
                                                            i]
                                                        .getCheckoutQuoteInPercent()
                                                        .toString(),
                                                style:
                                                    TextStyle(fontSize: 14.sp))
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              if (i !=
                                  gameX01.getPlayerGameStatistics.length - 1)
                                Divider(
                                  height: 20,
                                  thickness: 1,
                                  endIndent: 20,
                                  color: Colors.black,
                                ),
                            ],
                          ),
                        )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 30),
                child: Container(
                  width: 40.w,
                  height: 6.h,
                  child: ElevatedButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed("/statisticsX01"),
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
                      gameX01.reset(),
                      Navigator.of(context).pushNamed("/gameX01"),
                    },
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child:
                          Text("New Game", style: TextStyle(fontSize: 15.sp)),
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
                      child: Text("Undo Last Throw",
                          style: TextStyle(fontSize: 15.sp)),
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
          ),
        ),
      ),
    );
  }
}
