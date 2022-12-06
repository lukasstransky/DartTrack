import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/models/firestore/statistics_firestore_x01.dart';
import 'package:dart_app/screens/game_modes/x01/finish/local_widgets/stats_card/stats_card_x01.dart';
import 'package:dart_app/utils/app_bars/custom_app_bar_stats_list.dart';
import 'package:flutter/material.dart';
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
    switch (statisticsFirestoreX01.currentFilterValue) {
      case FilterValue.Overall:
        return 'have been played yet';
      case FilterValue.Month:
        return 'in the last 30 days';
      case FilterValue.Year:
        return 'in the last 365 days';
      case FilterValue.Custom:
        final List<String> dateTimeParts =
            statisticsFirestoreX01.customDateFilterRange.split(';');

        if (dateTimeParts[0] == dateTimeParts[1]) {
          return 'on ${dateTimeParts[0]}';
        } else {
          return 'from ${dateTimeParts[0]} to ${dateTimeParts[1]}';
        }
    }

    return '';
  }

  @override
  Widget build(BuildContext context) {
    final StatisticsFirestoreX01 statisticsFirestoreX01 =
        context.read<StatisticsFirestoreX01>();
    List<Game> games =
        statisticsFirestoreX01.currentFilterValue != FilterValue.Overall
            ? statisticsFirestoreX01.filteredGames
            : statisticsFirestoreX01.games;

    return Scaffold(
      appBar: CustomAppBarStatsList(title: '${_mode} Games'),
      body: Consumer<StatisticsFirestoreX01>(
        builder: (_, statisticsFirestore, __) => games.isNotEmpty
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
                            child:
                                Text('Click card to view details about a game'),
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
                          if (_mode == 'X01')
                            StatsCardX01(
                                isFinishScreen: false,
                                gameX01: GameX01.createGameX01(game),
                                openGame: false),
                          //add cards for other modes (StatsCardCricket)
                        ]
                      ],
                    ),
                  ),
                ),
              )
            : Center(
                child: statisticsFirestore.noGamesPlayed
                    ? Text(
                        'In the period ${_getMessage(statisticsFirestore)} no ${_mode} games were played!',
                        textAlign: TextAlign.center,
                      )
                    : CircularProgressIndicator(),
              ),
      ),
    );
  }
}
