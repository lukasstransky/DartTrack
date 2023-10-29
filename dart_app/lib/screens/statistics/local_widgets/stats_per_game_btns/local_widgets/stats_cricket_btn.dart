import 'package:dart_app/constants.dart';
import 'package:dart_app/utils/button_styles.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class StatsCricketBtn extends StatelessWidget {
  const StatsCricketBtn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.w,
      height: 5.h,
      padding: EdgeInsets.only(bottom: 1.h),
      child: ElevatedButton(
        onPressed: () {
          Utils.handleVibrationFeedback(context);
          Navigator.of(context).pushNamed('/statsPerGameList',
              arguments: {'mode': GameMode.Cricket});
        },
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            GameMode.Cricket.name,
            style: TextStyle(
                fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                color: Theme.of(context).colorScheme.secondary),
          ),
        ),
        style: ButtonStyles.darkPrimaryColorBtnStyle(context).copyWith(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
