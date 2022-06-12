import 'package:dart_app/models/statistics_firestore_x01.dart';
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

  @override
  Widget build(BuildContext context) {
    return Consumer<StatisticsFirestoreX01>(
      builder: (_, statisticsFirestore, __) => Padding(
        padding: EdgeInsets.only(top: 20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      "Rounded Scores",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      _showAllScoesPerDartWithCount
                          ? "All Scores per Dart"
                          : "Precise Scores",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: 10.w,
                ),
                SizedBox(
                  width: 30.w,
                  child: Container(
                    child: Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Column(
                        children: [
                          for (int i = (!_roundedScoresOdd ? 0 : 10);
                              i <= (!_roundedScoresOdd ? 180 : 170);
                              i += 20) ...[
                            Row(
                              children: [
                                SizedBox(
                                  width: 15.w,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        i != 180
                                            ? i.toString() + "+"
                                            : i.toString(),
                                        style: TextStyle(
                                            fontSize: 12.sp,
                                            fontWeight: (!_roundedScoresOdd
                                                        ? statisticsFirestore
                                                                .roundedScoresEven[
                                                            i]
                                                        : statisticsFirestore
                                                                .roundedScoresOdd[
                                                            i]) ==
                                                    (!_roundedScoresOdd
                                                        ? Utils.getMostOccurringValue(
                                                            statisticsFirestore
                                                                .roundedScoresEven)
                                                        : Utils.getMostOccurringValue(
                                                            statisticsFirestore
                                                                .roundedScoresOdd))
                                                ? FontWeight.bold
                                                : FontWeight.normal),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      top: 5,
                                      right: 10,
                                    ),
                                    child: Align(
                                      alignment: Alignment.centerRight,
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
                                            fontWeight: statisticsFirestore
                                                            .countOfGames >
                                                        0 &&
                                                    (!_roundedScoresOdd
                                                            ? statisticsFirestore
                                                                    .roundedScoresEven[
                                                                i]
                                                            : statisticsFirestore
                                                                    .roundedScoresOdd[
                                                                i]) ==
                                                        (!_roundedScoresOdd
                                                            ? Utils.getMostOccurringValue(
                                                                statisticsFirestore
                                                                    .roundedScoresEven)
                                                            : Utils.getMostOccurringValue(
                                                                statisticsFirestore
                                                                    .roundedScoresOdd))
                                                ? FontWeight.bold
                                                : FontWeight.normal),
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
                ),
                SizedBox(
                  width: 20.w,
                ),
                SizedBox(
                  width: 30.w,
                  child: Container(
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
                                    child: Text(
                                      i.toString() + ".",
                                      style: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: i == 1 || i == 2 || i == 3
                                              ? FontWeight.bold
                                              : FontWeight.normal),
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
                                                  ? "-"
                                                  : Utils.sortMapStringIntByKey(
                                                              statisticsFirestore
                                                                  .allScoresPerDartAsStringCount)
                                                          .keys
                                                          .elementAt(i - 1) +
                                                      " (" +
                                                      Utils.sortMapStringIntByKey(
                                                              statisticsFirestore
                                                                  .allScoresPerDartAsStringCount)
                                                          .values
                                                          .elementAt(i - 1)
                                                          .toString() +
                                                      "x)",
                                              style: TextStyle(
                                                  fontSize: 12.sp,
                                                  fontWeight:
                                                      i == 1 || i == 2 || i == 3
                                                          ? FontWeight.bold
                                                          : FontWeight.normal),
                                            )
                                          : Text(
                                              statisticsFirestore.preciseScores
                                                          .length <
                                                      i
                                                  ? "-"
                                                  : Utils.sortMapIntIntByKey(
                                                              statisticsFirestore
                                                                  .preciseScores)
                                                          .keys
                                                          .elementAt(i - 1)
                                                          .toString() +
                                                      " (" +
                                                      Utils.sortMapIntIntByKey(
                                                              statisticsFirestore
                                                                  .preciseScores)
                                                          .values
                                                          .elementAt(i - 1)
                                                          .toString() +
                                                      "x)",
                                              style: TextStyle(
                                                  fontSize: 12.sp,
                                                  fontWeight:
                                                      i == 1 || i == 2 || i == 3
                                                          ? FontWeight.bold
                                                          : FontWeight.normal),
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
                ),
                SizedBox(
                  width: 10.w,
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 5.w, top: 5),
              child: Row(
                children: [
                  const Text("Show All Scores per Dart"),
                  Switch(
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
                    const Text("Show Odd Rounded Scores"),
                    Switch(
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
