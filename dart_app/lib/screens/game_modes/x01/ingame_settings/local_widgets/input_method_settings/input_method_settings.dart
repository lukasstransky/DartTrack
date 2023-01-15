import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/firestore/x01/stats_firestore_x01_p.dart';
import 'package:dart_app/screens/game_modes/x01/ingame_settings/local_widgets/input_method_settings/local_widgets/auto_submit_scored_points_switch.dart';
import 'package:dart_app/screens/game_modes/x01/ingame_settings/local_widgets/input_method_settings/local_widgets/select_input_method_x01_settings.dart';
import 'package:dart_app/screens/game_modes/x01/ingame_settings/local_widgets/input_method_settings/local_widgets/show_input_method_switch.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:tuple/tuple.dart';

class InputMethodSettings extends StatelessWidget {
  const InputMethodSettings({Key? key}) : super(key: key);

  int _calcCardHeight(BuildContext context, InputMethod inputMethod,
      bool showMostScoredPoints) {
    final StatsFirestoreX01_P statisticsFirestoreX01 =
        context.read<StatsFirestoreX01_P>();

    if (inputMethod == InputMethod.Round && showMostScoredPoints) {
      if (!statisticsFirestoreX01.noGamesPlayed) {
        return 49;
      } else {
        return 43;
      }
    }

    return 28;
  }

  @override
  Widget build(BuildContext context) {
    return Selector<GameSettingsX01_P, Tuple2<InputMethod, bool>>(
      selector: (_, gameSettingsX01) => new Tuple2(
          gameSettingsX01.getInputMethod,
          gameSettingsX01.getShowMostScoredPoints),
      builder: (_, t, __) => Container(
        height: _calcCardHeight(context, t.item1, t.item2).h,
        padding: EdgeInsets.only(top: 2.0.h, left: 0.5.h, right: 0.5.h),
        child: Card(
          margin: EdgeInsets.all(0), //card adds 1.h per default
          elevation: 5,
          color: Utils.darken(Theme.of(context).colorScheme.primary, 10),
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
                    color: Utils.getTextColorDarken(context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ShowInputMethodSwitch(),
              SelectInputMethodX01Settings(),
              AutoSubmitOrScoredPointsSwitch(),
            ],
          ),
        ),
      ),
    );
  }
}
