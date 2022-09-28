import 'package:dart_app/constants.dart';
import 'package:dart_app/models/bot.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class SingleOrTeam extends StatelessWidget {
  _switchSingleOrTeamMode(
      BuildContext context, GameSettingsX01 gameSettingsX01) async {
    final List<Player> players = gameSettingsX01.getPlayers;

    if (gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Single) {
      gameSettingsX01.setSingleOrTeam = SingleOrTeamEnum.Team;
      /*await Future.delayed(const Duration(milliseconds: 100));
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (scrollControllerTeams.hasClients)
          scrollControllerTeams.animateTo(
              scrollControllerTeams.position.maxScrollExtent,
              duration: Duration(milliseconds: 300),
              curve: Curves.fastOutSlowIn);
      });*/
    } else {
      final int countOfBotPlayers = gameSettingsX01.getCountOfBotPlayers();
      final int countOfGuestPlayers = players.length - countOfBotPlayers;

      if (countOfBotPlayers >= 1 && countOfGuestPlayers >= 2) {
        const String loggedInUser = '';
        // final String loggedInUser =
        //     context.read<AuthService>().getPlayer!.getName;
        List<Player> toRemove = [];

        for (int i = 2; i < players.length; i++) {
          if (players.elementAt(i).getName == loggedInUser)
            toRemove.add(players.elementAt(1));
          else
            toRemove.add(players.elementAt(i));
        }

        toRemove.forEach((player) => gameSettingsX01.removePlayer(
            player, false)); //to avoid concurrency problem
      }
      if (countOfBotPlayers == 2) {
        final Player playerToRemove = players
            .where((player) => player is Bot && player.getName == 'Bot2')
            .first;
        gameSettingsX01.removePlayer(playerToRemove, false);
      }

      gameSettingsX01.setSingleOrTeam = SingleOrTeamEnum.Single;
    }

    gameSettingsX01.notify();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Consumer<GameSettingsX01>(
        builder: (_, gameSettingsX01, __) => Container(
          width: WIDTH_GAMESETTINGS.w,
          height: Utils.getHeightForWidget(gameSettingsX01).h,
          margin: EdgeInsets.only(
              top: MARGIN_GAMESETTINGS.h, bottom: MARGIN_GAMESETTINGS.h),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(width: 1.0, color: Colors.white),
                    ),
                    color: Colors.white,
                  ),
                  child: ElevatedButton(
                    onPressed: () =>
                        gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Team
                            ? _switchSingleOrTeamMode(context, gameSettingsX01)
                            : null,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: const Text('Single'),
                    ),
                    style: ButtonStyle(
                      splashFactory: gameSettingsX01.getSingleOrTeam ==
                              SingleOrTeamEnum.Single
                          ? NoSplash.splashFactory
                          : InkRipple.splashFactory,
                      shadowColor:
                          MaterialStateProperty.all(Colors.transparent),
                      overlayColor: gameSettingsX01.getSingleOrTeam ==
                              SingleOrTeamEnum.Single
                          ? MaterialStateProperty.all(Colors.transparent)
                          : Utils.getDefaultOverlayColor(context),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(BUTTON_BORDER_RADIUS),
                            bottomLeft: Radius.circular(BUTTON_BORDER_RADIUS),
                          ),
                        ),
                      ),
                      backgroundColor: gameSettingsX01.getSingleOrTeam ==
                              SingleOrTeamEnum.Single
                          ? Utils.getColor(
                              Theme.of(context).colorScheme.primary)
                          : Utils.getColor(Colors.grey),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: ElevatedButton(
                    onPressed: () => gameSettingsX01.getSingleOrTeam ==
                            SingleOrTeamEnum.Single
                        ? _switchSingleOrTeamMode(context, gameSettingsX01)
                        : null,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: const Text('Teams'),
                    ),
                    style: ButtonStyle(
                      splashFactory: gameSettingsX01.getSingleOrTeam ==
                              SingleOrTeamEnum.Team
                          ? NoSplash.splashFactory
                          : InkRipple.splashFactory,
                      shadowColor:
                          MaterialStateProperty.all(Colors.transparent),
                      overlayColor: gameSettingsX01.getSingleOrTeam ==
                              SingleOrTeamEnum.Team
                          ? MaterialStateProperty.all(Colors.transparent)
                          : Utils.getDefaultOverlayColor(context),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(BUTTON_BORDER_RADIUS),
                            bottomRight: Radius.circular(BUTTON_BORDER_RADIUS),
                          ),
                        ),
                      ),
                      backgroundColor: gameSettingsX01.getSingleOrTeam ==
                              SingleOrTeamEnum.Team
                          ? Utils.getColor(
                              Theme.of(context).colorScheme.primary)
                          : Utils.getColor(Colors.grey),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
