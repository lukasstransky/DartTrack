import 'package:dart_app/constants.dart';
import 'package:dart_app/models/firestore/stats_firestore_x01_p.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'local_widgets/rounded_chip.dart';

class AvgBestWorstStats extends StatelessWidget {
  const AvgBestWorstStats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color color = Utils.getTextColorDarken(context);
    final _padding = EdgeInsets.only(top: 1.h, left: 2.5.w, right: 2.5.w);
    final StatsFirestoreX01_P statisticsFirestore =
        context.read<StatsFirestoreX01_P>();

    return Selector<StatsFirestoreX01_P, FilterValue>(
      selector: (_, statsFirestoreX01) => statsFirestoreX01.currentFilterValue,
      builder: (_, __, ___) => Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 2.h, left: 2.5.w, right: 2.5.w),
            child: Row(
              children: [
                Container(
                  width: 30.w,
                  child: Text(''),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'Avg.',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize:
                            Theme.of(context).textTheme.titleSmall!.fontSize,
                        color: color,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'Best',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize:
                            Theme.of(context).textTheme.titleSmall!.fontSize,
                        color: color,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'Worst',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize:
                            Theme.of(context).textTheme.titleSmall!.fontSize,
                        color: color,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: _padding,
            child: Row(
              children: [
                Container(
                  width: 30.w,
                  child: Text(
                    'X01 avg.',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: color,
                      fontSize:
                          Theme.of(context).textTheme.bodyMedium!.fontSize,
                    ),
                  ),
                ),
                Expanded(
                  child: RoundedChip(
                    value: statisticsFirestore.avg > 0
                        ? statisticsFirestore.avg.toStringAsFixed(2)
                        : '-',
                    type: '',
                    darkenBackground: true,
                  ),
                ),
                Expanded(
                  child: RoundedChip(
                    value: statisticsFirestore.bestAvg != -1
                        ? statisticsFirestore.bestAvg.toStringAsFixed(2)
                        : '-',
                    type: BEST_AVG,
                  ),
                ),
                Expanded(
                  child: RoundedChip(
                    value: statisticsFirestore.worstAvg != -1
                        ? statisticsFirestore.worstAvg.toStringAsFixed(2)
                        : '-',
                    type: WORST_AVG,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: _padding,
            child: Row(
              children: [
                Container(
                  width: 30.w,
                  child: Text(
                    'First nine avg.',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: color,
                      fontSize:
                          Theme.of(context).textTheme.bodyMedium!.fontSize,
                    ),
                  ),
                ),
                Expanded(
                  child: RoundedChip(
                    value: statisticsFirestore.firstNineAvg > 0
                        ? statisticsFirestore.firstNineAvg.toStringAsFixed(2)
                        : '-',
                    type: '',
                    darkenBackground: true,
                  ),
                ),
                Expanded(
                  child: RoundedChip(
                    value: statisticsFirestore.bestFirstNineAvg != -1
                        ? statisticsFirestore.bestFirstNineAvg
                            .toStringAsFixed(2)
                        : '-',
                    type: BEST_FIRST_NINE_AVG,
                  ),
                ),
                Expanded(
                  child: RoundedChip(
                    value: statisticsFirestore.worstFirstNineAvg != -1
                        ? statisticsFirestore.worstFirstNineAvg
                            .toStringAsFixed(2)
                        : '-',
                    type: WORST_FIRST_NINE_AVG,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: _padding,
            child: Row(
              children: [
                Container(
                  width: 30.w,
                  child: Text(
                    'Checkout %',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: color,
                      fontSize:
                          Theme.of(context).textTheme.bodyMedium!.fontSize,
                    ),
                  ),
                ),
                Expanded(
                  child: RoundedChip(
                    value: statisticsFirestore.checkoutQuoteAvg != 0
                        ? statisticsFirestore.checkoutQuoteAvg
                            .toStringAsFixed(2)
                        : '-',
                    type: '',
                    darkenBackground: true,
                  ),
                ),
                Expanded(
                  child: RoundedChip(
                    value: statisticsFirestore.bestCheckoutQuote != -1
                        ? statisticsFirestore.bestCheckoutQuote
                            .toStringAsFixed(2)
                        : '-',
                    type: BEST_CHECKOUT_QUOTE,
                  ),
                ),
                Expanded(
                  child: RoundedChip(
                    value: statisticsFirestore.worstCheckoutQuote != -1
                        ? statisticsFirestore.worstCheckoutQuote
                            .toStringAsFixed(2)
                        : '-',
                    type: WORST_CHECKOUT_QUOTE,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: _padding,
            child: Row(
              children: [
                Container(
                  width: 30.w,
                  child: Text(
                    'Checkouts',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: color,
                      fontSize:
                          Theme.of(context).textTheme.bodyMedium!.fontSize,
                    ),
                  ),
                ),
                Expanded(
                  child: RoundedChip(
                    value: statisticsFirestore.checkoutScoreAvg != 0
                        ? statisticsFirestore.checkoutScoreAvg
                            .toStringAsFixed(2)
                        : '-',
                    type: '',
                    darkenBackground: true,
                  ),
                ),
                Expanded(
                  child: RoundedChip(
                    value: statisticsFirestore.bestCheckoutScore != -1
                        ? statisticsFirestore.bestCheckoutScore.toString()
                        : '-',
                    type: BEST_CHECKOUT_SCORE,
                  ),
                ),
                Expanded(
                  child: RoundedChip(
                    value: statisticsFirestore.worstCheckoutScore != -1
                        ? statisticsFirestore.worstCheckoutScore.toString()
                        : '-',
                    type: WORST_CHECKOUT_SCORE,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: _padding,
            child: Row(
              children: [
                Container(
                  width: 30.w,
                  child: Text(
                    'Legs',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: color,
                      fontSize:
                          Theme.of(context).textTheme.bodyMedium!.fontSize,
                    ),
                  ),
                ),
                Expanded(
                  child: RoundedChip(
                    value: statisticsFirestore.dartsPerLegAvg != 0
                        ? statisticsFirestore.dartsPerLegAvg.toStringAsFixed(2)
                        : '-',
                    type: '',
                    darkenBackground: true,
                  ),
                ),
                Expanded(
                  child: RoundedChip(
                    value: statisticsFirestore.bestLeg != -1
                        ? statisticsFirestore.bestLeg.toString()
                        : '-',
                    type: BEST_DARTS_PER_LEG,
                  ),
                ),
                Expanded(
                  child: RoundedChip(
                    value: statisticsFirestore.worstLeg != -1
                        ? statisticsFirestore.worstLeg.toString()
                        : '-',
                    type: WORST_DARTS_PER_LEG,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
