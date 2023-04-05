import 'package:dart_app/constants.dart';
import 'package:dart_app/models/firestore/stats_firestore_x01_p.dart';
import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/screens/statistics/local_widgets/avg_best_worst_stats/avg_best_worst_stats.dart';
import 'package:dart_app/screens/statistics/local_widgets/filter_bar.dart';
import 'package:dart_app/screens/statistics/local_widgets/more_stats/more_stats.dart';
import 'package:dart_app/screens/statistics/local_widgets/other_stats.dart';
import 'package:dart_app/screens/statistics/local_widgets/stats_per_game_btns/stats_per_game_btns.dart';
import 'package:dart_app/services/auth_service.dart';
import 'package:dart_app/services/firestore/firestore_service_player_stats.dart';
import 'package:dart_app/services/firestore/firestore_service_games.dart';
import 'package:dart_app/utils/app_bars/custom_app_bar.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class Statistics extends StatefulWidget {
  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  bool _showMoreStats = false;
  String username = '';

  @override
  initState() {
    final StatsFirestoreX01_P statsFirestore =
        context.read<StatsFirestoreX01_P>();

    statsFirestore.currentFilterValue = FilterValue.Overall;
    username =
        context.read<AuthService>().getUsernameFromSharedPreferences() ?? '';

    if (username == 'Guest') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showDialogWhenLoggedInAsGuest();
      });
      statsFirestore.resetAll();
    } else {
      if (statsFirestore.loadGames) {
        _getPlayerGameStatistics(statsFirestore);
        _getGames();
        statsFirestore.loadGames = false;
      }
    }

    super.initState();
  }

  _getPlayerGameStatistics(StatsFirestoreX01_P statsFirestore) async {
    await context
        .read<FirestoreServicePlayerStats>()
        .getX01Statistics(statsFirestore, username, true);
  }

  _getGames() async {
    await context.read<FirestoreServiceGames>().getGames('X01', context);
  }

  _showDialogWhenLoggedInAsGuest() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.primary,
        contentPadding: dialogContentPadding,
        title: const Text(
          'Information',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'In order to track your games you need to create an account.',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Continue',
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
            style: ButtonStyle(
              backgroundColor:
                  Utils.getPrimaryMaterialStateColorDarken(context),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(showBackBtn: false, title: 'Statistics'),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            FilterBar(),
            Selector<StatsFirestoreX01_P, SelectorModel>(
              selector: (_, statsFirestoreX01) => SelectorModel(
                avgBestWorstStatsLoaded:
                    statsFirestoreX01.avgBestWorstStatsLoaded,
                games: statsFirestoreX01.games,
              ),
              builder: (_, selectorModel, __) =>
                  selectorModel.avgBestWorstStatsLoaded || username == 'Guest'
                      ? Column(
                          children: [
                            OtherStats(),
                            AvgBestWorstStats(),
                            if (_showMoreStats) MoreStats(),
                            showMoreStatsBtn(),
                            StatsPerGameBtns()
                          ],
                        )
                      : SizedBox(
                          height: MediaQuery.of(context).size.height - 25.h,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        ),
            ),
          ],
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
          _showMoreStats ? 'Less stats' : 'More stats',
          style: TextStyle(
            color: Utils.getTextColorDarken(context),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class SelectorModel {
  final bool avgBestWorstStatsLoaded;
  final List<Game_P> games;

  SelectorModel({
    required this.avgBestWorstStatsLoaded,
    required this.games,
  });
}
