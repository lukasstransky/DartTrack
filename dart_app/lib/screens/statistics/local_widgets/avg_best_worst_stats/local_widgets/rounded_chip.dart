import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class RoundedChip extends StatelessWidget {
  const RoundedChip({
    Key? key,
    required this.value,
    required this.type,
  }) : super(key: key);

  final String value;
  final String type;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 3.5.h,
      padding: EdgeInsets.only(
        left: 1.w,
        right: 1.w,
      ),
      child: GestureDetector(
        child: ElevatedButton(
          onPressed: () => {
            if (this.type != '' && this.value != '-')
              {
                Navigator.of(context).pushNamed('/statsPerGameFilteredList',
                    arguments: {'type': this.type}),
              }
          },
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(
              value,
              style: TextStyle(color: Colors.white),
            ),
          ),
          style: ButtonStyle(
            shadowColor: MaterialStateProperty.all(Colors.transparent),
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
            ),
            backgroundColor: MaterialStateProperty.all(
                Utils.darken(Theme.of(context).colorScheme.primary, 15)),
          ),
        ),
      ),
    );
  }
}
