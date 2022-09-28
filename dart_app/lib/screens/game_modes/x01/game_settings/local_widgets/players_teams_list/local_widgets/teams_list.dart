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

class TeamsList extends StatefulWidget {
  @override
  State<TeamsList> createState() => _TeamsListState();
}

class _TeamsListState extends State<TeamsList> {
  @override
  initState() {
    super.initState();
    newScrollControllerTeams();
  }

  @override
  Widget build(BuildContext context) {
    final gameSettingsX01 =
        Provider.of<GameSettingsX01>(context, listen: false);

    return Selector<GameSettingsX01, Tuple2<List<Team>, List<Player>>>(
      selector: (_, gameSettingsX01) =>
          Tuple2(gameSettingsX01.getTeams, gameSettingsX01.getPlayers),
      shouldRebuild: (previous, next) => true,
      builder: (_, tuple, __) => ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 20.h),
        child: ListView.builder(
          shrinkWrap: true,
          controller: newScrollControllerTeams(),
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
                        TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold),
                  ),
                ),
                ListView.builder(
                  reverse: true,
                  shrinkWrap: true,
                  itemCount: team.getPlayers.length,
                  physics: ClampingScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    final player = team.getPlayers[index];

                    return Container(
                      padding: EdgeInsets.only(left: 2.w),
                      height: 4.h,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 39.w,
                            child: player is Bot
                                ? FittedBox(
                                    alignment: Alignment.centerLeft,
                                    fit: BoxFit.scaleDown,
                                    child: Container(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            'Level ${player.getLevel} Bot',
                                            style: TextStyle(
                                              fontSize: 11.sp,
                                            ),
                                          ),
                                          Container(
                                            transform:
                                                Matrix4.translationValues(
                                                    0.0, -0.5.w, 0.0),
                                            child: Text(
                                              ' (${player.getPreDefinedAverage.round() - BOT_AVG_SLIDER_VALUE_RANGE}-${player.getPreDefinedAverage.round() + BOT_AVG_SLIDER_VALUE_RANGE} avg.)',
                                              style: TextStyle(
                                                fontSize: 7.sp,
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
                            width: 39.w,
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
                                if (gameSettingsX01.getTeams.length > 1)
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    icon: Icon(
                                      Icons.swap_vert,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () => {
                                      PlayersTeamsListDialogs
                                          .showDialogForSwitchingTeam(
                                              context, player, gameSettingsX01)
                                    },
                                  ),
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: Icon(
                                    Icons.highlight_remove,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () => {
                                    if (team.getPlayers.length == 1)
                                      {
                                        PlayersTeamsListDialogs
                                            .showDialogForDeletingTeamAsLastPlayer(
                                                context,
                                                team,
                                                gameSettingsX01,
                                                player),
                                      }
                                    else
                                      {
                                        gameSettingsX01.removePlayer(
                                            player, true),
                                      }
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
              ],
            );
          },
        ),
      ),
    );
  }
}
