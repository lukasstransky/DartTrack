import 'package:dart_app/constants.dart';
import 'package:dart_app/models/bot.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
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

  static showDialogForEditingPlayer(BuildContext context, Player playerToEdit,
      GameSettingsX01 gameSettingsX01) {
    //store values as "backup" if user modifies the avg. or name & then clicks on cancel
    String cancelName = '';
    int cancelAverage = 0;

    if (playerToEdit is Bot)
      cancelAverage = playerToEdit.getPreDefinedAverage;
    else
      cancelName = playerToEdit.getName;

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => Form(
        key: _formKeyEditPlayer,
        child: AlertDialog(
          contentPadding: EdgeInsets.only(
              bottom: DIALOG_CONTENT_PADDING_BOTTOM,
              top: DIALOG_CONTENT_PADDING_TOP,
              left: DIALOG_CONTENT_PADDING_LEFT,
              right: DIALOG_CONTENT_PADDING_RIGHT),
          title: const Text('Edit'),
          content: StatefulBuilder(
            builder: (context, setState) {
              if (playerToEdit is Bot) {
                return Container(
                  child: Column(
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
                                  fontSize: 12.sp,
                                ),
                              ),
                            ),
                            Text(
                              ' (${playerToEdit.getPreDefinedAverage.round() - BOT_AVG_SLIDER_VALUE_RANGE}-${playerToEdit.getPreDefinedAverage.round() + BOT_AVG_SLIDER_VALUE_RANGE} avg.)',
                              style: TextStyle(
                                fontSize: 9.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SfSlider(
                        min: 22,
                        max: 118,
                        value: playerToEdit.getPreDefinedAverage,
                        stepSize: 4,
                        interval: 100,
                        showTicks: false,
                        onChanged: (dynamic newValue) {
                          setState(() {
                            playerToEdit.setPreDefinedAverage =
                                newValue.round();
                            playerToEdit.setLevel = int.parse(
                                Utils.getLevelForBot(newValue.round()));
                          });
                        },
                      ),
                    ],
                  ),
                );
              } else {
                return TextFormField(
                  controller: editPlayerController..text = playerToEdit.getName,
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value!.isEmpty) return ('Please enter a name!');

                    if (gameSettingsX01.checkIfPlayerNameExists(value))
                      return 'Playername already exists!';

                    return null;
                  },
                  keyboardType: TextInputType.text,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(
                        MAX_CHARACTERS_NEW_PLAYER_TEXTFIELD),
                  ],
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.person,
                    ),
                    hintText: 'Name',
                    filled: true,
                    hintStyle: TextStyle(color: Colors.grey),
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
                  playerToEdit.setPreDefinedAverage = cancelAverage
                else
                  playerToEdit.setName = cancelName,
                Navigator.of(context).pop(),
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () =>
                  _saveEdit(context, gameSettingsX01, playerToEdit),
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  static showDialogForEditingTeam(
      BuildContext context, Team teamToEdit, GameSettingsX01 gameSettingsX01) {
    String cancelName = teamToEdit.getName;

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Form(
          key: _formKeyEditTeam,
          child: AlertDialog(
            contentPadding: EdgeInsets.only(
                bottom: DIALOG_CONTENT_PADDING_BOTTOM,
                top: DIALOG_CONTENT_PADDING_TOP,
                left: DIALOG_CONTENT_PADDING_LEFT,
                right: DIALOG_CONTENT_PADDING_RIGHT),
            title: const Text('Edit Team'),
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
                        if (value!.isEmpty)
                          return ('Please enter a valid Name!');

                        if (gameSettingsX01.checkIfTeamNameExists(value))
                          return 'Teamname already exists!';

                        return null;
                      },
                      keyboardType: TextInputType.text,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(
                            MAX_CHARACTERS_NEW_PLAYER_TEXTFIELD),
                      ],
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.group,
                        ),
                        filled: true,
                        hintStyle: TextStyle(color: Colors.grey),
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
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () =>
                    _submitEditedTeam(context, gameSettingsX01, teamToEdit),
                child: const Text('Submit'),
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
      GameSettingsX01 gameSettingsX01,
      Player playerToDelete) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: EdgeInsets.only(
                bottom: DIALOG_CONTENT_PADDING_BOTTOM,
                top: DIALOG_CONTENT_PADDING_TOP,
                left: 24,
                right: 24),
            title: const Text('Delete Team'),
            content: const Text('Do you also want to delete this Team?'),
            actions: [
              Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 2.w),
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            gameSettingsX01.removePlayer(playerToDelete, false);
                            Navigator.of(context).pop();
                          },
                          child: const Text('No'),
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
                          child: const Text('Yes'),
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
      GameSettingsX01 gameSettingsX01) {
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
            contentPadding: EdgeInsets.only(
                bottom: DIALOG_CONTENT_PADDING_BOTTOM,
                top: DIALOG_CONTENT_PADDING_TOP,
                left: DIALOG_CONTENT_PADDING_LEFT,
                right: DIALOG_CONTENT_PADDING_RIGHT),
            title: const Text('Swap Team'),
            content: StatefulBuilder(
              builder: (context, setState) {
                return Container(
                  width: double.maxFinite,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: possibleTeamsToSwap.length,
                    itemBuilder: (BuildContext context, int index) {
                      final team = possibleTeamsToSwap[index];

                      return RadioListTile(
                        title: Text(team.getName),
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
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => _swapTeam(
                    context, playerToSwap, selectedTeam, gameSettingsX01),
                child: const Text('Submit'),
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

  static _saveEdit(BuildContext context, GameSettingsX01 gameSettingsX01,
      Player playerToEdit) {
    if (!_formKeyEditPlayer.currentState!.validate()) return;

    _formKeyEditPlayer.currentState!.save();

    if (!(playerToEdit is Bot))
      playerToEdit.setName = editPlayerController.text;

    gameSettingsX01.notify();

    Navigator.of(context).pop();
  }

  static _submitEditedTeam(
      BuildContext context, GameSettingsX01 gameSettingsX01, Team teamToEdit) {
    if (!_formKeyEditTeam.currentState!.validate()) return;

    _formKeyEditTeam.currentState!.save();

    teamToEdit.setName = editTeamController.text;
    gameSettingsX01.notify();
    Navigator.of(context).pop();
  }

  static _swapTeam(BuildContext context, Player playerToSwap, Team? newTeam,
      GameSettingsX01 gameSettingsX01) {
    final Team? currentTeam =
        _getTeamOfPlayer(playerToSwap, gameSettingsX01.getTeams);

    for (Team team in gameSettingsX01.getTeams) {
      if (team == currentTeam) team.getPlayers.remove(playerToSwap);
      if (team == newTeam) team.getPlayers.add(playerToSwap);
    }

    gameSettingsX01.notify();

    Navigator.of(context).pop();
  }

  static _deleteTeam(Team teamToDelete, GameSettingsX01 gameSettingsX01) {
    gameSettingsX01.getTeams.remove(teamToDelete);
    for (Player playerToDelete in teamToDelete.getPlayers)
      gameSettingsX01.getPlayers.remove(playerToDelete);

    gameSettingsX01.notify();
  }

  static List<Team> _getPossibleTeamsToSwap(
      Player playerToSwap, GameSettingsX01 gameSettingsX01) {
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
      Player playerToSwap, GameSettingsX01 gameSettingsX01) {
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

  static _showDialogForDeletingTeam(
      BuildContext context, GameSettingsX01 gameSettingsX01, Team teamToEdit) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            contentPadding: EdgeInsets.only(
                bottom: DIALOG_CONTENT_PADDING_BOTTOM,
                top: DIALOG_CONTENT_PADDING_TOP,
                left: 24,
                right: 24),
            title: const Text('Info'),
            content: const Text(
                'All the players in this team will also be deleted.'),
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
                          color: Theme.of(context).colorScheme.primary,
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
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            gameSettingsX01.checkTeamNamingIds(teamToEdit);
                            _deleteTeam(teamToEdit, gameSettingsX01);
                            Navigator.of(context).pop();
                          },
                          child: const Text('Continue'),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          );
        });
  }
}
