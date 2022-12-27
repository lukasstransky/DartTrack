import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_statistics_x01.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SingleDoubleOrTripple extends StatelessWidget {
  const SingleDoubleOrTripple({
    Key? key,
    required this.stats,
  }) : super(key: key);

  final PlayerOrTeamGameStatisticsX01 stats;

  @override
  Widget build(BuildContext context) {
    final GameX01 gameX01 = context.read<GameX01>();

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
                  backgroundColor:
                      gameX01.getCurrentPointType == PointType.Single ||
                              stats.getCurrentPoints == 0 ||
                              gameX01.getAmountOfDartsThrown() == 3
                          ? MaterialStateProperty.all(Utils.darken(
                              Theme.of(context).colorScheme.primary, 25))
                          : MaterialStateProperty.all(
                              Theme.of(context).colorScheme.primary),
                  overlayColor:
                      gameX01.getCurrentPointType == PointType.Single ||
                              stats.getCurrentPoints == 0 ||
                              gameX01.getAmountOfDartsThrown() == 3
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
                  if (stats.getCurrentPoints != 0 &&
                      gameX01.getAmountOfDartsThrown() != 3) {
                    gameX01.setCurrentPointType = PointType.Single;
                    gameX01.notify();
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
                  backgroundColor:
                      gameX01.getCurrentPointType == PointType.Double ||
                              stats.getCurrentPoints == 0 ||
                              gameX01.getAmountOfDartsThrown() == 3
                          ? MaterialStateProperty.all(Utils.darken(
                              Theme.of(context).colorScheme.primary, 25))
                          : MaterialStateProperty.all(
                              Theme.of(context).colorScheme.primary),
                  overlayColor:
                      gameX01.getCurrentPointType == PointType.Double ||
                              stats.getCurrentPoints == 0 ||
                              gameX01.getAmountOfDartsThrown() == 3
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
                  if (stats.getCurrentPoints != 0 &&
                      gameX01.getAmountOfDartsThrown() != 3) {
                    gameX01.setCurrentPointType = PointType.Double;
                    gameX01.notify();
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
                  backgroundColor:
                      gameX01.getCurrentPointType == PointType.Tripple ||
                              stats.getCurrentPoints == 0 ||
                              gameX01.getAmountOfDartsThrown() == 3
                          ? MaterialStateProperty.all(Utils.darken(
                              Theme.of(context).colorScheme.primary, 25))
                          : MaterialStateProperty.all(
                              Theme.of(context).colorScheme.primary),
                  overlayColor:
                      gameX01.getCurrentPointType == PointType.Tripple ||
                              stats.getCurrentPoints == 0 ||
                              gameX01.getAmountOfDartsThrown() == 3
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
                  if (stats.getCurrentPoints != 0 &&
                      gameX01.getAmountOfDartsThrown() != 3) {
                    gameX01.setCurrentPointType = PointType.Tripple;
                    gameX01.notify();
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
