import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_cricket_p.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/models/team.dart';
import 'package:dart_app/screens/game_modes/cricket/game_settings/local_widgets/best_of_or_first_to_c.dart';
import 'package:dart_app/screens/game_modes/cricket/game_settings/local_widgets/mode_c.dart';
import 'package:dart_app/screens/game_modes/cricket/game_settings/local_widgets/players_teams_list_c.dart';
import 'package:dart_app/screens/game_modes/cricket/game_settings/local_widgets/sets_legs_c.dart';
import 'package:dart_app/screens/game_modes/cricket/game_settings/local_widgets/single_or_team_c.dart';
import 'package:dart_app/screens/game_modes/shared/game_settings/add_player_team_btn/add_player_btn.dart';
import 'package:dart_app/screens/game_modes/shared/game_settings/start_game_btn.dart';
import 'package:dart_app/services/auth_service.dart';
import 'package:dart_app/utils/app_bars/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameSettingsCricket extends StatefulWidget {
  static const routeName = '/settingsCricket';

  const GameSettingsCricket({Key? key}) : super(key: key);

  @override
  State<GameSettingsCricket> createState() => _GameSettingsCricketState();
}

class _GameSettingsCricketState extends State<GameSettingsCricket> {
  @override
  void initState() {
    super.initState();
    _addCurrentUserToPlayers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Settings',
        showInfoIconCricket: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            SingleOrTeamBtnCricket(),
            PlayersTeamsListCricket(),
            Selector<GameSettingsCricket_P, SelectorModelAddPlayerBtn>(
                selector: (_, gameSettingsCricket) => SelectorModelAddPlayerBtn(
                      players: gameSettingsCricket.getPlayers,
                      singleOrTeam: gameSettingsCricket.getSingleOrTeam,
                      teams: gameSettingsCricket.getTeams,
                    ),
                builder: (_, selectorModel, __) =>
                    _showAddPlayerTeamBtn(selectorModel)
                        ? AddPlayerBtn(mode: GameMode.Cricket)
                        : SizedBox.shrink()),
            ModeCricket(),
            BestOfOrFirstToCricket(),
            SetsLegsCricket(),
            Selector<GameSettingsCricket_P, SelectorModelStartGameBtnCricket>(
              selector: (_, gameSettingsCricket) =>
                  SelectorModelStartGameBtnCricket(
                players: gameSettingsCricket.getPlayers,
                singleOrTeam: gameSettingsCricket.getSingleOrTeam,
                teams: gameSettingsCricket.getTeams,
              ),
              builder: (_, selectorModel, __) => StartGameBtn(
                  mode: GameMode.Cricket, selectorModel: selectorModel),
            ),
          ],
        ),
      ),
    );
  }

  bool _showAddPlayerTeamBtn(SelectorModelAddPlayerBtn selectorModel) {
    if (selectorModel.singleOrTeam == SingleOrTeamEnum.Single) {
      if (selectorModel.players.length == MAX_PLAYERS_CRICKET) {
        return false;
      }
    } else {
      if (selectorModel.players.length == MAX_PLAYERS_CRICKET_TEAM_MODE) {
        return false;
      }
    }

    return true;
  }

  _addCurrentUserToPlayers() {
    final String username =
        context.read<AuthService>().getUsernameFromSharedPreferences() ?? '';
    final GameSettingsCricket_P gameSettingsCricket =
        context.read<GameSettingsCricket_P>();

    gameSettingsCricket.reset();
    Future.delayed(Duration.zero, () {
      if (!gameSettingsCricket.getPlayers.any((p) => p.getName == username)) {
        gameSettingsCricket.addPlayer(Player(name: username));
        gameSettingsCricket.notify();
      }
    });
    gameSettingsCricket.setLoggedInPlayerToFirstOne(username);
  }
}

class SelectorModelStartGameBtnCricket {
  final List<Player> players;
  final SingleOrTeamEnum singleOrTeam;
  final List<Team> teams;

  SelectorModelStartGameBtnCricket({
    required this.players,
    required this.singleOrTeam,
    required this.teams,
  });
}

class SelectorModelAddPlayerBtn {
  final List<Player> players;
  final SingleOrTeamEnum singleOrTeam;
  final List<Team> teams;

  SelectorModelAddPlayerBtn({
    required this.players,
    required this.singleOrTeam,
    required this.teams,
  });
}
