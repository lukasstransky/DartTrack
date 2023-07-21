import 'package:dart_app/constants.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class StatsDoubleTrainingBtn extends StatelessWidget {
  const StatsDoubleTrainingBtn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.w,
      child: ElevatedButton(
        onPressed: () {
          Utils.handleVibrationFeedback(context);
          Navigator.of(context).pushNamed('/statsPerGameList',
              arguments: {'mode': GameMode.DoubleTraining});
        },
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            GameMode.DoubleTraining.name,
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
                Radius.circular(12.0),
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
