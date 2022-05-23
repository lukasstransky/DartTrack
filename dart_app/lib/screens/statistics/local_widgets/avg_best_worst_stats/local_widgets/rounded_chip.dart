import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class RoundedChip extends StatelessWidget {
  const RoundedChip({Key? key, required this.value, required this.type})
      : super(key: key);

  final String value;
  final String type;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 5, right: 5),
      child: SizedBox(
        height: 3.5.h,
        child: GestureDetector(
          child: ElevatedButton(
            onPressed: () => {
              if (this.type != "" && this.value != "-")
                {
                  Navigator.of(context).pushNamed('/statsPerGameFilteredList',
                      arguments: {'type': this.type}),
                }
            },
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(value),
            ),
            style: ButtonStyle(
              shadowColor: MaterialStateProperty.all(Colors.transparent),
              overlayColor: this.value != "-" && this.type != ""
                  ? Utils.getColor(
                      Theme.of(context).colorScheme.primary,
                      Utils.darken(Theme.of(context).colorScheme.primary, 15),
                    )
                  : MaterialStateProperty.all(Colors.transparent),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
              ),
              backgroundColor: MaterialStateProperty.all(this.type != ""
                  ? Theme.of(context).colorScheme.primary
                  : Utils.darken(Theme.of(context).colorScheme.primary, 20)),
            ),
          ),
        ),
      ),
    );
  }
}
