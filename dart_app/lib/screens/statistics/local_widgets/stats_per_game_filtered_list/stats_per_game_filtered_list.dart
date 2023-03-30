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
  static const Set<String> _fieldsToShowOverallPerGameBtn = {
    'highestFinish',
    'bestLeg',
    'worstFinish',
    'worstLeg'
  };

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
        _orderField = 'worstFinish';
        _ascendingOrder = false;
        break;
      case BEST_DARTS_PER_LEG:
        _orderField = 'bestLeg';
        _ascendingOrder = false;
        break;
      case WORST_DARTS_PER_LEG:
        _orderField = 'worstLeg';
        break;
    }

    await context
        .read<FirestoreServicePlayerStats>()
        .getFilteredPlayerGameStatistics(_orderField, _ascendingOrder, context);
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
        return 'Best first nine averages';
      case WORST_FIRST_NINE_AVG:
        return 'Worst first nine averages';
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
    final StatsFirestoreX01_P statisticsFirestore =
        context.read<StatsFirestoreX01_P>();

    return Scaffold(
      appBar: CustomAppBar(title: getAppBarTitle()),
      body: Selector<StatsFirestoreX01_P, List<Game_P>>(
        selector: (_, statsFirestoreX01) => statsFirestoreX01.filteredGames,
        builder: (_, filteredGames, ___) => SingleChildScrollView(
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
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'To view details about a game, click on its card.',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  if ((_orderField == 'highestFinish' ||
                          _orderField == 'worstFinish') &&
                      _overallFilter &&
                      statisticsFirestore.checkoutWithGameId.isNotEmpty) ...[
                    for (int i = 0;
                        i < statisticsFirestore.checkoutWithGameId.length;
                        i++) ...[
                      CheckoutStatsCard(
                        finish: statisticsFirestore.checkoutWithGameId
                            .elementAt(i)
                            .item1,
                        game: GameX01_P.createGame(
                          statisticsFirestore.getGameById(statisticsFirestore
                              .checkoutWithGameId
                              .elementAt(i)
                              .item2),
                        ),
                        isWorstFinished: _orderField == 'worstFinish',
                      ),
                    ],
                  ] else if ((_orderField == 'bestLeg' ||
                          _orderField == 'worstLeg') &&
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
                        isWorstSelected: _orderField == 'worstLeg',
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
    );
  }

  Row OverallPerGameBtns(BuildContext context) {
    return Row(
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
                    color: Utils.getTextColorForGameSettingsBtn(
                        _overallFilter, context),
                  ),
                ),
              ),
              style: ButtonStyle(
                splashFactory: NoSplash.splashFactory,
                shadowColor: MaterialStateProperty.all(Colors.transparent),
                overlayColor: MaterialStateProperty.all(Colors.transparent),
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
                backgroundColor: _overallFilter
                    ? Utils.getPrimaryMaterialStateColorDarken(context)
                    : Utils.getColor(Theme.of(context).colorScheme.primary),
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
                  'Per game',
                  style: TextStyle(
                    color: Utils.getTextColorForGameSettingsBtn(
                        !_overallFilter, context),
                  ),
                ),
              ),
              style: ButtonStyle(
                splashFactory: NoSplash.splashFactory,
                shadowColor: MaterialStateProperty.all(Colors.transparent),
                overlayColor: MaterialStateProperty.all(Colors.transparent),
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
                backgroundColor: !_overallFilter
                    ? Utils.getPrimaryMaterialStateColorDarken(context)
                    : Utils.getColor(Theme.of(context).colorScheme.primary),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
