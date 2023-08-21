import 'package:dart_app/constants.dart';
import 'package:dart_app/models/bot.dart';
import 'package:dart_app/models/game_settings/game_settings_p.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/models/team.dart';
import 'package:dart_app/screens/game_modes/x01/game_settings/local_widgets/players_teams_list/players_teams_list_dialogs_x01.dart';
import 'package:dart_app/utils/utils.dart';
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

  _deleteIconClicked(Team team, Player player, BuildContext context) {
    if (team.getPlayers.length == 1) {
      PlayersTeamsListDialogs.showDialogForDeletingTeamAsLastPlayer(
          context, team, gameSettings, player);
    } else {
      gameSettings.removePlayer(player, true);
    }
  }

  bool _areTwoTeamsWithMaxPlayers() {
    if (gameSettings.getTeams.length == 2) {
      for (Team team in gameSettings.getTeams) {
        if (team.getPlayers.length != MAX_PLAYERS_PER_TEAM) {
          return false;
        }
      }
      return true;
    }
    return false;
  }

  bool _atLeastOneTeamToSwap(Player player) {
    final Team teamOfPlayer = gameSettings.findTeamForPlayer(player.getName);
    for (Team team in gameSettings.getTeams) {
      if (team != teamOfPlayer) {
        if (team.getPlayers.length < MAX_PLAYERS_PER_TEAM) {
          return true;
        }
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final bool areTwoTeamsWithMaxPlayers = _areTwoTeamsWithMaxPlayers();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            Utils.handleVibrationFeedback(context);
            PlayersTeamsListDialogs.showDialogForEditingTeam(
                context, team, gameSettings);
          },
          child: Text(
            team.getName,
            style: TextStyle(
                fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
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
            final bool atLeastOneTeamToSwap = _atLeastOneTeamToSwap(player);

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
                                  'Bot - lvl. ${player.getLevel}',
                                  style: TextStyle(
                                    fontSize: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .fontSize,
                                    color: Colors.white,
                                  ),
                                ),
                                Container(
                                  transform: Matrix4.translationValues(
                                      0.0, -0.5.w, 0.0),
                                  child: Text(
                                    ' (${player.getPreDefinedAverage.round() - BOT_AVG_SLIDER_VALUE_RANGE} - ${player.getPreDefinedAverage.round() + BOT_AVG_SLIDER_VALUE_RANGE} avg.)',
                                    style: TextStyle(
                                      fontSize: 8.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Text(
                              player.getName,
                              style: TextStyle(
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .fontSize,
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
                            size: ICON_BUTTON_SIZE.h,
                            Icons.edit,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          onPressed: () {
                            Utils.handleVibrationFeedback(context);
                            PlayersTeamsListDialogs.showDialogForEditingPlayer(
                                context, player, gameSettings);
                          },
                        ),
                        if (gameSettings.getTeams.length > 1)
                          IconButton(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              padding: EdgeInsets.zero,
                              icon: Icon(
                                size: ICON_BUTTON_SIZE.h,
                                Icons.swap_vert,
                                color: !areTwoTeamsWithMaxPlayers &&
                                        atLeastOneTeamToSwap
                                    ? Theme.of(context).colorScheme.secondary
                                    : Utils.darken(
                                        Theme.of(context).colorScheme.secondary,
                                        30),
                              ),
                              onPressed: () {
                                Utils.handleVibrationFeedback(context);
                                if (!areTwoTeamsWithMaxPlayers &&
                                    atLeastOneTeamToSwap) {
                                  PlayersTeamsListDialogs
                                      .showDialogForSwitchingTeam(
                                          context, player, gameSettings);
                                }
                              }),
                        IconButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            size: ICON_BUTTON_SIZE.h,
                            Icons.highlight_remove,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          onPressed: () {
                            Utils.handleVibrationFeedback(context);
                            _deleteIconClicked(
                              team,
                              player,
                              context,
                            );
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
  }
}
