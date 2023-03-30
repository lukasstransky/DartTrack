import 'package:dart_app/models/firestore/stats_firestore_x01_p.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class MoreStatsPreciseScores extends StatelessWidget {
  const MoreStatsPreciseScores({
    Key? key,
    required bool this.showAllScoesPerDartWithCount,
  }) : super(key: key);

  final bool showAllScoesPerDartWithCount;

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
            for (int i = 1; i <= 10; i++)
              Row(
                children: [
                  Container(
                    width: 10.w,
                    child: Padding(
                      padding: EdgeInsets.only(top: 0.5.h),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          i.toString() + '.',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                            color: i == 1
                                ? Theme.of(context).colorScheme.secondary
                                : Utils.getTextColorDarken(context),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: 0.5,
                      ),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: showAllScoesPerDartWithCount
                            ? Text(
                                statisticsFirestore
                                            .allScoresPerDartAsStringCount
                                            .length <
                                        i
                                    ? '-'
                                    : Utils.sortMapStringIntByKey(
                                                statisticsFirestore
                                                    .allScoresPerDartAsStringCount)
                                            .keys
                                            .elementAt(i - 1) +
                                        ' (' +
                                        Utils.sortMapStringIntByKey(
                                                statisticsFirestore
                                                    .allScoresPerDartAsStringCount)
                                            .values
                                            .elementAt(i - 1)
                                            .toString() +
                                        'x)',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: statisticsFirestore.countOfGames > 0 &&
                                          i == 1
                                      ? Theme.of(context).colorScheme.secondary
                                      : Colors.white,
                                ),
                              )
                            : Text(
                                statisticsFirestore.preciseScores.length < i
                                    ? '-'
                                    : Utils.sortMapIntIntByKey(
                                                statisticsFirestore
                                                    .preciseScores)
                                            .keys
                                            .elementAt(i - 1)
                                            .toString() +
                                        ' (' +
                                        Utils.sortMapIntIntByKey(
                                                statisticsFirestore
                                                    .preciseScores)
                                            .values
                                            .elementAt(i - 1)
                                            .toString() +
                                        'x)',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: i == 1
                                      ? Theme.of(context).colorScheme.secondary
                                      : Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
