import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_cricket_p.dart';
import 'package:dart_app/models/player.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Cricket settings',
        showInfoIconCricket: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            SingleOrTeamBtnCricket(),
            PlayersTeamsListCricket(),
            AddPlayerBtn(mode: GameMode.Cricket),
            ModeCricket(),
            BestOfOrFirstToCricket(),
            SetsLegsCricket(),
            StartGameBtn(mode: GameMode.Cricket),
          ],
        ),
      ),
    );
  }
}
