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
          padding: EdgeInsets.only(top: PADDING_TOP_STATISTICS.h),
          transform: Matrix4.translationValues(-2.5.w, 0.0, 0.0),
          child: Text(
            'Rounded scores',
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.titleLarge!.fontSize,
              color: Colors.white,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: PADDING_TOP_STATISTICS.h),
          child: Row(
            children: [
              Column(
                children: [
                  for (int i = 10; i <= 170; i += 20)
                    Container(
                      width: WIDTH_HEADINGS_STATISTICS.w,
                      padding: EdgeInsets.only(top: 0.5.h),
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
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .fontSize,
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
                        padding: EdgeInsets.only(top: 0.5.h),
                        child: Text(
                          stats.getRoundedScoresOdd[i].toString(),
                          style: TextStyle(
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .fontSize,
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
