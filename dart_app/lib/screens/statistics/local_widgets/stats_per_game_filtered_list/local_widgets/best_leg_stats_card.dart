import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class BestLegStatsCard extends StatelessWidget {
  const BestLegStatsCard({Key? key, required this.bestLeg, required this.game})
      : super(key: key);

  final int bestLeg;
  final GameX01_P game;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/statisticsX01',
            arguments: {'game': game});
      },
      child: Card(
        color: Utils.darken(Theme.of(context).colorScheme.primary, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 5,
                left: 10,
                right: 10,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      game.getGameSettings.getGameMode(),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Spacer(),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      game.getFormattedDateTime(),
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 10,
                bottom: 5,
              ),
              child: Text(game.getGameSettings.getGameModeDetails(true),
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.white,
                  )),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 10,
                bottom: 5,
              ),
              child: Text(
                'Darts for Leg: ' + bestLeg.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13.sp,
                  color: Utils.getTextColorDarken(context),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
