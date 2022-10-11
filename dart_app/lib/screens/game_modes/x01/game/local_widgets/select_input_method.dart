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

  _roundBtnClicked(BuildContext context, GameX01 gameX01) {
    final int amountOfThrownDarts = gameX01.getAmountOfDartsThrown();

    for (int i = 0; i < amountOfThrownDarts; i++) {
      Revert.revertPoints(context);
    }

    gameX01.getGameSettings.setInputMethod = InputMethod.Round;
    gameX01.getGameSettings.notify();
  }

  _threeDartsBtnClicked(GameX01 gameX01) {
    gameX01.setCurrentPointsSelected = 'Points';
    gameX01.getGameSettings.setInputMethod = InputMethod.ThreeDarts;
    gameX01.getGameSettings.notify();
  }

  @override
  Widget build(BuildContext context) {
    final gameSettingsX01 =
        Provider.of<GameSettingsX01>(context, listen: false);
    final gameX01 = Provider.of<GameX01>(context, listen: false);

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
              onPressed: () => _roundBtnClicked(context, gameX01),
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
              onPressed: () => _threeDartsBtnClicked(gameX01),
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
