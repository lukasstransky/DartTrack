import 'package:dart_app/models/firestore/stats_firestore_x01_p.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class MoreStatsRoundedScores extends StatelessWidget {
  const MoreStatsRoundedScores({
    Key? key,
    required bool this.roundedScoresOdd,
  }) : super(key: key);

  final bool roundedScoresOdd;

  @override
  Widget build(BuildContext context) {
    final StatsFirestoreX01_P statisticsFirestore =
        context.read<StatsFirestoreX01_P>();

    return Container(
      width: 30.w,
      child: Padding(
        padding: EdgeInsets.only(top: 1.h),
        child: Column(
          children: [
            for (int i = (!roundedScoresOdd ? 0 : 10);
                i <= (!roundedScoresOdd ? 180 : 170);
                i += 20) ...[
              Row(
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(top: 0.5.h),
                      child: Text(
                        i != 180 ? i.toString() + '+' : i.toString(),
                        style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.bodyMedium!.fontSize,
                          fontWeight: FontWeight.bold,
                          color: Utils.highlightRoundedScore(
                                  statisticsFirestore, i, roundedScoresOdd)
                              ? Theme.of(context).colorScheme.secondary
                              : Utils.getTextColorDarken(context),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(
                        top: 0.5.h,
                        right: 2.5.w,
                      ),
                      child: Text(
                        !roundedScoresOdd
                            ? statisticsFirestore.roundedScoresEven[i]
                                .toString()
                            : statisticsFirestore.roundedScoresOdd[i]
                                .toString(),
                        style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.bodyMedium!.fontSize,
                          color: Utils.highlightRoundedScore(
                                  statisticsFirestore, i, roundedScoresOdd)
                              ? Theme.of(context).colorScheme.secondary
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
