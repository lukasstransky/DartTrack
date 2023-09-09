import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/screens/game_modes/x01/ingame_settings/local_widgets/input_method_settings/local_widgets/auto_submit_or_most_scored_points/auto_submit_scored_points_switch_x01.dart';
import 'package:dart_app/screens/game_modes/x01/ingame_settings/local_widgets/input_method_settings/local_widgets/select_input_method_settings_x01.dart';
import 'package:dart_app/screens/game_modes/x01/ingame_settings/local_widgets/input_method_settings/local_widgets/show_input_method_switch_x01.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class InputMethodSettingsX01 extends StatelessWidget {
  const InputMethodSettingsX01({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<GameSettingsX01_P, SelectorModel>(
      selector: (_, gameSettingsX01) => SelectorModel(
        inputMethod: gameSettingsX01.getInputMethod,
        showMostScoredPoints: gameSettingsX01.getShowMostScoredPoints,
      ),
      builder: (_, selectorModel, __) => Container(
        padding: EdgeInsets.only(
          top: 2.0.h,
          left: 0.5.w,
          right: 0.5.w,
        ),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(CARD_SHAPE_ROUNDING),
              ),
              margin: EdgeInsets.all(0), //card adds 1.h per default
              elevation: 5,
              color: Utils.darken(Theme.of(context).colorScheme.primary, 10),
              child: Column(
                children: [
                  Container(
                    height: 5.h,
                    padding: EdgeInsets.only(left: 1.5.w),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Input method',
                      style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.titleLarge!.fontSize,
                        color: Utils.getTextColorDarken(context),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ShowInputMethodSwitchX01(),
                  SelectInputMethodSettingsX01(),
                  AutoSubmitOrScoredPointsSwitchX01()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SelectorModel {
  final InputMethod inputMethod;
  final bool showMostScoredPoints;

  SelectorModel({
    required this.inputMethod,
    required this.showMostScoredPoints,
  });
}
