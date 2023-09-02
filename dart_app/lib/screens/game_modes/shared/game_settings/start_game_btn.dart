import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_cricket_p.dart';
import 'package:dart_app/models/game_settings/game_settings_score_training_p.dart';
import 'package:dart_app/models/game_settings/game_settings_single_double_training_p.dart';
import 'package:dart_app/models/team.dart';
import 'package:dart_app/screens/game_modes/cricket/game_settings/game_settings_c.dart';
import 'package:dart_app/services/auth_service.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:dart_app/utils/utils_dialogs.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class StartGameBtn extends StatelessWidget {
  const StartGameBtn({
    Key? key,
    required this.mode,
    this.selectorModel,
  }) : super(key: key);

  final GameMode mode;
  final SelectorModelStartGameBtnCricket? selectorModel;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: GAMESETTINGS_START_GAME_BTN_WIDTH.w,
          height: GAMESETTINGS_START_GAME_BTN_HEIGHT.h,
          child: ElevatedButton(
            onPressed: () {
              Utils.handleVibrationFeedback(context);
              _startGameBtnPressed(context);
            },
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
              backgroundColor: selectorModel == null ||
                      _activateStartGameBtn(selectorModel)
                  ? Utils.getPrimaryMaterialStateColorDarken(context)
                  : Utils.getColor(
                      Utils.darken(Theme.of(context).colorScheme.primary, 60),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  _startGameBtnPressed(BuildContext context) {
    final String currentUsername =
        context.read<AuthService>().getUsernameFromSharedPreferences() ?? '';

    if (mode == GameMode.ScoreTraining) {
      final GameSettingsScoreTraining_P gameSettingsScoreTraining =
          context.read<GameSettingsScoreTraining_P>();

      if (!gameSettingsScoreTraining.isCurrentUserInPlayers(context) &&
          currentUsername != 'Guest') {
        UtilsDialogs.showDialogNoUserInPlayerWarning(
            context, gameSettingsScoreTraining, mode);
      } else {
        Navigator.of(context).pushNamed(
          '/gameScoreTraining',
          arguments: {
            'openGame': false,
            'mode': mode,
          },
        );
      }
    } else if (mode == GameMode.SingleTraining ||
        mode == GameMode.DoubleTraining) {
      final GameSettingsSingleDoubleTraining_P
          gameSettingsSingleDoubleTraining =
          context.read<GameSettingsSingleDoubleTraining_P>();

      if (!gameSettingsSingleDoubleTraining.isCurrentUserInPlayers(context) &&
          currentUsername != 'Guest') {
        UtilsDialogs.showDialogNoUserInPlayerWarning(
            context, gameSettingsSingleDoubleTraining, mode);
      } else {
        Navigator.of(context).pushNamed(
          '/gameSingleDoubleTraining',
          arguments: {
            'openGame': false,
            'mode': mode.name,
          },
        );
      }
    } else if (mode == GameMode.Cricket) {
      final GameSettingsCricket_P gameSettingsCricket =
          context.read<GameSettingsCricket_P>();

      if (_activateStartGameBtn(selectorModel)) {
        if (!gameSettingsCricket.isCurrentUserInPlayers(context) &&
            currentUsername != 'Guest') {
          UtilsDialogs.showDialogNoUserInPlayerWarning(
              context, gameSettingsCricket, mode);
        } else {
          UtilsDialogs.showDialogForBeginner(
              context, gameSettingsCricket, mode);
        }
      } else {
        Fluttertoast.showToast(
          msg: 'At least two players are required!',
          toastLength: Toast.LENGTH_LONG,
          fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
        );
      }
    }
  }

  bool _activateStartGameBtn(SelectorModelStartGameBtnCricket? selectorModel) {
    if (selectorModel == null) {
      return false;
    }

    if (selectorModel.players.length < 2) {
      return false;
    } else if (selectorModel.singleOrTeam == SingleOrTeamEnum.Team) {
      if (_anyEmptyTeam(selectorModel.teams)) {
        return false;
      } else if (selectorModel.teams.length < 2) {
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
