import 'package:dart_app/constants.dart';
import 'package:dart_app/models/bot.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
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

  _deleteIconClicked(
      Team team, Player player, GameSettingsX01_P gameSettingsX01) {
    if (team.getPlayers.length == 1) {
      PlayersTeamsListDialogs.showDialogForDeletingTeamAsLastPlayer(
          context, team, gameSettingsX01, player);
    } else {
      gameSettingsX01.removePlayer(player, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameSettingsX01 = context.read<GameSettingsX01_P>();

    return Selector<GameSettingsX01_P, Tuple2<List<Team>, List<Player>>>(
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
            final Team team = tuple.item1[index];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => PlayersTeamsListDialogs.showDialogForEditingTeam(
                      context, team, gameSettingsX01),
                  child: Text(
                    team.getName,
                    style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                ListView.builder(
                  reverse: true,
                  shrinkWrap: true,
                  itemCount: team.getPlayers.length,
                  physics: ClampingScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    final Player player = team.getPlayers[index];

                    return Container(
                      padding: EdgeInsets.only(left: 2.w),
                      height: 4.h,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 39.w,
                            child: FittedBox(
                              alignment: Alignment.centerLeft,
                              fit: BoxFit.scaleDown,
                              child: player is Bot
                                  ? Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          'Level ${player.getLevel} Bot',
                                          style: TextStyle(
                                              fontSize: 10.sp,
                                              color: Colors.white),
                                        ),
                                        Container(
                                          transform: Matrix4.translationValues(
                                              0.0, -0.5.w, 0.0),
                                          child: Text(
                                            ' (${player.getPreDefinedAverage.round() - BOT_AVG_SLIDER_VALUE_RANGE}-${player.getPreDefinedAverage.round() + BOT_AVG_SLIDER_VALUE_RANGE} avg.)',
                                            style: TextStyle(
                                                fontSize: 7.sp,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Text(
                                      player.getName,
                                      style: TextStyle(
                                          fontSize: 10.sp, color: Colors.white),
                                    ),
                            ),
                          ),
                          Container(
                            width: 39.w,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  padding: EdgeInsets.zero,
                                  icon: Icon(
                                    Icons.edit,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                  onPressed: () => PlayersTeamsListDialogs
                                      .showDialogForEditingPlayer(
                                          context, player, gameSettingsX01),
                                ),
                                if (gameSettingsX01.getTeams.length > 1)
                                  IconButton(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    padding: EdgeInsets.zero,
                                    icon: Icon(
                                      Icons.swap_vert,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                    onPressed: () => PlayersTeamsListDialogs
                                        .showDialogForSwitchingTeam(
                                            context, player, gameSettingsX01),
                                  ),
                                IconButton(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  padding: EdgeInsets.zero,
                                  icon: Icon(
                                    Icons.highlight_remove,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                  onPressed: () => _deleteIconClicked(
                                      team, player, gameSettingsX01),
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
