import 'package:dart_app/constants.dart';
import 'package:dart_app/models/statistics_firestore_x01.dart';
import 'package:dart_app/services/firestore_service.dart';
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
  String _range = "";
  String _customBtnDateRange = "";
  bool _showCustomBtnDateRange = false;

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        _range = '${DateFormat('dd-MM-yyyy').format(args.value.startDate)};'
            '${DateFormat('dd-MM-yyyy').format(args.value.endDate ?? args.value.startDate)}';
        _customBtnDateRange =
            '${DateFormat('dd-MM-yy').format(args.value.startDate)}' +
                "\n" +
                '${DateFormat('dd-MM-yy').format(args.value.endDate ?? args.value.startDate)}';
      }
    });
  }

  @override
  void initState() {
    context.read<FirestoreService>().getStatistics(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final statisticsFirestore =
        Provider.of<StatisticsFirestoreX01>(context, listen: false);

    return Selector<StatisticsFirestoreX01, FilterValue>(
      selector: (_, statisticsFirestore) =>
          statisticsFirestore.currentFilterValue,
      builder: (_, currentFilterValue, __) => Padding(
        padding: EdgeInsets.only(top: 10, left: 10, right: 10),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => {
                      _showDatePicker = false,
                      _showCustomBtnDateRange = false,
                      statisticsFirestore.loadStatistics(
                          context, FilterValue.Overall),
                    },
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: const Text("Overall"),
                    ),
                    style: ButtonStyle(
                      shadowColor:
                          MaterialStateProperty.all(Colors.transparent),
                      overlayColor: Utils.getColor(
                        Theme.of(context).colorScheme.primary,
                        Utils.darken(Theme.of(context).colorScheme.primary, 15),
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            bottomLeft: Radius.circular(10.0),
                          ),
                        ),
                      ),
                      backgroundColor: currentFilterValue == FilterValue.Overall
                          ? MaterialStateProperty.all(
                              Theme.of(context).colorScheme.primary)
                          : MaterialStateProperty.all<Color>(Colors.grey),
                    ),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => {
                      _showDatePicker = false,
                      _showCustomBtnDateRange = false,
                      statisticsFirestore.loadStatistics(
                          context, FilterValue.Month),
                    },
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: const Text("Last Month"),
                    ),
                    style: ButtonStyle(
                      shadowColor:
                          MaterialStateProperty.all(Colors.transparent),
                      overlayColor: Utils.getColor(
                        Theme.of(context).colorScheme.primary,
                        Utils.darken(Theme.of(context).colorScheme.primary, 15),
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.zero,
                          ),
                        ),
                      ),
                      backgroundColor: currentFilterValue == FilterValue.Month
                          ? MaterialStateProperty.all(
                              Theme.of(context).colorScheme.primary)
                          : MaterialStateProperty.all<Color>(Colors.grey),
                    ),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => {
                      _showDatePicker = false,
                      _showCustomBtnDateRange = false,
                      statisticsFirestore.loadStatistics(
                          context, FilterValue.Year),
                    },
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: const Text("Last Year"),
                    ),
                    style: ButtonStyle(
                      shadowColor:
                          MaterialStateProperty.all(Colors.transparent),
                      overlayColor: Utils.getColor(
                        Theme.of(context).colorScheme.primary,
                        Utils.darken(Theme.of(context).colorScheme.primary, 15),
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.zero,
                          ),
                        ),
                      ),
                      backgroundColor: currentFilterValue == FilterValue.Year
                          ? MaterialStateProperty.all(
                              Theme.of(context).colorScheme.primary)
                          : MaterialStateProperty.all<Color>(Colors.grey),
                    ),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => {
                      setState(
                        () {
                          _showDatePicker = true;
                          statisticsFirestore.currentFilterValue =
                              FilterValue.Custom;
                        },
                      ),
                    },
                    child: FittedBox(
                      fit: BoxFit.fitHeight,
                      child: Padding(
                        padding: _customBtnDateRange != ""
                            ? EdgeInsets.all(5)
                            : EdgeInsets.all(0),
                        child: Text(_showCustomBtnDateRange
                            ? _customBtnDateRange
                            : "Custom"),
                      ),
                    ),
                    style: ButtonStyle(
                      shadowColor:
                          MaterialStateProperty.all(Colors.transparent),
                      overlayColor: Utils.getColor(
                        Theme.of(context).colorScheme.primary,
                        Utils.darken(Theme.of(context).colorScheme.primary, 15),
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                          ),
                        ),
                      ),
                      backgroundColor: currentFilterValue == FilterValue.Custom
                          ? MaterialStateProperty.all(
                              Theme.of(context).colorScheme.primary)
                          : MaterialStateProperty.all<Color>(Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
            if (_showDatePicker == true)
              SfDateRangePicker(
                onSelectionChanged: _onSelectionChanged,
                selectionMode: DateRangePickerSelectionMode.range,
                initialSelectedRange:
                    PickerDateRange(DateTime.now(), DateTime.now()),
                showActionButtons: true,
                onSubmit: (p0) {
                  statisticsFirestore.customDateFilterRange = _range;
                  _showDatePicker = false;
                  _showCustomBtnDateRange = true;
                  statisticsFirestore.loadStatistics(
                      context, FilterValue.Custom);
                },
                onCancel: () {
                  _showDatePicker = false;
                  statisticsFirestore.loadStatistics(
                      context, FilterValue.Overall);
                },
                showTodayButton: true,
              ),
          ],
        ),
      ),
    );
  }
}
