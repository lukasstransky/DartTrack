import 'package:dart_app/models/statistics_firestore.dart';
import 'package:dart_app/screens/statistics/local_widgets/avg_best_worst_stats.dart';
import 'package:dart_app/screens/statistics/local_widgets/filter_bar.dart';
import 'package:dart_app/screens/statistics/local_widgets/full_stats.dart';
import 'package:dart_app/screens/statistics/local_widgets/other_stats.dart';
import 'package:dart_app/screens/statistics/local_widgets/stats_per_game_btns.dart';
import 'package:dart_app/utils/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

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
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            FilterBar(),
            OtherStats(),
            AvgBestWorstStats(),
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
            StatsPerGameBtns()
          ],
        ),
      ),
    );
  }
}
