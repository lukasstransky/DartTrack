import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class RoundedScoresEven extends StatelessWidget {
  const RoundedScoresEven({Key? key, required this.game_p}) : super(key: key);

  final Game_P game_p;

  bool _atLeastOneRoundedScoreValue(dynamic stats) {
    for (int value in stats.getRoundedScoresEven.values) {
      if (value != 0) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          transform: Matrix4.translationValues(-10.0, 0.0, 0.0),
          padding: EdgeInsets.only(top: PADDING_TOP_STATISTICS.h),
          child: Text(
            'Rounded scores',
            style: TextStyle(
              fontSize: FONTSIZE_HEADING_STATISTICS.sp,
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
                  for (int i = 0; i <= 180; i += 20)
                    Container(
                      width: WIDTH_HEADINGS_STATISTICS.w,
                      padding: EdgeInsets.only(top: 0.5.h),
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: 12.w,
                        alignment: Alignment.centerRight,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: i == 180
                              ? RichText(
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: '180',
                                        style: TextStyle(
                                          fontSize: FONTSIZE_STATISTICS.sp,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Utils.getTextColorDarken(context),
                                        ),
                                      ),
                                      TextSpan(
                                        text: '+',
                                        style: TextStyle(
                                          fontSize: FONTSIZE_STATISTICS.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Text(
                                  '${i}+',
                                  style: TextStyle(
                                    fontSize: FONTSIZE_STATISTICS.sp,
                                    fontWeight: FontWeight.bold,
                                    color: Utils.getTextColorDarken(context),
                                  ),
                                ),
                        ),
                      ),
                    ),
                ],
              ),
              for (dynamic stats
                  in Utils.getPlayerOrTeamStatsDynamic(game_p, context))
                Column(
                  children: [
                    for (int i = 0; i <= 180; i += 20)
                      Container(
                        width: WIDTH_DATA_STATISTICS.w,
                        padding: EdgeInsets.only(top: 0.5.h),
                        child: Text(
                          stats.getRoundedScoresEven[i].toString(),
                          style: TextStyle(
                            fontSize: FONTSIZE_STATISTICS.sp,
                            color: _atLeastOneRoundedScoreValue(stats) &&
                                    Utils.getMostOccurringValue(
                                            stats.getRoundedScoresEven) ==
                                        stats.getRoundedScoresEven[i]
                                ? Theme.of(context).colorScheme.secondary
                                : Colors.white,
                            fontWeight: _atLeastOneRoundedScoreValue(stats) &&
                                    Utils.getMostOccurringValue(
                                            stats.getRoundedScoresEven) ==
                                        stats.getRoundedScoresEven[i]
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
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
