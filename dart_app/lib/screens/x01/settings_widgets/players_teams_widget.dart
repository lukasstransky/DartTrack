import 'package:dart_app/constants.dart';
import 'package:dart_app/models/bot_model.dart';
import 'package:dart_app/models/game_settings/game_settings_x01_model.dart';
import 'package:dart_app/models/player_model.dart';
import 'package:dart_app/models/team_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:tuple/tuple.dart';
import 'package:sizer/sizer.dart';

final GlobalKey<FormState> _formKeyEditPlayer = GlobalKey<FormState>();

final GlobalKey<FormState> _formKeyEditTeam = GlobalKey<FormState>();

final TextEditingController _editTeamController = new TextEditingController();
final TextEditingController _editPlayerController = new TextEditingController();

//this widget contains all listview related dialogs like editing, swapping, deleting
class PlayersWidget extends StatelessWidget {
  const PlayersWidget({Key? key}) : super(key: key);

  void _showDialogForEditingPlayer(BuildContext context, Player playerToEdit,
      GameSettingsX01 gameSettingsX01) {
    //store values as "backup" if user modifies the avg. or name & then clicks on cancel
    String cancelName = "";
    double cancelAverage = 0.0;
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
          title: const Text("Edit"),
          content: StatefulBuilder(
            builder: (context, setState) {
              if (playerToEdit is Bot) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Slider(
                          value: playerToEdit.getPreDefinedAverage,
                          max: 120,
                          min: 10,
                          divisions: 120,
                          label: playerToEdit.getPreDefinedAverage
                                  .round()
                                  .toString() +
                              ' avg.',
                          onChanged: (value) {
                            setState(
                              () {
                                playerToEdit.setPreDefinedAverage = value;
                              },
                            );
                          },
                        ),
                        Flexible(
                          child: Text(
                            playerToEdit.getPreDefinedAverage
                                    .round()
                                    .toString() +
                                ' avg.',
                            style: TextStyle(
                              fontSize: 7.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              } else {
                return TextFormField(
                  controller: _editPlayerController
                    ..text = playerToEdit.getName,
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return ("Please Enter a Name!");
                    }
                    if (gameSettingsX01.checkIfPlayerNameExists(value)) {
                      return "Playername already exists!";
                    }
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
                    hintText: "Name",
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
                Navigator.of(context).pop(),
                if (playerToEdit is Bot)
                  {
                    playerToEdit.setPreDefinedAverage = cancelAverage,
                  }
                else
                  {
                    playerToEdit.setName = cancelName,
                  }
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () =>
                  _saveEdit(context, gameSettingsX01, playerToEdit),
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }

  void _saveEdit(BuildContext context, GameSettingsX01 gameSettingsX01,
      Player playerToEdit) {
    if (!_formKeyEditPlayer.currentState!.validate()) {
      return;
    }
    _formKeyEditPlayer.currentState!.save();

    if (playerToEdit is Bot) {
      gameSettingsX01.notify();
    } else {
      gameSettingsX01.updatePlayerName(
          _editPlayerController.text, playerToEdit);
    }

    Navigator.of(context).pop();
  }

  void _showDialogForSwitchingTeam(BuildContext context, Player playerToSwap,
      GameSettingsX01 gameSettingsX01) {
    Team? newTeam = gameSettingsX01
        .checkIfMultipleTeamsToAddExceptCurrentTeam(playerToSwap);
    if (newTeam == null) {
      List<Team> possibleTeamsToSwap =
          gameSettingsX01.getPossibleTeamsToSwap(playerToSwap);
      Team? selectedTeam = possibleTeamsToSwap[0];

      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Swap Team"),
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
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () => _swapTeam(
                    context, playerToSwap, selectedTeam, gameSettingsX01),
                child: const Text("Submit"),
              ),
            ],
          );
        },
      );
    } else {
      gameSettingsX01.swapTeam(playerToSwap, newTeam);
    }
  }

  void _swapTeam(BuildContext context, Player playerToSwap, Team? newTeam,
      GameSettingsX01 gameSettingsX01) {
    gameSettingsX01.swapTeam(playerToSwap, newTeam);
    Navigator.of(context).pop();
  }

