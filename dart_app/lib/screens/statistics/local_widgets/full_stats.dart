import 'package:dart_app/models/statistics_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class FullStats extends StatefulWidget {
  const FullStats({Key? key}) : super(key: key);

  @override
  State<FullStats> createState() => _FullStatsState();
}

class _FullStatsState extends State<FullStats> {
  bool _showAllScoesPerDartWithCount = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<StatisticsFirestore>(
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
                          for (int i = 0; i <= 180; i += 20) ...[
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
                                            fontWeight: i ==
                                                    statisticsFirestore
                                                        .mostRoundedScoresKey
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
                                        statisticsFirestore.roundedScores[i]
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 12.sp,
                                            fontWeight: i ==
                                                    statisticsFirestore
                                                        .mostRoundedScoresKey
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
                                                  : statisticsFirestore
                                                          .allScoresPerDartAsStringCount
                                                          .keys
                                                          .elementAt(i - 1) +
                                                      " (" +
                                                      statisticsFirestore
                                                          .allScoresPerDartAsStringCount
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
                                                  : statisticsFirestore
                                                          .preciseScores.keys
                                                          .elementAt(i - 1)
                                                          .toString() +
                                                      " (" +
                                                      statisticsFirestore
                                                          .preciseScores.values
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
          ],
        ),
      ),
    );
  }
}
