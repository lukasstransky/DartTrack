import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/game_single_double_training_p.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class DoubleMissedBtnDoubleTraining extends StatelessWidget {
  const DoubleMissedBtnDoubleTraining({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Utils.getPrimaryColorDarken(context),
              width: GENERAL_BORDER_WIDTH.w,
            ),
            bottom: BorderSide(
              color: Utils.getPrimaryColorDarken(context),
              width: GENERAL_BORDER_WIDTH.w,
            ),
            right: BorderSide(
              color: Utils.getPrimaryColorDarken(context),
              width: GENERAL_BORDER_WIDTH.w,
            ),
          ),
        ),
        child: ElevatedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
            ),
            backgroundColor: MaterialStateProperty.all(
                Theme.of(context).colorScheme.primary),
            overlayColor: Utils.getColorOrPressed(
              Theme.of(context).colorScheme.primary,
              Utils.darken(Theme.of(context).colorScheme.primary, 25),
            ),
          ),
          child: Icon(
            Icons.close_sharp,
            color: Utils.getTextColorDarken(context),
            size: 60.sp,
          ),
          onPressed: () {
            Utils.handleVibrationFeedback(context);
            context.read<GameSingleDoubleTraining_P>().submit('X', context);
          },
        ),
      ),
    );
  }
}
