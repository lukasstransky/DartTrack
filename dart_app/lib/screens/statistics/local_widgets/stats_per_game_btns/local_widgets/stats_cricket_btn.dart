import 'package:dart_app/constants.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class StatsCricketBtn extends StatelessWidget {
  const StatsCricketBtn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.w,
      child: ElevatedButton(
        onPressed: () => Navigator.of(context)
            .pushNamed('/statsPerGameList', arguments: {'mode': 'Cricket'}),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'Cricket',
            style: TextStyle(
                fontSize: 12.sp,
                color: Theme.of(context).colorScheme.secondary),
          ),
        ),
        style: ButtonStyle(
          shadowColor: MaterialStateProperty.all(Colors.transparent),
          overlayColor: Utils.getColorOrPressed(
            Theme.of(context).colorScheme.primary,
            Utils.darken(Theme.of(context).colorScheme.primary, 15),
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
          ),
          backgroundColor: MaterialStateProperty.all(
            Utils.darken(Theme.of(context).colorScheme.primary, GENERAL_DARKEN),
          ),
        ),
      ),
    );
  }
}
