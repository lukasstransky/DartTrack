import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/models/firestore/stats_firestore_x01_p.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats_x01.dart';
import 'package:dart_app/screens/statistics/local_widgets/stats_per_game_filtered_list/local_widgets/best_leg_stats_card.dart';
import 'package:dart_app/screens/statistics/local_widgets/stats_per_game_filtered_list/local_widgets/checkouts_stats_card.dart';
import 'package:dart_app/screens/statistics/local_widgets/stats_per_game_filtered_list/local_widgets/stats_card_filtered.dart';
import 'package:dart_app/utils/app_bars/custom_app_bar.dart';
import 'package:dart_app/utils/button_styles.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:tuple/tuple.dart';

class StatsPerGameFilteredList extends StatefulWidget {
  static const routeName = '/statsPerGameFilteredList';

  const StatsPerGameFilteredList({Key? key}) : super(key: key);

  @override
  State<StatsPerGameFilteredList> createState() =>
      _StatsPerGameFilteredListState();
}

class _StatsPerGameFilteredListState extends State<StatsPerGameFilteredList> {
  static const String ORDER_FIELD_AVG = 'average';
  static const String ORDER_FIELD_FIRST_NINE_AVG = 'firstNineAvg';
  static const String ORDER_FIELD_CHECKOUT_IN_PERCENT = 'checkoutInPercent';
  static const String ORDER_FIELD_HIGHEST_FINISH = 'highestFinish';
  static const String ORDER_FIELD_WORST_FINISH = 'worstFinish';
  static const String ORDER_FIELD_BEST_LEG = 'bestLeg';
  static const String ORDER_FIELD_WORST_LEG = 'worstLeg';

  String? _type;
  String _orderField = '';
  bool _overallFilter = true;
  bool _ascendingOrder = true;
  bool _showLoadSpinner = false;
  Set<String> _fieldsToShowOverallPerGameBtn = {};

  @override
  didChangeDependencies() {
    super.didChangeDependencies();

    _getSortedPlayerStats();
  }

  _getSortedPlayerStats() async {
    _fieldsToShowOverallPerGameBtn = {
      ORDER_FIELD_HIGHEST_FINISH,
      ORDER_FIELD_BEST_LEG,
      ORDER_FIELD_WORST_FINISH,
      ORDER_FIELD_WORST_LEG
    };

    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    if (arguments.isNotEmpty) {
      _type = arguments.entries.first.value;
    }

    switch (this._type) {
      case BEST_AVG:
        _orderField = ORDER_FIELD_AVG;
        break;
      case WORST_AVG:
        _orderField = ORDER_FIELD_AVG;
        _ascendingOrder = false;
        break;
      case BEST_FIRST_NINE_AVG:
        _orderField = ORDER_FIELD_FIRST_NINE_AVG;
        break;
      case WORST_FIRST_NINE_AVG:
        _orderField = ORDER_FIELD_FIRST_NINE_AVG;
        _ascendingOrder = false;
        break;
      case BEST_CHECKOUT_QUOTE:
        _orderField = ORDER_FIELD_CHECKOUT_IN_PERCENT;
        break;
      case WORST_CHECKOUT_QUOTE:
        _orderField = ORDER_FIELD_CHECKOUT_IN_PERCENT;
        _ascendingOrder = false;
        break;
      case BEST_CHECKOUT_SCORE:
        _orderField = ORDER_FIELD_HIGHEST_FINISH;
        break;
      case WORST_CHECKOUT_SCORE:
        _orderField = ORDER_FIELD_WORST_FINISH;
        _ascendingOrder = false;
        break;
      case BEST_DARTS_PER_LEG:
        _orderField = ORDER_FIELD_BEST_LEG;
        _ascendingOrder = false;
        break;
      case WORST_DARTS_PER_LEG:
        _orderField = ORDER_FIELD_WORST_LEG;
        break;
    }

    _sortAvgFirstNineAndCheckoutPercent();
    _setAndSortCheckoutsOrLegs();
  }

