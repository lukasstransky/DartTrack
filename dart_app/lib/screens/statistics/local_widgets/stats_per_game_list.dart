import 'package:dart_app/constants.dart';
import 'package:dart_app/models/firestore/stats_firestore_c.dart';
import 'package:dart_app/models/firestore/stats_firestore_d_t.dart';
import 'package:dart_app/models/firestore/stats_firestore_s_t.dart';
import 'package:dart_app/models/firestore/stats_firestore_sc_t.dart';
import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/models/games/game_cricket_p.dart';
import 'package:dart_app/models/games/game_score_training_p.dart';
import 'package:dart_app/models/games/game_single_double_training_p.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/models/firestore/stats_firestore_x01_p.dart';
import 'package:dart_app/screens/game_modes/shared/finish/stats_card/stats_card.dart';
import 'package:dart_app/screens/game_modes/x01/finish/local_widgets/stats_card/stats_card_x01.dart';
import 'package:dart_app/services/firestore/firestore_service_games.dart';
import 'package:dart_app/services/firestore/firestore_service_player_stats.dart';
import 'package:dart_app/utils/app_bars/custom_app_bar_stats_list.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class StatsPerGameList extends StatefulWidget {
  StatsPerGameList({Key? key}) : super(key: key);

  static const routeName = '/statsPerGameList';

  @override
  State<StatsPerGameList> createState() => _StatsPerGameListState();
}

