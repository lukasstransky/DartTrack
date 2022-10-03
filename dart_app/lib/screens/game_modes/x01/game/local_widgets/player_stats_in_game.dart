import 'package:dart_app/constants.dart';
import 'package:dart_app/models/bot.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/models/player_statistics/player_game_statistics_x01.dart';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:provider/provider.dart';

class PlayerStatsInGame extends StatelessWidget {
  const PlayerStatsInGame({Key? key, this.playerGameStatisticsX01})
      : super(key: key);

  final PlayerGameStatisticsX01? playerGameStatisticsX01;

  //for showing finish ways -> if one player is in finish area and the other one not -> text widget not centered
  bool _onePlayerInFinishArea(BuildContext context) {
    final GameX01 gameX01 = Provider.of<GameX01>(context, listen: false);

    for (PlayerGameStatisticsX01 stats in gameX01.getPlayerGameStatistics) {
      if (stats.getCurrentPoints <= 170) {
        return true;
      }
    }

    return false;
  }

  String _getLastThrow(List<int> allScores) {
    if (allScores.length == 0) return '-';

    return allScores[allScores.length - 1].toString();
  }

  String _getFinishWay(int currentPoints) {
    if (currentPoints != 0) return FINISH_WAYS[currentPoints]![0];

    return '';
  }

  bool _checkoutPossible(int currentPoints) {
    if (currentPoints <= 170 && !BOGEY_NUMBERS.contains(currentPoints))
      return true;

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<GameX01, GameSettingsX01>(
      builder: (_, gameX01, gameSettingsX01, __) => Container(
        color: Player.samePlayer(gameX01.getCurrentPlayerToThrow,
                playerGameStatisticsX01!.getPlayer)
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
                  if (_checkoutPossible(
                      playerGameStatisticsX01!.getCurrentPoints)) ...[
                    Text(
                        _getFinishWay(
                            playerGameStatisticsX01!.getCurrentPoints),
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 15.sp)),
                  ] else if (_onePlayerInFinishArea(context))
                    if (BOGEY_NUMBERS
                        .contains(playerGameStatisticsX01!.getCurrentPoints))
                      Text('No Finish possible!',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 12.sp))
                    else
                      Text('',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 15.sp)),
                Text(
                  playerGameStatisticsX01!.getCurrentPoints.toString(),
                  style: TextStyle(fontSize: 50.sp),
                ),
                Text(
                  playerGameStatisticsX01!.getPlayer is Bot
                      ? 'Lvl. ${playerGameStatisticsX01!.getPlayer.getLevel} Bot'
                      : playerGameStatisticsX01!.getPlayer.getName,
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
                                      'Sets: ${playerGameStatisticsX01!.getSetsWon.toString()}',
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
                                        'Legs: ${playerGameStatisticsX01!.getLegsWon.toString()}',
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
                                    'Sets: ${playerGameStatisticsX01!.getSetsWon.toString()} Legs: ${playerGameStatisticsX01!.getLegsWon.toString()}',
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
                            'Legs: ${playerGameStatisticsX01!.getLegsWon.toString()}',
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
                            'Average: ${playerGameStatisticsX01!.getAverage()}',
                            style: TextStyle(
                              fontSize: 13.sp,
                            ),
                          ),
                        ),
                      if (gameSettingsX01.getShowLastThrow)
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'Last Throw: ${_getLastThrow(playerGameStatisticsX01!.getAllScores)}',
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
                                  'Thrown Darts: ${playerGameStatisticsX01!.getCurrentThrownDartsInLeg.toString()}',
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                  ),
                                ),
                              )
                            : FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  'Thrown Darts: -',
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
