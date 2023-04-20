import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_cricket_p.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/models/team.dart';
import 'package:dart_app/screens/game_modes/shared/game_settings/single_or_team_btn.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SingleOrTeamBtnCricket extends StatelessWidget {
  const SingleOrTeamBtnCricket({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Selector<GameSettingsCricket_P, SelectorModel>(
        selector: (_, gameSettingsCricket) => SelectorModel(
          singleOrTeam: gameSettingsCricket.getSingleOrTeam,
          players: gameSettingsCricket.getPlayers,
          teams: gameSettingsCricket.getTeams,
        ),
        builder: (_, selectorModel, __) => SingleOrTeamBtn(
            gameSettingsProvider: context.read<GameSettingsCricket_P>()),
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
