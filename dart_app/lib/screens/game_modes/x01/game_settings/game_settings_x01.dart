import 'package:dart_app/constants.dart';
import 'package:dart_app/models/bot.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/game_settings/x01/helper/default_settings_helper.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/screens/game_modes/shared/game_settings/add_player_team_btn/add_player_btn.dart';
import 'package:dart_app/screens/game_modes/x01/game_settings/local_widgets/advanced_settings_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game_settings/local_widgets/bestof_or_first_to_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game_settings/local_widgets/checkout_counting_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game_settings/local_widgets/draw_mode_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game_settings/local_widgets/mode_in_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game_settings/local_widgets/mode_out_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game_settings/local_widgets/players_teams_list/players_teams_list_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game_settings/local_widgets/points_row/points_row_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game_settings/local_widgets/sets_or_legs/sets_legs_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game_settings/local_widgets/single_or_team_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game_settings/local_widgets/start_game_btn_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game_settings/local_widgets/win_by_two_legs_diff_x01.dart';
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
    disposeControllersForGamesettingsX01();
    super.dispose();
  }

  _addCurrentUserToPlayers() {
    final String username =
        context.read<AuthService>().getUsernameFromSharedPreferences() ?? '';
    final GameSettingsX01_P gameSettingsX01 = context.read<GameSettingsX01_P>();

    Future.delayed(Duration.zero, () {
      if (!gameSettingsX01.getPlayers.any((p) => p.getName == username)) {
        gameSettingsX01.addPlayer(Player(name: username));
      }
    });
  }

  bool _showAddButton(List<Player> players) {
    if ((players.any((player) => player is Bot) &&
            players.length >= 2 &&
            context.read<GameSettingsX01_P>().getSingleOrTeam ==
                SingleOrTeamEnum.Single) ||
        players.length >= MAX_PLAYERS_X01) {
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBarX01Settings(),
      body: SafeArea(
        child: Column(
          children: [
            SingleOrTeamX01(),
            PlayersTeamsListX01(),
            Selector<GameSettingsX01_P, List<Player>>(
              selector: (_, gameSettingsX01) => gameSettingsX01.getPlayers,
              shouldRebuild: (previous, next) => true,
              builder: (_, players, __) => _showAddButton(players)
                  ? AddPlayerBtn(mode: GameMode.X01)
                  : SizedBox.shrink(),
            ),
            Column(
              children: [
                ModeInX01(),
                ModeOutX01(),
                BestOfOrFirstToX01(),
                SetsLegsX01(),
                PointsRowX01(),
                WinByTwoLegsDifferenceX01(),
                CheckoutCountingX01(),
                DrawModeX01(),
                AdvancedSettingsX01(),
              ],
            ),
            StartGameBtnX01(),
          ],
        ),
      ),
    );
  }
}
