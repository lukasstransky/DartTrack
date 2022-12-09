import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/models/firestore/statistics_firestore_x01.dart';
import 'package:dart_app/screens/game_modes/x01/finish/local_widgets/stats_card/stats_card_x01.dart';
import 'package:dart_app/services/firestore/firestore_service_games.dart';
import 'package:dart_app/services/firestore/firestore_service_player_stats.dart';
import 'package:dart_app/utils/app_bars/custom_app_bar_stats_list.dart';
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
  String _mode = '';

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    _getMode();
  }

  _getMode() async {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
            <String, dynamic>{})
        as Map; // extract arguments that are passed into in order to get game mode (X01, Cricket...)
    _mode = arguments.entries.first.value.toString();
  }

  String _getMessage(StatisticsFirestoreX01 statisticsFirestoreX01) {
    if (!statisticsFirestoreX01.noGamesPlayed &&
        statisticsFirestoreX01.favouriteGames.isEmpty) {
      return 'There are currently no games selected as favourite.';
    }

    final String messagePart = 'No ${_mode} games were played';

    switch (statisticsFirestoreX01.currentFilterValue) {
      case FilterValue.Overall:
        return 'No ${_mode} games have been played yet.';
      case FilterValue.Month:
        return '${messagePart} in the last 30 days.';
      case FilterValue.Year:
        return '${messagePart} in the last 365 days.';
      case FilterValue.Custom:
        final List<String> dateTimeParts =
            statisticsFirestoreX01.customDateFilterRange.split(';');

        if (dateTimeParts[0] == dateTimeParts[1]) {
          return '${messagePart} on ${dateTimeParts[0]}.';
        } else {
          return 'Between the period from ${dateTimeParts[0]} to ${dateTimeParts[1]}, no ${_mode} games were played.';
        }
    }

    return '';
  }

  void _deleteGame(
      Game game, StatisticsFirestoreX01 statisticsFirestoreX01) async {
    await context.read<FirestoreServiceGames>().deleteGame(game, context);

    final Game toDelete = statisticsFirestoreX01.games
        .where(((g) => g.getGameId == game.getGameId))
        .first;
    final FirestoreServicePlayerStats firestoreServicePlayerStats =
        context.read<FirestoreServicePlayerStats>();

    statisticsFirestoreX01.games.remove(toDelete);
    statisticsFirestoreX01.filteredGames.remove(toDelete);
    if (statisticsFirestoreX01.games.isEmpty) {
      statisticsFirestoreX01.noGamesPlayed = true;
    }

    await firestoreServicePlayerStats.getStatistics(context);

    statisticsFirestoreX01.notify();
  }

  @override
  Widget build(BuildContext context) {
    final StatisticsFirestoreX01 statisticsFirestoreX01 =
        context.read<StatisticsFirestoreX01>();
    final List<Game> games =
        statisticsFirestoreX01.currentFilterValue != FilterValue.Overall
            ? statisticsFirestoreX01.filteredGames
            : statisticsFirestoreX01.games;

    return Scaffold(
      appBar: CustomAppBarStatsList(title: '${_mode} Games'),
      body: Consumer<StatisticsFirestoreX01>(
        builder: (_, statisticsFirestore, __) => (statisticsFirestore
                    .showFavouriteGames
                ? statisticsFirestore.favouriteGames.isNotEmpty
                : games.isNotEmpty)
            ? SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Center(
                  child: Container(
                    width: 90.w,
                    padding: EdgeInsets.only(bottom: 20),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            top: 10,
                            left: 5,
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                                'Click card to view the details about a game'),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: 5,
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text('(Swipe left to delete a game)'),
                          ),
                        ),
                        if ((statisticsFirestore.showFavouriteGames
                            ? statisticsFirestore.favouriteGames.isNotEmpty
                            : games.isNotEmpty))
                          statisticsFirestore.sortGames() == null
                              ? SizedBox.shrink()
                              : SizedBox.shrink(),
                        for (Game game in statisticsFirestore.showFavouriteGames
                            ? statisticsFirestore.favouriteGames
                            : games) ...[
                          if (_mode == 'X01') ...[
                            Slidable(
                              key: ValueKey(game.getGameId),
                              child: StatsCardX01(
                                  isFinishScreen: false,
                                  gameX01: GameX01.createGameX01(game),
                                  openGame: false),
                              startActionPane: ActionPane(
                                dismissible:
                                    DismissiblePane(onDismissed: () {}),
                                motion: const ScrollMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (context) async {
                                      _deleteGame(game, statisticsFirestore);
                                    },
                                    backgroundColor: Color(0xFFFE4A49),
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete,
                                    label: 'Delete',
                                  ),
                                ],
                              ),
                            )
                          ]

                          //add cards for other modes (StatsCardCricket)
                        ]
                      ],
                    ),
                  ),
                ),
              )
            : Center(
                child: statisticsFirestore.noGamesPlayed ||
                        statisticsFirestore.favouriteGames.isEmpty
                    ? Text(
                        _getMessage(statisticsFirestore),
                        textAlign: TextAlign.center,
                      )
                    : CircularProgressIndicator(),
              ),
      ),
    );
  }
}
