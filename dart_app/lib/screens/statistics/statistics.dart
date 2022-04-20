import 'package:dart_app/models/statistics_firestore.dart';
import 'package:dart_app/screens/statistics/local_widgets/filter_bar.dart';
import 'package:dart_app/screens/statistics/local_widgets/full_stats.dart';
import 'package:dart_app/screens/statistics/local_widgets/rounded_chip.dart';
import 'package:dart_app/services/firestore_service.dart';
import 'package:dart_app/utils/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'dart:developer';

class Statistics extends StatefulWidget {
  const Statistics({Key? key}) : super(key: key);

  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  bool _showFullStats = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(false, "Statistics"),
      body: Consumer<StatisticsFirestore>(
        builder: (_, statisticsFirestore, __) => SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                child: FilterBar(),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(statisticsFirestore.countOf180 > 0
                              ? statisticsFirestore.countOf180.toString()
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
                          Text(statisticsFirestore.countOfAllDarts > 0
                              ? statisticsFirestore.countOfAllDarts.toString()
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
                          Text(statisticsFirestore.countOfGames > 0
                              ? statisticsFirestore.countOfGames.toString()
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
                          Text(statisticsFirestore.countOfGamesWon > 0
                              ? statisticsFirestore.countOfGamesWon.toString()
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
                        value: statisticsFirestore.avg > 0
                            ? statisticsFirestore.avg.toStringAsFixed(2)
                            : "-",
                      ),
                    ),
                    Expanded(
                      child: RoundedChip(
                        value: statisticsFirestore.bestAvg != -1
                            ? statisticsFirestore.bestAvg.toStringAsFixed(2)
                            : "-",
                      ),
                    ),
                    Expanded(
                      child: RoundedChip(
                        value: statisticsFirestore.worstAvg != -1
                            ? statisticsFirestore.worstAvg.toStringAsFixed(2)
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
                        value: statisticsFirestore.firstNineAvg > 0
                            ? statisticsFirestore.firstNineAvg
                                .toStringAsFixed(2)
                            : "-",
                      ),
                    ),
                    Expanded(
                      child: RoundedChip(
                        value: statisticsFirestore.bestFirstNineAvg != -1
                            ? statisticsFirestore.bestFirstNineAvg
                                .toStringAsFixed(2)
                            : "-",
                      ),
                    ),
                    Expanded(
                      child: RoundedChip(
                        value: statisticsFirestore.worstFirstNineAvg != -1
                            ? statisticsFirestore.worstFirstNineAvg
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
                          value: statisticsFirestore.checkoutQuoteAvg != 0
                              ? statisticsFirestore.checkoutQuoteAvg
                                  .toStringAsFixed(2)
                              : "-"),
                    ),
                    Expanded(
                      child: RoundedChip(
                        value: statisticsFirestore.bestCheckoutQuote != -1
                            ? statisticsFirestore.bestCheckoutQuote
                                .toStringAsFixed(2)
                            : "-",
                      ),
                    ),
                    Expanded(
                      child: RoundedChip(
                        value: statisticsFirestore.worstCheckoutQuote != -1
                            ? statisticsFirestore.worstCheckoutQuote
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
                        value: statisticsFirestore.dartsPerLegAvg != 0
                            ? statisticsFirestore.dartsPerLegAvg
                                .toStringAsFixed(2)
                            : "-",
                      ),
                    ),
                    Expanded(
                      child: RoundedChip(
                        value: statisticsFirestore.bestLeg != -1
                            ? statisticsFirestore.bestLeg.toString()
                            : "-",
                      ),
                    ),
                    Expanded(
                      child: RoundedChip(
                        value: statisticsFirestore.worstLeg != -1
                            ? statisticsFirestore.worstLeg.toString()
                            : "-",
                      ),
                    ),
                  ],
                ),
              ),
              if (_showFullStats) FullStats(),
              Center(
                child: TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _showFullStats = !_showFullStats;
                    });
                  },
                  icon: Icon(
                    _showFullStats ? Icons.expand_less : Icons.expand_more,
                    color: Colors.black,
                  ),
                  label: const Text(
                    "Full Stats",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
