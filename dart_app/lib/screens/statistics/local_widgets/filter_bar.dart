import 'package:dart_app/constants.dart';
import 'package:dart_app/models/firestore/stats_firestore_x01_p.dart';
import 'package:dart_app/services/firestore/firestore_service_player_stats.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class FilterBar extends StatefulWidget {
  const FilterBar({Key? key}) : super(key: key);

  @override
  State<FilterBar> createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> {
  bool _showDatePicker = false;
  String _range = '';
  String _customBtnDateRange = '';
  bool _showCustomBtnDateRange = false;

  @override
  void initState() {
    super.initState();
    final String customBtnDateRangeTemp =
        context.read<StatsFirestoreX01_P>().customBtnDateRange;
    if (customBtnDateRangeTemp == '') {
      _setCurrentDate();
    } else {
      _customBtnDateRange = customBtnDateRangeTemp;
      _showCustomBtnDateRange = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final StatsFirestoreX01_P statisticsFirestore =
        context.read<StatsFirestoreX01_P>();
    final FirestoreServicePlayerStats firestoreServicePlayerStats =
        context.read<FirestoreServicePlayerStats>();

    return Selector<StatsFirestoreX01_P, FilterValue>(
      selector: (_, statisticsFirestore) =>
          statisticsFirestore.currentFilterValue,
      builder: (_, currentFilterValue, __) => Padding(
        padding: EdgeInsets.only(top: 1.h, left: 2.5.w, right: 2.5.w),
        child: Column(
          children: [
            Row(
              children: [
                OverallFilterBtn(
                  currentFilterValue: currentFilterValue,
                  filterBtnPressed: _filterBtnPressed,
                ),
                MonthFilterBtn(
                  currentFilterValue: currentFilterValue,
                  filterBtnPressed: _filterBtnPressed,
                ),
                YearFilterBtn(
                  currentFilterValue: currentFilterValue,
                  filterBtnPressed: _filterBtnPressed,
                ),
                Expanded(
                  child: Container(
                    height: 4.h,
                    child: ElevatedButton(
                      onPressed: () {
                        Utils.handleVibrationFeedback(context);
                        setState(
                          () {
                            _showDatePicker = true;
                            _showCustomBtnDateRange = true;
                            statisticsFirestore.currentFilterValue =
                                FilterValue.Custom;
                          },
                        );
                      },
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          _showCustomBtnDateRange
                              ? _customBtnDateRange
                              : 'Custom',
                          style: TextStyle(
                            fontSize: 9.sp,
                            color: Utils.getTextColorForGameSettingsBtn(
                                currentFilterValue == FilterValue.Custom,
                                context),
                          ),
                        ),
                      ),
                      style: ButtonStyle(
                        splashFactory: NoSplash.splashFactory,
                        shadowColor:
                            MaterialStateProperty.all(Colors.transparent),
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent),
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
                        backgroundColor: currentFilterValue ==
                                FilterValue.Custom
                            ? Utils.getPrimaryMaterialStateColorDarken(context)
                            : Utils.getColor(
                                Theme.of(context).colorScheme.primary),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (_showDatePicker)
              Theme(
                data: ThemeData(),
                child: SfDateRangePicker(
                  confirmText: 'Select',
                  cancelText: 'Cancel',
                  todayHighlightColor: Colors.white,
                  monthCellStyle: DateRangePickerMonthCellStyle(
                    todayTextStyle: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.white,
                    ),
                  ),
                  yearCellStyle: DateRangePickerYearCellStyle(
                    todayCellDecoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 1),
                        shape: BoxShape.circle),
                    todayTextStyle: const TextStyle(color: Colors.white),
                  ),
                  rangeSelectionColor:
                      Utils.darken(Theme.of(context).colorScheme.primary, 20),
                  endRangeSelectionColor: Utils.getPrimaryColorDarken(context),
                  startRangeSelectionColor:
                      Utils.getPrimaryColorDarken(context),
                  maxDate: DateTime.now(),
                  onSelectionChanged: _onSelectionChanged,
                  selectionMode: DateRangePickerSelectionMode.range,
                  initialSelectedRange: PickerDateRange(
                      statisticsFirestore.getCustomStartDate(),
                      statisticsFirestore.getCustomEndDate(false)),
                  showActionButtons: true,
                  onSubmit: (p0) {
                    statisticsFirestore.customDateFilterRange = _range;
                    statisticsFirestore.customBtnDateRange =
                        _customBtnDateRange;
                    statisticsFirestore.filterGamesAndPlayerOrTeamStatsByDate(
                      FilterValue.Custom,
                      context,
                      statisticsFirestore,
                      firestoreServicePlayerStats,
                    );
                    statisticsFirestore.calculateX01Stats();

                    setState(() {
                      _showCustomBtnDateRange = true;
                      _showDatePicker = false;
                    });

                    statisticsFirestore.notify();
                  },
                  onCancel: () {
                    _showDatePicker = false;
                    _showCustomBtnDateRange = false;
                    _range = '';
                    _setCurrentDate();
                    statisticsFirestore.filterGamesAndPlayerOrTeamStatsByDate(
                      FilterValue.Overall,
                      context,
                      statisticsFirestore,
                      firestoreServicePlayerStats,
                    );
                    statisticsFirestore.customDateFilterRange = '';
                    statisticsFirestore.calculateX01Stats();
                    statisticsFirestore.notify();
                  },
                  showTodayButton: true,
                ),
              ),
          ],
        ),
      ),
    );
  }

  _setCurrentDate() {
    DateTime now = new DateTime.now();
    _customBtnDateRange = DateFormat('dd-MM-yyyy').format(now);
  }

  _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    Utils.handleVibrationFeedback(context);
    setState(() {
      if (args.value is PickerDateRange) {
        _range = '${DateFormat('dd-MM-yyyy').format(args.value.startDate)};'
            '${DateFormat('dd-MM-yyyy').format(args.value.endDate ?? args.value.startDate)}';

        _customBtnDateRange =
            '${DateFormat('dd-MM-yy').format(args.value.startDate)}' +
                '\n' +
                '${DateFormat('dd-MM-yy').format(args.value.endDate ?? args.value.startDate)}';

        final List<String> dateParts = _range.split(';');
        if (dateParts[0] == dateParts[1]) {
          _customBtnDateRange = dateParts[0];
        }
      }
    });
  }

  _filterBtnPressed(FilterValue filterValue) {
    final StatsFirestoreX01_P statisticsFirestore =
        context.read<StatsFirestoreX01_P>();
    final FirestoreServicePlayerStats firestoreServicePlayerStats =
        context.read<FirestoreServicePlayerStats>();

    _setCurrentDate();

    _showDatePicker = false;
    _showCustomBtnDateRange = false;

    statisticsFirestore.customDateFilterRange = '';
    statisticsFirestore.filterGamesAndPlayerOrTeamStatsByDate(
      filterValue,
      context,
      statisticsFirestore,
      firestoreServicePlayerStats,
    );
    statisticsFirestore.calculateX01Stats();
    statisticsFirestore.notify();
  }
}

