import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/models/statistics_firestore_x01.dart';
import 'package:dart_app/screens/game_modes/x01/ingame_settings/local_widgets/input_method_settings/local_widgets/auto_submit_scored_points_switch.dart';
import 'package:dart_app/screens/game_modes/x01/ingame_settings/local_widgets/input_method_settings/local_widgets/select_input_method.dart';
import 'package:dart_app/screens/game_modes/x01/ingame_settings/local_widgets/input_method_settings/local_widgets/show_input_method_switch.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:tuple/tuple.dart';

class InputMethodSettings extends StatelessWidget {
  const InputMethodSettings({Key? key}) : super(key: key);

  int _calcCardHeight(BuildContext context, InputMethod inputMethod,
      bool showMostScoredPoints) {
    final statisticsFirestoreX01 = context.read<StatisticsFirestoreX01>();

    if (inputMethod == InputMethod.Round && showMostScoredPoints) {
      if (!statisticsFirestoreX01.noGamesPlayed) {
        return 47;
      } else {
        return 41;
      }
    }

    return 26;
  }

  @override
  Widget build(BuildContext context) {
    return Selector<GameSettingsX01, Tuple2<InputMethod, bool>>(
      selector: (_, gameSettingsX01) => new Tuple2(
          gameSettingsX01.getInputMethod,
          gameSettingsX01.getShowMostScoredPoints),
      builder: (_, t, __) => Container(
        height: _calcCardHeight(context, t.item1, t.item2).h,
        padding: EdgeInsets.only(top: 1.0.h, left: 0.5.h, right: 0.5.h),
        child: Card(
          margin: EdgeInsets.all(0), //card adds 1.h per default
          elevation: 5,
          child: Column(
            children: [
              Container(
                height: 5.h,
                padding: EdgeInsets.only(top: 0.5.h, left: 1.5.w),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Input Method',
                  style: TextStyle(
                      fontSize: FONTSIZE_HEADINGS_IN_GAME_SETTINGS.sp,
                      color: Theme.of(context).colorScheme.primary),
                ),
              ),
              ShowInputMethodSwitch(),
              SelectInputMethod(),
              AutoSubmitOrScoredPointsSwitch(),
            ],
          ),
        ),
      ),
    );
  }
}
