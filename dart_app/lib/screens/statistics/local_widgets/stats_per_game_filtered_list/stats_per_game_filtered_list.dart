import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/models/firestore/stats_firestore_x01_p.dart';
import 'package:dart_app/screens/statistics/local_widgets/stats_per_game_filtered_list/local_widgets/best_leg_stats_card.dart';
import 'package:dart_app/screens/statistics/local_widgets/stats_per_game_filtered_list/local_widgets/checkouts_stats_card.dart';
import 'package:dart_app/screens/statistics/local_widgets/stats_per_game_filtered_list/local_widgets/stats_card_filtered.dart';
import 'package:dart_app/services/firestore/firestore_service_player_stats.dart';
import 'package:dart_app/utils/app_bars/custom_app_bar.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class StatsPerGameFilteredList extends StatefulWidget {
  static const routeName = '/statsPerGameFilteredList';

  const StatsPerGameFilteredList({Key? key}) : super(key: key);

  @override
  State<StatsPerGameFilteredList> createState() =>
      _StatsPerGameFilteredListState();
}

class _StatsPerGameFilteredListState extends State<StatsPerGameFilteredList> {
  String? _type;
  String _orderField = '';
  bool _overallFilter = true;
  bool _ascendingOrder = true;

  @override
  didChangeDependencies() {
    super.didChangeDependencies();

    _getSortedPlayerStats();
  }

  _getSortedPlayerStats() async {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    if (arguments.isNotEmpty) {
      _type = arguments.entries.first.value;
    }

    switch (this._type) {
      case BEST_AVG:
        _orderField = 'average';
        break;
      case WORST_AVG:
        _orderField = 'average';
        _ascendingOrder = false;
        break;
      case BEST_FIRST_NINE_AVG:
        _orderField = 'firstNineAvg';
        break;
      case WORST_FIRST_NINE_AVG:
        _orderField = 'firstNineAvg';
        _ascendingOrder = false;
        break;
      case BEST_CHECKOUT_QUOTE:
        _orderField = 'checkoutInPercent';
        break;
      case WORST_CHECKOUT_QUOTE:
        _orderField = 'checkoutInPercent';
        _ascendingOrder = false;
        break;
      case BEST_CHECKOUT_SCORE:
        _orderField = 'highestFinish';
        break;
      case WORST_CHECKOUT_SCORE:
        _orderField = 'highestFinish';
        _ascendingOrder = false;
        break;
      case BEST_DARTS_PER_LEG:
        _orderField = 'bestLeg';
        _ascendingOrder = false;
        break;
      case WORST_DARTS_PER_LEG:
        _orderField = 'bestLeg';
        break;
    }

    await context
        .read<FirestoreServicePlayerStats>()
        .getFilteredPlayerGameStatistics(_orderField, _ascendingOrder, context);
  }

