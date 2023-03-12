import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_score_training_p.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/screens/game_modes/score_training/game_settings/local_widgets/mode_sc_t.dart';
import 'package:dart_app/screens/game_modes/shared/game_settings/players_teams_list/players_list.dart';
import 'package:dart_app/screens/game_modes/score_training/game_settings/local_widgets/rounds_or_points_input_sc_t.dart';
import 'package:dart_app/screens/game_modes/shared/game_settings/start_game_btn.dart';
import 'package:dart_app/screens/game_modes/shared/game_settings/add_player_team_btn/add_player_btn.dart';
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
    final settings = context.read<GameSettingsScoreTraining_P>();

    settings.reset();
    //todo add current logged in user
    if (!settings.getPlayers.any((p) => p.getName == 'Strainski')) {
      settings.getPlayers.add(new Player(name: 'Strainski'));
    }

    super.initState();
  }

  @override
  void dispose() {
    disposeControllersForGamesettingsScoreTraining();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        title: 'Score training settings',
        showInfoIcon: true,
      ),
      body: SafeArea(
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
                  if (players.length < MAX_PLAYERS_SINGLE_DOUBLE_SCORE_TRAINING)
                    AddPlayerBtn(mode: GameMode.ScoreTraining),
                ],
              ),
            ),
            ModeScoreTraining(),
            RoundsOrPointsInputScoreTraining(),
            StartGameBtn(mode: GameMode.ScoreTraining),
          ],
        ),
      ),
    );
  }
}
