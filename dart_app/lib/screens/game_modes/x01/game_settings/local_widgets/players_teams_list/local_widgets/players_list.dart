import 'package:dart_app/constants.dart';
import 'package:dart_app/models/bot.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/screens/game_modes/x01/game_settings/local_widgets/players_teams_list/players_teams_list_dialogs.dart';
import 'package:dart_app/utils/globals.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class PlayersList extends StatefulWidget {
  @override
  State<PlayersList> createState() => _PlayersListState();
}

class _PlayersListState extends State<PlayersList> {
  @override
  initState() {
    super.initState();
    newScrollControllerPlayers();
  }

  @override
  Widget build(BuildContext context) {
    final gameSettingsX01 = context.read<GameSettingsX01>();

    return Selector<GameSettingsX01, List<Player>>(
      selector: (_, gameSettingsX01) => gameSettingsX01.getPlayers,
      shouldRebuild: (previous, next) => true,
      builder: (_, players, __) => ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 16.h),
        child: ListView.builder(
          shrinkWrap: true,
          controller: newScrollControllerPlayers(),
          reverse: true, //show new added player on top
          scrollDirection: Axis.vertical,
          itemCount: gameSettingsX01.getPlayers.length,
          itemBuilder: (BuildContext context, int index) {
            final player = players[index];

            return Container(
              padding: EdgeInsets.only(left: 4.w),
              height: 4.h,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 46.w,
                    child: player is Bot
                        ? FittedBox(
                            alignment: Alignment.centerLeft,
                            fit: BoxFit.scaleDown,
                            child: Container(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'Level ${player.getLevel} Bot',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                  Container(
                                    transform: Matrix4.translationValues(
                                        0.0, -0.5.w, 0.0),
                                    child: Text(
                                      ' (${player.getPreDefinedAverage.round() - BOT_AVG_SLIDER_VALUE_RANGE}-${player.getPreDefinedAverage.round() + BOT_AVG_SLIDER_VALUE_RANGE} avg.)',
                                      style: TextStyle(
                                        fontSize: 8.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        : FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(player.getName),
                          ),
                  ),
                  Container(
                    width: 30.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            Icons.edit,
                            color: Colors.grey,
                          ),
                          onPressed: () => PlayersTeamsListDialogs
                              .showDialogForEditingPlayer(
                                  context, player, gameSettingsX01),
                        ),
                        IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            Icons.highlight_remove,
                            color: Colors.grey,
                          ),
                          onPressed: () => {
                            gameSettingsX01.removePlayer(player, true),
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