  String getAppBarTitle() {
    switch (this._type) {
      case BEST_AVG:
        return 'Best Averages';
      case WORST_AVG:
        return 'Worst Averages';
      case BEST_FIRST_NINE_AVG:
        return 'Best First 9 Averages';
      case WORST_FIRST_NINE_AVG:
        return 'Worst First 9 Averages';
      case BEST_CHECKOUT_QUOTE:
        return 'Best Checkout Quotes';
      case WORST_CHECKOUT_QUOTE:
        return 'Worst Checkout Quotes';
      case BEST_CHECKOUT_SCORE:
        return 'Best Finishes';
      case WORST_CHECKOUT_SCORE:
        return 'Worst Finishes';
      case BEST_DARTS_PER_LEG:
        return 'Best Legs';
      case WORST_DARTS_PER_LEG:
        return 'Worst Legs';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: getAppBarTitle()),
      body: Consumer<StatsFirestoreX01_P>(
        builder: (_, statisticsFirestore, __) => SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: Container(
              width: 90.w,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: _orderField == 'highestFinish' ||
                            _orderField == 'bestLeg'
                        ? Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 4.h,
                                  child: ElevatedButton(
                                    onPressed: () => {
                                      setState(() {
                                        _overallFilter = !_overallFilter;
                                      }),
                                    },
                                    child: FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Text(
                                        'Overall',
                                        style: TextStyle(
                                          color: Utils
                                              .getTextColorForGameSettingsBtn(
                                                  _overallFilter, context),
                                        ),
                                      ),
                                    ),
                                    style: ButtonStyle(
                                      splashFactory: NoSplash.splashFactory,
                                      shadowColor: MaterialStateProperty.all(
                                          Colors.transparent),
                                      overlayColor: MaterialStateProperty.all(
                                          Colors.transparent),
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                          side: BorderSide(
                                            color: Utils.getPrimaryColorDarken(
                                                context),
                                            width:
                                                GAME_SETTINGS_BTN_BORDER_WITH,
                                          ),
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(10.0),
                                            bottomLeft: Radius.circular(10.0),
                                          ),
                                        ),
                                      ),
                                      backgroundColor: _overallFilter
                                          ? Utils
                                              .getPrimaryMaterialStateColorDarken(
                                                  context)
                                          : Utils.getColor(Theme.of(context)
                                              .colorScheme
                                              .primary),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: SizedBox(
                                  height: 4.h,
                                  child: ElevatedButton(
                                    onPressed: () => {
                                      setState(() {
                                        _overallFilter = !_overallFilter;
                                      }),
                                    },
                                    child: FittedBox(
                                      fit: BoxFit.fitWidth,
                                      child: Text(
                                        'per Game',
                                        style: TextStyle(
                                          color: Utils
                                              .getTextColorForGameSettingsBtn(
                                                  !_overallFilter, context),
                                        ),
                                      ),
                                    ),
                                    style: ButtonStyle(
                                      splashFactory: NoSplash.splashFactory,
                                      shadowColor: MaterialStateProperty.all(
                                          Colors.transparent),
                                      overlayColor: MaterialStateProperty.all(
                                          Colors.transparent),
                                      shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                          side: BorderSide(
                                            color: Utils.getPrimaryColorDarken(
                                                context),
                                            width:
                                                GAME_SETTINGS_BTN_BORDER_WITH,
                                          ),
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(10.0),
                                            bottomRight: Radius.circular(10.0),
                                          ),
                                        ),
                                      ),
                                      backgroundColor: !_overallFilter
                                          ? Utils
                                              .getPrimaryMaterialStateColorDarken(
                                                  context)
                                          : Utils.getColor(Theme.of(context)
                                              .colorScheme
                                              .primary),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : SizedBox.shrink(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 10,
                      left: 5,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Click card to view the details about a game',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  if (_orderField == 'highestFinish' &&
                      _overallFilter &&
                      statisticsFirestore.checkoutWithGameId.isNotEmpty) ...[
                    for (int i = 0;
                        i < statisticsFirestore.checkoutWithGameId.length;
                        i++) ...[
                      CheckoutStatsCard(
                        finish: statisticsFirestore.checkoutWithGameId
                            .elementAt(i)
                            .item1,
                        game: GameX01_P.createGame(statisticsFirestore
                            .getGameById(statisticsFirestore.checkoutWithGameId
                                .elementAt(i)
                                .item2)),
                      ),
                    ],
                  ] else if (_orderField == 'bestLeg' &&
                      statisticsFirestore.thrownDartsWithGameId.isNotEmpty &&
                      _overallFilter) ...[
                    for (int i = 0;
                        i < statisticsFirestore.thrownDartsWithGameId.length;
                        i++) ...[
                      BestLegStatsCard(
                        bestLeg: statisticsFirestore.thrownDartsWithGameId
                            .elementAt(i)
                            .item1,
                        game: GameX01_P.createGame(
                          statisticsFirestore.getGameById(statisticsFirestore
                              .thrownDartsWithGameId
                              .elementAt(i)
                              .item2),
                        ),
                      ),
                    ],
                  ] else ...[
                    for (Game_P game in statisticsFirestore.filteredGames) ...[
                      StatsCardFiltered(
                          game: GameX01_P.createGame(game),
                          orderField: _orderField),
                    ],
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
