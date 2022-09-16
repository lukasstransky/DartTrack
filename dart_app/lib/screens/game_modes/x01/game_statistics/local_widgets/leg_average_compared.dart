import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class LegAvgCompared extends StatelessWidget {
  const LegAvgCompared({Key? key, required this.game}) : super(key: key);

  final GameX01? game;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          transform: Matrix4.translationValues(-10.0, 0.0, 0.0),
          child: Padding(
            padding: EdgeInsets.only(top: PADDING_TOP_STATISTICS, bottom: 10),
            child: Center(
              child: Text(
                "Averages per Leg",
                style: TextStyle(
                    fontSize: FONTSIZE_HEADING_STATISTICS.sp,
                    color: Theme.of(context).primaryColor),
              ),
            ),
          ),
        ),

        //averages per leg
        for (int i = 0; i < game!.getPlayerGameStatistics.length; i++)
          Row(
            children: [
              Container(
                width: 20.w,
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Center(
                    child: Text(
                      game!.getPlayerGameStatistics[i].getPlayer.getName,
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 1.0, color: Colors.black),
                  ),
                ),
              ),
              for (String setLegString
                  in (game as GameX01).getAllLegSetStringsExceptCurrentOne())
                Container(
                  width: 25.w,
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Center(
                      child: Text(Utils.getAverageForLeg(
                          game!.getPlayerGameStatistics[i], setLegString)),
                    ),
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(width: 1.0, color: Colors.black),
                      bottom: BorderSide(width: 1.0, color: Colors.black),
                    ),
                  ),
                ),
            ],
          ),

        //set leg strings
        Row(
          children: [
            SizedBox(
              width: 20.w,
            ),
            for (String setLegString
                in (game as GameX01).getAllLegSetStringsExceptCurrentOne())
              Container(
                width: 25.w,
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Center(
                    child: Text(setLegString),
                  ),
                ),
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(width: 1.0, color: Colors.black),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
