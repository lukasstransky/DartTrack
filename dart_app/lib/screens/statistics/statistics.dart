import 'dart:io';

import 'package:dart_app/constants.dart';
import 'package:dart_app/models/firestore/stats_firestore_x01_p.dart';
import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/models/user_p.dart';
import 'package:dart_app/screens/statistics/local_widgets/avg_best_worst_stats/avg_best_worst_stats.dart';
import 'package:dart_app/screens/statistics/local_widgets/filter_bar.dart';
import 'package:dart_app/screens/statistics/local_widgets/more_stats/more_stats.dart';
import 'package:dart_app/screens/statistics/local_widgets/other_stats.dart';
import 'package:dart_app/screens/statistics/local_widgets/stats_per_game_btns/stats_per_game_btns.dart';
import 'package:dart_app/services/auth_service.dart';
import 'package:dart_app/services/firestore/firestore_service_games.dart';
import 'package:dart_app/services/firestore/firestore_service_player_stats.dart';
import 'package:dart_app/utils/ad_management/banner_ad_widget.dart';
import 'package:dart_app/utils/app_bars/custom_app_bar.dart';
import 'package:dart_app/utils/button_styles.dart';
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
  String _username = '';
  //TODO replace
  // ios -> ca-app-pub-8582367743573228/8518148683
  // android -> ca-app-pub-8582367743573228/7166179194
  final String _bannerAdUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-3940256099942544/2934735716';

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  initState() {
    final StatsFirestoreX01_P statsFirestore =
        context.read<StatsFirestoreX01_P>();
    statsFirestore.currentFilterValue = FilterValue.Overall;
    statsFirestore.setShowLoadingSpinner = true;

    _username =
        context.read<AuthService>().getUsernameFromSharedPreferences() ?? '';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_username == 'Guest') {
        _showDialogWhenLoggedInAsGuest();
      } else {
        _loadData(statsFirestore);
        showSpinner(statsFirestore);
      }
    });

    super.initState();
  }

  showSpinner(StatsFirestoreX01_P statsFirestore) async {
    if (statsFirestore.gamesLoaded || statsFirestore.noGamesPlayed) {
      statsFirestore.setShowLoadingSpinner = true;
      statsFirestore.notify();
      await Future.delayed(Duration(milliseconds: DEFAULT_DELY));
      statsFirestore.setShowLoadingSpinner = false;
      statsFirestore.notify();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: CustomAppBar(showBackBtn: false, title: 'Statistics'),
        body: Column(
          children: [
            if (context.read<User_P>().getAdsEnabled)
              BannerAdWidget(
                bannerAdUnitId: _bannerAdUnitId,
                bannerAdEnum: BannerAdEnum.OverallStatsScreen,
              ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    FilterBar(),
                    Selector<StatsFirestoreX01_P, SelectorModel>(
                      selector: (_, statsFirestoreX01) => SelectorModel(
                          games: statsFirestoreX01.games,
                          showLoadingSpinner:
                              statsFirestoreX01.getShowLoadingSpinner),
                      builder: (_, model, __) => model.showLoadingSpinner &&
                              _username != 'Guest'
                          ? SizedBox(
                              height: MediaQuery.of(context).size.height - 25.h,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                            )
                          : Column(
                              children: [
                                OtherStats(),
                                AvgBestWorstStats(),
                                if (_showMoreStats) MoreStats(),
                                showMoreStatsBtn(),
                                StatsPerGameBtns()
                              ],
                            ),
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

  // only loaded when user goes to statistics tab for the first time
  _loadData(StatsFirestoreX01_P statsFirestore) async {
    final bool isConnected = await Utils.hasInternetConnection();
    if (!isConnected) {
      return;
    }

    if (!statsFirestore.loadPlayerGameStats && !statsFirestore.loadGames) {
      return;
    }

    statsFirestore.setShowLoadingSpinner = true;
    statsFirestore.notify();

    if (statsFirestore.loadPlayerGameStats) {
      final String currentUsername =
          context.read<AuthService>().getUsernameFromSharedPreferences() ?? '';

      await context
          .read<FirestoreServicePlayerStats>()
          .getAllPlayerGameStats(statsFirestore, GameMode.X01, currentUsername);
      await context
          .read<FirestoreServicePlayerStats>()
          .getAllTeamGameStats(statsFirestore, GameMode.X01);
      await statsFirestore.calculateX01Stats();

      statsFirestore.loadPlayerGameStats = false;
      statsFirestore.loadTeamGameStats = false;
    }

    // only loaded when user goes to statistics tab for the first time
    if (statsFirestore.loadGames) {
      await context
          .read<FirestoreServiceGames>()
          .getGames(GameMode.X01, context);

      statsFirestore.loadGames = false;
    }

    statsFirestore.setShowLoadingSpinner = false;
    statsFirestore.notify();
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
        contentPadding:
            Utils.isMobile(context) ? DIALOG_CONTENT_PADDING_MOBILE : null,
        title: Container(
          width: TEXT_DIALOG_WIDTH.w,
          child: Text(
            'Information',
            style: TextStyle(
              color: Colors.white,
              fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
            ),
          ),
        ),
        content: Container(
          width: DIALOG_NORMAL_WIDTH.w,
          child: Text(
            'In order to track your games, please create an account.',
            style: TextStyle(
              color: Colors.white,
              fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
            ),
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
                fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
              ),
            ),
            style: ButtonStyles.darkPrimaryColorBtnStyle(context).copyWith(
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
          _showMoreStats ? 'Less' : 'More',
          style: TextStyle(
            color: Colors.white,
            fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
          ),
        ),
        style: ButtonStyle(
          splashFactory: InkRipple.splashFactory,
          shadowColor: Utils.getColor(
              Utils.darken(Theme.of(context).colorScheme.primary, 30)
                  .withOpacity(0.3)),
          overlayColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (states.contains(MaterialState.pressed))
              return Utils.darken(Theme.of(context).colorScheme.primary, 10);
            return Colors.transparent;
          }),
        ),
      ),
    );
  }
}

class SelectorModel {
  final bool showLoadingSpinner;
  final List<Game_P> games;

  SelectorModel({
    required this.showLoadingSpinner,
    required this.games,
  });
}
