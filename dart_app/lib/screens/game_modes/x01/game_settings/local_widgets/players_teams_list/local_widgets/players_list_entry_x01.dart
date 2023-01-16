import 'package:dart_app/constants.dart';
import 'package:dart_app/models/bot.dart';
import 'package:dart_app/models/game_settings/game_settings_p.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/screens/game_modes/x01/game_settings/local_widgets/players_teams_list/players_teams_list_dialogs_x01.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class PlayersListEntryX01 extends StatelessWidget {
  const PlayersListEntryX01(
      {Key? key,
      required Player this.player,
      required GameSettings_P this.gameSettings_P})
      : super(key: key);

  final Player player;
  final GameSettings_P gameSettings_P;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 4.w),
      height: 4.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 46.w,
            child: player is Bot
                ? FittedBox(
                    alignment: Alignment.centerLeft,
                    fit: BoxFit.scaleDown,
                    child: Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Level ${(player as Bot).getLevel} Bot',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.white,
                            ),
                          ),
                          Container(
                            transform:
                                Matrix4.translationValues(0.0, -0.5.w, 0.0),
                            child: Text(
                              ' (${(player as Bot).getPreDefinedAverage.round() - BOT_AVG_SLIDER_VALUE_RANGE}-${(player as Bot).getPreDefinedAverage.round() + BOT_AVG_SLIDER_VALUE_RANGE} avg.)',
                              style: TextStyle(
                                fontSize: 8.sp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      player.getName,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Utils.getTextColorForGameSettingsPage(),
                      ),
                    ),
                  ),
          ),
          Container(
            width: 30.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    Icons.edit,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  onPressed: () =>
                      PlayersTeamsListDialogsX01.showDialogForEditingPlayer(
                          context, player, gameSettings_P),
                ),
                IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    Icons.highlight_remove,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  onPressed: () => {
                    if (gameSettings_P is GameSettingsX01_P)
                      {
                        (gameSettings_P as GameSettingsX01_P)
                            .removePlayer(player, true),
                      }
                    else
                      {
                        gameSettings_P.getPlayers.remove(player),
                        gameSettings_P.notify(),
                      }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
