import 'package:dart_app/constants.dart';
import 'package:dart_app/models/bot.dart';
import 'package:dart_app/models/game_settings/game_settings_cricket_p.dart';
import 'package:dart_app/models/game_settings/game_settings_p.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/screens/game_modes/x01/game_settings/local_widgets/players_teams_list/players_teams_list_dialogs_x01.dart';
import 'package:dart_app/services/auth_service.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class PlayersListEntry extends StatelessWidget {
  const PlayersListEntry(
      {Key? key,
      required Player this.player,
      required GameSettings_P this.settings})
      : super(key: key);

  final Player player;
  final GameSettings_P settings;

  @override
  Widget build(BuildContext context) {
    final String currentUsername =
        context.read<AuthService>().getUsernameFromSharedPreferences() ?? '';

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
                            'Bot - lvl. ${(player as Bot).getLevel}',
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
                        fontWeight: player.getName == currentUsername
                            ? FontWeight.bold
                            : null,
                      ),
                    ),
                  ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  padding: EdgeInsets.zero,
                  iconSize: ICON_BUTTON_SIZE.h,
                  icon: Icon(
                    Icons.edit,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  onPressed: () {
                    Utils.handleVibrationFeedback(context);
                    PlayersTeamsListDialogs.showDialogForEditingPlayer(
                        context, player, settings);
                  },
                ),
                IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  padding: EdgeInsets.zero,
                  iconSize: ICON_BUTTON_SIZE.h,
                  icon: Icon(
                    Icons.highlight_remove,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  onPressed: () {
                    Utils.handleVibrationFeedback(context);
                    if (settings is GameSettingsX01_P ||
                        settings is GameSettingsCricket_P) {
                      settings.removePlayer(player, true, true);
                    } else {
                      settings.getPlayers.remove(player);
                      settings.notify();
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
