import 'package:dart_app/constants.dart';
import 'package:dart_app/models/firestore/stats_firestore_x01_p.dart';
import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/screens/statistics/local_widgets/avg_best_worst_stats/avg_best_worst_stats.dart';
import 'package:dart_app/screens/statistics/local_widgets/filter_bar.dart';
import 'package:dart_app/screens/statistics/local_widgets/more_stats/more_stats.dart';
import 'package:dart_app/screens/statistics/local_widgets/other_stats.dart';
import 'package:dart_app/screens/statistics/local_widgets/stats_per_game_btns/stats_per_game_btns.dart';
import 'package:dart_app/services/auth_service.dart';
import 'package:dart_app/services/firestore/firestore_service_games.dart';
import 'package:dart_app/services/firestore/firestore_service_player_stats.dart';
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

    username =
        context.read<AuthService>().getUsernameFromSharedPreferences() ?? '';

    if (username == 'Guest') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showDialogWhenLoggedInAsGuest();
      });
      statsFirestore.resetAll();
    } else {
      if (statsFirestore.loadPlayerStats) {
        _getAllPlayerOrTeamGameStatsX01(statsFirestore);
        statsFirestore.loadPlayerStats = false;
      }
      if (statsFirestore.loadGames) {
        _getAllX01Games();
        statsFirestore.loadGames = false;
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: CustomAppBar(showBackBtn: false, title: 'Statistics'),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              FilterBar(),
              Selector<StatsFirestoreX01_P, SelectorModel>(
                selector: (_, statsFirestoreX01) => SelectorModel(
                  playerOrTeamGameStatsLoaded:
                      statsFirestoreX01.playerOrTeamGameStatsLoaded,
                  gamesLoaded: statsFirestoreX01.gamesLoaded,
                  noGamesPlayed: statsFirestoreX01.noGamesPlayed,
                  games: statsFirestoreX01.games,
                ),
                builder: (_, selectorModel, __) =>
                    (selectorModel.playerOrTeamGameStatsLoaded &&
                                selectorModel.gamesLoaded) ||
                            selectorModel.noGamesPlayed ||
                            username == 'Guest'
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
      ),
    );
  }

  _getAllPlayerOrTeamGameStatsX01(StatsFirestoreX01_P statsFirestore) async {
    await context
        .read<FirestoreServicePlayerStats>()
        .getAllPlayerOrTeamGameStatsX01(
            statsFirestore, context.read<AuthService>().getCurrentUserUid);
    statsFirestore.calculateX01Stats();
  }

  _getAllX01Games() async {
    await context.read<FirestoreServiceGames>().getGames(
        GameMode.X01, context, context.read<FirestoreServicePlayerStats>());
  }

  _showDialogWhenLoggedInAsGuest() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DIALOG_SHAPE_ROUNDING),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        contentPadding: dialogContentPadding,
        title: Text(
          'Information',
          style: TextStyle(
            color: Colors.white,
            fontSize: DIALOG_TITLE_FONTSIZE.sp,
          ),
        ),
        content: Text(
          'In order to track your games, please create an account.',
          style: TextStyle(
            color: Colors.white,
            fontSize: DIALOG_CONTENT_FONTSIZE.sp,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Utils.handleVibrationFeedback(context);
              Navigator.of(context).pop();
            },
            child: Text(
              'Ok',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: DIALOG_BTN_FONTSIZE.sp,
              ),
            ),
            style: ButtonStyle(
              splashFactory: NoSplash.splashFactory,
              shadowColor: MaterialStateProperty.all(Colors.transparent),
              overlayColor: MaterialStateProperty.all(Colors.transparent),
              backgroundColor:
                  Utils.getPrimaryMaterialStateColorDarken(context),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(DIALOG_BTN_SHAPE_ROUNDING),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Center showMoreStatsBtn() {
    return Center(
      child: TextButton.icon(
        onPressed: () {
          Utils.handleVibrationFeedback(context);
          setState(() {
            _showMoreStats = !_showMoreStats;
          });
        },
        icon: Icon(
          size: ICON_BUTTON_SIZE.h,
          _showMoreStats ? Icons.expand_less : Icons.expand_more,
          color: Theme.of(context).colorScheme.secondary,
        ),
        label: Text(
          _showMoreStats ? 'Less stats' : 'More stats',
          style: TextStyle(
            color: Colors.white,
            fontSize: 11.sp,
          ),
        ),
      ),
    );
  }
}

class SelectorModel {
  final bool playerOrTeamGameStatsLoaded;
  final bool gamesLoaded;
  final bool noGamesPlayed;
  final List<Game_P> games;

  SelectorModel({
    required this.playerOrTeamGameStatsLoaded,
    required this.gamesLoaded,
    required this.noGamesPlayed,
    required this.games,
  });
}
