import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/models/team.dart';
import 'package:dart_app/services/auth_service.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:dart_app/utils/utils_dialogs.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class StartGameBtnX01 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String currentUsername =
        context.read<AuthService>().getUsernameFromSharedPreferences() ?? '';
    final GameSettingsX01_P gameSettingsX01 = context.read<GameSettingsX01_P>();

    return Container(
      width: GAMESETTINGS_START_GAME_BTN_WIDTH.w,
      height: GAMESETTINGS_START_GAME_BTN_HEIGHT.h,
      margin: context.read<GameSettingsX01_P>().getSafeAreaPadding.bottom > 0
          ? null
          : EdgeInsets.only(bottom: 1.h),
      child: Selector<GameSettingsX01_P, SelectorModel>(
        selector: (_, gameSettingsX01) => SelectorModel(
          players: gameSettingsX01.getPlayers,
          singleOrTeam: gameSettingsX01.getSingleOrTeam,
          teams: gameSettingsX01.getTeams,
        ),
        builder: (_, selectorModel, __) => TextButton(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'Start',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
              ),
            ),
          ),
          style: ButtonStyle(
            splashFactory: NoSplash.splashFactory,
            shadowColor: MaterialStateProperty.all(Colors.transparent),
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(BUTTON_BORDER_RADIUS),
                ),
              ),
            ),
            backgroundColor: _activateStartGameBtn(selectorModel)
                ? Utils.getPrimaryMaterialStateColorDarken(context)
                : Utils.getColor(
                    Utils.darken(Theme.of(context).colorScheme.primary, 60)),
          ),
          onPressed: () {
            Utils.handleVibrationFeedback(context);
            if (_activateStartGameBtn(selectorModel)) {
              if (!gameSettingsX01.isCurrentUserInPlayers(context) &&
                  currentUsername != 'Guest') {
                UtilsDialogs.showDialogNoUserInPlayerWarning(
                    context, gameSettingsX01, GameMode.X01);
              } else {
                UtilsDialogs.showDialogForBeginner(
                    context, gameSettingsX01, GameMode.X01);
              }
            } else {
              String msg = '';
              if (gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Team) {
                if (_anyEmptyTeam(gameSettingsX01.getTeams)) {
                  msg = 'Empty teams are not allowed!';
                } else if (gameSettingsX01.getTeams.length == 1) {
                  msg = 'At least two teams are required!';
                } else if (_areAllTeamsWithSinglePlayer(
                    gameSettingsX01.getTeams)) {
                  msg = 'At least one team must have a minimum of two players!';
                }
              } else {
                msg = 'At least two players are required!';
              }

              Fluttertoast.showToast(
                msg: msg,
                toastLength: Toast.LENGTH_LONG,
                fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
              );
            }
          },
        ),
      ),
    );
  }

  bool _areAllTeamsWithSinglePlayer(List<Team> teams) {
    for (Team team in teams) {
      if (team.getPlayers.length > 1) {
        return false;
      }
    }
    return true;
  }

  bool _activateStartGameBtn(SelectorModel selectorModel) {
    if (selectorModel.players.length < 2) {
      return false;
    } else if (selectorModel.singleOrTeam == SingleOrTeamEnum.Team) {
      if (_anyEmptyTeam(selectorModel.teams)) {
        return false;
      } else if (selectorModel.teams.length < 2) {
        return false;
      } else if (_areAllTeamsWithSinglePlayer(selectorModel.teams)) {
        return false;
      }
    }

    return true;
  }

  bool _anyEmptyTeam(List<Team> teams) {
    for (Team team in teams) {
      if (team.getPlayers.isEmpty) {
        return true;
      }
    }

    return false;
  }
}

class SelectorModel {
  final List<Player> players;
  final SingleOrTeamEnum singleOrTeam;
  final List<Team> teams;

  SelectorModel(
      {required this.players, required this.singleOrTeam, required this.teams});
}