  void _showDialogForEditingTeam(
      BuildContext context, Team teamToEdit, GameSettingsX01 gameSettingsX01) {
    String cancelName = teamToEdit.getName;

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Form(
          key: _formKeyEditTeam,
          child: AlertDialog(
            title: const Text("Edit Team"),
            content: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _editTeamController
                        ..text = teamToEdit.getName,
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return ("Please enter a valid name!");
                        }

                        if (gameSettingsX01.checkIfTeamNameExists(value)) {
                          return "Teamname already exists!";
                        }
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
                          "Want to delete this Team?",
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                        IconButton(
                            icon: Icon(Icons.delete),
                            color: Colors.red,
                            onPressed: () {
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
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () =>
                    _submitEditedTeam(context, gameSettingsX01, teamToEdit),
                child: const Text("Submit"),
              ),
            ],
          ),
        );
      },
    );
  }

  void _submitEditedTeam(
      BuildContext context, GameSettingsX01 gameSettingsX01, Team teamToEdit) {
    if (!_formKeyEditTeam.currentState!.validate()) {
      return;
    }
    _formKeyEditTeam.currentState!.save();

    gameSettingsX01.updateTeamName(_editTeamController.text, teamToEdit);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final gameSettingsX01 =
        Provider.of<GameSettingsX01>(context, listen: false);

    return Container(
      width: WIDTH_GAMESETTINGS.w,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Selector<GameSettingsX01, SingleOrTeam>(
              selector: (_, gameSettingsX01) => gameSettingsX01.getSingleOrTeam,
              builder: (_, singleOrTeam, __) {
                if (singleOrTeam == SingleOrTeam.Single) {
                  return Selector<GameSettingsX01, List<Player>>(
                      selector: (_, gameSettingsX01) =>
                          gameSettingsX01.getPlayers,
                      shouldRebuild: (previous, next) => true,
                      builder: (_, players, __) => ConstrainedBox(
                            constraints: BoxConstraints(maxHeight: 18.h),
                            child: ListView.builder(
                              shrinkWrap: true,

                              reverse: true, //show new added player on top
                              scrollDirection: Axis.vertical,
                              itemCount: gameSettingsX01.getPlayers.length,
                              itemBuilder: (BuildContext context, int index) {
                                final player = players[index];
                                return ListTile(
                                  key: ValueKey(player),
                                  title: player is Bot
                                      ? Row(
                                          children: [
                                            Text(player.getName),
                                            Text(
                                              ' ' +
                                                  player.getPreDefinedAverage
                                                      .round()
                                                      .toString() +
                                                  ' avg.',
                                              style: TextStyle(
                                                fontSize: 7.sp,
                                              ),
                                            ),
                                          ],
                                        )
                                      : FittedBox(
                                          fit: BoxFit.scaleDown,
                                          alignment: Alignment.centerLeft,
                                          child: Text(player.getName),
                                        ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.edit),
                                        onPressed: () =>
                                            _showDialogForEditingPlayer(context,
                                                player, gameSettingsX01),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.highlight_remove),
                                        onPressed: () => {
                                          gameSettingsX01.removePlayer(player),
                                        },
                                      ),
                                    ],
                                  ),
                                  visualDensity: VisualDensity(
                                      horizontal: 0, vertical: -4),
                                );
                              },
                            ),
                          ));
                } else {
                  return Selector<GameSettingsX01,
                      Tuple2<List<Team>, List<Player>>>(
                    selector: (_, gameSettingsX01) => Tuple2(
                        gameSettingsX01.getTeams, gameSettingsX01.getPlayers),
                    shouldRebuild: (previous, next) => true,
                    builder: (_, tuple, __) => ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: 24.h),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: tuple.item1.length,
                        itemBuilder: (BuildContext context, int index) {
                          final team = tuple.item1[index];

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _showDialogForEditingTeam(
                                      context, team, gameSettingsX01);
                                },
                                child: Text(
                                  team.getName,
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              ListView.builder(
                                reverse: true,
                                shrinkWrap: true,
                                itemCount: team.getPlayers.length,
                                physics: ClampingScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  final player = team.getPlayers[index];

                                  return ListTile(
                                    key: ValueKey(player),
                                    title: player is Bot
                                        ? Row(
                                            children: [
                                              Text(player.getName),
                                              Text(
                                                ' ' +
                                                    player.getPreDefinedAverage
                                                        .round()
                                                        .toString() +
                                                    ' avg.',
                                                style: TextStyle(
                                                  fontSize: 7.sp,
                                                ),
                                              ),
                                            ],
                                          )
                                        : FittedBox(
                                            fit: BoxFit.scaleDown,
                                            alignment: Alignment.centerLeft,
                                            child: Text(player.getName),
                                          ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.edit),
                                          onPressed: () =>
                                              _showDialogForEditingPlayer(
                                                  context,
                                                  player,
                                                  gameSettingsX01),
                                        ),
                                        if (gameSettingsX01.getTeams.length > 1)
                                          IconButton(
                                            icon: Icon(Icons.swap_vert),
                                            onPressed: () => {
                                              _showDialogForSwitchingTeam(
                                                  context,
                                                  player,
                                                  gameSettingsX01)
                                            },
                                          ),
                                        IconButton(
                                          icon: Icon(Icons.highlight_remove),
                                          onPressed: () => {
                                            gameSettingsX01
                                                .removePlayer(player),
                                          },
                                        ),
                                      ],
                                    ),
                                    visualDensity: VisualDensity(
                                        horizontal: 0, vertical: -4),
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  );
                }
              }),
        ],
      ),
    );
  }
}
