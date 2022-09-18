import 'package:dart_app/models/default_settings_x01.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/screens/game_modes/x01/game_settings/local_widgets/add_player_team_btn/add_player_team_btn.dart';
import 'package:dart_app/screens/game_modes/x01/game_settings/local_widgets/advanced_settings.dart';
import 'package:dart_app/screens/game_modes/x01/game_settings/local_widgets/bestof_or_first_to.dart';
import 'package:dart_app/screens/game_modes/x01/game_settings/local_widgets/checkout_counting.dart';
import 'package:dart_app/screens/game_modes/x01/game_settings/local_widgets/draw_mode.dart';
import 'package:dart_app/screens/game_modes/x01/game_settings/local_widgets/mode_in.dart';
import 'package:dart_app/screens/game_modes/x01/game_settings/local_widgets/mode_out.dart';
import 'package:dart_app/screens/game_modes/x01/game_settings/local_widgets/players_teams_list/players_teams_list.dart';
import 'package:dart_app/screens/game_modes/x01/game_settings/local_widgets/points_row/points_row.dart';
import 'package:dart_app/screens/game_modes/x01/game_settings/local_widgets/sets_or_legs/sets_legs.dart';
import 'package:dart_app/screens/game_modes/x01/game_settings/local_widgets/single_or_team.dart';
import 'package:dart_app/screens/game_modes/x01/game_settings/local_widgets/start_game_btn.dart';
import 'package:dart_app/screens/game_modes/x01/game_settings/local_widgets/win_by_two_legs_diff.dart';
import 'package:dart_app/services/auth_service.dart';
import 'package:dart_app/utils/app_bars/custom_app_bar_x01_settings.dart';
import 'package:dart_app/utils/globals.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameSettings extends StatefulWidget {
  static const routeName = '/settingsX01';

  @override
  _GameSettingsState createState() => _GameSettingsState();
}

class _GameSettingsState extends State<GameSettings> {
  @override
  void initState() {
    super.initState();
    Provider.of<GameSettingsX01>(context, listen: false)
        .setSettingsFromDefault(context);
    addCurrentUserToPlayers();

    /*Provider.of<GameSettingsX01>(context, listen: false)
        .addPlayer(new Player(name: 'Strainski'));*/
  }

  @override
  void dispose() {
    disposeScrollControllersForGamesettings();
    super.dispose();
  }

  void addCurrentUserToPlayers() {
    final Player? currentUserAsPlayer = context.read<AuthService>().getPlayer;
    final gameSettingsX01 =
        Provider.of<GameSettingsX01>(context, listen: false);
    final defaultSettingsX01 =
        Provider.of<DefaultSettingsX01>(context, listen: false);

    if (currentUserAsPlayer != null) {
      defaultSettingsX01.playersNames.add(currentUserAsPlayer.getName);
    }

    //check if user already inserted -> in case of switching between other screen -> would get inserted multiple times
    if (currentUserAsPlayer != null &&
        !gameSettingsX01.checkIfPlayerAlreadyInserted(currentUserAsPlayer)) {
      Player toAdd = new Player(name: currentUserAsPlayer.getName);
      Future.delayed(Duration.zero, () {
        gameSettingsX01.addPlayer(toAdd);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBarX01Settings(),
      body: SafeArea(
        child: Column(
          children: [
            SingleOrTeam(),
            PlayersTeamsList(),
            AddPlayerTeamBtn(),
            Column(
              children: [
                ModeIn(),
                ModeOut(),
                BestOfOrFirstTo(),
                SetsLegs(),
                PointsRow(),
                WinByTwoLegsDifference(),
                CheckoutCounting(),
                DrawMode(),
                AdvancedSettings(),
              ],
            ),
            StartGameBtn(),
          ],
        ),
      ),
    );
  }
}
