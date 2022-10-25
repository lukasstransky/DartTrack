import 'package:dart_app/constants.dart';
import 'package:dart_app/models/bot.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/models/team.dart';
import 'package:dart_app/screens/game_modes/x01/game_settings/local_widgets/add_player_team_btn/add_player_team_btn_dialogs.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class AddPlayerTeamBtn extends StatelessWidget {
  bool _showAddButton(List<Player> players, GameSettingsX01 gameSettingsX01) {
    if ((players.any((player) => player is Bot) &&
            players.length >= 2 &&
            gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Single) ||
        players.length >= MAX_PLAYERS) {
      return false;
    }

    return true;
  }

  //checks if its possible to add an player to a team -> e.g. there is 1 team with the MAX players in the team -> should not be possible to add a player, instead only possible to add a team
  bool _possibleToAddPlayerToSomeTeam(List<Team> teams) {
    for (Team t in teams)
      if (t.getPlayers.length < MAX_PLAYERS_PER_TEAM) return true;

    return false;
  }

  _addPlayerTeamBtnPressed(
      GameSettingsX01 gameSettingsX01, BuildContext context) {
    if (gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Single ||
        gameSettingsX01.getTeams.length == MAX_TEAMS) {
      AddPlayerTeamBtnDialogs.showDialogForAddingPlayer(
          gameSettingsX01, context);
    }
    //case -> team full of players -> should not be possible to add a player, instead only allow to add team
    else if (gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Team &&
        !_possibleToAddPlayerToSomeTeam(gameSettingsX01.getTeams)) {
      AddPlayerTeamBtnDialogs.showDialogForAddingTeam(gameSettingsX01, context);
    } else {
      AddPlayerTeamBtnDialogs.showDialogForAddingPlayerOrTeam(
          gameSettingsX01, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameSettingsX01 = context.read<GameSettingsX01>();

    return Container(
      width: 10.w,
      child: Selector<GameSettingsX01, List<Player>>(
        selector: (_, gameSettingsX01) => gameSettingsX01.getPlayers,
        shouldRebuild: (previous, next) => true,
        builder: (_, players, __) => _showAddButton(players, gameSettingsX01)
            ? FloatingActionButton(
                elevation: 0.0,
                onPressed: () =>
                    _addPlayerTeamBtnPressed(gameSettingsX01, context),
                child: const Icon(Icons.add),
              )
            : SizedBox.shrink(),
      ),
    );
  }
}
