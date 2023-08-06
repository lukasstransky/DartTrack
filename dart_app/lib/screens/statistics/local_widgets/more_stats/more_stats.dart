import 'package:dart_app/constants.dart';
import 'package:dart_app/models/firestore/stats_firestore_x01_p.dart';
import 'package:dart_app/screens/statistics/local_widgets/more_stats/local_widgets/more_stats_precise_scores.dart';
import 'package:dart_app/screens/statistics/local_widgets/more_stats/local_widgets/more_stats_rounded_scores.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:sizer/sizer.dart';

class MoreStats extends StatefulWidget {
  const MoreStats({Key? key}) : super(key: key);

  @override
  State<MoreStats> createState() => _MoreStatsState();
}

class _MoreStatsState extends State<MoreStats> {
  bool _showAllScoesPerDartWithCount = false;
  bool _roundedScoresOdd = false;

  @override
  Widget build(BuildContext context) {
    late double scaleFactorSwitch;
    if (ResponsiveBreakpoints.of(context).isMobile) {
      scaleFactorSwitch = SWTICH_SCALE_FACTOR_MOBILE;
    } else if (ResponsiveBreakpoints.of(context).isTablet ||
        ResponsiveBreakpoints.of(context).isDesktop) {
      scaleFactorSwitch = SWTICH_SCALE_FACTOR_TABLET;
    } else {
      scaleFactorSwitch = SWTICH_SCALE_FACTOR_TABLET;
    }

    return Selector<StatsFirestoreX01_P, FilterValue>(
      selector: (_, statsFirestoreX01) => statsFirestoreX01.currentFilterValue,
      builder: (_, __, ___) => Padding(
        padding: EdgeInsets.only(top: 2.h),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Center(
                    child: Text(
                      'Rounded scores',
                      style: TextStyle(
                          fontSize: 14.sp,
                          color: Utils.getTextColorDarken(context),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      _showAllScoesPerDartWithCount
                          ? 'All scores per dart'
                          : 'Precise scores',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Utils.getTextColorDarken(context),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: 5.w,
                ),
                MoreStatsRoundedScores(roundedScoresOdd: _roundedScoresOdd),
                SizedBox(
                  width: 25.w,
                ),
                MoreStatsPreciseScores(
                    showAllScoesPerDartWithCount:
                        _showAllScoesPerDartWithCount),
                SizedBox(
                  width: 10.w,
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.only(
                left: 5.w,
                top: 2.h,
              ),
              child: Row(
                children: [
                  Text(
                    'Show odd rounded scores',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11.sp,
                    ),
                  ),
                  Transform.scale(
                    scale: scaleFactorSwitch,
                    child: Switch(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      thumbColor: MaterialStateProperty.all(
                          Theme.of(context).colorScheme.secondary),
                      activeColor: Theme.of(context).colorScheme.secondary,
                      inactiveThumbColor:
                          Theme.of(context).colorScheme.secondary,
                      value: _roundedScoresOdd,
                      onChanged: (value) {
                        Utils.handleVibrationFeedback(context);
                        setState(() {
                          _roundedScoresOdd = !_roundedScoresOdd;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 5.w),
              child: Row(
                children: [
                  Text(
                    'Show all scores per dart',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11.sp,
                    ),
                  ),
                  Transform.scale(
                    scale: scaleFactorSwitch,
                    child: Switch(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      thumbColor: MaterialStateProperty.all(
                          Theme.of(context).colorScheme.secondary),
                      activeColor: Theme.of(context).colorScheme.secondary,
                      inactiveThumbColor:
                          Theme.of(context).colorScheme.secondary,
                      value: _showAllScoesPerDartWithCount,
                      onChanged: (value) {
                        Utils.handleVibrationFeedback(context);
                        setState(() {
                          _showAllScoesPerDartWithCount =
                              !_showAllScoesPerDartWithCount;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
