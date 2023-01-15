import 'package:dart_app/constants.dart';
import 'package:dart_app/models/firestore/x01/stats_firestore_x01_p.dart';
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
    _setCurrentDate();
  }

  _setCurrentDate() {
    DateTime now = new DateTime.now();
    _customBtnDateRange = DateFormat('dd-MM-yyyy').format(now);
  }

  _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
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

  @override
  Widget build(BuildContext context) {
    final StatsFirestoreX01_P statisticsFirestore =
        context.read<StatsFirestoreX01_P>();

    return Selector<StatsFirestoreX01_P, FilterValue>(
      selector: (_, statisticsFirestore) =>
          statisticsFirestore.currentFilterValue,
      builder: (_, currentFilterValue, __) => Padding(
        padding: EdgeInsets.only(top: 10, left: 10, right: 10),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 4.h,
                    child: ElevatedButton(
                      onPressed: () => {
                        _showDatePicker = false,
                        _showCustomBtnDateRange = false,
                        statisticsFirestore.filterGamesByDate(
                            FilterValue.Overall, context),
                      },
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Overall',
                          style: TextStyle(
                            fontSize: 9.sp,
                            color: Utils.getTextColorForGameSettingsBtn(
                                currentFilterValue == FilterValue.Overall,
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
                              width: GAME_SETTINGS_BTN_BORDER_WITH,
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              bottomLeft: Radius.circular(10.0),
                            ),
                          ),
                        ),
                        backgroundColor: currentFilterValue ==
                                FilterValue.Overall
                            ? Utils.getPrimaryMaterialStateColorDarken(context)
                            : Utils.getColor(
                                Theme.of(context).colorScheme.primary),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 4.h,
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                            color: Utils.getPrimaryColorDarken(context),
                            width: 2),
                        bottom: BorderSide(
                            color: Utils.getPrimaryColorDarken(context),
                            width: 2),
                        right: BorderSide(
                            color: Utils.getPrimaryColorDarken(context),
                            width: 2),
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: () => {
                        _showDatePicker = false,
                        _showCustomBtnDateRange = false,
                        statisticsFirestore.filterGamesByDate(
                            FilterValue.Month, context),
                      },
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Last 30 Days',
                          style: TextStyle(
                            fontSize: 7.sp,
                            color: Utils.getTextColorForGameSettingsBtn(
                                currentFilterValue == FilterValue.Month,
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
                            borderRadius: BorderRadius.all(
                              Radius.zero,
                            ),
                          ),
                        ),
                        backgroundColor: currentFilterValue == FilterValue.Month
                            ? Utils.getPrimaryMaterialStateColorDarken(context)
                            : Utils.getColor(
                                Theme.of(context).colorScheme.primary),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 4.h,
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                            color: Utils.getPrimaryColorDarken(context),
                            width: 2),
                        bottom: BorderSide(
                            color: Utils.getPrimaryColorDarken(context),
                            width: 2),
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: () => {
                        _showDatePicker = false,
                        _showCustomBtnDateRange = false,
                        statisticsFirestore.filterGamesByDate(
                            FilterValue.Year, context),
                      },
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Last 365 Days',
                          style: TextStyle(
                            fontSize: 7.sp,
                            color: Utils.getTextColorForGameSettingsBtn(
                                currentFilterValue == FilterValue.Year,
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
                            borderRadius: BorderRadius.all(
                              Radius.zero,
                            ),
                          ),
                        ),
                        backgroundColor: currentFilterValue == FilterValue.Year
                            ? Utils.getPrimaryMaterialStateColorDarken(context)
                            : Utils.getColor(
                                Theme.of(context).colorScheme.primary),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 4.h,
                    child: ElevatedButton(
                      onPressed: () => {
                        setState(
                          () {
                            _showDatePicker = true;
                            _showCustomBtnDateRange = true;
                            statisticsFirestore.currentFilterValue =
                                FilterValue.Custom;
                          },
                        ),
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
                              width: GAME_SETTINGS_BTN_BORDER_WITH,
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
            if (_showDatePicker == true)
              Theme(
                data: ThemeData(),
                child: SfDateRangePicker(
                  confirmText: 'Ok',
                  cancelText: 'Cancel',
                  todayHighlightColor: Colors.white,
                  rangeSelectionColor:
                      Utils.darken(Theme.of(context).colorScheme.primary, 20),
                  endRangeSelectionColor: Utils.getPrimaryColorDarken(context),
                  startRangeSelectionColor:
                      Utils.getPrimaryColorDarken(context),
                  maxDate: DateTime.now(),
                  onSelectionChanged: _onSelectionChanged,
                  selectionMode: DateRangePickerSelectionMode.range,
                  initialSelectedRange:
                      PickerDateRange(DateTime.now(), DateTime.now()),
                  showActionButtons: true,
                  onSubmit: (p0) async {
                    statisticsFirestore.customDateFilterRange = _range;
                    statisticsFirestore.filterGamesByDate(
                        FilterValue.Custom, context);
                    _showCustomBtnDateRange = true;
                    Future.delayed(const Duration(milliseconds: 300), () {
                      setState(() {
                        _showDatePicker = false;
                      });
                    });
                  },
                  onCancel: () {
                    _showDatePicker = false;
                    _showCustomBtnDateRange = false;
                    statisticsFirestore.filterGamesByDate(
                        FilterValue.Overall, context);
                  },
                  showTodayButton: true,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
