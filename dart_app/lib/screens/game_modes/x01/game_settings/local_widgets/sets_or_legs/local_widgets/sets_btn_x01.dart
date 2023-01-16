import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class SetsBtnX01 extends StatelessWidget {
  _setsBtnClicked(GameSettingsX01_P gameSettingsX01) {
    gameSettingsX01.setSetsEnabled = !gameSettingsX01.getSetsEnabled;
    gameSettingsX01.setWinByTwoLegsDifference = false;
    gameSettingsX01.setSuddenDeath = false;
    gameSettingsX01.setMaxExtraLegs = DEFAULT_MAX_EXTRA_LEGS;

    if (gameSettingsX01.getDrawMode) {
      gameSettingsX01.setSets = DEFAULT_SETS_DRAW_MODE;
      gameSettingsX01.setLegs = gameSettingsX01.getSetsEnabled
          ? DEFAULT_LEGS_DRAW_MODE_SETS_ENABLED
          : DEFAULT_LEGS_DRAW_MODE;
    } else {
      if (gameSettingsX01.getMode == BestOfOrFirstToEnum.FirstTo) {
        gameSettingsX01.setSets = DEFAULT_SETS_FIRST_TO_SETS_ENABLED;
        gameSettingsX01.setLegs = gameSettingsX01.getSetsEnabled
            ? DEFAULT_LEGS_FIRST_TO_SETS_ENABLED
            : DEFAULT_LEGS_FIRST_TO_NO_SETS;
      } else {
        gameSettingsX01.setSets = DEFAULT_SETS_BEST_OF_SETS_ENABLED;
        gameSettingsX01.setLegs = gameSettingsX01.getSetsEnabled
            ? gameSettingsX01.setLegs = DEFAULT_LEGS_BEST_OF_SETS_ENABLED
            : gameSettingsX01.setSets = DEFAULT_LEGS_BEST_OF_NO_SETS;
      }
    }

    gameSettingsX01.notify();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Consumer<GameSettingsX01_P>(
        builder: (_, gameSettingsX01, __) => Container(
          height: Utils.getHeightForWidget(gameSettingsX01).h,
          child: ElevatedButton(
            onPressed: () => _setsBtnClicked(gameSettingsX01),
            child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'Sets',
                  style: TextStyle(
                    color: Utils.getTextColorForGameSettingsBtn(
                        gameSettingsX01.getSetsEnabled, context),
                  ),
                )),
            style: ButtonStyle(
              splashFactory: NoSplash.splashFactory,
              shadowColor: MaterialStateProperty.all(Colors.transparent),
              overlayColor: MaterialStateProperty.all(Colors.transparent),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  side: BorderSide(
                    color: Utils.getPrimaryColorDarken(context),
                    width: GAME_SETTINGS_BTN_BORDER_WITH,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(BUTTON_BORDER_RADIUS),
                  ),
                ),
              ),
              backgroundColor: gameSettingsX01.getSetsEnabled
                  ? Utils.getPrimaryMaterialStateColorDarken(context)
                  : Utils.getColor(Theme.of(context).colorScheme.primary),
            ),
          ),
        ),
      ),
    );
  }
}
