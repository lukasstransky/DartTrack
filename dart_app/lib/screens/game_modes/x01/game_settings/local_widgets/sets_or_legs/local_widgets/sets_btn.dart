import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class SetsBtn extends StatelessWidget {
  _setsBtnClicked(GameSettingsX01 gs) {
    gs.setSetsEnabled = !gs.getSetsEnabled;
    gs.setWinByTwoLegsDifference = false;
    gs.setSuddenDeath = false;
    gs.setMaxExtraLegs = DEFAULT_MAX_EXTRA_LEGS;

    if (gs.getDrawMode) {
      gs.setSets = DEFAULT_SETS_DRAW_MODE;
      gs.setLegs = gs.getSetsEnabled
          ? DEFAULT_LEGS_DRAW_MODE_SETS_ENABLED
          : DEFAULT_LEGS_DRAW_MODE;
    } else {
      if (gs.getMode == BestOfOrFirstToEnum.FirstTo) {
        gs.setSets = DEFAULT_SETS_FIRST_TO_SETS_ENABLED;
        gs.setLegs = gs.getSetsEnabled
            ? DEFAULT_LEGS_FIRST_TO_SETS_ENABLED
            : DEFAULT_LEGS_FIRST_TO_NO_SETS;
      } else {
        gs.setSets = DEFAULT_SETS_BEST_OF_SETS_ENABLED;
        gs.setLegs = gs.getSetsEnabled
            ? gs.setLegs = DEFAULT_LEGS_BEST_OF_SETS_ENABLED
            : gs.setSets = DEFAULT_LEGS_BEST_OF_NO_SETS;
      }
    }

    gs.notify();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Consumer<GameSettingsX01>(
        builder: (_, gameSettingsX01, __) => Container(
          height: Utils.getHeightForWidget(gameSettingsX01).h,
          child: ElevatedButton(
            onPressed: () => _setsBtnClicked(gameSettingsX01),
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: const Text('Sets'),
            ),
            style: ButtonStyle(
              splashFactory: NoSplash.splashFactory,
              shadowColor: MaterialStateProperty.all(Colors.transparent),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(BUTTON_BORDER_RADIUS),
                  ),
                ),
              ),
              backgroundColor: gameSettingsX01.getSetsEnabled
                  ? Utils.getColor(Theme.of(context).colorScheme.primary)
                  : Utils.getColor(Colors.grey),
            ),
          ),
        ),
      ),
    );
  }
}
