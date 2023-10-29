import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats_x01.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class SingleDoubleOrTrippleX01 extends StatelessWidget {
  const SingleDoubleOrTrippleX01({
    Key? key,
    required this.stats,
  }) : super(key: key);

  final PlayerOrTeamGameStatsX01 stats;

  @override
  Widget build(BuildContext context) {
    final GameX01_P gameX01 = context.read<GameX01_P>();
    final EdgeInsets safeAreaPadding = gameX01.getSafeAreaPadding;

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
                    width: GENERAL_BORDER_WIDTH.w,
                  ),
                  bottom: safeAreaPadding.bottom > 0
                      ? BorderSide(
                          color: Utils.getPrimaryColorDarken(context),
                          width: GENERAL_BORDER_WIDTH.w,
                        )
                      : BorderSide.none,
                  left: Utils.isLandscape(context)
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
                                  Theme.of(context).colorScheme.primary, 10),
                            ),
                ),
                child: FittedBox(
                  child: Text(
                    'Single',
                    style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.titleSmall!.fontSize,
                      color: Utils.getTextColorDarken(context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                onPressed: () {
                  if (stats.getCurrentPoints != 0 &&
                      gameX01.getAmountOfDartsThrown() != 3) {
                    Utils.handleVibrationFeedback(context);
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
                    width: GENERAL_BORDER_WIDTH.w,
                  ),
                  bottom: safeAreaPadding.bottom > 0
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
                                  Theme.of(context).colorScheme.primary, 10),
                            ),
                ),
                child: FittedBox(
                  child: Text(
                    'Double',
                    style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.titleSmall!.fontSize,
                      color: Utils.getTextColorDarken(context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                onPressed: () {
                  if (stats.getCurrentPoints != 0 &&
                      gameX01.getAmountOfDartsThrown() != 3) {
                    Utils.handleVibrationFeedback(context);
                    gameX01.setCurrentPointType = PointType.Double;
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
                  bottom: safeAreaPadding.bottom > 0
                      ? BorderSide(
                          color: Utils.getPrimaryColorDarken(context),
                          width: GENERAL_BORDER_WIDTH.w,
                        )
                      : BorderSide.none,
                  right: safeAreaPadding.right > 0
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
                                  Theme.of(context).colorScheme.primary, 10),
                            ),
                ),
                child: FittedBox(
                  child: Text(
                    'Tripple',
                    style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.titleSmall!.fontSize,
                      color: Utils.getTextColorDarken(context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                onPressed: () {
                  if (stats.getCurrentPoints != 0 &&
                      gameX01.getAmountOfDartsThrown() != 3) {
                    Utils.handleVibrationFeedback(context);
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
