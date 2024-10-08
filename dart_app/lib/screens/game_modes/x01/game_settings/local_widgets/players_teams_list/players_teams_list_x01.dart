import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/models/team.dart';
import 'package:dart_app/screens/game_modes/shared/game_settings/players_teams_list/players_list/players_list.dart';
import 'package:dart_app/screens/game_modes/shared/game_settings/players_teams_list/teams_list/teams_list.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class PlayersTeamsListX01 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: WIDTH_GAMESETTINGS.w,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Selector<GameSettingsX01_P, SingleOrTeamEnum>(
            selector: (_, gameSettingsX01) => gameSettingsX01.getSingleOrTeam,
            builder: (_, singleOrTeam, __) {
              if (singleOrTeam == SingleOrTeamEnum.Single) {
                return Selector<GameSettingsX01_P, List<Player>>(
                  selector: (_, gameSettingsX01) => gameSettingsX01.getPlayers,
                  shouldRebuild: (previous, next) => true,
                  builder: (_, players, __) => PlayersList(
                    mode: GameMode.X01,
                    players: players,
                  ),
                );
              } else {
                return Selector<GameSettingsX01_P, SelectorModel>(
                  selector: (_, gameSettingsX01) => SelectorModel(
                    teams: gameSettingsX01.getTeams,
                    players: gameSettingsX01.getPlayers,
                  ),
                  shouldRebuild: (previous, next) => true,
                  builder: (_, selectorModel, __) => TeamsList(
                    gameSettings: context.read<GameSettingsX01_P>(),
                    teams: selectorModel.teams,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class SelectorModel {
  final List<Team> teams;
  final List<Player> players;

  SelectorModel({
    required this.teams,
    required this.players,
  });
}
