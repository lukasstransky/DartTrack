import 'package:dart_app/models/games/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:sizer/sizer.dart';

class PlayerEntry extends StatelessWidget {
  const PlayerEntry(
      {Key? key, required this.i, required this.game, required this.openGame})
      : super(key: key);

  final int i;
  final Game game;
  final bool openGame;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 10,
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
                bottom: i != game.getPlayerGameStatistics.length - 1 ? 0 : 10),
            child: Row(
              children: [
                Container(
                    width: 40.w,
                    child: Row(
                      children: [
                        Text(
                          (i + 1).toString() + ". ",
                          style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: (i == 0 && !openGame)
                                  ? FontWeight.bold
                                  : null),
                        ),
                        if (!openGame) ...[
                          if (i == 0)
                            Padding(
                              padding: EdgeInsets.only(
                                right: 5,
                              ),
                              child: Icon(
                                Entypo.trophy,
                                size: 12.sp,
                                color: Color(0xffFFD700),
                              ),
                            )
                          else
                            SizedBox.shrink(),
                        ],
                        Text(game.getPlayerGameStatistics[i].getPlayer.getName,
                            style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: (i == 0 && !openGame)
                                    ? FontWeight.bold
                                    : null)),
                      ],
                    )),
                Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Container(
                    width: 40.w,
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
                            style: TextStyle(fontSize: 12.sp)),
                        if (!openGame) ...[
                          Text(
                              "Average: " +
                                  game.getPlayerGameStatistics[i].getAverage(
                                      game, game.getPlayerGameStatistics[i]),
                              style: TextStyle(fontSize: 12.sp)),
                          if (game.getGameSettings.getEnableCheckoutCounting)
                            Text(
                              "Checkout: " +
                                  game.getPlayerGameStatistics[i]
                                      .getCheckoutQuoteInPercent()
                                      .toString(),
                              style: TextStyle(fontSize: 12.sp),
                            ),
                        ],
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
