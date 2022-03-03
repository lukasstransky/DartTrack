import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01_model.dart';
import 'package:dart_app/models/games/game_model.dart';
import 'package:dart_app/models/games/game_x01_model.dart';
import 'package:dart_app/models/player_statistics/player_game_statistics_model.dart';
import 'package:dart_app/models/player_statistics/player_game_statistics_x01_model.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class PlayerStatsInGame extends StatelessWidget {
  const PlayerStatsInGame({Key? key, this.playerGameStatisticsX01})
      : super(key: key);

  final PlayerGameStatisticsX01? playerGameStatisticsX01;

  @override
  Widget build(BuildContext context) {
    final gameX01 = Provider.of<GameX01>(context, listen: false);
    final gameSettingsX01 =
        Provider.of<GameSettingsX01>(context, listen: false);

    return Consumer2<GameX01, GameSettingsX01>(
      //todo -> add selector
      builder: (_, gameX01, gameSettingsX01, __) => Container(
        color: gameX01.getCurrentPlayerToThrow ==
                playerGameStatisticsX01!.getPlayer
            ? Colors.grey
            : Colors.transparent,
        width: gameSettingsX01.getPlayers.length <= 2 ? 50.w : 33.33.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
                        Chip(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          label: Text(
                            'Sets: ' +
                                playerGameStatisticsX01!.getSetsWon.toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 5),
                          child: Chip(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            label: FittedBox(
                              child: Text(
                                'Legs: ' +
                                    playerGameStatisticsX01!.getLegsWon
                                        .toString(),
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    SizedBox(
                      width: 28.w,
                      child: Chip(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        label: FittedBox(
                          child: Text(
                            'Sets: ' +
                                playerGameStatisticsX01!.getSetsWon.toString() +
                                ' Legs: ' +
                                playerGameStatisticsX01!.getLegsWon.toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                ],
              )
            else
              Chip(
                backgroundColor: Theme.of(context).colorScheme.primary,
                label: Text(
                  'Legs: ' + playerGameStatisticsX01!.getLegsWon.toString(),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (gameSettingsX01.getShowAverage)
                  Text(
                    "Average: " + playerGameStatisticsX01!.getAverage(),
                    style: TextStyle(
                      fontSize: 13.sp,
                    ),
                  ),
                if (gameSettingsX01.getShowLastThrow)
                  Text(
                    "Last Throw: " + playerGameStatisticsX01!.getLastThrow(),
                    style: TextStyle(
                      fontSize: 13.sp,
                    ),
                  ),
                if (gameSettingsX01.getShowThrownDartsPerLeg)
                  Text(
                    "Thrown Darts: " +
                        playerGameStatisticsX01!.getThrownDartsPerLeg
                            .toString(),
                    style: TextStyle(
                      fontSize: 13.sp,
                    ),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
