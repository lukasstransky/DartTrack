import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_p.dart';
import 'package:dart_app/models/game_settings/game_settings_score_training_p.dart';
import 'package:dart_app/models/game_settings/game_settings_single_double_training_p.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/screens/game_modes/shared/game_settings/players_teams_list/players_list_entry.dart';
import 'package:dart_app/utils/globals.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class PlayersList extends StatefulWidget {
  const PlayersList({Key? key, required this.mode, required this.players})
      : super(key: key);

  final GameMode mode;
  final List<Player> players;

  @override
  State<PlayersList> createState() => _PlayersListState();
}

class _PlayersListState extends State<PlayersList> {
  @override
  initState() {
    super.initState();
    newScrollControllerPlayers();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: WIDTH_GAMESETTINGS.w,
      child: ConstrainedBox(
        constraints: BoxConstraints(
            maxHeight: widget.mode == GameMode.X01 ? 16.h : 20.h),
        child: ListView.builder(
          shrinkWrap: true,
          controller: newScrollControllerPlayers(),
          reverse: true,
          scrollDirection: Axis.vertical,
          itemCount: widget.players.length,
          itemBuilder: (BuildContext context, int index) {
            late GameSettings_P settings;
            switch (widget.mode) {
              case GameMode.X01:
                break;
              case GameMode.ScoreTraining:
                settings = context.read<GameSettingsScoreTraining_P>();
                break;
              case GameMode.SingleTraining:
                settings = context.read<GameSettingsSingleDoubleTraining_P>();
                break;
              case GameMode.DoubleTraining:
                settings = context.read<GameSettingsSingleDoubleTraining_P>();
                break;
              case GameMode.Cricket:
                break;
            }
            return PlayersListEntry(
              player: widget.players[index],
              settings: settings,
            );
          },
        ),
      ),
    );
  }
}
