import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class RoundedChip extends StatelessWidget {
  const RoundedChip({Key? key, required this.value}) : super(key: key);

  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 5, right: 5),
      child: SizedBox(
        height: 3.5.h,
        child: ElevatedButton(
          onPressed: () => null,
          child: FittedBox(
            fit: BoxFit.fitWidth,
            child: Text(value),
          ),
          style: ButtonStyle(
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
            ),
            backgroundColor: MaterialStateProperty.all(
                Theme.of(context).colorScheme.primary),
          ),
        ),
      ),
    );
  }
}
