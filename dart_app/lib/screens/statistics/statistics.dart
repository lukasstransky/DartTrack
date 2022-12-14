import 'package:dart_app/constants.dart';
import 'package:dart_app/models/firestore/statistics_firestore_x01.dart';
import 'package:dart_app/screens/statistics/local_widgets/avg_best_worst_stats/avg_best_worst_stats.dart';
import 'package:dart_app/screens/statistics/local_widgets/filter_bar.dart';
import 'package:dart_app/screens/statistics/local_widgets/more_stats.dart';
import 'package:dart_app/screens/statistics/local_widgets/other_stats.dart';
import 'package:dart_app/screens/statistics/local_widgets/stats_per_game_btns.dart';
import 'package:dart_app/services/firestore/firestore_service_player_stats.dart';
import 'package:dart_app/services/firestore/firestore_service_games.dart';
import 'package:dart_app/utils/app_bars/custom_app_bar.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Statistics extends StatefulWidget {
  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  bool _showMoreStats = false;

  @override
  initState() {
    context.read<StatisticsFirestoreX01>().currentFilterValue =
        FilterValue.Overall;
    _getPlayerGameStatistics();
    _getGames();
    super.initState();
  }

  _getPlayerGameStatistics() async {
    await context.read<FirestoreServicePlayerStats>().getStatistics(context);
  }

  _getGames() async {
    await context.read<FirestoreServiceGames>().getGames('X01', context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(showBackBtn: false, title: 'Statistics'),
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
                        showMoreStatsBtn(),
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

  Center showMoreStatsBtn() {
    return Center(
      child: TextButton.icon(
        onPressed: () {
          setState(() {
            _showMoreStats = !_showMoreStats;
          });
        },
        icon: Icon(
          _showMoreStats ? Icons.expand_less : Icons.expand_more,
          color: Colors.black,
        ),
        label: Text(
          _showMoreStats ? 'Less Stats' : 'More Stats',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
