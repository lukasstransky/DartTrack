import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/score_training/game_settings_score_training_p.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/screens/game_modes/x01/game_settings/local_widgets/players_teams_list/local_widgets/players_list_entry.dart';
import 'package:dart_app/utils/globals.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class PlayersListScoreTraining extends StatefulWidget {
  const PlayersListScoreTraining({Key? key}) : super(key: key);

  @override
  State<PlayersListScoreTraining> createState() =>
      _PlayersListScoreTrainingState();
}

class _PlayersListScoreTrainingState extends State<PlayersListScoreTraining> {
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
        constraints: BoxConstraints(maxHeight: 16.h),
        child: Selector<GameSettingsScoreTraining_P, List<Player>>(
          selector: (_, gameSettingsScoreTraining) =>
              gameSettingsScoreTraining.getPlayers,
          shouldRebuild: (previous, next) => true,
          builder: (_, players, __) => ListView.builder(
            shrinkWrap: true,
            controller: newScrollControllerPlayers(),
            reverse: true,
            scrollDirection: Axis.vertical,
            itemCount: players.length,
            itemBuilder: (BuildContext context, int index) {
              return PlayersListEntry(
                player: players[index],
                gameSettings_P: context.read<GameSettingsScoreTraining_P>(),
              );
            },
          ),
        ),
      ),
    );
  }
}
