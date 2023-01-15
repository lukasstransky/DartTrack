import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class RoundedScoresOdd extends StatelessWidget {
  const RoundedScoresOdd({
    Key? key,
    required this.game_p,
  }) : super(key: key);

  final Game_P game_p;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          transform: Matrix4.translationValues(-10.0, 0.0, 0.0),
          padding: EdgeInsets.only(top: PADDING_TOP_STATISTICS),
          child: Text(
            'Rounded Scores',
            style: TextStyle(
              fontSize: FONTSIZE_HEADING_STATISTICS.sp,
              color: Colors.white,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: PADDING_TOP_STATISTICS),
          child: Row(
            children: [
              Column(
                children: [
                  for (int i = 10; i <= 170; i += 20)
                    Container(
                      width: WIDTH_HEADINGS_STATISTICS.w,
                      padding: EdgeInsets.only(top: 5),
                      child: Row(
                        children: [
                          Container(
                            width: 12.w,
                            alignment: Alignment.centerRight,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                '${i}+',
                                style: TextStyle(
                                  fontSize: FONTSIZE_STATISTICS.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Utils.getTextColorDarken(context),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                ],
              ),
              for (dynamic stats
                  in Utils.getPlayerOrTeamStatsDynamic(game_p, context))
                Column(
                  children: [
                    for (int i = 10; i <= 170; i += 20)
                      Container(
                        width: WIDTH_DATA_STATISTICS.w,
                        padding: EdgeInsets.only(top: 5),
                        child: Text(
                          stats.getRoundedScoresOdd[i].toString(),
                          style: TextStyle(
                              fontSize: FONTSIZE_STATISTICS.sp,
                              color: stats.getHighestScore() >= 10 &&
                                      Utils.getMostOccurringValue(
                                              stats.getRoundedScoresOdd) ==
                                          stats.getRoundedScoresOdd[i]
                                  ? Theme.of(context).colorScheme.secondary
                                  : Colors.white,
                              fontWeight: stats.getHighestScore() >= 10 &&
                                      Utils.getMostOccurringValue(
                                              stats.getRoundedScoresOdd) ==
                                          stats.getRoundedScoresOdd[i]
                                  ? FontWeight.bold
                                  : FontWeight.normal),
                        ),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}
