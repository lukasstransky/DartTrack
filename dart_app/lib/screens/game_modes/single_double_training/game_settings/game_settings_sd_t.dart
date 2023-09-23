import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_single_double_training_p.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/screens/game_modes/shared/game_settings/add_player_team_btn/add_player_btn.dart';
import 'package:dart_app/screens/game_modes/shared/game_settings/players_teams_list/players_list/players_list.dart';
import 'package:dart_app/screens/game_modes/shared/game_settings/start_game_btn.dart';
import 'package:dart_app/screens/game_modes/single_double_training/game_settings/local_widgets/amount_of_rounds_for_target_sd_t.dart';
import 'package:dart_app/screens/game_modes/single_double_training/game_settings/local_widgets/game_info_sd_t.dart';
import 'package:dart_app/screens/game_modes/single_double_training/game_settings/local_widgets/mode_sd_t.dart';
import 'package:dart_app/screens/game_modes/single_double_training/game_settings/local_widgets/point_distribution_info_sd_t.dart';
import 'package:dart_app/screens/game_modes/single_double_training/game_settings/local_widgets/target_number_sd_t.dart';
import 'package:dart_app/services/auth_service.dart';
import 'package:dart_app/utils/app_bars/custom_app_bar.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameSettingsSingleDoubleTraining extends StatefulWidget {
  static const routeName = '/settingsSingleDoubleTraining';

  const GameSettingsSingleDoubleTraining({Key? key}) : super(key: key);

  @override
  State<GameSettingsSingleDoubleTraining> createState() =>
      _GameSettingsSingleDoubleTrainingState();
}

class _GameSettingsSingleDoubleTrainingState
    extends State<GameSettingsSingleDoubleTraining> {
  GameMode _mode = GameMode.SingleTraining;

  @override
  void initState() {
    _addCurrentUserToPlayers();
    super.initState();
  }

  _addCurrentUserToPlayers() {
    final String username =
        context.read<AuthService>().getUsernameFromSharedPreferences() ?? '';
    final GameSettingsSingleDoubleTraining_P settings =
        context.read<GameSettingsSingleDoubleTraining_P>();
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Map arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    if (arguments.isNotEmpty) {
      _mode = arguments['mode'];
    }
  }

  @override
  Widget build(BuildContext context) {
    context.read<GameSettingsSingleDoubleTraining_P>().setSafeAreaPadding =
        MediaQuery.of(context).padding;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        title: 'Settings',
        gameMode: _mode,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Selector<GameSettingsSingleDoubleTraining_P, List<Player>>(
                      selector: (_, gameSettingsScoreTraining) =>
                          gameSettingsScoreTraining.getPlayers,
                      shouldRebuild: (previous, next) => true,
                      builder: (_, players, __) => Column(
                        children: [
                          PlayersList(
                            mode: GameMode.SingleTraining,
                            players: players,
                          ),
                          if (players.length <
                              MAX_PLAYERS_SINGLE_DOUBLE_SCORE_TRAINING)
                            AddPlayerBtn(mode: _mode),
                        ],
                      ),
                    ),
                    ModeSingleDoubleTraining(),
                    GameInfoSingleDoubleTraining(gameMode: _mode),
                    PointDistributionInfoSingleDoubleTraining(gameMode: _mode),
                    TargetNumberSingleDoubleTraining(gameMode: _mode),
                    AmountOfRoundsForTargetNumberSingleDoubleTraining(),
                  ],
                ),
              ),
            ),
            StartGameBtn(mode: _mode),
          ],
        ),
      ),
    );
  }
}