  _sortAvgFirstNineAndCheckoutPercent() {
    final StatsFirestoreX01_P firestoreStats =
        context.read<StatsFirestoreX01_P>();
    List<String> _gamesToNotDisplay = [];

    int compareAscendingDescending(double a, double b) {
      return _ascendingOrder ? b.compareTo(a) : a.compareTo(b);
    }

    double parseStat(String value, String gameId) {
      if (value == '-') {
        _gamesToNotDisplay.add(gameId);
        return 0;
      }
      return double.parse(value);
    }

    parseCheckoutQuote(String value, String gameId) {
      if (value != '-') {
        value = value.substring(0, value.length - 1);
      }
      return parseStat(value, gameId);
    }

    firestoreStats.getUserFilteredPlayerGameStats.sort((a, b) {
      double valueA, valueB;

      switch (_orderField) {
        case ORDER_FIELD_AVG:
          valueA = parseStat(a.getAverage(), a.getGameId);
          valueB = parseStat(b.getAverage(), b.getGameId);
          break;
        case ORDER_FIELD_FIRST_NINE_AVG:
          valueA = parseStat(a.getFirstNinveAvg(), a.getGameId);
          valueB = parseStat(b.getFirstNinveAvg(), b.getGameId);
          break;
        case ORDER_FIELD_CHECKOUT_IN_PERCENT:
          valueA =
              parseCheckoutQuote(a.getCheckoutQuoteInPercent(), a.getGameId);
          valueB =
              parseCheckoutQuote(b.getCheckoutQuoteInPercent(), b.getGameId);
          break;
        case ORDER_FIELD_HIGHEST_FINISH:
          valueA = a.getHighestCheckout().toDouble();
          if (valueA == 0) {
            _gamesToNotDisplay.add(a.getGameId);
          }
          valueB = b.getHighestCheckout().toDouble();
          if (valueB == 0) {
            _gamesToNotDisplay.add(b.getGameId);
          }
          break;
        case ORDER_FIELD_WORST_FINISH:
          valueA = parseStat(a.getWorstCheckout(), a.getGameId);
          valueB = parseStat(b.getWorstCheckout(), b.getGameId);
          break;
        case ORDER_FIELD_BEST_LEG:
          valueA = parseStat(a.getBestLeg(), a.getGameId);
          valueB = parseStat(b.getBestLeg(), b.getGameId);
          break;
        case ORDER_FIELD_WORST_LEG:
          valueA = parseStat(a.getWorstLeg(), a.getGameId);
          valueB = parseStat(b.getWorstLeg(), b.getGameId);
          break;
        default:
          return 0;
      }

      return compareAscendingDescending(valueA, valueB);
    });

    List<Game_P> _sortedGames = [];
    for (PlayerOrTeamGameStatsX01 stats
        in firestoreStats.getUserFilteredPlayerGameStats) {
      if (_gamesToNotDisplay.contains(stats.getGameId)) {
        continue;
      }
      final Game_P game = firestoreStats.games
          .firstWhere((game) => game.getGameId == stats.getGameId);
      _sortedGames.add(game);
    }
    firestoreStats.filteredGames = _sortedGames;
  }

  _setAndSortCheckoutsOrLegs() {
    final Set<String> validOrderFields = {
      ORDER_FIELD_HIGHEST_FINISH,
      ORDER_FIELD_BEST_LEG,
      ORDER_FIELD_WORST_FINISH,
      ORDER_FIELD_WORST_LEG,
    };
    if (!validOrderFields.contains(_orderField)) {
      return;
    }

    final StatsFirestoreX01_P firestoreStats =
        context.read<StatsFirestoreX01_P>();

    firestoreStats.resetOverallStats();
    firestoreStats.getUserFilteredPlayerGameStats.forEach((stats) {
      final String currentGameId = stats.getGameId;

      stats.getCheckouts.values.forEach((int checkout) {
        firestoreStats.checkoutWithGameId
            .add(new Tuple2(checkout, currentGameId));
      });

      stats.getCheckouts.keys.forEach((String legSetString) {
        final int thrownDartsPerLeg = stats.getThrownDartsPerLeg[legSetString];
        firestoreStats.thrownDartsWithGameId
            .add(new Tuple2(thrownDartsPerLeg, currentGameId));
      });
    });

    firestoreStats.sortCheckoutsAndBestLegsStats(_ascendingOrder);
  }

  String getAppBarTitle() {
    final StatsFirestoreX01_P statsFirestoreX01 =
        context.read<StatsFirestoreX01_P>();

    switch (this._type) {
      case BEST_AVG:
        return 'Best averages';
      case WORST_AVG:
        return 'Worst averages';
      case BEST_FIRST_NINE_AVG:
        return 'Best first nine avgs.';
      case WORST_FIRST_NINE_AVG:
        return 'Worst first nine avgs.';
      case BEST_CHECKOUT_QUOTE:
        return 'Best checkout quotes';
      case WORST_CHECKOUT_QUOTE:
        return 'Worst checkout quotes';
      case BEST_CHECKOUT_SCORE:
        return 'Best finishes';
      case WORST_CHECKOUT_SCORE:
        statsFirestoreX01.filteredGames =
            statsFirestoreX01.filteredGames.reversed.toList();
        return 'Worst finishes';
      case BEST_DARTS_PER_LEG:
        return 'Best legs';
      case WORST_DARTS_PER_LEG:
        return 'Worst legs';
    }

    return '';
  }

