import 'package:dart_app/constants.dart';
import 'package:dart_app/models/bot.dart';
import 'package:dart_app/models/game_settings/game_settings_cricket_p.dart';
import 'package:dart_app/models/game_settings/game_settings_p.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/models/team.dart';
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
      GameSettings_P gameSettings_P) {
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
          contentPadding: dialogContentPadding,
          title: Text(
            'Edit',
            style: TextStyle(color: Colors.white),
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              if (playerToEdit is Bot) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 30.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 1.w),
                            child: Text(
                              'Bot - lvl. ${playerToEdit.getLevel}',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Text(
                            ' (${playerToEdit.getPreDefinedAverage.round() - BOT_AVG_SLIDER_VALUE_RANGE}-${playerToEdit.getPreDefinedAverage.round() + BOT_AVG_SLIDER_VALUE_RANGE} avg.)',
                            style: TextStyle(
                              fontSize: 9.sp,
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
                      newTextControllerForEditingPlayerInGameSettingsX01()
                        ..text = playerToEdit.getName,
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return ('Please enter a name!');
                    }
                    if (gameSettings_P.checkIfPlayerNameExists(value)) {
                      return 'Name already exists!';
                    }

                    return null;
                  },
                  keyboardType: TextInputType.text,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(
                        MAX_CHARACTERS_NEW_PLAYER_TEXTFIELD),
                  ],
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.person,
                      color: Utils.getPrimaryColorDarken(context),
                    ),
                    hintText: 'Name',
                    filled: true,
                    fillColor:
                        Utils.darken(Theme.of(context).colorScheme.primary, 10),
                    hintStyle:
                        TextStyle(color: Utils.getPrimaryColorDarken(context)),
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
                style:
                    TextStyle(color: Theme.of(context).colorScheme.secondary),
              ),
              style: ButtonStyle(
                splashFactory: NoSplash.splashFactory,
                shadowColor: MaterialStateProperty.all(Colors.transparent),
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                backgroundColor:
                    Utils.getPrimaryMaterialStateColorDarken(context),
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
                style:
                    TextStyle(color: Theme.of(context).colorScheme.secondary),
              ),
              style: ButtonStyle(
                splashFactory: NoSplash.splashFactory,
                shadowColor: MaterialStateProperty.all(Colors.transparent),
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                backgroundColor:
                    Utils.getPrimaryMaterialStateColorDarken(context),
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
  }

  static showDialogForEditingTeam(
      BuildContext context, Team teamToEdit, GameSettings_P gameSettings) {
    final String cancelName = teamToEdit.getName;

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
            contentPadding: dialogContentPadding,
            title: Text(
              'Edit team',
              style: TextStyle(color: Colors.white),
            ),
            content: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller:
                          newTextControllerForEditingTeamInGameSettingsX01()
                            ..text = teamToEdit.getName,
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value!.trim().isEmpty) {
                          return ('Please enter a name!');
                        }
                        if (gameSettings.checkIfTeamNameExists(value)) {
                          return 'Team name already exists!';
                        }

                        return null;
                      },
                      keyboardType: TextInputType.text,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(
                            MAX_CHARACTERS_NEW_PLAYER_TEXTFIELD),
                      ],
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.group,
                          color: Utils.getPrimaryColorDarken(context),
                        ),
                        filled: true,
                        fillColor: Utils.darken(
                            Theme.of(context).colorScheme.primary, 10),
                        hintStyle: TextStyle(
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
                        const Text(
                          'Delete this team?',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                        IconButton(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            icon: const Icon(Icons.delete),
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
            actions: [
              TextButton(
                onPressed: () {
                  Utils.handleVibrationFeedback(context);
                  Navigator.of(context).pop();
                  teamToEdit.setName = cancelName;
                },
                child: Text(
                  'Cancel',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
                style: ButtonStyle(
                  splashFactory: NoSplash.splashFactory,
                  shadowColor: MaterialStateProperty.all(Colors.transparent),
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  backgroundColor:
                      Utils.getPrimaryMaterialStateColorDarken(context),
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
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
                style: ButtonStyle(
                  splashFactory: NoSplash.splashFactory,
                  shadowColor: MaterialStateProperty.all(Colors.transparent),
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  backgroundColor:
                      Utils.getPrimaryMaterialStateColorDarken(context),
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
            contentPadding: dialogContentPadding,
            title: Text(
              'Delete team',
              style: TextStyle(color: Colors.white),
            ),
            content: Text(
              'Do you also want to delete the team?',
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 3.w),
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () {
                        Utils.handleVibrationFeedback(context);
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                      style: ButtonStyle(
                        splashFactory: NoSplash.splashFactory,
                        shadowColor:
                            MaterialStateProperty.all(Colors.transparent),
                        overlayColor:
                            MaterialStateProperty.all(Colors.transparent),
                        backgroundColor:
                            Utils.getPrimaryMaterialStateColorDarken(context),
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
                      Container(
                        padding: EdgeInsets.only(right: 2.w),
                        child: TextButton(
                          onPressed: () {
                            Utils.handleVibrationFeedback(context);
                            gameSettings.removePlayer(playerToDelete, false);
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'No',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary),
                          ),
                          style: ButtonStyle(
                            splashFactory: NoSplash.splashFactory,
                            shadowColor:
                                MaterialStateProperty.all(Colors.transparent),
                            overlayColor:
                                MaterialStateProperty.all(Colors.transparent),
                            backgroundColor:
                                Utils.getPrimaryMaterialStateColorDarken(
                                    context),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    DIALOG_BTN_SHAPE_ROUNDING),
                              ),
                            ),
                          ),
                        ),
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
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                        style: ButtonStyle(
                          splashFactory: NoSplash.splashFactory,
                          shadowColor:
                              MaterialStateProperty.all(Colors.transparent),
                          overlayColor:
                              MaterialStateProperty.all(Colors.transparent),
                          backgroundColor:
                              Utils.getPrimaryMaterialStateColorDarken(context),
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
      List<Team> possibleTeamsToSwap =
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
            contentPadding: dialogContentPadding,
            title: Text(
              'Swap team',
              style: TextStyle(color: Colors.white),
            ),
            content: StatefulBuilder(
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
                        child: RadioListTile(
                          activeColor: Theme.of(context).colorScheme.secondary,
                          title: Text(
                            team.getName,
                            style: TextStyle(color: Colors.white),
                          ),
                          value: team,
                          groupValue: selectedTeam,
                          onChanged: (Team? value) {
                            Utils.handleVibrationFeedback(context);
                            setState(() => selectedTeam = value);
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Utils.handleVibrationFeedback(context);
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Cancel',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
                style: ButtonStyle(
                  splashFactory: NoSplash.splashFactory,
                  shadowColor: MaterialStateProperty.all(Colors.transparent),
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  backgroundColor:
                      Utils.getPrimaryMaterialStateColorDarken(context),
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
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
                style: ButtonStyle(
                  splashFactory: NoSplash.splashFactory,
                  shadowColor: MaterialStateProperty.all(Colors.transparent),
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                  backgroundColor:
                      Utils.getPrimaryMaterialStateColorDarken(context),
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
      if (team != currentTeam) result.add(team);
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
          contentPadding: dialogContentPadding,
          title: const Text(
            'Info',
            style: TextStyle(color: Colors.white),
          ),
          content: Container(
            width: 0.6.w,
            child: Text(
              'All the players in this team will also be deleted.',
              style: TextStyle(color: Colors.white),
            ),
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      padding: EdgeInsets.zero,
                      icon: Icon(
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
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 3.w),
                        child: TextButton(
                          onPressed: () {
                            Utils.handleVibrationFeedback(context);
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary),
                          ),
                          style: ButtonStyle(
                            splashFactory: NoSplash.splashFactory,
                            shadowColor:
                                MaterialStateProperty.all(Colors.transparent),
                            overlayColor:
                                MaterialStateProperty.all(Colors.transparent),
                            backgroundColor:
                                Utils.getPrimaryMaterialStateColorDarken(
                                    context),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    DIALOG_BTN_SHAPE_ROUNDING),
                              ),
                            ),
                          ),
                        ),
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
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                        style: ButtonStyle(
                          splashFactory: NoSplash.splashFactory,
                          shadowColor:
                              MaterialStateProperty.all(Colors.transparent),
                          overlayColor:
                              MaterialStateProperty.all(Colors.transparent),
                          backgroundColor:
                              Utils.getPrimaryMaterialStateColorDarken(context),
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
