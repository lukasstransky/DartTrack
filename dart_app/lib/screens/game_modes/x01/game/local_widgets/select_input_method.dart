import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/models/games/helper/revert_helper.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class SelectInputMethod extends StatelessWidget {
  const SelectInputMethod({Key? key}) : super(key: key);

  _roundBtnClicked(
      BuildContext context, GameX01 gameX01, GameSettingsX01 gameSettingsX01) {
    final int amountOfThrownDarts = gameX01.getAmountOfDartsThrown();

    for (int i = 0; i < amountOfThrownDarts; i++) {
      Revert.revertPoints(context);
    }

    gameSettingsX01.setInputMethod = InputMethod.Round;
    gameSettingsX01.notify();
  }

  _threeDartsBtnClicked(GameX01 gameX01, GameSettingsX01 gameSettingsX01) {
    gameX01.setCurrentPointsSelected = 'Points';
    gameSettingsX01.setInputMethod = InputMethod.ThreeDarts;
    gameSettingsX01.notify();
  }

  @override
  Widget build(BuildContext context) {
    final gameSettingsX01 = context.read<GameSettingsX01>();
    final gameX01 = context.read<GameX01>();

    return Container(
      height: 4.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: 50.w - 0.5,
            margin: const EdgeInsets.only(
              bottom: MARGIN_GAMESETTINGS,
              right: MARGIN_GAMESETTINGS,
            ),
            child: ElevatedButton(
              child: Text(
                'Round',
                style: TextStyle(fontSize: 14.sp, color: Colors.black),
              ),
              onPressed: () =>
                  _roundBtnClicked(context, gameX01, gameSettingsX01),
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.zero,
                    ),
                  ),
                ),
                backgroundColor: gameSettingsX01.getInputMethod ==
                        InputMethod.Round
                    ? MaterialStateProperty.all(
                        Utils.darken(Theme.of(context).colorScheme.primary, 25))
                    : MaterialStateProperty.all(
                        Theme.of(context).colorScheme.primary),
                overlayColor: gameSettingsX01.getInputMethod ==
                        InputMethod.Round
                    ? MaterialStateProperty.all(Colors.transparent)
                    : Utils.getColorOrPressed(
                        Theme.of(context).colorScheme.primary,
                        Utils.darken(Theme.of(context).colorScheme.primary, 15),
                      ),
              ),
            ),
          ),
          Container(
            width: 50.w - 0.5,
            margin: const EdgeInsets.only(
              bottom: MARGIN_GAMESETTINGS,
            ),
            child: ElevatedButton(
              child: Text(
                '3-Darts',
                style: TextStyle(fontSize: 14.sp, color: Colors.black),
              ),
              onPressed: () => _threeDartsBtnClicked(gameX01, gameSettingsX01),
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.zero,
                    ),
                  ),
                ),
                backgroundColor: gameSettingsX01.getInputMethod ==
                        InputMethod.ThreeDarts
                    ? MaterialStateProperty.all(
                        Utils.darken(Theme.of(context).colorScheme.primary, 25))
                    : MaterialStateProperty.all(
                        Theme.of(context).colorScheme.primary),
                overlayColor: gameSettingsX01.getInputMethod ==
                        InputMethod.ThreeDarts
                    ? MaterialStateProperty.all(Colors.transparent)
                    : Utils.getColorOrPressed(
                        Theme.of(context).colorScheme.primary,
                        Utils.darken(Theme.of(context).colorScheme.primary, 15),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
