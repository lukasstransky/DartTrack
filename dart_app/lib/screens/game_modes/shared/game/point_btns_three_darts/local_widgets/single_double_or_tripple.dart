import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/game_cricket_p.dart';
import 'package:dart_app/models/games/game_score_training_p.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class SingleDoubleOrTrippleBtns extends StatelessWidget {
  const SingleDoubleOrTrippleBtns({
    Key? key,
    required this.mode,
  }) : super(key: key);

  final GameMode mode;

  @override
  Widget build(BuildContext context) {
    late dynamic gameProvider;

    if (mode == GameMode.ScoreTraining) {
      gameProvider = context.read<GameScoreTraining_P>();
    } else if (mode == GameMode.Cricket) {
      gameProvider = context.read<GameCricket_P>();
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: Utils.getPrimaryColorDarken(context),
                  width: GENERAL_BORDER_WIDTH.w,
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
                backgroundColor: gameProvider.getCurrentPointType ==
                            PointType.Single ||
                        gameProvider.getAmountOfDartsThrown() == 3
                    ? MaterialStateProperty.all(
                        Utils.darken(Theme.of(context).colorScheme.primary, 25))
                    : MaterialStateProperty.all(
                        Theme.of(context).colorScheme.primary),
                overlayColor: gameProvider.getCurrentPointType ==
                            PointType.Single ||
                        gameProvider.getAmountOfDartsThrown() == 3
                    ? MaterialStateProperty.all(Colors.transparent)
                    : Utils.getColorOrPressed(
                        Theme.of(context).colorScheme.primary,
                        Utils.darken(Theme.of(context).colorScheme.primary, 25),
                      ),
              ),
              child: FittedBox(
                child: Text(
                  'Single',
                  style: TextStyle(
                    fontSize: THREE_DARTS_BUTTON_TEXT_SIZE.sp,
                    color: Utils.getTextColorDarken(context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              onPressed: () {
                Utils.handleVibrationFeedback(context);
                if (gameProvider.getAmountOfDartsThrown() != 3) {
                  gameProvider.setCurrentPointType = PointType.Single;
                  gameProvider.notify();
                }
              },
            ),
          ),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: Utils.getPrimaryColorDarken(context),
                  width: GENERAL_BORDER_WIDTH.w,
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
                backgroundColor: gameProvider.getCurrentPointType ==
                            PointType.Double ||
                        gameProvider.getAmountOfDartsThrown() == 3
                    ? MaterialStateProperty.all(
                        Utils.darken(Theme.of(context).colorScheme.primary, 25))
                    : MaterialStateProperty.all(
                        Theme.of(context).colorScheme.primary),
                overlayColor: gameProvider.getCurrentPointType ==
                            PointType.Double ||
                        gameProvider.getAmountOfDartsThrown() == 3
                    ? MaterialStateProperty.all(Colors.transparent)
                    : Utils.getColorOrPressed(
                        Theme.of(context).colorScheme.primary,
                        Utils.darken(Theme.of(context).colorScheme.primary, 25),
                      ),
              ),
              child: FittedBox(
                child: Text(
                  'Double',
                  style: TextStyle(
                    fontSize: THREE_DARTS_BUTTON_TEXT_SIZE.sp,
                    color: Utils.getTextColorDarken(context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              onPressed: () {
                Utils.handleVibrationFeedback(context);
                if (gameProvider.getAmountOfDartsThrown() != 3) {
                  gameProvider.setCurrentPointType = PointType.Double;
                  gameProvider.notify();
                }
              },
            ),
          ),
        ),
        Expanded(
          child: Container(
            child: ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                backgroundColor: gameProvider.getCurrentPointType ==
                            PointType.Tripple ||
                        gameProvider.getAmountOfDartsThrown() == 3
                    ? MaterialStateProperty.all(
                        Utils.darken(Theme.of(context).colorScheme.primary, 25))
                    : MaterialStateProperty.all(
                        Theme.of(context).colorScheme.primary),
                overlayColor: gameProvider.getCurrentPointType ==
                            PointType.Tripple ||
                        gameProvider.getAmountOfDartsThrown() == 3
                    ? MaterialStateProperty.all(Colors.transparent)
                    : Utils.getColorOrPressed(
                        Theme.of(context).colorScheme.primary,
                        Utils.darken(Theme.of(context).colorScheme.primary, 25),
                      ),
              ),
              child: FittedBox(
                child: Text(
                  'Tripple',
                  style: TextStyle(
                    fontSize: THREE_DARTS_BUTTON_TEXT_SIZE.sp,
                    color: Utils.getTextColorDarken(context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              onPressed: () {
                Utils.handleVibrationFeedback(context);
                if (gameProvider.getAmountOfDartsThrown() != 3) {
                  gameProvider.setCurrentPointType = PointType.Tripple;
                  gameProvider.notify();
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
