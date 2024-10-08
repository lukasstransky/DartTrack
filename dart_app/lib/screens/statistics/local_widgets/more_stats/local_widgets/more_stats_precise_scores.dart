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

  bool _shouldHighlightRankNumber(StatsFirestoreX01_P statisticsFirestore) {
    if (showAllScoesPerDartWithCount) {
      return statisticsFirestore.allScoresPerDartAsStringCount.isNotEmpty;
    }
    return statisticsFirestore.filteredGames.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final StatsFirestoreX01_P statisticsFirestore =
        context.read<StatsFirestoreX01_P>();
    final double halfScreenWidth = MediaQuery.of(context).size.width / 2;

    return Container(
      width: halfScreenWidth,
      padding: EdgeInsets.only(top: 1.h),
      child: Column(
        children: [
          for (int i = 1; i <= 10; i++)
            Container(
              width: 30.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 0.5.h),
                    child: Text(
                      '${i.toString()}.',
                      style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.bodyMedium!.fontSize,
                        fontWeight: FontWeight.bold,
                        color:
                            _shouldHighlightRankNumber(statisticsFirestore) &&
                                    i == 1
                                ? Theme.of(context).colorScheme.secondary
                                : Utils.getTextColorDarken(context),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 0.5),
                    child: showAllScoesPerDartWithCount
                        ? Text(
                            statisticsFirestore
                                        .allScoresPerDartAsStringCount.length <
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
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .fontSize,
                              color: statisticsFirestore
                                          .allScoresPerDartAsStringCount
                                          .isNotEmpty &&
                                      i == 1
                                  ? Theme.of(context).colorScheme.secondary
                                  : Colors.white,
                            ),
                          )
                        : Text(
                            statisticsFirestore.preciseScores.length < i
                                ? '-'
                                : Utils.sortMapIntIntByKey(
                                            statisticsFirestore.preciseScores)
                                        .keys
                                        .elementAt(i - 1)
                                        .toString() +
                                    ' (' +
                                    Utils.sortMapIntIntByKey(
                                            statisticsFirestore.preciseScores)
                                        .values
                                        .elementAt(i - 1)
                                        .toString() +
                                    'x)',
                            style: TextStyle(
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .fontSize,
                              color:
                                  statisticsFirestore.games.isNotEmpty && i == 1
                                      ? Theme.of(context).colorScheme.secondary
                                      : Colors.white,
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
