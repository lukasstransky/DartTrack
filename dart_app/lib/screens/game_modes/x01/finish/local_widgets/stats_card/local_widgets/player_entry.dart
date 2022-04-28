import 'package:dart_app/models/games/game.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class PlayerEntry extends StatelessWidget {
  const PlayerEntry({Key? key, required this.i, required this.game})
      : super(key: key);

  final int i;
  final Game game;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
                bottom: i != game.getPlayerGameStatistics.length - 1 ? 0 : 10),
            child: Row(
              children: [
                Container(
                  width: 30.w,
                  child: Text(
                      (i + 1).toString() +
                          ". " +
                          game.getPlayerGameStatistics[i].getPlayer.getName,
                      style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: i == 0 ? FontWeight.bold : null)),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 25),
                  child: Container(
                    width: 45.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            game.getGameSettings.getSetsEnabled
                                ? "Sets: " +
                                    game.getPlayerGameStatistics[i].getSetsWon
                                        .toString()
                                : "Legs: " +
                                    game.getPlayerGameStatistics[i].getLegsWon
                                        .toString(),
                            style: TextStyle(fontSize: 14.sp)),
                        Text(
                            "Average: " +
                                game.getPlayerGameStatistics[i].getAverage(
                                    game, game.getPlayerGameStatistics[i]),
                            style: TextStyle(fontSize: 14.sp)),
                        if (game.getGameSettings.getEnableCheckoutCounting)
                          Text(
                              "Checkout %: " +
                                  game.getPlayerGameStatistics[i]
                                      .getCheckoutQuoteInPercent()
                                      .toString(),
                              style: TextStyle(fontSize: 14.sp))
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
