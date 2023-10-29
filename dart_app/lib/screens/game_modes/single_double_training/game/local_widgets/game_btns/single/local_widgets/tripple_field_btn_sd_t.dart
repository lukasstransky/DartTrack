import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/game_single_double_training_p.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class TrippleFieldBtnSingleTraining extends StatelessWidget {
  const TrippleFieldBtnSingleTraining({
    Key? key,
    required this.game,
  }) : super(key: key);

  final GameSingleDoubleTraining_P game;

  @override
  Widget build(BuildContext context) {
    final double fontSize = Utils.getResponsiveValue(
      context: context,
      mobileValue: BTN_FONTSIZE_SD_T_MOBILE,
      tabletValue: BTN_FONTSIZE_SD_T_TABLET,
    );
    final GameSingleDoubleTraining_P gameSingleDoubleTraining =
        context.read<GameSingleDoubleTraining_P>();

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: gameSingleDoubleTraining.getSafeAreaPadding.bottom > 0
                ? BorderSide(
                    color: Utils.getPrimaryColorDarken(context),
                    width: GENERAL_BORDER_WIDTH.w,
                  )
                : BorderSide.none,
            right: gameSingleDoubleTraining.getSafeAreaPadding.right > 0
                ? BorderSide(
                    color: Utils.getPrimaryColorDarken(context),
                    width: GENERAL_BORDER_WIDTH.w,
                  )
                : BorderSide.none,
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
                        Utils.darken(Theme.of(context).colorScheme.primary, 10),
                      )
                    : MaterialStateProperty.all(Colors.transparent),
          ),
          child: FittedBox(
            child: Selector<GameSingleDoubleTraining_P, int>(
              selector: (_, settings) => settings.getCurrentFieldToHit,
              builder: (_, currentFieldToScore, __) => Text(
                'T${currentFieldToScore}',
                style: TextStyle(
                  fontSize: fontSize.sp,
                  color: Utils.getTextColorDarken(context),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          onPressed: () {
            Utils.handleVibrationFeedback(context);
            game.submit('T', context);
          },
        ),
      ),
    );
  }
}
