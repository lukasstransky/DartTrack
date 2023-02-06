import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/game_single_double_training_p.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class DoubleFieldBtnSingleTraining extends StatelessWidget {
  const DoubleFieldBtnSingleTraining({
    Key? key,
    required this.game,
  }) : super(key: key);

  final GameSingleDoubleTraining_P game;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Utils.getPrimaryColorDarken(context),
              width: GENERAL_BORDER_WIDTH,
            ),
            right: BorderSide(
              color: Utils.getPrimaryColorDarken(context),
              width: GENERAL_BORDER_WIDTH,
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
            backgroundColor: game.getAmountOfDartsThrown() != 3
                ? MaterialStateProperty.all(
                    Theme.of(context).colorScheme.primary)
                : MaterialStateProperty.all(
                    Utils.darken(Theme.of(context).colorScheme.primary, 25)),
            overlayColor:
                game.getAmountOfDartsThrown() != 3 && game.getCanBePressed
                    ? Utils.getColorOrPressed(
                        Theme.of(context).colorScheme.primary,
                        Utils.darken(Theme.of(context).colorScheme.primary, 25),
                      )
                    : MaterialStateProperty.all(Colors.transparent),
          ),
          child: FittedBox(
            child: Selector<GameSingleDoubleTraining_P, int>(
              selector: (_, settings) => settings.getCurrentFieldToHit,
              builder: (_, currentFieldToScore, __) => Text(
                'D${game.getCurrentFieldToHit}',
                style: TextStyle(
                  fontSize: BTN_FONTSIZE_SD_T.sp,
                  color: Utils.getTextColorDarken(context),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          onPressed: () => game.submit('D', context),
        ),
      ),
    );
  }
}
