import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/models/games/game_x01.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class StatsCard extends StatelessWidget {
  const StatsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameX01 = Provider.of<GameX01>(context, listen: false);
    final gameSettingsX01 =
        Provider.of<GameSettingsX01>(context, listen: false);

    return Padding(
      padding: EdgeInsets.only(top: 100),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    gameSettingsX01.getGameMode(),
                    style:
                        TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
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
                  "X01 (" + gameSettingsX01.getGameModeDetails(true) + ")",
                  style: TextStyle(fontSize: 14.sp)),
            ),
            for (int i = 0; i < gameX01.getPlayerGameStatistics.length; i++)
              Padding(
                padding: EdgeInsets.only(
                  left: 20,
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          bottom:
                              i != gameX01.getPlayerGameStatistics.length - 1
                                  ? 0
                                  : 10),
                      child: Row(
                        children: [
                          Container(
                            width: 30.w,
                            child: Text(
                                (i + 1).toString() +
                                    ". " +
                                    gameX01.getPlayerGameStatistics[i].getPlayer
                                        .getName,
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight:
                                        i == 0 ? FontWeight.bold : null)),
                          ),
                          Container(
                            width: 40.w,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    gameSettingsX01.getSetsEnabled
                                        ? "Sets: " +
                                            gameX01.getPlayerGameStatistics[i]
                                                .getSetsWon
                                                .toString()
                                        : "Legs: " +
                                            gameX01.getPlayerGameStatistics[i]
                                                .getLegsWon
                                                .toString(),
                                    style: TextStyle(fontSize: 14.sp)),
                                Text(
                                    "Average: " +
                                        gameX01.getPlayerGameStatistics[i]
                                            .getAverage(
                                                gameX01,
                                                gameX01.getPlayerGameStatistics[
                                                    i]),
                                    style: TextStyle(fontSize: 14.sp)),
                                if (gameSettingsX01.getEnableCheckoutCounting)
                                  Text(
                                      "Checkout %: " +
                                          gameX01.getPlayerGameStatistics[i]
                                              .getCheckoutQuoteInPercent()
                                              .toString(),
                                      style: TextStyle(fontSize: 14.sp))
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    if (i != gameX01.getPlayerGameStatistics.length - 1)
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
    );
  }
}
