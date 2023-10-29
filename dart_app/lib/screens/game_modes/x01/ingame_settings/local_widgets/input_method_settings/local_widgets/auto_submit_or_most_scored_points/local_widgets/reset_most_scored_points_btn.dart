import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/utils/button_styles.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class ResetMostScoredPointsBtn extends StatelessWidget {
  const ResetMostScoredPointsBtn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GameSettingsX01_P gameSettingsX01 = context.read<GameSettingsX01_P>();
    final bool resetBtnClickable = !listEquals(
        gameSettingsX01.getMostScoredPoints, DEFAULT_MOST_SCORED_POINTS);

    return Container(
      padding: EdgeInsets.only(
        top: 2.h,
        left: 3.w,
      ),
      child: ElevatedButton(
        child: Container(
          height: 4.h,
          alignment: Alignment.center,
          child: Text(
            'Reset',
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
            ),
          ),
        ),
        onPressed: () {
          if (!resetBtnClickable) {
            Utils.handleVibrationFeedback(context);
            Fluttertoast.showToast(
              msg: 'No values changed!',
              toastLength: Toast.LENGTH_LONG,
              fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
            );
            return;
          }
          gameSettingsX01.setMostScoredPoints =
              List<String>.of(mostScoredPoints);
          gameSettingsX01.notify();
        },
        style: ButtonStyles.darkPrimaryColorBtnStyleWithDisabled(
                context, resetBtnClickable)
            .copyWith(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(BUTTON_BORDER_RADIUS),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
