import 'package:dart_app/constants.dart';
import 'package:dart_app/models/firestore/x01/stats_firestore_x01_p.dart';
import 'package:dart_app/screens/statistics/local_widgets/avg_best_worst_stats/avg_best_worst_stats.dart';
import 'package:dart_app/screens/statistics/local_widgets/filter_bar.dart';
import 'package:dart_app/screens/statistics/local_widgets/more_stats.dart';
import 'package:dart_app/screens/statistics/local_widgets/other_stats.dart';
import 'package:dart_app/screens/statistics/local_widgets/stats_per_game_btns/stats_per_game_btns.dart';
import 'package:dart_app/services/firestore/firestore_service_player_stats.dart';
import 'package:dart_app/services/firestore/firestore_service_games.dart';
import 'package:dart_app/utils/app_bars/custom_app_bar.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

class Statistics extends StatefulWidget {
  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  bool _showMoreStats = false;

  @override
  initState() {
    context.read<StatsFirestoreX01_P>().currentFilterValue =
        FilterValue.Overall;
    _getPlayerGameStatistics();
    _getGames();
    super.initState();
  }

  _getPlayerGameStatistics() async {
    await context.read<FirestoreServicePlayerStats>().getX01Statistics(context);
  }

  _getGames() async {
    await context.read<FirestoreServiceGames>().getGames('X01', context);
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
        appBar: CustomAppBar(showBackBtn: false, title: 'Statistics'),
        body: Consumer<StatsFirestoreX01_P>(
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
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
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
          color: Theme.of(context).colorScheme.secondary,
        ),
        label: Text(
          _showMoreStats ? 'Less Stats' : 'More Stats',
          style: TextStyle(
            color: Utils.getTextColorDarken(context),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
