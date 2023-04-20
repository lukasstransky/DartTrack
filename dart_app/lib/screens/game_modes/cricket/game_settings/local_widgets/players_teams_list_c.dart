import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_cricket_p.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/models/team.dart';
import 'package:dart_app/screens/game_modes/shared/game_settings/players_teams_list/players_list/players_list.dart';
import 'package:dart_app/screens/game_modes/shared/game_settings/players_teams_list/teams_list/teams_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class PlayersTeamsListCricket extends StatelessWidget {
  const PlayersTeamsListCricket({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: WIDTH_GAMESETTINGS.w,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Selector<GameSettingsCricket_P, SingleOrTeamEnum>(
            selector: (_, gameSettingsCricket) =>
                gameSettingsCricket.getSingleOrTeam,
            builder: (_, singleOrTeam, __) {
              if (singleOrTeam == SingleOrTeamEnum.Single) {
                return Selector<GameSettingsCricket_P, List<Player>>(
                  selector: (_, gameSettingsCricket) =>
                      gameSettingsCricket.getPlayers,
                  shouldRebuild: (previous, next) => true,
                  builder: (_, players, __) => PlayersList(
                    mode: GameMode.Cricket,
                    players: players,
                  ),
                );
              } else {
                return Selector<GameSettingsCricket_P, SelectorModel>(
                  selector: (_, gameSettingsCricket) => SelectorModel(
                    teams: gameSettingsCricket.getTeams,
                    players: gameSettingsCricket.getPlayers,
                  ),
                  shouldRebuild: (previous, next) => true,
                  builder: (_, selectorModel, __) => TeamsList(
                    gameSettings: context.read<GameSettingsCricket_P>(),
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
