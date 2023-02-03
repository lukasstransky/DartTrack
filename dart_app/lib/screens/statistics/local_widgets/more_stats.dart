import 'package:dart_app/models/firestore/stats_firestore_x01_p.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class MoreStats extends StatefulWidget {
  const MoreStats({Key? key}) : super(key: key);

  @override
  State<MoreStats> createState() => _MoreStatsState();
}

class _MoreStatsState extends State<MoreStats> {
  bool _showAllScoesPerDartWithCount = false;
  bool _roundedScoresOdd = false;

  bool _highlightRoundedScore(StatsFirestoreX01_P statisticsFirestore, int i) {
    return statisticsFirestore.countOfGames > 0 &&
        statisticsFirestore.countOfGames > 0 &&
        (!_roundedScoresOdd
                ? statisticsFirestore.roundedScoresEven[i]
                : statisticsFirestore.roundedScoresOdd[i]) ==
            (!_roundedScoresOdd
                ? Utils.getMostOccurringValue(
                    statisticsFirestore.roundedScoresEven)
                : Utils.getMostOccurringValue(
                    statisticsFirestore.roundedScoresOdd));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StatsFirestoreX01_P>(
      builder: (_, statisticsFirestore, __) => Padding(
        padding: EdgeInsets.only(top: 20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      'Rounded Scores',
                      style: TextStyle(
                          fontSize: 14.sp,
                          color: Utils.getTextColorDarken(context),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      _showAllScoesPerDartWithCount
                          ? 'All Scores per Dart'
                          : 'Precise Scores',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Utils.getTextColorDarken(context),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  width: 5.w,
                ),
                Container(
                  width: 30.w,
                  child: Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Column(
                      children: [
                        for (int i = (!_roundedScoresOdd ? 0 : 10);
                            i <= (!_roundedScoresOdd ? 180 : 170);
                            i += 20) ...[
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  padding: EdgeInsets.only(top: 5),
                                  child: Text(
                                    i != 180
                                        ? i.toString() + '+'
                                        : i.toString(),
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                      color: _highlightRoundedScore(
                                              statisticsFirestore, i)
                                          ? Theme.of(context)
                                              .colorScheme
                                              .secondary
                                          : Utils.getTextColorDarken(context),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  padding: EdgeInsets.only(
                                    top: 5,
                                    right: 10,
                                  ),
                                  child: Text(
                                    !_roundedScoresOdd
                                        ? statisticsFirestore
                                            .roundedScoresEven[i]
                                            .toString()
                                        : statisticsFirestore
                                            .roundedScoresOdd[i]
                                            .toString(),
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: _highlightRoundedScore(
                                              statisticsFirestore, i)
                                          ? Theme.of(context)
                                              .colorScheme
                                              .secondary
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
                ),
                Container(
                  width: 25.w,
                ),
                Container(
                  width: 30.w,
                  child: Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Column(
                      children: [
                        for (int i = 1; i <= 10; i++)
                          Row(
                            children: [
                              Container(
                                width: 10.w,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    top: 5,
                                  ),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      i.toString() + '.',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.bold,
                                        color: i == 1
                                            ? Theme.of(context)
                                                .colorScheme
                                                .secondary
                                            : Utils.getTextColorDarken(context),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    top: 5,
                                  ),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: _showAllScoesPerDartWithCount
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
                                              color: statisticsFirestore
                                                              .countOfGames >
                                                          0 &&
                                                      i == 1
                                                  ? Theme.of(context)
                                                      .colorScheme
                                                      .secondary
                                                  : Colors.white,
                                            ),
                                          )
                                        : Text(
                                            statisticsFirestore
                                                        .preciseScores.length <
                                                    i
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
                                                  ? Theme.of(context)
                                                      .colorScheme
                                                      .secondary
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
                ),
                Container(
                  width: 10.w,
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 5.w, top: 5),
              child: Row(
                children: [
                  Text(
                    'Show All Scores per Dart',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Switch(
                    thumbColor: MaterialStateProperty.all(
                        Theme.of(context).colorScheme.secondary),
                    activeColor: Theme.of(context).colorScheme.secondary,
                    inactiveThumbColor: Theme.of(context).colorScheme.secondary,
                    value: _showAllScoesPerDartWithCount,
                    onChanged: (value) {
                      setState(() {
                        _showAllScoesPerDartWithCount =
                            !_showAllScoesPerDartWithCount;
                      });
                    },
                  ),
                ],
              ),
            ),
            Container(
              transform: Matrix4.translationValues(0.0, -10.0, 0.0),
              child: Padding(
                padding: EdgeInsets.only(left: 5.w),
                child: Row(
                  children: [
                    Text(
                      'Show Odd Rounded Scores',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    Switch(
                      thumbColor: MaterialStateProperty.all(
                          Theme.of(context).colorScheme.secondary),
                      activeColor: Theme.of(context).colorScheme.secondary,
                      inactiveThumbColor:
                          Theme.of(context).colorScheme.secondary,
                      value: _roundedScoresOdd,
                      onChanged: (value) {
                        setState(() {
                          _roundedScoresOdd = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
