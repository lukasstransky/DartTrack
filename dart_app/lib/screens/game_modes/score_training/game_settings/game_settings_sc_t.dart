import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_score_training_p.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/screens/game_modes/score_training/game_settings/local_widgets/mode_sc_t.dart';
import 'package:dart_app/screens/game_modes/score_training/game_settings/local_widgets/rounds_or_points_input_sc_t.dart';
import 'package:dart_app/screens/game_modes/shared/game_settings/players_teams_list/players_list/players_list.dart';
import 'package:dart_app/screens/game_modes/shared/game_settings/start_game_btn.dart';
import 'package:dart_app/screens/game_modes/shared/game_settings/add_player_team_btn/add_player_btn.dart';
import 'package:dart_app/services/auth_service.dart';
import 'package:dart_app/utils/app_bars/custom_app_bar.dart';
import 'package:dart_app/utils/globals.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameSettingsScoreTraining extends StatefulWidget {
  static const routeName = '/settingsScoreTraining';

  const GameSettingsScoreTraining({Key? key}) : super(key: key);

  @override
  State<GameSettingsScoreTraining> createState() =>
      _GameSettingsScoreTrainingState();
}

class _GameSettingsScoreTrainingState extends State<GameSettingsScoreTraining> {
  @override
  void initState() {
    _addCurrentUserToPlayers();
    super.initState();
  }

  @override
  void dispose() {
    disposeControllersForGamesettingsScoreTraining();
    super.dispose();
  }

  _addCurrentUserToPlayers() {
    final GameSettingsScoreTraining_P settings =
        context.read<GameSettingsScoreTraining_P>();
    final String username =
        context.read<AuthService>().getUsernameFromSharedPreferences() ?? '';

    settings.reset();
    Future.delayed(Duration.zero, () {
      if (!settings.getPlayers.any((p) => p.getName == username)) {
        settings.getPlayers.add(Player(name: username));
        settings.notify();
      }
    });
    settings.setLoggedInPlayerToFirstOne(username);
  }

  @override
  Widget build(BuildContext context) {
    context.read<GameSettingsScoreTraining_P>().setSafeAreaPadding =
        MediaQuery.of(context).padding;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        title: 'Settings',
        showInfoIconScoreTraining: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Selector<GameSettingsScoreTraining_P, List<Player>>(
                      selector: (_, gameSettingsScoreTraining) =>
                          gameSettingsScoreTraining.getPlayers,
                      shouldRebuild: (previous, next) => true,
                      builder: (_, players, __) => Column(
                        children: [
                          PlayersList(
                            mode: GameMode.ScoreTraining,
                            players: players,
                          ),
                          if (players.length <
                              MAX_PLAYERS_SINGLE_DOUBLE_SCORE_TRAINING)
                            AddPlayerBtn(mode: GameMode.ScoreTraining),
                        ],
                      ),
                    ),
                    ModeScoreTraining(),
                    RoundsOrPointsInputScoreTraining(),
                  ],
                ),
              ),
            ),
            StartGameBtn(mode: GameMode.ScoreTraining),
          ],
        ),
      ),
    );
  }
}