  bool _showOverallPerGameBtn() {
    return _fieldsToShowOverallPerGameBtn.contains(_orderField);
  }

  @override
  Widget build(BuildContext context) {
    final StatsFirestoreX01_P statsFirestore =
        context.read<StatsFirestoreX01_P>();

    return Scaffold(
      appBar: CustomAppBar(title: getAppBarTitle()),
      body: Selector<StatsFirestoreX01_P, List<Game_P>>(
        selector: (_, statsFirestoreX01) => statsFirestoreX01.filteredGames,
        builder: (_, filteredGames, ___) => _showLoadSpinner
            ? Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
            : SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Center(
                          child: Container(
                            width: 90.w,
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 1.h),
                                  child: _showOverallPerGameBtn()
                                      ? OverallPerGameBtns(context)
                                      : SizedBox.shrink(),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: 1.h,
                                    left: 1.w,
                                    bottom: 1.h,
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
                                if ((_orderField == 'highestFinish' ||
                                        _orderField == 'worstFinish') &&
                                    _overallFilter &&
                                    statsFirestore
                                        .checkoutWithGameId.isNotEmpty) ...[
                                  for (int i = 0;
                                      i <
                                          statsFirestore
                                              .checkoutWithGameId.length;
                                      i++) ...[
                                    CheckoutStatsCard(
                                      finish: statsFirestore.checkoutWithGameId
                                          .elementAt(i)
                                          .item1,
                                      game: GameX01_P.createGame(
                                        statsFirestore.getGameById(
                                            statsFirestore.checkoutWithGameId
                                                .elementAt(i)
                                                .item2),
                                      ),
                                      isWorstFinished:
                                          _orderField == 'worstFinish',
                                    ),
                                  ],
                                ] else if ((_orderField == 'bestLeg' ||
                                        _orderField == 'worstLeg') &&
                                    statsFirestore
                                        .thrownDartsWithGameId.isNotEmpty &&
                                    _overallFilter) ...[
                                  for (int i = 0;
                                      i <
                                          statsFirestore
                                              .thrownDartsWithGameId.length;
                                      i++) ...[
                                    BestLegStatsCard(
                                      bestLeg: statsFirestore
                                          .thrownDartsWithGameId
                                          .elementAt(i)
                                          .item1,
                                      game: GameX01_P.createGame(
                                        statsFirestore.getGameById(
                                            statsFirestore.thrownDartsWithGameId
                                                .elementAt(i)
                                                .item2),
                                      ),
                                      isWorstSelected:
                                          _orderField == 'worstLeg',
                                    ),
                                  ],
                                ] else ...[
                                  for (Game_P game in filteredGames) ...[
                                    StatsCardFiltered(
                                      game: GameX01_P.createGame(game),
                                      orderField: _orderField,
                                    ),
                                  ],
                                ],
                              ],
                            ),
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

  Row OverallPerGameBtns(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 4.h,
            child: ElevatedButton(
              onPressed: () {
                Utils.handleVibrationFeedback(context);
                setState(() {
                  _overallFilter = !_overallFilter;
                });
              },
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  'Overall',
                  style: TextStyle(
                    color: Utils.getTextColorForGameSettingsBtn(
                      _overallFilter,
                      context,
                    ),
                    fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                  ),
                ),
              ),
              style: ButtonStyles.primaryColorBtnStyle(context, _overallFilter)
                  .copyWith(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    side: BorderSide(
                      color: Utils.getPrimaryColorDarken(context),
                      width: GAME_SETTINGS_BTN_BORDER_WITH.w,
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      bottomLeft: Radius.circular(10.0),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: SizedBox(
            height: 4.h,
            child: ElevatedButton(
              onPressed: () {
                Utils.handleVibrationFeedback(context);
                setState(() {
                  _overallFilter = !_overallFilter;
                });
              },
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  'Per game',
                  style: TextStyle(
                    color: Utils.getTextColorForGameSettingsBtn(
                        !_overallFilter, context),
                    fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                  ),
                ),
              ),
              style: ButtonStyles.primaryColorBtnStyle(context, !_overallFilter)
                  .copyWith(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    side: BorderSide(
                      color: Utils.getPrimaryColorDarken(context),
                      width: GAME_SETTINGS_BTN_BORDER_WITH.w,
                    ),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
