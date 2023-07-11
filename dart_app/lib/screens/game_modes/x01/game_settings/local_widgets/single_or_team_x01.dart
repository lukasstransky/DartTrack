import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/models/team.dart';
import 'package:dart_app/screens/game_modes/shared/game_settings/single_or_team_btn.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SingleOrTeamX01 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Selector<GameSettingsX01_P, SelectorModel>(
        selector: (_, gameSettingsX01) => SelectorModel(
          singleOrTeam: gameSettingsX01.getSingleOrTeam,
          players: gameSettingsX01.getPlayers,
          teams: gameSettingsX01.getTeams,
        ),
        builder: (_, selectorModel, __) =>
            SingleOrTeamBtn(settings: context.read<GameSettingsX01_P>()),
      ),
    );
  }
}

class SelectorModel {
  final SingleOrTeamEnum singleOrTeam;
  final List<Player> players;
  final List<Team> teams;

  SelectorModel({
    required this.singleOrTeam,
    required this.players,
    required this.teams,
  });
}
