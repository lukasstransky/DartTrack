import 'package:dart_app/constants.dart';
import 'package:dart_app/models/bot.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/screens/game_modes/x01/game_settings/local_widgets/players_teams_list/players_teams_list_dialogs.dart';
import 'package:dart_app/utils/globals.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class PlayersList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final gameSettingsX01 =
        Provider.of<GameSettingsX01>(context, listen: false);

    return Selector<GameSettingsX01, List<Player>>(
      selector: (_, gameSettingsX01) => gameSettingsX01.getPlayers,
      shouldRebuild: (previous, next) => true,
      builder: (_, players, __) => ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 20.h),
        child: ListView.builder(
          shrinkWrap: true,
          controller: scrollControllerPlayers,
          reverse: true, //show new added player on top
          scrollDirection: Axis.vertical,
          itemCount: gameSettingsX01.getPlayers.length,
          itemBuilder: (BuildContext context, int index) {
            final player = players[index];

            return ListTile(
              key: ValueKey(player),
              title: player is Bot
                  ? Row(
                      children: [
                        Text(
                          player.getName,
                          style: TextStyle(
                            fontSize: 12.sp,
                          ),
                        ),
                        Text(
                          ' (${player.getPreDefinedAverage.round() - BOT_AVG_SLIDER_VALUE_RANGE}-${player.getPreDefinedAverage.round() + BOT_AVG_SLIDER_VALUE_RANGE} avg.)',
                          style: TextStyle(
                            fontSize: 9.sp,
                          ),
                        ),
                      ],
                    )
                  : FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(player.getName),
                    ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () =>
                        PlayersTeamsListDialogs.showDialogForEditingPlayer(
                            context, player, gameSettingsX01),
                  ),
                  IconButton(
                    icon: Icon(Icons.highlight_remove),
                    onPressed: () => {
                      gameSettingsX01.checkBotNamingIds(player),
                      gameSettingsX01.removePlayer(player),
                    },
                  ),
                ],
              ),
              visualDensity: VisualDensity(horizontal: 0, vertical: -4),
            );
          },
        ),
      ),
    );
  }
}
