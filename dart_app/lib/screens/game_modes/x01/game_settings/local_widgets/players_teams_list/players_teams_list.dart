import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game_settings/local_widgets/players_teams_list/local_widgets/players_list.dart';
import 'package:dart_app/screens/game_modes/x01/game_settings/local_widgets/players_teams_list/local_widgets/teams_list.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class PlayersTeamsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: WIDTH_GAMESETTINGS.w,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Selector<GameSettingsX01, SingleOrTeamEnum>(
            selector: (_, gameSettingsX01) => gameSettingsX01.getSingleOrTeam,
            builder: (_, singleOrTeam, __) {
              if (singleOrTeam == SingleOrTeamEnum.Single)
                return PlayersList();
              else
                return TeamsList();
            },
          ),
        ],
      ),
    );
  }
}
