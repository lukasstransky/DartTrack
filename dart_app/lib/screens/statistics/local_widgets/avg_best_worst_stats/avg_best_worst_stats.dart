import 'package:dart_app/constants.dart';
import 'package:dart_app/models/firestore/statistics_firestore_x01.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'local_widgets/rounded_chip.dart';

class AvgBestWorstStats extends StatelessWidget {
  const AvgBestWorstStats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color = Utils.getTextColorDarken(context);
    //Color color = Colors.black;
    return Consumer<StatisticsFirestoreX01>(
      builder: (_, statisticsFirestore, __) => Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 20, left: 10, right: 10),
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
                        fontSize: 14.sp,
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
                        fontSize: 14.sp,
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
                        fontSize: 14.sp,
                        color: color,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10, left: 10, right: 10),
            child: Row(
              children: [
                Container(
                  width: 30.w,
                  child: Text(
                    'X01 Avg.',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: color,
                        fontSize: 12.sp),
                  ),
                ),
                Expanded(
                  child: RoundedChip(
                    value: statisticsFirestore.avg > 0
                        ? statisticsFirestore.avg.toStringAsFixed(2)
                        : '-',
                    type: '',
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
            padding: EdgeInsets.only(top: 10, left: 10, right: 10),
            child: Row(
              children: [
                Container(
                  width: 30.w,
                  child: Text(
                    'First Nine Avg.',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: color,
                        fontSize: 12.sp),
                  ),
                ),
                Expanded(
                  child: RoundedChip(
                    value: statisticsFirestore.firstNineAvg > 0
                        ? statisticsFirestore.firstNineAvg.toStringAsFixed(2)
                        : '-',
                    type: '',
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
            padding: EdgeInsets.only(top: 10, left: 10, right: 10),
            child: Row(
              children: [
                Container(
                  width: 30.w,
                  child: Text(
                    'Checkout %',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: color,
                        fontSize: 12.sp),
                  ),
                ),
                Expanded(
                  child: RoundedChip(
                    value: statisticsFirestore.checkoutQuoteAvg != 0
                        ? statisticsFirestore.checkoutQuoteAvg
                            .toStringAsFixed(2)
                        : '-',
                    type: '',
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
            padding: EdgeInsets.only(top: 10, left: 10, right: 10),
            child: Row(
              children: [
                Container(
                  width: 30.w,
                  child: Text(
                    'Checkouts',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: color,
                        fontSize: 12.sp),
                  ),
                ),
                Expanded(
                  child: RoundedChip(
                    value: statisticsFirestore.checkoutScoreAvg != 0
                        ? statisticsFirestore.checkoutScoreAvg
                            .toStringAsFixed(2)
                        : '-',
                    type: '',
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
            padding: EdgeInsets.only(top: 10, left: 10, right: 10),
            child: Row(
              children: [
                Container(
                  width: 30.w,
                  child: Text(
                    'Legs',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: color,
                        fontSize: 12.sp),
                  ),
                ),
                Expanded(
                  child: RoundedChip(
                    value: statisticsFirestore.dartsPerLegAvg != 0
                        ? statisticsFirestore.dartsPerLegAvg.toStringAsFixed(2)
                        : '-',
                    type: '',
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
