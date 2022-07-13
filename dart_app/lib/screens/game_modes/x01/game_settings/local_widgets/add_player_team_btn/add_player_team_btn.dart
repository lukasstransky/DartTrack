import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/screens/game_modes/x01/game_settings/local_widgets/add_player_team_btn/add_player_team_btn_dialogs.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class AddPlayerTeamBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final gameSettingsX01 =
        Provider.of<GameSettingsX01>(context, listen: false);

    return Container(
      width: 10.w,
      child: Selector<GameSettingsX01, List<Player>>(
        selector: (_, gameSettingsX01) => gameSettingsX01.getPlayers,
        builder: (_, players, __) => players.length < MAX_PLAYERS
            ? FloatingActionButton(
                onPressed: () => {
                  if (gameSettingsX01.getSingleOrTeam ==
                          SingleOrTeamEnum.Single ||
                      gameSettingsX01.getTeams.length == MAX_TEAMS)
                    {
                      AddPlayerTeamBtnDialogs.showDialogForAddingPlayer(
                          gameSettingsX01, context),
                    }
                  //case -> team full of players -> should not be possible to add a player, instead only allow to add team
                  else if (gameSettingsX01.getSingleOrTeam ==
                          SingleOrTeamEnum.Team &&
                      gameSettingsX01.possibleToAddPlayerToSomeTeam() == false)
                    {
                      AddPlayerTeamBtnDialogs.showDialogForAddingTeam(
                          gameSettingsX01, context),
                    }
                  else
                    {
                      AddPlayerTeamBtnDialogs.showDialogForAddingPlayerOrTeam(
                          gameSettingsX01, context),
                    },
                },
                child: Icon(Icons.add),
              )
            : SizedBox.shrink(),
      ),
    );
  }
}
