import 'package:dart_app/models/statistics_firestore_x01.dart';
import 'package:dart_app/screens/statistics/local_widgets/avg_best_worst_stats/avg_best_worst_stats.dart';
import 'package:dart_app/screens/statistics/local_widgets/filter_bar.dart';
import 'package:dart_app/screens/statistics/local_widgets/more_stats.dart';
import 'package:dart_app/screens/statistics/local_widgets/other_stats.dart';
import 'package:dart_app/screens/statistics/local_widgets/stats_per_game_btns.dart';
import 'package:dart_app/services/firestore_service.dart';
import 'package:dart_app/utils/app_bars/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class Statistics extends StatefulWidget {
  const Statistics({Key? key}) : super(key: key);

  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  bool _showMoreStats = false;

  @override
  void initState() {
    _getPlayerGameStatistics();
    super.initState();
  }

  _getPlayerGameStatistics() async {
    await context.read<FirestoreService>().getStatistics(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(false, "Statistics"),
      body: Consumer<StatisticsFirestoreX01>(
        builder: (_, statisticsFirestore, __) =>
            statisticsFirestore.avgBestWorstStatsLoaded
                ? SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        FilterBar(),
                        OtherStats(),
                        AvgBestWorstStats(),
                        if (_showMoreStats) MoreStats(),
                        Center(
                          child: TextButton.icon(
                            onPressed: () {
                              setState(() {
                                _showMoreStats = !_showMoreStats;
                              });
                            },
                            icon: Icon(
                              _showMoreStats
                                  ? Icons.expand_less
                                  : Icons.expand_more,
                              color: Colors.black,
                            ),
                            label: const Text(
                              "More Stats",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        StatsPerGameBtns()
                      ],
                    ),
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  ),
      ),
    );
  }
}
