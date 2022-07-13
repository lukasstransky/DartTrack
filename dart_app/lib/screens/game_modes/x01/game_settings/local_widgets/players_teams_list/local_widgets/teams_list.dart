import 'package:dart_app/constants.dart';
import 'package:dart_app/models/bot.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/models/team.dart';
import 'package:dart_app/screens/game_modes/x01/game_settings/local_widgets/players_teams_list/players_teams_list_dialogs.dart';
import 'package:dart_app/utils/globals.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:tuple/tuple.dart';

class TeamsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final gameSettingsX01 =
        Provider.of<GameSettingsX01>(context, listen: false);

    return Selector<GameSettingsX01, Tuple2<List<Team>, List<Player>>>(
      selector: (_, gameSettingsX01) =>
          Tuple2(gameSettingsX01.getTeams, gameSettingsX01.getPlayers),
      shouldRebuild: (previous, next) => true,
      builder: (_, tuple, __) => ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 24.h),
        child: ListView.builder(
          shrinkWrap: true,
          controller: scrollControllerTeams,
          reverse: true,
          itemCount: tuple.item1.length,
          itemBuilder: (BuildContext context, int index) {
            final team = tuple.item1[index];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => PlayersTeamsListDialogs.showDialogForEditingTeam(
                      context, team, gameSettingsX01),
                  child: Text(
                    team.getName,
                    style:
                        TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                  ),
                ),
                ListView.builder(
                  reverse: true,
                  shrinkWrap: true,
                  itemCount: team.getPlayers.length,
                  physics: ClampingScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    final player = team.getPlayers[index];

                    return ListTile(
                      key: ValueKey(player),
                      title: player is Bot
                          ? Row(
                              children: [
                                Text(
                                  player.getName,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                  ),
                                ),
                                Text(
                                  ' (${player.getPreDefinedAverage.round() - BOT_AVG_SLIDER_VALUE_RANGE}-${player.getPreDefinedAverage.round() + BOT_AVG_SLIDER_VALUE_RANGE} avg.)',
                                  style: TextStyle(
                                    fontSize: 9.sp,
                                  ),
                                ),
                              ],
                            )
                          : FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerLeft,
                              child: Text(player.getName),
                            ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => PlayersTeamsListDialogs
                                .showDialogForEditingPlayer(
                                    context, player, gameSettingsX01),
                          ),
                          if (gameSettingsX01.getTeams.length > 1)
                            IconButton(
                              icon: Icon(Icons.swap_vert),
                              onPressed: () => {
                                PlayersTeamsListDialogs
                                    .showDialogForSwitchingTeam(
                                        context, player, gameSettingsX01)
                              },
                            ),
                          IconButton(
                            icon: Icon(Icons.highlight_remove),
                            onPressed: () => {
                              gameSettingsX01.checkBotNamingIds(player),
                              gameSettingsX01.removePlayer(player),
                            },
                          ),
                        ],
                      ),
                      visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
