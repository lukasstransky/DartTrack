import 'package:dart_app/constants.dart';
import 'package:dart_app/models/bot.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/models/team.dart';
import 'package:dart_app/utils/globals.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class PlayersTeamsListDialogs {
  static final GlobalKey<FormState> _formKeyEditPlayer = GlobalKey<FormState>();
  static final GlobalKey<FormState> _formKeyEditTeam = GlobalKey<FormState>();

  static void showDialogForEditingPlayer(BuildContext context,
      Player playerToEdit, GameSettingsX01 gameSettingsX01) {
    //store values as "backup" if user modifies the avg. or name & then clicks on cancel
    String cancelName = '';
    double cancelAverage = 0.0;

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
          title: const Text('Edit'),
          content: StatefulBuilder(
            builder: (context, setState) {
              if (playerToEdit is Bot) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                        '${playerToEdit.getName} (${playerToEdit.getPreDefinedAverage - BOT_AVG_SLIDER_VALUE_RANGE}-${playerToEdit.getPreDefinedAverage + BOT_AVG_SLIDER_VALUE_RANGE} avg.)'),
                    SfSlider(
                      min: 22,
                      max: 118,
                      value: playerToEdit.getPreDefinedAverage,
                      stepSize: 4,
                      interval: 100,
                      showTicks: false,
                      onChanged: (dynamic newValue) {
                        setState(() {
                          playerToEdit.setPreDefinedAverage = newValue;
                        });
                      },
                    ),
                  ],
                );
              } else {
                return TextFormField(
                  controller: editPlayerController..text = playerToEdit.getName,
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value!.isEmpty) return ('Please enter a Name!');

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

  static void _saveEdit(BuildContext context, GameSettingsX01 gameSettingsX01,
      Player playerToEdit) {
    if (!_formKeyEditPlayer.currentState!.validate()) {
      return;
    }
    _formKeyEditPlayer.currentState!.save();

    if (!(playerToEdit is Bot))
      playerToEdit.setName = editPlayerController.text;
    gameSettingsX01.notify();

    Navigator.of(context).pop();
  }

  static void showDialogForEditingTeam(
      BuildContext context, Team teamToEdit, GameSettingsX01 gameSettingsX01) {
    String cancelName = teamToEdit.getName;

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Form(
          key: _formKeyEditTeam,
          child: AlertDialog(
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
                          'Want to delete this Team?',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                        IconButton(
                            icon: Icon(Icons.delete),
                            color: Colors.red,
                            onPressed: () {
                              gameSettingsX01.checkTeamNamingIds(teamToEdit);
                              gameSettingsX01.deleteTeam(teamToEdit);
                              Navigator.of(context).pop();
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

  static void _submitEditedTeam(
      BuildContext context, GameSettingsX01 gameSettingsX01, Team teamToEdit) {
    if (!_formKeyEditTeam.currentState!.validate()) return;

    _formKeyEditTeam.currentState!.save();

    teamToEdit.setName = editTeamController.text;
    gameSettingsX01.notify();
    Navigator.of(context).pop();
  }

  static void showDialogForSwitchingTeam(BuildContext context,
      Player playerToSwap, GameSettingsX01 gameSettingsX01) {
    Team? newTeam =
        gameSettingsX01.checkIfSwappingOnlyToOneTeamPossible(playerToSwap);
    if (newTeam == null) {
      List<Team> possibleTeamsToSwap =
          gameSettingsX01.getPossibleTeamsToSwap(playerToSwap);
      Team? selectedTeam = possibleTeamsToSwap[0];

      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
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
      gameSettingsX01.swapTeam(playerToSwap, newTeam);
    }
  }

  static void _swapTeam(BuildContext context, Player playerToSwap,
      Team? newTeam, GameSettingsX01 gameSettingsX01) {
    gameSettingsX01.swapTeam(playerToSwap, newTeam);
    Navigator.of(context).pop();
  }
}
