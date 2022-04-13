import 'package:dart_app/constants.dart';
import 'package:dart_app/models/statistics_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class FilterBar extends StatefulWidget {
  const FilterBar({Key? key, required this.notifyParent}) : super(key: key);

  final Function() notifyParent;

  @override
  State<FilterBar> createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> {
  bool _showDatePicker = false;
  String _range = "";

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is PickerDateRange) {
        _range = '${DateFormat('dd-MM-yyyy').format(args.value.startDate)};'
            '${DateFormat('dd-MM-yyyy').format(args.value.endDate ?? args.value.startDate)}';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final statisticsFirestore =
        Provider.of<StatisticsFirestore>(context, listen: false);

    return Selector<StatisticsFirestore, FilterValue>(
      selector: (_, statisticsFirestore) =>
          statisticsFirestore.currentFilterValue,
      builder: (_, currentFilterValue, __) => Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => {
                    statisticsFirestore
                        .changeCurrentFilterValue(FilterValue.Overall),
                    widget.notifyParent(),
                  },
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: const Text("Overall"),
                  ),
                  style: ButtonStyle(
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
                    statisticsFirestore
                        .changeCurrentFilterValue(FilterValue.Month),
                    widget.notifyParent(),
                  },
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: const Text("Last Month"),
                  ),
                  style: ButtonStyle(
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
                    statisticsFirestore
                        .changeCurrentFilterValue(FilterValue.Year),
                    widget.notifyParent(),
                  },
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: const Text("Last Year"),
                  ),
                  style: ButtonStyle(
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
                      },
                    ),
                  },
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: const Text("Custom"),
                  ),
                  style: ButtonStyle(
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
                statisticsFirestore
                    .changeCurrentFilterValue(FilterValue.Custom);
                widget.notifyParent();
              },
              onCancel: () {
                statisticsFirestore
                    .changeCurrentFilterValue(FilterValue.Overall);
                widget.notifyParent();
              },
              showTodayButton: true,
            ),
        ],
      ),
    );
  }
}
