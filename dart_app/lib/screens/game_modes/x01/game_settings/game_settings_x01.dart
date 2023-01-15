import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/game_settings/x01/helper/default_settings_helper.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/screens/game_modes/x01/game_settings/local_widgets/add_player_team_btn/add_player_team_btn_x01.dart';
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
import 'package:dart_app/screens/game_modes/x01/game_settings/local_widgets/start_game_btn_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game_settings/local_widgets/win_by_two_legs_diff.dart';
import 'package:dart_app/services/auth_service.dart';
import 'package:dart_app/utils/app_bars/x01/custom_app_bar_x01_settings.dart';
import 'package:dart_app/utils/globals.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameSettingsX01 extends StatefulWidget {
  static const routeName = '/settingsX01';

  @override
  _GameSettingsX01State createState() => _GameSettingsX01State();
}

class _GameSettingsX01State extends State<GameSettingsX01> {
  @override
  initState() {
    super.initState();
    DefaultSettingsHelper.setSettingsFromDefault(context);
    _addCurrentUserToPlayers();
  }

  @override
  dispose() {
    disposeScrollControllersForGamesettings();
    super.dispose();
  }

  _addCurrentUserToPlayers() {
    final Player? currentUserAsPlayer = context.read<AuthService>().getPlayer;
    final GameSettingsX01_P gameSettingsX01 = context.read<GameSettingsX01_P>();

    gameSettingsX01.getPlayers.add(new Player(name: 'Strainski'));
    //todo comment out
    /* if (currentUserAsPlayer != null) {
      final Player toAdd = new Player(name: currentUserAsPlayer.getName);

      Future.delayed(Duration.zero, () {
        gameSettingsX01.addPlayer(toAdd);
      });
    } */
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
            PlayersTeamsListX01(),
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
            StartGameBtnX01(),
          ],
        ),
      ),
    );
  }
}
