import 'package:dart_app/constants.dart';
import 'package:dart_app/models/bot.dart';
import 'package:dart_app/models/game_settings/game_settings_cricket_p.dart';
import 'package:dart_app/models/game_settings/game_settings_p.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/models/team.dart';
import 'package:dart_app/utils/button_styles.dart';
import 'package:dart_app/utils/globals.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class PlayersTeamsListDialogs {
  static final GlobalKey<FormState> _formKeyEditPlayer = GlobalKey<FormState>();
  static final GlobalKey<FormState> _formKeyEditTeam = GlobalKey<FormState>();

  static _editBotAvg(
      GameSettingsX01_P gameSettingsX01, Bot botToEdit, dynamic newValue) {
    // player from team is not the same refernce as in the single players list, therefore also needs to be updated and vice versa
    if (gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Team) {
      Player? playerFromSingles =
          gameSettingsX01.getPlayerFromSingles(botToEdit.getName);
      if (playerFromSingles != null) {
        playerFromSingles = playerFromSingles as Bot;
        playerFromSingles.setPreDefinedAverage = newValue.round();
        playerFromSingles.setLevel =
            int.parse(Utils.getLevelForBot(newValue.round()));
      }
    } else {
      Bot playerFromTeam =
          gameSettingsX01.getPlayerFromTeam(botToEdit.getName) as Bot;
      playerFromTeam.setPreDefinedAverage = newValue.round();
      playerFromTeam.setLevel =
          int.parse(Utils.getLevelForBot(newValue.round()));
    }

    botToEdit.setPreDefinedAverage = newValue.round();
    botToEdit.setLevel = int.parse(Utils.getLevelForBot(newValue.round()));
  }

  static showDialogForEditingPlayer(BuildContext context, Player playerToEdit,
      GameSettings_P gameSettings_P) async {
    //store values as "backup" if user modifies the avg. or name & then clicks on cancel
    String cancelName = '';
    int cancelLvl = 0;
    int cancelAverage = 0;

    if (playerToEdit is Bot) {
      cancelAverage = playerToEdit.getPreDefinedAverage;
      cancelLvl = playerToEdit.getLevel;
    } else {
      cancelName = playerToEdit.getName;
    }

    Utils.forcePortraitMode(context);

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => Form(
        key: _formKeyEditPlayer,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DIALOG_SHAPE_ROUNDING),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          contentPadding:
              Utils.isMobile(context) ? DIALOG_CONTENT_PADDING_MOBILE : null,
          title: Text(
            'Edit player',
            style: TextStyle(
              color: Colors.white,
              fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
            ),
          ),
          content: Container(
            width: DIALOG_NORMAL_WIDTH.w,
            child: StatefulBuilder(
              builder: (context, setState) {
                if (playerToEdit is Bot) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 30.w,
                        padding: EdgeInsets.only(left: 5.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Bot - lvl. ${playerToEdit.getLevel}',
                              style: TextStyle(
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .fontSize,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              ' (${playerToEdit.getPreDefinedAverage.round() - BOT_AVG_SLIDER_VALUE_RANGE} - ${playerToEdit.getPreDefinedAverage.round() + BOT_AVG_SLIDER_VALUE_RANGE} avg.)',
                              style: TextStyle(
                                fontSize: 8.sp,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SfSlider(
                        activeColor: Theme.of(context).colorScheme.secondary,
                        inactiveColor: Utils.getPrimaryColorDarken(context),
                        min: 22,
                        max: 118,
                        value: playerToEdit.getPreDefinedAverage,
                        stepSize: 4,
                        interval: 100,
                        showTicks: false,
                        onChanged: (dynamic newValue) {
                          Utils.handleVibrationFeedback(context);
                          setState(() => _editBotAvg(
                              gameSettings_P as GameSettingsX01_P,
                              playerToEdit,
                              newValue));
                        },
                      ),
                    ],
                  );
                } else {
                  return TextFormField(
                    autofocus: true,
                    controller:
                        newTextControllerForEditingPlayerInGameSettingsX01(
                            playerToEdit.getName),
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      if (value!.trim().isEmpty) {
                        return ('Please enter a name!');
                      }
                      if (gameSettings_P.checkIfPlayerNameExists(value)) {
                        Utils.setCursorForTextControllerToEnd(
                            editPlayerController);
                        return 'Name already exists!';
                      }

                      return null;
                    },
                    keyboardType: TextInputType.text,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(
                          MAX_CHARACTERS_NEW_PLAYER_TEXTFIELD),
                    ],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize:
                          Theme.of(context).textTheme.bodyMedium!.fontSize,
                    ),
                    decoration: InputDecoration(
                      errorStyle:
                          TextStyle(fontSize: DIALOG_ERROR_MSG_FONTSIZE.sp),
                      prefixIcon: Icon(
                        size: ICON_BUTTON_SIZE.h,
                        Icons.person,
                        color: Utils.getPrimaryColorDarken(context),
                      ),
                      hintText: 'Name',
                      filled: true,
                      fillColor: Utils.darken(
                          Theme.of(context).colorScheme.primary, 10),
                      hintStyle: TextStyle(
                          color: Utils.getPrimaryColorDarken(context)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          width: 0,
                          style: BorderStyle.none,
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Utils.handleVibrationFeedback(context);
                Navigator.of(context).pop();
                if (playerToEdit is Bot) {
                  playerToEdit.setPreDefinedAverage = cancelAverage;
                  playerToEdit.setLevel = cancelLvl;
                } else {
                  playerToEdit.setName = cancelName;
                }
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                ),
              ),
              style: ButtonStyles.darkPrimaryColorBtnStyle(context).copyWith(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(DIALOG_BTN_SHAPE_ROUNDING),
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Utils.handleVibrationFeedback(context);
                _saveEdit(context, gameSettings_P, playerToEdit);
              },
              child: Text(
                'Submit',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                ),
              ),
              style: ButtonStyles.darkPrimaryColorBtnStyle(context).copyWith(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(DIALOG_BTN_SHAPE_ROUNDING),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
  }

  static showDialogForEditingTeam(BuildContext context, Team teamToEdit,
      GameSettings_P gameSettings) async {
    final String cancelName = teamToEdit.getName;

    Utils.forcePortraitMode(context);

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Form(
          key: _formKeyEditTeam,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(DIALOG_SHAPE_ROUNDING),
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            contentPadding:
                Utils.isMobile(context) ? DIALOG_CONTENT_PADDING_MOBILE : null,
            title: Text(
              'Edit team',
              style: TextStyle(
                color: Colors.white,
                fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
              ),
            ),
            content: Container(
              width: DIALOG_NORMAL_WIDTH.w,
              child: StatefulBuilder(
                builder: (context, setState) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller:
                            newTextControllerForEditingTeamInGameSettingsX01(
                                teamToEdit.getName),
                        textInputAction: TextInputAction.done,
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return ('Please enter a name!');
                          }
                          if (gameSettings.checkIfTeamNameExists(value)) {
                            Utils.setCursorForTextControllerToEnd(
                                editTeamController);
                            return 'Team name already exists!';
                          }

                          return null;
                        },
                        keyboardType: TextInputType.text,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(
                              MAX_CHARACTERS_NEW_PLAYER_TEXTFIELD),
                        ],
                        style: TextStyle(
                          color: Colors.white,
                          fontSize:
                              Theme.of(context).textTheme.bodyMedium!.fontSize,
                        ),
                        decoration: InputDecoration(
                          errorStyle:
                              TextStyle(fontSize: DIALOG_ERROR_MSG_FONTSIZE.sp),
                          prefixIcon: Icon(
                            size: ICON_BUTTON_SIZE.h,
                            Icons.group,
                            color: Utils.getPrimaryColorDarken(context),
                          ),
                          filled: true,
                          fillColor: Utils.darken(
                              Theme.of(context).colorScheme.primary, 10),
                          hintStyle: TextStyle(
                            fontSize: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .fontSize,
                            color: Utils.getPrimaryColorDarken(context),
                          ),
                          hintText: 'Team',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Delete this team?',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .fontSize,
                            ),
                          ),
                          IconButton(
                              splashRadius: SPLASH_RADIUS,
                              splashColor: Utils.darken(
                                  Theme.of(context).colorScheme.primary, 10),
                              highlightColor: Utils.darken(
                                  Theme.of(context).colorScheme.primary, 10),
                              icon: Icon(
                                Icons.delete,
                                size: ICON_BUTTON_SIZE.h,
                              ),
                              color: Colors.red,
                              onPressed: () {
                                Utils.handleVibrationFeedback(context);
                                Navigator.of(context).pop();
                                if (teamToEdit.getPlayers.length > 0) {
                                  _showDialogForDeletingTeam(
                                      context, gameSettings, teamToEdit);
                                } else {
                                  _deleteTeam(teamToEdit, gameSettings);
                                }
                              }),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Utils.handleVibrationFeedback(context);
                  Navigator.of(context).pop();
                  teamToEdit.setName = cancelName;
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                  ),
                ),
                style: ButtonStyles.darkPrimaryColorBtnStyle(context).copyWith(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(DIALOG_BTN_SHAPE_ROUNDING),
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Utils.handleVibrationFeedback(context);
                  _submitEditedTeam(context, gameSettings, teamToEdit);
                },
                child: Text(
                  'Submit',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                  ),
                ),
                style: ButtonStyles.darkPrimaryColorBtnStyle(context).copyWith(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(DIALOG_BTN_SHAPE_ROUNDING),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
  }

  static showDialogForDeletingTeamAsLastPlayer(
      BuildContext context,
      Team teamToMaybeDelete,
      GameSettings_P gameSettings,
      Player playerToDelete) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(DIALOG_SHAPE_ROUNDING),
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            contentPadding:
                Utils.isMobile(context) ? DIALOG_CONTENT_PADDING_MOBILE : null,
            title: Text(
              'Delete team',
              style: TextStyle(
                color: Colors.white,
                fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
              ),
            ),
            content: Container(
              width: DIALOG_NORMAL_WIDTH.w,
              child: Text(
                'Do you also want to delete the team?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                ),
              ),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () {
                        Utils.handleVibrationFeedback(context);
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize:
                              Theme.of(context).textTheme.bodyMedium!.fontSize,
                        ),
                      ),
                      style: ButtonStyles.darkPrimaryColorBtnStyle(context)
                          .copyWith(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                DIALOG_BTN_SHAPE_ROUNDING),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          Utils.handleVibrationFeedback(context);
                          gameSettings.removePlayer(playerToDelete, false);
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'No',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .fontSize,
                          ),
                        ),
                        style: ButtonStyles.darkPrimaryColorBtnStyle(context)
                            .copyWith(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  DIALOG_BTN_SHAPE_ROUNDING),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: ACTION_BTNS_SPACING.w,
                      ),
                      TextButton(
                        onPressed: () {
                          Utils.handleVibrationFeedback(context);
                          gameSettings.getTeams
                              .removeWhere((team) => team == teamToMaybeDelete);
                          gameSettings.removePlayer(playerToDelete, true);
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Yes',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .fontSize,
                          ),
                        ),
                        style: ButtonStyles.darkPrimaryColorBtnStyle(context)
                            .copyWith(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  DIALOG_BTN_SHAPE_ROUNDING),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        });
  }

  static showDialogForSwitchingTeam(
      BuildContext context, Player playerToSwap, GameSettings_P gameSettings) {
    final Team? newTeam =
        _checkIfSwappingOnlyToOneTeamPossible(playerToSwap, gameSettings);

    if (newTeam == null) {
      final List<Team> possibleTeamsToSwap =
          _getPossibleTeamsToSwap(playerToSwap, gameSettings);
      Team? selectedTeam = possibleTeamsToSwap[0];

      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(DIALOG_SHAPE_ROUNDING),
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            contentPadding:
                Utils.isMobile(context) ? DIALOG_CONTENT_PADDING_MOBILE : null,
            title: Text(
              'Swap team',
              style: TextStyle(
                color: Colors.white,
                fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
              ),
            ),
            content: Container(
              width: DIALOG_NORMAL_WIDTH.w,
              child: StatefulBuilder(
                builder: (context, setState) {
                  return Container(
                    width: 0.6.w,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: possibleTeamsToSwap.length,
                      itemBuilder: (BuildContext context, int index) {
                        final Team team = possibleTeamsToSwap[index];

                        return Theme(
                          data: ThemeData(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                          ),
                          child: ListTile(
                            title: Text(
                              team.getName,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .fontSize,
                              ),
                            ),
                            leading: Theme(
                              data: Theme.of(context).copyWith(
                                  unselectedWidgetColor:
                                      Utils.getPrimaryColorDarken(context)),
                              child: Radio<Team>(
                                activeColor:
                                    Theme.of(context).colorScheme.secondary,
                                value: team,
                                groupValue: selectedTeam,
                                onChanged: (value) {
                                  Utils.handleVibrationFeedback(context);
                                  setState(
                                    () {
                                      Utils.handleVibrationFeedback(context);
                                      setState(() => selectedTeam = value);
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Utils.handleVibrationFeedback(context);
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                  ),
                ),
                style: ButtonStyles.darkPrimaryColorBtnStyle(context).copyWith(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(DIALOG_BTN_SHAPE_ROUNDING),
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Utils.handleVibrationFeedback(context);
                  _swapTeam(
                      context, playerToSwap, selectedTeam, gameSettings, true);
                },
                child: Text(
                  'Submit',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                  ),
                ),
                style: ButtonStyles.darkPrimaryColorBtnStyle(context).copyWith(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(DIALOG_BTN_SHAPE_ROUNDING),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );
    } else {
      _swapTeam(context, playerToSwap, newTeam, gameSettings, false);
    }
  }

  /*********************************************************************************/
  /*****************               PRIVATE METHODS             *********************/
  /*********************************************************************************/

  static _saveEdit(
      BuildContext context, dynamic gameSettings_P, Player playerToEdit) {
    editPlayerController.text = editPlayerController.text.trim();
    if (!_formKeyEditPlayer.currentState!.validate()) {
      return;
    }
    _formKeyEditPlayer.currentState!.save();

    if (!(playerToEdit is Bot)) {
      final String editPlayerControllerText = editPlayerController.text;

      // player from team is not the same refernce as in the single players list, therefore also needs to be updated and vice versa
      if (gameSettings_P is GameSettingsX01_P ||
          gameSettings_P is GameSettingsCricket_P) {
        if (gameSettings_P.getSingleOrTeam == SingleOrTeamEnum.Team) {
          final Player? playerFromSingles =
              gameSettings_P.getPlayerFromSingles(playerToEdit.getName);
          if (playerFromSingles != null) {
            playerFromSingles.setName = editPlayerControllerText;
          }
        }
        final Player playerFromTeam =
            gameSettings_P.getPlayerFromTeam(playerToEdit.getName);
        playerFromTeam.setName = editPlayerControllerText;
      }

      playerToEdit.setName = editPlayerControllerText;
    }

    gameSettings_P.notify();

    Navigator.of(context).pop();
  }

  static _submitEditedTeam(
      BuildContext context, GameSettings_P gameSettings, Team teamToEdit) {
    editTeamController.text = editTeamController.text.trim();
    if (!_formKeyEditTeam.currentState!.validate()) {
      return;
    }

    _formKeyEditTeam.currentState!.save();

    teamToEdit.setName = editTeamController.text;
    gameSettings.notify();
    Navigator.of(context).pop();
  }

  static _swapTeam(BuildContext context, Player playerToSwap, Team? newTeam,
      GameSettings_P gameSettings, bool closeDialog) {
    final Team? currentTeam =
        _getTeamOfPlayer(playerToSwap, gameSettings.getTeams);

    for (Team team in gameSettings.getTeams) {
      if (team == currentTeam) {
        team.getPlayers.remove(playerToSwap);
      }
      if (team == newTeam) {
        team.getPlayers.add(playerToSwap);
      }
    }

    gameSettings.notify();

    if (closeDialog) {
      Navigator.of(context).pop();
    }
  }

  static _deleteTeam(Team teamToDelete, GameSettings_P gameSettings) {
    gameSettings.getTeams.remove(teamToDelete);
    for (Player playerToDelete in teamToDelete.getPlayers) {
      gameSettings.getPlayers
          .removeWhere((p) => p.getName == playerToDelete.getName);
    }

    gameSettings.notify();
  }

  static List<Team> _getPossibleTeamsToSwap(
      Player playerToSwap, GameSettings_P gameSettings) {
    final Team? currentTeam =
        _getTeamOfPlayer(playerToSwap, gameSettings.getTeams);
    List<Team> result = [];

    for (Team team in gameSettings.getTeams) {
      if (team != currentTeam &&
          team.getPlayers.length < MAX_PLAYERS_PER_TEAM) {
        result.add(team);
      }
    }

    return result;
  }

  //for swaping team -> if only one other team is available then the current one -> swap immediately instead of showing 1 radio button
  static Team? _checkIfSwappingOnlyToOneTeamPossible(
      Player playerToSwap, GameSettings_P gameSettings) {
    final Team? currentTeam =
        _getTeamOfPlayer(playerToSwap, gameSettings.getTeams);
    int count = 0;
    Team? resultTeam;

    for (Team team in gameSettings.getTeams) {
      if (team.getPlayers.length < MAX_PLAYERS_PER_TEAM &&
          team != currentTeam) {
        count++;
        resultTeam = team;
      }
    }

    if (count == 1) return resultTeam;

    return null;
  }

  static Team? _getTeamOfPlayer(Player playerToCheck, List<Team> teams) {
    for (Team team in teams) {
      for (Player player in team.getPlayers) {
        if (player == playerToCheck) return team;
      }
    }

    return null;
  }

  static _showDialogForDeletingTeam(
      BuildContext context, GameSettings_P gameSettings, Team teamToEdit) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DIALOG_SHAPE_ROUNDING),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          contentPadding:
              Utils.isMobile(context) ? DIALOG_CONTENT_PADDING_MOBILE : null,
          title: Text(
            'Information',
            style: TextStyle(
              color: Colors.white,
              fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
            ),
          ),
          content: Container(
            width: TEXT_DIALOG_WIDTH.w,
            child: Text(
              'All the players in this team will also be deleted.',
              style: TextStyle(
                color: Colors.white,
                fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
              ),
            ),
          ),
          actions: [
            Row(
              children: [
                Container(
                  width: 20.w,
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    splashRadius: SPLASH_RADIUS,
                    splashColor:
                        Utils.darken(Theme.of(context).colorScheme.primary, 10),
                    highlightColor:
                        Utils.darken(Theme.of(context).colorScheme.primary, 10),
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      size: ICON_BUTTON_SIZE.h,
                      Icons.arrow_back,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    onPressed: () {
                      Utils.handleVibrationFeedback(context);
                      Navigator.of(context).pop();
                      showDialogForEditingTeam(
                        context,
                        teamToEdit,
                        gameSettings,
                      );
                    },
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Utils.handleVibrationFeedback(context);
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .fontSize,
                          ),
                        ),
                        style: ButtonStyles.darkPrimaryColorBtnStyle(context)
                            .copyWith(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  DIALOG_BTN_SHAPE_ROUNDING),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: ACTION_BTNS_SPACING.w,
                      ),
                      TextButton(
                        onPressed: () {
                          Utils.handleVibrationFeedback(context);
                          _deleteTeam(teamToEdit, gameSettings);
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Submit',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary,
                            fontSize: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .fontSize,
                          ),
                        ),
                        style: ButtonStyles.darkPrimaryColorBtnStyle(context)
                            .copyWith(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  DIALOG_BTN_SHAPE_ROUNDING),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
