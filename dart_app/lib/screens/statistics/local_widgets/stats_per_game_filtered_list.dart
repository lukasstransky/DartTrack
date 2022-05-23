import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/models/player_statistics/player_game_statistics_x01.dart';
import 'package:dart_app/models/statistics_firestore_x01.dart';
import 'package:dart_app/screens/statistics/local_widgets/best_leg_stats_card.dart';
import 'package:dart_app/screens/statistics/local_widgets/checkouts_stats_card.dart';
import 'package:dart_app/screens/statistics/local_widgets/stats_card_filtered.dart';
import 'package:dart_app/services/firestore_service.dart';
import 'package:dart_app/utils/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class StatsPerGameFilteredList extends StatefulWidget {
  static const routeName = "/statsPerGameFilteredList";

  const StatsPerGameFilteredList({Key? key}) : super(key: key);

  @override
  State<StatsPerGameFilteredList> createState() =>
      _StatsPerGameFilteredListState();
}

class _StatsPerGameFilteredListState extends State<StatsPerGameFilteredList> {
  String? _type;
  String _orderField = "";
  bool _overallFilter = true;
  bool _ascendingOrder = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    getGames();
  }

  getGames() async {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    if (arguments.isNotEmpty) {
      _type = arguments.entries.first.value;
    }

    switch (this._type) {
      case BEST_AVG:
        _orderField = "average";
        break;
      case WORST_AVG:
        _orderField = "average";
        _ascendingOrder = false;
        break;
      case BEST_FIRST_NINE_AVG:
        _orderField = "firstNineAverage";
        break;
      case WORST_FIRST_NINE_AVG:
        _orderField = "firstNineAverage";
        _ascendingOrder = false;
        break;
      case BEST_CHECKOUT_QUOTE:
        _orderField = "checkoutInPercent";
        break;
      case WORST_CHECKOUT_QUOTE:
        _orderField = "checkoutInPercent";
        _ascendingOrder = false;
        break;
      case BEST_CHECKOUT_SCORE:
        _orderField = "highestFinish";
        break;
      case WORST_CHECKOUT_SCORE:
        _orderField = "highestFinish";
        _ascendingOrder = false;
        break;
      case BEST_DARTS_PER_LEG:
        _orderField = "bestLeg";
        _ascendingOrder = false;
        break;
      case WORST_DARTS_PER_LEG:
        _orderField = "bestLeg";

        break;
    }

    await context
        .read<FirestoreService>()
        .getFilteredPlayerGameStatistics(_orderField, _ascendingOrder, context);
  }

  String getAppBarTitle() {
    switch (this._type) {
      case BEST_AVG:
        return "Best Averages";
      case WORST_AVG:
        return "Worst Averages";
      case BEST_FIRST_NINE_AVG:
        return "Best First 9 Averages";
      case WORST_FIRST_NINE_AVG:
        return "Worst First 9 Averages";
      case BEST_CHECKOUT_QUOTE:
        return "Best Checkout Quotes";
      case WORST_CHECKOUT_QUOTE:
        return "Worst Checkout Quotes";
      case BEST_CHECKOUT_SCORE:
        return "Best Finishes";
      case WORST_CHECKOUT_SCORE:
        return "Worst Finishes";
      case BEST_DARTS_PER_LEG:
        return "Best Legs";
      case WORST_DARTS_PER_LEG:
        return "Worst Legs";
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(true, this.getAppBarTitle()),
      body: Consumer<StatisticsFirestoreX01>(
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
                                            child: const Text("Overall"),
                                          ),
                                          style: ButtonStyle(
                                            shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                  topLeft:
                                                      Radius.circular(10.0),
                                                  bottomLeft:
                                                      Radius.circular(10.0),
                                                ),
                                              ),
                                            ),
                                            backgroundColor: _overallFilter
                                                ? MaterialStateProperty.all(
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .primary)
                                                : MaterialStateProperty.all<
                                                    Color>(Colors.grey),
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
                                            child: const Text("per Game"),
                                          ),
                                          style: ButtonStyle(
                                            shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                  topRight:
                                                      Radius.circular(10.0),
                                                  bottomRight:
                                                      Radius.circular(10.0),
                                                ),
                                              ),
                                            ),
                                            backgroundColor: !_overallFilter
                                                ? MaterialStateProperty.all(
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .primary)
                                                : MaterialStateProperty.all<
                                                    Color>(Colors.grey),
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
                                  "(Click Card to view Details about a Game)")),
                        ),
                        if (_orderField == 'highestFinish' &&
                            _overallFilter &&
                            statisticsFirestore
                                .checkoutWithGameId.isNotEmpty) ...[
                          for (int i = 0;
                              i < statisticsFirestore.checkoutWithGameId.length;
                              i++) ...[
                            CheckoutStatsCard(
                              finish: statisticsFirestore.checkoutWithGameId
                                  .elementAt(i)
                                  .item1,
                              game: statisticsFirestore.getGameById(
                                  statisticsFirestore.checkoutWithGameId
                                      .elementAt(i)
                                      .item2) as Game,
                            ),
                          ],
                        ] else if (_orderField == 'bestLeg' &&
                            statisticsFirestore
                                .thrownDartsWithGameId.isNotEmpty &&
                            _overallFilter) ...[
                          for (int i = 0;
                              i <
                                  statisticsFirestore
                                      .thrownDartsWithGameId.length;
                              i++) ...[
                            BestLegStatsCard(
                              bestLeg: statisticsFirestore.thrownDartsWithGameId
                                  .elementAt(i)
                                  .item1,
                              game: statisticsFirestore.getGameById(
                                  statisticsFirestore.thrownDartsWithGameId
                                      .elementAt(i)
                                      .item2) as Game,
                            ),
                          ],
                        ] else ...[
                          for (Game game in statisticsFirestore.games) ...[
                            StatsCardFiltered(
                                game: game, orderField: _orderField),
                          ],
                        ]
                      ],
                    ),
                  ),
                ),
              )),
    );
  }
}
