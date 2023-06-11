import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_cricket_p.dart';
import 'package:dart_app/models/game_settings/game_settings_score_training_p.dart';
import 'package:dart_app/models/game_settings/game_settings_single_double_training_p.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/team.dart';
import 'package:dart_app/screens/game_modes/shared/game_settings/add_player_team_btn/add_player_team_btn_dialogs.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class AddPlayerBtn extends StatelessWidget {
  const AddPlayerBtn({Key? key, required this.mode}) : super(key: key);

  final GameMode mode;

  bool _shouldShowOnlyDialogForAddingTeam(dynamic settings) {
    if (settings.getPlayers.length >= 8) {
      return true;
    }

    for (Team team in settings.getTeams) {
      if (team.getPlayers.length < MAX_PLAYERS_PER_TEAM) {
        return false;
      }
    }

    return true;
  }

  _addPlayerTeamBtnPressed(dynamic settings, BuildContext context) {
    if (settings.getSingleOrTeam == SingleOrTeamEnum.Single ||
        settings.getTeams.length == MAX_TEAMS) {
      AddPlayerTeamBtnDialogs.showDialogForAddingPlayer(settings, context);
    } else if (settings.getSingleOrTeam == SingleOrTeamEnum.Team &&
        _shouldShowOnlyDialogForAddingTeam(settings)) {
      AddPlayerTeamBtnDialogs.showDialogForAddingTeam(settings, context);
    } else {
      AddPlayerTeamBtnDialogs.showDialogForAddingPlayerOrTeam(
          settings, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10.w,
      padding: EdgeInsets.only(bottom: 0.5.h),
      child: Theme(
        data: Theme.of(context).copyWith(
            highlightColor: Colors.transparent,
            shadowColor: Colors.transparent),
        child: FloatingActionButton(
          splashColor: Colors.transparent,
          backgroundColor: Utils.getPrimaryColorDarken(context),
          elevation: 0.0,
          onPressed: () {
            switch (mode) {
              case GameMode.X01:
                _addPlayerTeamBtnPressed(
                    context.read<GameSettingsX01_P>(), context);
                break;
              case GameMode.ScoreTraining:
                AddPlayerTeamBtnDialogs.showDialogForAddingPlayer(
                    context.read<GameSettingsScoreTraining_P>(), context);
                break;
              case GameMode.SingleTraining:
                AddPlayerTeamBtnDialogs.showDialogForAddingPlayer(
                    context.read<GameSettingsSingleDoubleTraining_P>(),
                    context);
                break;
              case GameMode.DoubleTraining:
                AddPlayerTeamBtnDialogs.showDialogForAddingPlayer(
                    context.read<GameSettingsSingleDoubleTraining_P>(),
                    context);
                break;
              case GameMode.Cricket:
                _addPlayerTeamBtnPressed(
                    context.read<GameSettingsCricket_P>(), context);
                break;
            }
          },
          child: Icon(
            Icons.add,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ),
    );
  }
}