class _StatsPerGameListState extends State<StatsPerGameList> {
  GameMode _mode = GameMode.X01;
  bool _showLoadingSpinner = false;

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    _getMode();
    _getGamesAndPlayerOrTeamGameStats();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarStatsList(
        title: '${_mode.name} - Games',
        mode: _mode,
      ),
      body: SafeArea(
        child: _getWidgetWithSelector(),
      ),
    );
  }

  _getMode() async {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
            <String, dynamic>{})
        as Map; // extract arguments that are passed into in order to get game mode (X01, Cricket...)
    _mode = arguments.entries.first.value;
  }

  _getGamesAndPlayerOrTeamGameStats() async {
    final bool isConnected = await Utils.hasInternetConnection();
    if (!isConnected) {
      return;
    }

    final dynamic statsFirestore =
        Utils.getFirestoreStatsProviderBasedOnMode(_mode, context);
    statsFirestore.showFavouriteGames = false;

    setState(() {
      _showLoadingSpinner = true;
    });

    if (statsFirestore.loadPlayerGameStats) {
      await context
          .read<FirestoreServicePlayerStats>()
          .getAllPlayerGameStats(statsFirestore, _mode);

      statsFirestore.loadPlayerGameStats = false;
    }

    if ((_mode == GameMode.X01 || _mode == GameMode.Cricket) &&
        statsFirestore.loadTeamGameStats) {
      await context
          .read<FirestoreServicePlayerStats>()
          .getAllTeamGameStats(statsFirestore, _mode);

      statsFirestore.loadTeamGameStats = false;
    }

    if (statsFirestore.loadGames) {
      await context.read<FirestoreServiceGames>().getGames(_mode, context);

      statsFirestore.loadGames = false;
    }

    setState(() {
      _showLoadingSpinner = false;
    });
  }

  String _getMessage(dynamic statsFirestore, GameMode mode) {
    if (statsFirestore.showFavouriteGames &&
        statsFirestore.favouriteGames.isEmpty) {
      return 'There are currently no games selected as favourite.';
    }

    final String modeLowerCase =
        _mode.name == 'X01' ? _mode.name : _mode.name.toLowerCase();
    final String messagePart = 'No ${modeLowerCase} games have been played';
    if (mode == GameMode.X01) {
      switch (statsFirestore.currentFilterValue) {
        case FilterValue.Overall:
          return 'No ${modeLowerCase} games have been played yet.';
        case FilterValue.Month:
          return '${messagePart} in the last 30 days.';
        case FilterValue.Year:
          return '${messagePart} in the last 365 days.';
        case FilterValue.Custom:
          final List<String> dateTimeParts =
              statsFirestore.customDateFilterRange.split(';');

          if (dateTimeParts[0] == dateTimeParts[1]) {
            return '${messagePart} on ${dateTimeParts[0]}.';
          } else {
            return 'Between the period from ${dateTimeParts[0]} to ${dateTimeParts[1]}, no ${_mode} games were played.';
          }
      }
    }

    return '${messagePart} yet.';
  }

  void _deleteGame(Game_P game, dynamic statsFirestore) async {
    final bool isConnected = await Utils.hasInternetConnection();
    if (!isConnected) {
      return;
    }

    if (statsFirestore.games.isEmpty) {
      statsFirestore.noGamesPlayed = true;
    }

    setState(() {
      _showLoadingSpinner = true;
    });

    await context.read<FirestoreServiceGames>().deleteGame(
          game.getGameId,
          context,
          game.getTeamGameStatistics.length > 0 ? true : false,
          _mode,
        );

    if (statsFirestore is StatsFirestoreX01_P) {
      await statsFirestore.calculateX01Stats();
    }

    setState(() {
      _showLoadingSpinner = false;
    });
    statsFirestore.notify();
  }

  _getCard(Game_P game) {
    if (_mode == GameMode.X01) {
      return StatsCardX01(
        isFinishScreen: false,
        gameX01: GameX01_P.createGame(game),
        isOpenGame: false,
      );
    } else if (_mode == GameMode.ScoreTraining) {
      return StatsCard(
        isFinishScreen: false,
        game: GameScoreTraining_P.createGame(game),
        isOpenGame: false,
      );
    } else if (_mode == GameMode.SingleTraining ||
        _mode == GameMode.DoubleTraining) {
      return StatsCard(
        isFinishScreen: false,
        game: GameSingleDoubleTraining_P.createGame(game),
        isOpenGame: false,
      );
    } else if (_mode == GameMode.Cricket) {
      return StatsCard(
        isFinishScreen: false,
        game: GameCricket_P.createGame(game),
        isOpenGame: false,
      );
    }
  }

  _getWidget(dynamic statsFirestore, List<Game_P> games) {
    Widget widgetToReturn;

    if (_showLoadingSpinner) {
      widgetToReturn = Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      );
    } else if ((statsFirestore.showFavouriteGames &&
            statsFirestore.favouriteGames.isNotEmpty) ||
        (!statsFirestore.showFavouriteGames && games.isNotEmpty)) {
      statsFirestore.sortGames();

      widgetToReturn = Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Center(
                child: Container(
                  width: 90.w,
                  padding: EdgeInsets.only(bottom: 2.h),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: 2.h,
                          left: 1.w,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'To view the details about a game, click on its card.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .fontSize,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: 1.w,
                          bottom: 1.h,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '(Swipe left to delete a game)',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .fontSize,
                            ),
                          ),
                        ),
                      ),
                      if ((statsFirestore.showFavouriteGames
                          ? statsFirestore.favouriteGames.isNotEmpty
                          : games.isNotEmpty))
                        for (Game_P game in statsFirestore.showFavouriteGames
                            ? statsFirestore.favouriteGames
                            : games) ...[
                          Container(
                            padding: EdgeInsets.only(bottom: 2.h),
                            child: Slidable(
                              key: UniqueKey(),
                              child: _getCard(game),
                              startActionPane: ActionPane(
                                extentRatio: 0.1,
                                dismissible: DismissiblePane(onDismissed: () {
                                  _deleteGame(game, statsFirestore);
                                }),
                                motion: const ScrollMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (context) {},
                                    backgroundColor: Color(0xFFFE4A49),
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete,
                                    label: 'Delete',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      widgetToReturn = Center(
        child: Text(
          _getMessage(statsFirestore, _mode),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
          ),
        ),
      );
    }

    return widgetToReturn;
  }

  _getWidgetWithSelector() {
    final dynamic statsFirestore =
        Utils.getFirestoreStatsProviderBasedOnMode(_mode, context);
    statsFirestore.favouriteGames.sort();

    List<Game_P> games = statsFirestore.games;
    if (_mode == GameMode.X01 &&
        statsFirestore.currentFilterValue != FilterValue.Overall) {
      games = statsFirestore.filteredGames;
    }

    if (_mode == GameMode.Cricket) {
      return Selector<StatsFirestoreCricket_P, SelectorModel>(
        selector: (_, statsFirestore) => SelectorModel(
          showFavouriteGames: statsFirestore.showFavouriteGames,
          favouriteGames: statsFirestore.favouriteGames,
        ),
        builder: (_, selectorModel, __) => _getWidget(statsFirestore, games),
      );
    } else if (_mode == GameMode.X01) {
      return Selector<StatsFirestoreX01_P, SelectorModel>(
        selector: (_, statsFirestore) => SelectorModel(
          showFavouriteGames: statsFirestore.showFavouriteGames,
          favouriteGames: statsFirestore.favouriteGames,
        ),
        builder: (_, selectorModel, __) => _getWidget(statsFirestore, games),
      );
    } else if (_mode == GameMode.ScoreTraining) {
      return Selector<StatsFirestoreScoreTraining_P, SelectorModel>(
        selector: (_, statsFirestore) => SelectorModel(
          showFavouriteGames: statsFirestore.showFavouriteGames,
          favouriteGames: statsFirestore.favouriteGames,
        ),
        builder: (_, selectorModel, __) => _getWidget(statsFirestore, games),
      );
    } else if (_mode == GameMode.SingleTraining) {
      return Selector<StatsFirestoreSingleTraining_P, SelectorModel>(
        selector: (_, statsFirestore) => SelectorModel(
          showFavouriteGames: statsFirestore.showFavouriteGames,
          favouriteGames: statsFirestore.favouriteGames,
        ),
        builder: (_, selectorModel, __) => _getWidget(statsFirestore, games),
      );
    } else if (_mode == GameMode.DoubleTraining) {
      return Selector<StatsFirestoreDoubleTraining_P, SelectorModel>(
        selector: (_, statsFirestore) => SelectorModel(
          showFavouriteGames: statsFirestore.showFavouriteGames,
          favouriteGames: statsFirestore.favouriteGames,
        ),
        builder: (_, selectorModel, __) => _getWidget(statsFirestore, games),
      );
    }
  }
}

class SelectorModel {
  final bool showFavouriteGames;
  final List<Game_P> favouriteGames;

  SelectorModel({
    required this.showFavouriteGames,
    required this.favouriteGames,
  });
}
