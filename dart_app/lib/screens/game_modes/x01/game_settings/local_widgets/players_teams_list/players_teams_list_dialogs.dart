import 'package:dart_app/constants.dart';
import 'package:dart_app/models/bot.dart';
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
      GameSettingsX01_P gameSettingsX01) {
    //store values as "backup" if user modifies the avg. or name & then clicks on cancel
    String cancelName = '';
    int cancelAverage = 0;

    if (playerToEdit is Bot) {
      cancelAverage = playerToEdit.getPreDefinedAverage;
    } else {
      cancelName = playerToEdit.getName;
    }

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => Form(
        key: _formKeyEditPlayer,
        child: AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.primary,
          contentPadding: EdgeInsets.only(
              bottom: DIALOG_CONTENT_PADDING_BOTTOM,
              top: DIALOG_CONTENT_PADDING_TOP,
              left: DIALOG_CONTENT_PADDING_LEFT,
              right: DIALOG_CONTENT_PADDING_RIGHT),
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
                            padding: EdgeInsets.only(left: 5),
                            child: Text(
                              'Level ${playerToEdit.getLevel} Bot',
                              style: TextStyle(
                                  fontSize: 12.sp, color: Colors.white),
                            ),
                          ),
                          Text(
                            ' (${playerToEdit.getPreDefinedAverage.round() - BOT_AVG_SLIDER_VALUE_RANGE}-${playerToEdit.getPreDefinedAverage.round() + BOT_AVG_SLIDER_VALUE_RANGE} avg.)',
                            style:
                                TextStyle(fontSize: 9.sp, color: Colors.white),
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
                        setState(() => _editBotAvg(
                            gameSettingsX01, playerToEdit, newValue));
                      },
                    ),
                  ],
                );
              } else {
                return TextFormField(
                  controller: editPlayerController..text = playerToEdit.getName,
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return ('Please enter a name!');
                    }
                    if (gameSettingsX01.checkIfPlayerNameExists(value, false)) {
                      return 'Playername already exists!';
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
              onPressed: () => {
                if (playerToEdit is Bot)
                  {
                    playerToEdit.setPreDefinedAverage = cancelAverage,
                  }
                else
                  {
                    playerToEdit.setName = cancelName,
                  },
                Navigator.of(context).pop(),
              },
              child: Text(
                'Cancel',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.secondary),
              ),
              style: ButtonStyle(
                backgroundColor:
                    Utils.getPrimaryMaterialStateColorDarken(context),
              ),
            ),
            TextButton(
              onPressed: () =>
                  _saveEdit(context, gameSettingsX01, playerToEdit),
              child: Text(
                'Submit',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.secondary),
              ),
              style: ButtonStyle(
                backgroundColor:
                    Utils.getPrimaryMaterialStateColorDarken(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static showDialogForEditingTeam(BuildContext context, Team teamToEdit,
      GameSettingsX01_P gameSettingsX01) {
    String cancelName = teamToEdit.getName;

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Form(
          key: _formKeyEditTeam,
          child: AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.primary,
            contentPadding: EdgeInsets.only(
                bottom: DIALOG_CONTENT_PADDING_BOTTOM,
                top: DIALOG_CONTENT_PADDING_TOP,
                left: DIALOG_CONTENT_PADDING_LEFT,
                right: DIALOG_CONTENT_PADDING_RIGHT),
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
                      controller: editTeamController..text = teamToEdit.getName,
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return ('Please enter a valid name!');
                        }
                        if (gameSettingsX01.checkIfTeamNameExists(value)) {
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
                          'Delete this Team?',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                        IconButton(
                            icon: const Icon(Icons.delete),
                            color: Colors.red,
                            onPressed: () {
                              Navigator.of(context).pop();
                              if (teamToEdit.getPlayers.length > 0) {
                                _showDialogForDeletingTeam(
                                    context, gameSettingsX01, teamToEdit);
                              } else {
                                gameSettingsX01.checkTeamNamingIds(teamToEdit);
                                _deleteTeam(teamToEdit, gameSettingsX01);
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
                  teamToEdit.setName = cancelName;
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Cancel',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
                style: ButtonStyle(
                  backgroundColor:
                      Utils.getPrimaryMaterialStateColorDarken(context),
                ),
              ),
              TextButton(
                onPressed: () =>
                    _submitEditedTeam(context, gameSettingsX01, teamToEdit),
                child: Text(
                  'Submit',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
                style: ButtonStyle(
                  backgroundColor:
                      Utils.getPrimaryMaterialStateColorDarken(context),
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
      GameSettingsX01_P gameSettingsX01,
      Player playerToDelete) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.primary,
            contentPadding: EdgeInsets.only(
                bottom: DIALOG_CONTENT_PADDING_BOTTOM,
                top: DIALOG_CONTENT_PADDING_TOP,
                left: 24,
                right: 24),
            title: Text(
              'Delete team',
              style: TextStyle(color: Colors.white),
            ),
            content: Text(
              'Do you also want to delete this team?',
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(left: 3.w),
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                              Utils.getPrimaryMaterialStateColorDarken(context),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 3.w),
                          child: TextButton(
                            onPressed: () {
                              gameSettingsX01.removePlayer(
                                  playerToDelete, false);
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'No',
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                            ),
                            style: ButtonStyle(
                              backgroundColor:
                                  Utils.getPrimaryMaterialStateColorDarken(
                                      context),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            gameSettingsX01
                                .checkTeamNamingIds(teamToMaybeDelete);
                            gameSettingsX01.getTeams.removeWhere(
                                (team) => team == teamToMaybeDelete);
                            gameSettingsX01.removePlayer(playerToDelete, true);
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Yes',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary),
                          ),
                          style: ButtonStyle(
                            backgroundColor:
                                Utils.getPrimaryMaterialStateColorDarken(
                                    context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        });
  }

  static showDialogForSwitchingTeam(BuildContext context, Player playerToSwap,
      GameSettingsX01_P gameSettingsX01) {
    Team? newTeam =
        _checkIfSwappingOnlyToOneTeamPossible(playerToSwap, gameSettingsX01);
    if (newTeam == null) {
      List<Team> possibleTeamsToSwap =
          _getPossibleTeamsToSwap(playerToSwap, gameSettingsX01);
      Team? selectedTeam = possibleTeamsToSwap[0];

      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.primary,
            contentPadding: EdgeInsets.only(
                bottom: DIALOG_CONTENT_PADDING_BOTTOM,
                top: DIALOG_CONTENT_PADDING_TOP,
                left: DIALOG_CONTENT_PADDING_LEFT,
                right: DIALOG_CONTENT_PADDING_RIGHT),
            title: Text(
              'Swap Team',
              style: TextStyle(color: Colors.white),
            ),
            content: StatefulBuilder(
              builder: (context, setState) {
                return Container(
                  width: double.maxFinite,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: possibleTeamsToSwap.length,
                    itemBuilder: (BuildContext context, int index) {
                      final Team team = possibleTeamsToSwap[index];

                      return RadioListTile(
                        activeColor: Theme.of(context).colorScheme.secondary,
                        title: Text(
                          team.getName,
                          style: TextStyle(color: Colors.white),
                        ),
                        value: team,
                        groupValue: selectedTeam,
                        onChanged: (Team? value) {
                          setState(() => selectedTeam = value);
                        },
                      );
                    },
                  ),
                );
              },
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'Cancel',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
                style: ButtonStyle(
                  backgroundColor:
                      Utils.getPrimaryMaterialStateColorDarken(context),
                ),
              ),
              TextButton(
                onPressed: () => _swapTeam(
                    context, playerToSwap, selectedTeam, gameSettingsX01),
                child: Text(
                  'Submit',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.secondary),
                ),
                style: ButtonStyle(
                  backgroundColor:
                      Utils.getPrimaryMaterialStateColorDarken(context),
                ),
              ),
            ],
          );
        },
      );
    } else {
      _swapTeam(context, playerToSwap, newTeam, gameSettingsX01);
    }
  }

  /*********************************************************************************/
  /*****************               PRIVATE METHODS             *********************/
  /*********************************************************************************/

  static _saveEdit(BuildContext context, GameSettingsX01_P gameSettingsX01,
      Player playerToEdit) {
    if (!_formKeyEditPlayer.currentState!.validate()) return;

    _formKeyEditPlayer.currentState!.save();

    if (!(playerToEdit is Bot)) {
      // player from team is not the same refernce as in the single players list, therefore also needs to be updated and vice versa
      if (gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Team) {
        Player? playerFromSingles =
            gameSettingsX01.getPlayerFromSingles(playerToEdit.getName);
        if (playerFromSingles != null) {
          playerFromSingles.setName = editPlayerController.text;
        }
      }
      Player playerFromTeam =
          gameSettingsX01.getPlayerFromTeam(playerToEdit.getName);
      playerFromTeam.setName = editPlayerController.text;
      playerToEdit.setName = editPlayerController.text;
    }

    gameSettingsX01.notify();

    Navigator.of(context).pop();
  }

  static _submitEditedTeam(BuildContext context,
      GameSettingsX01_P gameSettingsX01, Team teamToEdit) {
    if (!_formKeyEditTeam.currentState!.validate()) return;

    _formKeyEditTeam.currentState!.save();

    teamToEdit.setName = editTeamController.text;
    gameSettingsX01.notify();
    Navigator.of(context).pop();
  }

  static _swapTeam(BuildContext context, Player playerToSwap, Team? newTeam,
      GameSettingsX01_P gameSettingsX01) {
    final Team? currentTeam =
        _getTeamOfPlayer(playerToSwap, gameSettingsX01.getTeams);

    for (Team team in gameSettingsX01.getTeams) {
      if (team == currentTeam) team.getPlayers.remove(playerToSwap);
      if (team == newTeam) team.getPlayers.add(playerToSwap);
    }

    gameSettingsX01.notify();

    if (gameSettingsX01.getTeams.length > 2) Navigator.of(context).pop();
  }

  static _deleteTeam(Team teamToDelete, GameSettingsX01_P gameSettingsX01) {
    gameSettingsX01.getTeams.remove(teamToDelete);
    for (Player playerToDelete in teamToDelete.getPlayers)
      gameSettingsX01.getPlayers.remove(playerToDelete);

    gameSettingsX01.notify();
  }

  static List<Team> _getPossibleTeamsToSwap(
      Player playerToSwap, GameSettingsX01_P gameSettingsX01) {
    final Team? currentTeam =
        _getTeamOfPlayer(playerToSwap, gameSettingsX01.getTeams);
    List<Team> result = [];

    for (Team team in gameSettingsX01.getTeams) {
      if (team != currentTeam) result.add(team);
    }

    return result;
  }

  //for swaping team -> if only one other team is available then the current one -> swap immediately instead of showing 1 radio button
  static Team? _checkIfSwappingOnlyToOneTeamPossible(
      Player playerToSwap, GameSettingsX01_P gameSettingsX01) {
    final Team? currentTeam =
        _getTeamOfPlayer(playerToSwap, gameSettingsX01.getTeams);
    int count = 0;
    Team? resultTeam;

    for (Team team in gameSettingsX01.getTeams) {
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

  static _showDialogForDeletingTeam(BuildContext context,
      GameSettingsX01_P gameSettingsX01, Team teamToEdit) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.primary,
          contentPadding: EdgeInsets.only(
              bottom: DIALOG_CONTENT_PADDING_BOTTOM,
              top: DIALOG_CONTENT_PADDING_TOP,
              left: 24,
              right: 24),
          title: const Text(
            'Info',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'All the players in this team will also be deleted.',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        Icons.arrow_back,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        showDialogForEditingTeam(
                            context, teamToEdit, gameSettingsX01);
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
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.secondary),
                          ),
                          style: ButtonStyle(
                            backgroundColor:
                                Utils.getPrimaryMaterialStateColorDarken(
                                    context),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          gameSettingsX01.checkTeamNamingIds(teamToEdit);
                          _deleteTeam(teamToEdit, gameSettingsX01);
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Continue',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                              Utils.getPrimaryMaterialStateColorDarken(context),
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
