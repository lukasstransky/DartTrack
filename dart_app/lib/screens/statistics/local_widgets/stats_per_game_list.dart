import 'package:dart_app/constants.dart';
import 'package:dart_app/models/firestore/stats_firestore_s_t.dart';
import 'package:dart_app/models/firestore/stats_firestore_sc_t.dart';
import 'package:dart_app/models/firestore/stats_firestore_d_t.dart';
import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/models/games/game_score_training_p.dart';
import 'package:dart_app/models/games/game_single_double_training_p.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/models/firestore/stats_firestore_x01_p.dart';
import 'package:dart_app/screens/game_modes/shared/finish/stats_card/stats_card.dart';
import 'package:dart_app/screens/game_modes/x01/finish/local_widgets/stats_card/stats_card_x01.dart';
import 'package:dart_app/services/auth_service.dart';
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
    _getGames();
  }

  _getMode() async {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
            <String, dynamic>{})
        as Map; // extract arguments that are passed into in order to get game mode (X01, Cricket...)
    _mode = arguments.entries.first.value.toString();
  }

  _getGames() async {
    if (_mode == 'X01') {
      return;
    }

    late dynamic statsFirestore;

    if (_mode == 'Single training') {
      statsFirestore = context.read<StatsFirestoreSingleTraining_P>();
    } else if (_mode == 'Double training') {
      statsFirestore = context.read<StatsFirestoreDoubleTraining_P>();
    } else if (_mode == 'Score training') {
      statsFirestore = context.read<StatsFirestoreScoreTraining_P>();
    }

    if (statsFirestore.loadGames) {
      await Future.delayed(Duration(milliseconds: DEFEAULT_DELAY));
      await context.read<FirestoreServiceGames>().getGames(_mode, context);

      statsFirestore.loadGames = false;
    }
  }

  String _getMessage(dynamic statsFirestore, String mode) {
    if (statsFirestore.showFavouriteGames &&
        statsFirestore.favouriteGames.isEmpty) {
      return 'There are currently no games selected as favourite.';
    }

    String tempMode = _mode.toLowerCase();
    final String messagePart = 'No ${tempMode} games have been played';
    if (mode == 'X01') {
      switch (statsFirestore.currentFilterValue) {
        case FilterValue.Overall:
          return 'No ${tempMode} games have been played yet.';
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
    await context.read<FirestoreServiceGames>().deleteGame(game.getGameId,
        context, game.getTeamGameStatistics.length > 0 ? true : false);

    final Game_P toDelete = statsFirestore.games
        .where(((g) => g.getGameId == game.getGameId))
        .first;

    statsFirestore.games.remove(toDelete);
    if (game is GameX01_P) {
      statsFirestore.filteredGames.remove(toDelete);
    }
    if (statsFirestore.games.isEmpty) {
      statsFirestore.noGamesPlayed = true;
    }

    final String username =
        context.read<AuthService>().getUsernameFromSharedPreferences() ?? '';
    await context.read<FirestoreServicePlayerStats>().getX01Statistics(
          context.read<StatsFirestoreX01_P>(),
          username,
        );

    statsFirestore.notify();
  }

  _getCard(Game_P game) {
    if (_mode == 'X01') {
      return StatsCardX01(
        isFinishScreen: false,
        gameX01: GameX01_P.createGame(game),
        isOpenGame: false,
      );
    } else if (_mode == 'Score training') {
      return StatsCard(
        isFinishScreen: false,
        game: GameScoreTraining_P.createGame(game),
        isOpenGame: false,
      );
    } else if (_mode == 'Single training' || _mode == 'Double training') {
      return StatsCard(
        isFinishScreen: false,
        game: GameSingleDoubleTraining_P.createGame(game),
        isOpenGame: false,
      );
    }
  }

  _getWidget(dynamic statsFirestore, List<Game_P> games) {
    if (_mode != 'X01' && statsFirestore.loadGames) {
      return Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      );
    } else if ((statsFirestore.showFavouriteGames &&
            statsFirestore.favouriteGames.isNotEmpty) ||
        (!statsFirestore.showFavouriteGames && games.isNotEmpty)) {
      statsFirestore.sortGames();

      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Container(
            width: 90.w,
            padding: EdgeInsets.only(bottom: 2.h),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: 1.h,
                    left: 1.w,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'To view details about a game, click on its card.',
                      style: TextStyle(color: Colors.white),
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
                          dismissible: DismissiblePane(onDismissed: () {}),
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) async {
                                _deleteGame(game, statsFirestore);
                              },
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
      );
    } else {
      return Center(
        child: Text(
          _getMessage(statsFirestore, _mode),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    late dynamic statsFirestore;

    if (_mode == 'X01') {
      statsFirestore = context.watch<StatsFirestoreX01_P>();
    } else if (_mode == 'Single training') {
      statsFirestore = context.watch<StatsFirestoreSingleTraining_P>();
    } else if (_mode == 'Double training') {
      statsFirestore = context.watch<StatsFirestoreDoubleTraining_P>();
    } else if (_mode == 'Score training') {
      statsFirestore = context.watch<StatsFirestoreScoreTraining_P>();
    }

    List<Game_P> games = statsFirestore.games;
    if (_mode == 'X01' &&
        statsFirestore.currentFilterValue != FilterValue.Overall) {
      games = statsFirestore.filteredGames;
    }

    return Scaffold(
      appBar: CustomAppBarStatsList(
        title: '${_mode} games',
        mode: _mode,
      ),
      body: _getWidget(statsFirestore, games),
    );
  }
}
