import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/screens/game_modes/shared/game_settings/players_teams_list/players_list_entry.dart';
import 'package:dart_app/utils/globals.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class PlayersListX01 extends StatefulWidget {
  const PlayersListX01({Key? key}) : super(key: key);

  @override
  State<PlayersListX01> createState() => _PlayersListX01State();
}

class _PlayersListX01State extends State<PlayersListX01> {
  @override
  initState() {
    super.initState();
    newScrollControllerPlayers();
  }

  @override
  Widget build(BuildContext context) {
    return Selector<GameSettingsX01_P, List<Player>>(
      selector: (_, gameSettingsX01) => gameSettingsX01.getPlayers,
      shouldRebuild: (previous, next) => true,
      builder: (_, players, __) => ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 16.h),
        child: ListView.builder(
          shrinkWrap: true,
          controller: newScrollControllerPlayers(),
          reverse: true, // show new added player on top
          scrollDirection: Axis.vertical,
          itemCount: players.length,
          itemBuilder: (BuildContext context, int index) {
            return PlayersListEntry(
              player: players[index],
              settings: context.read<GameSettingsX01_P>(),
            );
          },
        ),
      ),
    );
  }
}