class OverallFilterBtn extends StatelessWidget {
  const OverallFilterBtn(
      {Key? key,
      required Function(FilterValue) this.filterBtnPressed,
      required FilterValue this.currentFilterValue})
      : super(key: key);

  final Function(FilterValue) filterBtnPressed;
  final FilterValue currentFilterValue;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 4.h,
        child: ElevatedButton(
          onPressed: () {
            Utils.handleVibrationFeedback(context);
            if (currentFilterValue != FilterValue.Overall) {
              filterBtnPressed(FilterValue.Overall);
            }
          },
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'Overall',
              style: TextStyle(
                fontSize: 9.sp,
                color: Utils.getTextColorForGameSettingsBtn(
                    currentFilterValue == FilterValue.Overall, context),
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
            backgroundColor: currentFilterValue == FilterValue.Overall
                ? Utils.getPrimaryMaterialStateColorDarken(context)
                : Utils.getColor(Theme.of(context).colorScheme.primary),
          ),
        ),
      ),
    );
  }
}

class MonthFilterBtn extends StatelessWidget {
  const MonthFilterBtn(
      {Key? key,
      required Function(FilterValue) this.filterBtnPressed,
      required FilterValue this.currentFilterValue})
      : super(key: key);

  final Function(FilterValue) filterBtnPressed;
  final FilterValue currentFilterValue;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 4.h,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Utils.getPrimaryColorDarken(context),
              width: 0.5.w,
            ),
            bottom: BorderSide(
              color: Utils.getPrimaryColorDarken(context),
              width: 0.5.w,
            ),
            right: BorderSide(
              color: Utils.getPrimaryColorDarken(context),
              width: 0.5.w,
            ),
          ),
        ),
        child: ElevatedButton(
          onPressed: () {
            Utils.handleVibrationFeedback(context);
            if (currentFilterValue != FilterValue.Month) {
              filterBtnPressed(FilterValue.Month);
            }
          },
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'Last 30 days',
              style: TextStyle(
                fontSize: 7.sp,
                color: Utils.getTextColorForGameSettingsBtn(
                    currentFilterValue == FilterValue.Month, context),
              ),
            ),
          ),
          style: ButtonStyle(
            splashFactory: NoSplash.splashFactory,
            shadowColor: MaterialStateProperty.all(Colors.transparent),
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.zero,
                ),
              ),
            ),
            backgroundColor: currentFilterValue == FilterValue.Month
                ? Utils.getPrimaryMaterialStateColorDarken(context)
                : Utils.getColor(Theme.of(context).colorScheme.primary),
          ),
        ),
      ),
    );
  }
}

class YearFilterBtn extends StatelessWidget {
  const YearFilterBtn(
      {Key? key,
      required Function(FilterValue) this.filterBtnPressed,
      required FilterValue this.currentFilterValue})
      : super(key: key);

  final Function(FilterValue) filterBtnPressed;
  final FilterValue currentFilterValue;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 4.h,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Utils.getPrimaryColorDarken(context),
              width: 0.5.w,
            ),
            bottom: BorderSide(
              color: Utils.getPrimaryColorDarken(context),
              width: 0.5.w,
            ),
          ),
        ),
        child: ElevatedButton(
          onPressed: () {
            Utils.handleVibrationFeedback(context);
            if (currentFilterValue != FilterValue.Year) {
              filterBtnPressed(FilterValue.Year);
            }
          },
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'Last 365 days',
              style: TextStyle(
                fontSize: 7.sp,
                color: Utils.getTextColorForGameSettingsBtn(
                    currentFilterValue == FilterValue.Year, context),
              ),
            ),
          ),
          style: ButtonStyle(
            splashFactory: NoSplash.splashFactory,
            shadowColor: MaterialStateProperty.all(Colors.transparent),
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.zero,
                ),
              ),
            ),
            backgroundColor: currentFilterValue == FilterValue.Year
                ? Utils.getPrimaryMaterialStateColorDarken(context)
                : Utils.getColor(Theme.of(context).colorScheme.primary),
          ),
        ),
      ),
    );
  }
}
