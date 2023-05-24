import 'package:dart_app/constants.dart';
import 'package:dart_app/models/bot.dart';
import 'package:dart_app/models/game_settings/game_settings_p.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/models/team.dart';
import 'package:dart_app/screens/game_modes/x01/game_settings/local_widgets/players_teams_list/players_teams_list_dialogs_x01.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class TeamsListEntry extends StatelessWidget {
  const TeamsListEntry({
    Key? key,
    required Team this.team,
    required GameSettings_P this.gameSettings,
  }) : super(key: key);

  final Team team;
  final GameSettings_P gameSettings;

  _deleteIconClicked(Team team, Player player, GameSettings_P gameSettings,
      BuildContext context) {
    if (team.getPlayers.length == 1) {
      PlayersTeamsListDialogs.showDialogForDeletingTeamAsLastPlayer(
          context, team, gameSettings, player);
    } else {
      gameSettings.removePlayer(player, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => PlayersTeamsListDialogs.showDialogForEditingTeam(
              context, team, gameSettings),
          child: Text(
            team.getName,
            style: TextStyle(
                fontSize: 13.sp,
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
                    padding: EdgeInsets.only(left: 4.w),
                    child: FittedBox(
                      alignment: Alignment.centerLeft,
                      fit: BoxFit.scaleDown,
                      child: player is Bot
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Bot - level ${player.getLevel}',
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: Colors.white,
                                  ),
                                ),
                                Container(
                                  transform: Matrix4.translationValues(
                                      0.0, -0.5.w, 0.0),
                                  child: Text(
                                    ' (${player.getPreDefinedAverage.round() - BOT_AVG_SLIDER_VALUE_RANGE}-${player.getPreDefinedAverage.round() + BOT_AVG_SLIDER_VALUE_RANGE} avg.)',
                                    style: TextStyle(
                                      fontSize: 7.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Text(
                              player.getName,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            Icons.edit,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          onPressed: () => PlayersTeamsListDialogs
                              .showDialogForEditingPlayer(
                                  context, player, gameSettings),
                        ),
                        if (gameSettings.getTeams.length > 1)
                          IconButton(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            padding: EdgeInsets.zero,
                            icon: Icon(
                              Icons.swap_vert,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            onPressed: () => PlayersTeamsListDialogs
                                .showDialogForSwitchingTeam(
                                    context, player, gameSettings),
                          ),
                        IconButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            Icons.highlight_remove,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          onPressed: () => _deleteIconClicked(
                            team,
                            player,
                            gameSettings,
                            context,
                          ),
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
  }
}
