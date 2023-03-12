import 'package:dart_app/constants.dart';
import 'package:dart_app/models/bot.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/services/auth_service.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class SingleOrTeamX01 extends StatelessWidget {
  _switchSingleOrTeamMode(
      BuildContext context, GameSettingsX01_P gameSettingsX01) async {
    final List<Player> players = gameSettingsX01.getPlayers;

    if (gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Single) {
      gameSettingsX01.setSingleOrTeam = SingleOrTeamEnum.Team;
    } else {
      final int countOfBotPlayers = gameSettingsX01.getCountOfBotPlayers();
      final int countOfGuestPlayers = players.length - countOfBotPlayers;

      if (countOfBotPlayers >= 1 && countOfGuestPlayers >= 2) {
        final String username =
            context.read<AuthService>().getUsernameFromSharedPreferences() ??
                '';
        List<Player> toRemove = [];

        for (int i = 2; i < players.length; i++) {
          if (players.elementAt(i).getName == username) {
            toRemove.add(players.elementAt(1));
          } else {
            toRemove.add(players.elementAt(i));
          }
        }

        toRemove.forEach((player) => gameSettingsX01.removePlayer(
            player, false)); // to avoid concurrency problem
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
      child: Consumer<GameSettingsX01_P>(
        builder: (_, gameSettingsX01, __) => Container(
          width: WIDTH_GAMESETTINGS.w,
          height: Utils.getHeightForWidget(gameSettingsX01).h,
          margin: EdgeInsets.only(
              top: MARGIN_GAMESETTINGS.h, bottom: MARGIN_GAMESETTINGS.h),
          child: Row(
            children: [
              SingleBtn(switchSingleOrTeamMode: _switchSingleOrTeamMode),
              TeamBtn(switchSingleOrTeamMode: _switchSingleOrTeamMode),
            ],
          ),
        ),
      ),
    );
  }
}

class SingleBtn extends StatelessWidget {
  const SingleBtn({Key? key, required Function this.switchSingleOrTeamMode})
      : super(key: key);

  final Function switchSingleOrTeamMode;

  @override
  Widget build(BuildContext context) {
    final GameSettingsX01_P gameSettings = context.read<GameSettingsX01_P>();
    final bool isSingle =
        gameSettings.getSingleOrTeam == SingleOrTeamEnum.Single;

    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          if (!isSingle) {
            switchSingleOrTeamMode(context, gameSettings);
          }
        },
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'Single ${gameSettings.getSingleOrTeam == SingleOrTeamEnum.Single ? '(${gameSettings.getPlayers.length})' : ''}',
            style: TextStyle(
              color: Utils.getTextColorForGameSettingsBtn(isSingle, context),
            ),
          ),
        ),
        style: ButtonStyle(
          splashFactory: NoSplash.splashFactory,
          shadowColor: MaterialStateProperty.all(Colors.transparent),
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              side: BorderSide(
                color: Utils.getPrimaryColorDarken(context),
                width: GAME_SETTINGS_BTN_BORDER_WITH,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(BUTTON_BORDER_RADIUS),
                bottomLeft: Radius.circular(BUTTON_BORDER_RADIUS),
              ),
            ),
          ),
          backgroundColor: isSingle
              ? Utils.getPrimaryMaterialStateColorDarken(context)
              : Utils.getColor(Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }
}

class TeamBtn extends StatelessWidget {
  const TeamBtn({Key? key, required Function this.switchSingleOrTeamMode})
      : super(key: key);

  final Function switchSingleOrTeamMode;

  @override
  Widget build(BuildContext context) {
    final GameSettingsX01_P gameSettings = context.read<GameSettingsX01_P>();
    final bool isTeam = gameSettings.getSingleOrTeam == SingleOrTeamEnum.Team;

    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          if (!isTeam) {
            switchSingleOrTeamMode(context, gameSettings);
          }
        },
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'Team ${gameSettings.getSingleOrTeam == SingleOrTeamEnum.Team ? '(${gameSettings.getTeams.length})' : ''}',
            style: TextStyle(
              color: Utils.getTextColorForGameSettingsBtn(isTeam, context),
            ),
          ),
        ),
        style: ButtonStyle(
          splashFactory: NoSplash.splashFactory,
          shadowColor: MaterialStateProperty.all(Colors.transparent),
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              side: BorderSide(
                color: Utils.getPrimaryColorDarken(context),
                width: GAME_SETTINGS_BTN_BORDER_WITH,
              ),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(BUTTON_BORDER_RADIUS),
                bottomRight: Radius.circular(BUTTON_BORDER_RADIUS),
              ),
            ),
          ),
          backgroundColor: isTeam
              ? Utils.getPrimaryMaterialStateColorDarken(context)
              : Utils.getColor(Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }
}
