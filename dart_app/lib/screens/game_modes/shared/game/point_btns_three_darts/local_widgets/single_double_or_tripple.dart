import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/score_training/game_score_training_p.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SingleDoubleOrTrippleBtns extends StatelessWidget {
  const SingleDoubleOrTrippleBtns({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameScoreTraining_P = context.read<GameScoreTraining_P>();

    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(
                    color: Utils.getPrimaryColorDarken(context),
                    width: 3,
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
                  backgroundColor: gameScoreTraining_P.getCurrentPointType ==
                              PointType.Single ||
                          gameScoreTraining_P.getAmountOfDartsThrown() == 3
                      ? MaterialStateProperty.all(Utils.darken(
                          Theme.of(context).colorScheme.primary, 25))
                      : MaterialStateProperty.all(
                          Theme.of(context).colorScheme.primary),
                  overlayColor: gameScoreTraining_P.getCurrentPointType ==
                              PointType.Single ||
                          gameScoreTraining_P.getAmountOfDartsThrown() == 3
                      ? MaterialStateProperty.all(Colors.transparent)
                      : Utils.getColorOrPressed(
                          Theme.of(context).colorScheme.primary,
                          Utils.darken(
                              Theme.of(context).colorScheme.primary, 25),
                        ),
                ),
                child: FittedBox(
                  child: Text(
                    'Single',
                    style: TextStyle(
                      fontSize: THREE_DARTS_BUTTON_TEXT_SIZE,
                      color: Utils.getTextColorDarken(context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                onPressed: () {
                  if (gameScoreTraining_P.getAmountOfDartsThrown() != 3) {
                    gameScoreTraining_P.setCurrentPointType = PointType.Single;
                    gameScoreTraining_P.notify();
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
                    width: 3,
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
                  backgroundColor: gameScoreTraining_P.getCurrentPointType ==
                              PointType.Double ||
                          gameScoreTraining_P.getAmountOfDartsThrown() == 3
                      ? MaterialStateProperty.all(Utils.darken(
                          Theme.of(context).colorScheme.primary, 25))
                      : MaterialStateProperty.all(
                          Theme.of(context).colorScheme.primary),
                  overlayColor: gameScoreTraining_P.getCurrentPointType ==
                              PointType.Double ||
                          gameScoreTraining_P.getAmountOfDartsThrown() == 3
                      ? MaterialStateProperty.all(Colors.transparent)
                      : Utils.getColorOrPressed(
                          Theme.of(context).colorScheme.primary,
                          Utils.darken(
                              Theme.of(context).colorScheme.primary, 25),
                        ),
                ),
                child: FittedBox(
                  child: Text(
                    'Double',
                    style: TextStyle(
                      fontSize: THREE_DARTS_BUTTON_TEXT_SIZE,
                      color: Utils.getTextColorDarken(context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                onPressed: () {
                  if (gameScoreTraining_P.getAmountOfDartsThrown() != 3) {
                    gameScoreTraining_P.setCurrentPointType = PointType.Double;
                    gameScoreTraining_P.notify();
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
                  backgroundColor: gameScoreTraining_P.getCurrentPointType ==
                              PointType.Tripple ||
                          gameScoreTraining_P.getAmountOfDartsThrown() == 3
                      ? MaterialStateProperty.all(Utils.darken(
                          Theme.of(context).colorScheme.primary, 25))
                      : MaterialStateProperty.all(
                          Theme.of(context).colorScheme.primary),
                  overlayColor: gameScoreTraining_P.getCurrentPointType ==
                              PointType.Tripple ||
                          gameScoreTraining_P.getAmountOfDartsThrown() == 3
                      ? MaterialStateProperty.all(Colors.transparent)
                      : Utils.getColorOrPressed(
                          Theme.of(context).colorScheme.primary,
                          Utils.darken(
                              Theme.of(context).colorScheme.primary, 25),
                        ),
                ),
                child: FittedBox(
                  child: Text(
                    'Tripple',
                    style: TextStyle(
                      fontSize: THREE_DARTS_BUTTON_TEXT_SIZE,
                      color: Utils.getTextColorDarken(context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                onPressed: () {
                  if (gameScoreTraining_P.getAmountOfDartsThrown() != 3) {
                    gameScoreTraining_P.setCurrentPointType = PointType.Tripple;
                    gameScoreTraining_P.notify();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
