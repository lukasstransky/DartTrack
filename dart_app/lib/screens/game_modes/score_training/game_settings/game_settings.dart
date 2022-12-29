import 'package:dart_app/models/game_settings/score_training/game_settings_score_training_p.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/screens/game_modes/score_training/game_settings/local_widgets/add_player_btn.dart';
import 'package:dart_app/screens/game_modes/score_training/game_settings/local_widgets/mode.dart';
import 'package:dart_app/screens/game_modes/score_training/game_settings/local_widgets/players_list.dart';
import 'package:dart_app/screens/game_modes/score_training/game_settings/local_widgets/rounds_or_points_input.dart';
import 'package:dart_app/screens/game_modes/score_training/game_settings/local_widgets/start_game_btn.dart';
import 'package:dart_app/utils/app_bars/custom_app_bar.dart';

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
    final GameSettingsScoreTraining_P gameSettingsScoreTraining =
        context.read<GameSettingsScoreTraining_P>();

    gameSettingsScoreTraining.reset();
    //todo add current logged in user
    if (!gameSettingsScoreTraining.getPlayers
        .any((p) => p.getName == 'Strainski')) {
      gameSettingsScoreTraining.getPlayers.add(new Player(name: 'Strainski'));
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar:
          CustomAppBar(title: 'Score Training Settings', showInfoIcon: true),
      body: SafeArea(
        child: Column(
          children: [
            PlayersListScoreTraining(),
            AddPlayerBtnScoreTraining(),
            ModeScoreTraining(),
            RoundsOrPointsInput(),
            StartGameBtnScoreTraining(),
          ],
        ),
      ),
    );
  }
}
