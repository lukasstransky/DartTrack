import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/models/player_statistics/player_game_statistics_x01.dart';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:provider/provider.dart';

class PlayerStatsInGame extends StatelessWidget {
  const PlayerStatsInGame({Key? key, this.playerGameStatisticsX01})
      : super(key: key);

  final PlayerGameStatisticsX01? playerGameStatisticsX01;

  @override
  Widget build(BuildContext context) {
    return Consumer2<GameX01, GameSettingsX01>(
      //todo -> add selector
      builder: (_, gameX01, gameSettingsX01, __) => Container(
        color: gameX01.getCurrentPlayerToThrow ==
                playerGameStatisticsX01!.getPlayer
            ? Colors.grey
            : Colors.transparent,
        width: 50.w,
        child: Center(
          child: Container(
            transform: Matrix4.translationValues(0.0, -15.0, 0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (gameX01.getPlayerLegStartIndex ==
                    gameX01.getPlayerGameStatistics
                        .indexOf(playerGameStatisticsX01)) ...[
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        transform: Matrix4.translationValues(0.0, 10.0, 0.0),
                        child: SizedBox(
                          height: 6.h,
                          child: Image.asset(
                            'assets/dart_arrow.png',
                          ),
                        ),
                      ),
                    ),
                  ),
                ] else
                  SizedBox(
                    height: 6.h,
                  ),
                if (gameSettingsX01.getShowFinishWays)
                  if (playerGameStatisticsX01!.checkoutPossible()) ...[
                    Text(playerGameStatisticsX01!.getFinishWay(),
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 15.sp)),
                  ] else if (gameX01.onePlayerInFinishArea())
                    if (playerGameStatisticsX01!.isBogeyNumber())
                      Text("No Finish possible!",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 12.sp))
                    else
                      Text("",
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 15.sp)),
                Text(
                  playerGameStatisticsX01!.getCurrentPoints.toString(),
                  style: TextStyle(fontSize: 50.sp),
                ),
                Text(
                  playerGameStatisticsX01!.getPlayer.getName,
                  style: TextStyle(fontSize: 18.sp),
                ),
                if (gameSettingsX01.getSetsEnabled)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (gameSettingsX01.getPlayers.length == 2)
                        Row(
                          children: [
                            SizedBox(
                              height: 4.h,
                              child: ElevatedButton(
                                onPressed: () => null,
                                child: FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Text(
                                      'Sets: ' +
                                          playerGameStatisticsX01!.getSetsWon
                                              .toString(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10.sp)),
                                ),
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20.0),
                                      ),
                                    ),
                                  ),
                                  backgroundColor: MaterialStateProperty.all(
                                      Theme.of(context).colorScheme.primary),
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 5),
                              child: SizedBox(
                                height: 4.h,
                                child: ElevatedButton(
                                  onPressed: () => null,
                                  child: FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: Text(
                                        'Legs: ' +
                                            playerGameStatisticsX01!.getLegsWon
                                                .toString(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10.sp)),
                                  ),
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(20.0),
                                        ),
                                      ),
                                    ),
                                    backgroundColor: MaterialStateProperty.all(
                                        Theme.of(context).colorScheme.primary),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      else
                        SizedBox(
                          width: 28.w,
                          child: SizedBox(
                            height: 4.h,
                            child: ElevatedButton(
                              onPressed: () => null,
                              child: FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Text(
                                    'Sets: ' +
                                        playerGameStatisticsX01!.getSetsWon
                                            .toString() +
                                        ' Legs: ' +
                                        playerGameStatisticsX01!.getLegsWon
                                            .toString(),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 10.sp)),
                              ),
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20.0),
                                    ),
                                  ),
                                ),
                                backgroundColor: MaterialStateProperty.all(
                                    Theme.of(context).colorScheme.primary),
                              ),
                            ),
                          ),
                        ),
                    ],
                  )
                else
                  SizedBox(
                    height: 4.h,
                    child: ElevatedButton(
                      onPressed: () => null,
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: Text(
                            'Legs: ' +
                                playerGameStatisticsX01!.getLegsWon.toString(),
                            style: TextStyle(
                                color: Colors.white, fontSize: 10.sp)),
                      ),
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20.0),
                            ),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all(
                            Theme.of(context).colorScheme.primary),
                      ),
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (gameSettingsX01.getShowAverage)
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            "Average: " +
                                playerGameStatisticsX01!.getAverage(
                                    gameX01, playerGameStatisticsX01!),
                            style: TextStyle(
                              fontSize: 13.sp,
                            ),
                          ),
                        ),
                      if (gameSettingsX01.getShowLastThrow)
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            "Last Throw: " +
                                playerGameStatisticsX01!.getLastThrow(),
                            style: TextStyle(
                              fontSize: 13.sp,
                            ),
                          ),
                        ),
                      if (gameSettingsX01.getShowThrownDartsPerLeg)
                        playerGameStatisticsX01!.getCurrentThrownDartsInLeg != 0
                            ? FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  "Thrown Darts: " +
                                      playerGameStatisticsX01!
                                          .getCurrentThrownDartsInLeg
                                          .toString(),
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                  ),
                                ),
                              )
                            : FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  "Thrown Darts: -",
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                  ),
                                ),
                              ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
