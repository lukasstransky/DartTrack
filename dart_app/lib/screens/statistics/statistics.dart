import 'package:dart_app/models/statistics_firestore.dart';
import 'package:dart_app/screens/statistics/local_widgets/filter_bar.dart';
import 'package:dart_app/screens/statistics/local_widgets/rounded_chip.dart';
import 'package:dart_app/services/firestore_service.dart';
import 'package:dart_app/utils/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'dart:developer';

import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class Statistics extends StatefulWidget {
  const Statistics({Key? key}) : super(key: key);

  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<StatisticsFirestore>(
      future: context.read<FirestoreService>().getStatistics(context),
      builder:
          (BuildContext context, AsyncSnapshot<StatisticsFirestore> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if (snapshot.hasError)
            return Center(child: Text('Error: ${snapshot.error}'));
          else {
            return Scaffold(
              appBar: CustomAppBar(false, "Statistics"),
              body: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                    child: FilterBar(notifyParent: refresh),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Text(snapshot.data!.countOf180 > 0
                                  ? snapshot.data!.countOf180.toString()
                                  : "-"),
                              Text(
                                "180",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(snapshot.data!.countOfAllDarts > 0
                                  ? snapshot.data!.countOfAllDarts.toString()
                                  : "-"),
                              Text(
                                "Darts",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(snapshot.data!.countOfGames > 0
                                  ? snapshot.data!.countOfGames.toString()
                                  : "-"),
                              Text(
                                "Games",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Text(snapshot.data!.countOfGamesWon > 0
                                  ? snapshot.data!.countOfGamesWon.toString()
                                  : "-"),
                              Text(
                                "Games Won",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                    child: Row(
                      children: [
                        Container(
                          width: 30.w,
                          child: Text(""),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              "Avg.",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14.sp),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              "Best",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14.sp),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: Text(
                              "Worst",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14.sp),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                    child: Row(
                      children: [
                        Container(
                          width: 30.w,
                          child: Text(
                            "X01 Avg.",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: RoundedChip(
                            value: snapshot.data!.avg > 0
                                ? snapshot.data!.avg.toStringAsFixed(2)
                                : "-",
                          ),
                        ),
                        Expanded(
                          child: RoundedChip(
                            value: snapshot.data!.bestAvg != -1
                                ? snapshot.data!.bestAvg.toStringAsFixed(2)
                                : "-",
                          ),
                        ),
                        Expanded(
                          child: RoundedChip(
                            value: snapshot.data!.worstAvg != -1
                                ? snapshot.data!.worstAvg.toStringAsFixed(2)
                                : "-",
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                    child: Row(
                      children: [
                        Container(
                          width: 30.w,
                          child: Text(
                            "First Nine Avg.",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: RoundedChip(
                            value: snapshot.data!.firstNineAvg > 0
                                ? snapshot.data!.firstNineAvg.toStringAsFixed(2)
                                : "-",
                          ),
                        ),
                        Expanded(
                          child: RoundedChip(
                            value: snapshot.data!.bestFirstNineAvg != -1
                                ? snapshot.data!.bestFirstNineAvg
                                    .toStringAsFixed(2)
                                : "-",
                          ),
                        ),
                        Expanded(
                          child: RoundedChip(
                            value: snapshot.data!.worstFirstNineAvg != -1
                                ? snapshot.data!.worstFirstNineAvg
                                    .toStringAsFixed(2)
                                : "-",
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                    child: Row(
                      children: [
                        Container(
                          width: 30.w,
                          child: Text(
                            "Checkout %",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: RoundedChip(
                              value: snapshot.data!.checkoutQuoteAvg != 0
                                  ? snapshot.data!.checkoutQuoteAvg
                                      .toStringAsFixed(2)
                                  : "-"),
                        ),
                        Expanded(
                          child: RoundedChip(
                            value: snapshot.data!.bestCheckoutQuote != -1
                                ? snapshot.data!.bestCheckoutQuote
                                    .toStringAsFixed(2)
                                : "-",
                          ),
                        ),
                        Expanded(
                          child: RoundedChip(
                            value: snapshot.data!.worstCheckoutQuote != -1
                                ? snapshot.data!.worstCheckoutQuote
                                    .toStringAsFixed(2)
                                : "-",
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                    child: Row(
                      children: [
                        Container(
                          width: 30.w,
                          child: Text(
                            "Legs",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Expanded(
                          child: RoundedChip(
                            value: snapshot.data!.dartsPerLegAvg != 0
                                ? snapshot.data!.dartsPerLegAvg
                                    .toStringAsFixed(2)
                                : "-",
                          ),
                        ),
                        Expanded(
                          child: RoundedChip(
                            value: snapshot.data!.bestLeg != -1
                                ? snapshot.data!.bestLeg.toString()
                                : "-",
                          ),
                        ),
                        Expanded(
                          child: RoundedChip(
                            value: snapshot.data!.worstLeg != -1
                                ? snapshot.data!.worstLeg.toString()
                                : "-",
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
      },
    );
  }
}
