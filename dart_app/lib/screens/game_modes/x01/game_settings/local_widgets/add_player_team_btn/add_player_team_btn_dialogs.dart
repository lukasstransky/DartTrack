import 'package:dart_app/constants.dart';
import 'package:dart_app/models/bot.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/models/team.dart';
import 'package:dart_app/utils/globals.dart';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class AddPlayerTeamBtnDialogs {
  static final GlobalKey<FormState> _formKeyNewTeam = GlobalKey<FormState>();
  static final GlobalKey<FormState> _formKeyNewPlayer = GlobalKey<FormState>();

  static double _selectedBotAvgValue = 0.0;

  static void _resetBotAvgValue() {
    _selectedBotAvgValue = DEFAULT_BOT_AVG_SLIDER_VALUE.toDouble();
  }

  static void showDialogForAddingPlayer(
      GameSettingsX01 gameSettingsX01, BuildContext context) {
    NewPlayer? newPlayer =
        gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Single
            ? NewPlayer.Bot
            : NewPlayer.Guest;
    _resetBotAvgValue();

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => Form(
        key: _formKeyNewPlayer,
        child: AlertDialog(
          title: const Text('Add New Player'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Row(
                      children: [
                        const Text('Bot'),
                        if (newPlayer == NewPlayer.Bot)
                          Text(
                            ' (${_selectedBotAvgValue - BOT_AVG_SLIDER_VALUE_RANGE}-${_selectedBotAvgValue + BOT_AVG_SLIDER_VALUE_RANGE} avg.)',
                            style: TextStyle(fontSize: 10.sp),
                          ),
                      ],
                    ),
                    leading: Radio<NewPlayer>(
                      value: NewPlayer.Bot,
                      groupValue: newPlayer,
                      onChanged: (value) => {
                        setState(
                          () {
                            newPlayerController.text = '';
                            newPlayer = value;
                          },
                        ),
                      },
                    ),
                  ),
                  if (newPlayer == NewPlayer.Bot)
                    SfSlider(
                      min: 22,
                      max: 118,
                      value: _selectedBotAvgValue,
                      stepSize: 4,
                      interval: 100,
                      showTicks: false,
                      onChanged: (dynamic newValue) {
                        setState(() {
                          _selectedBotAvgValue = newValue;
                        });
                      },
                    ),
                  ListTile(
                    title: const Text('Guest'),
                    leading: Radio<NewPlayer>(
                      value: NewPlayer.Guest,
                      groupValue: newPlayer,
                      onChanged: (value) => {
                        setState(
                          () {
                            _resetBotAvgValue();
                            newPlayer = value;
                          },
                        ),
                      },
                    ),
                  ),
                  if (newPlayer == NewPlayer.Guest)
                    TextFormField(
                      controller: newPlayerController,
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return ('Please Enter a Name!');
                        }
                        if (gameSettingsX01.checkIfPlayerNameExists(value)) {
                          return 'Playername already exists!';
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
                    ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => {
                _resetBotAvgValue(),
                newPlayerController.clear(),
                Navigator.of(context).pop(),
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              key: Key('submitPlayerBtn'),
              onPressed: () =>
                  _submitNewPlayer(gameSettingsX01, context, newPlayer),
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  static void _submitNewPlayer(GameSettingsX01 gameSettingsX01,
      BuildContext context, NewPlayer? newPlayer) async {
    if (!_formKeyNewPlayer.currentState!.validate()) return;
    _formKeyNewPlayer.currentState!.save();

    Player playerToAdd;
    if (newPlayer == NewPlayer.Bot) {
      final int botNameId = gameSettingsX01.getBotNamingIds.length + 1;
      playerToAdd = new Bot(
          name: 'Bot$botNameId', preDefinedAverage: _selectedBotAvgValue);
      gameSettingsX01.getBotNamingIds.add(botNameId);
    } else
      playerToAdd = new Player(name: newPlayerController.text);

    Navigator.of(context).pop();

    if (gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Team) {
      Team? team = gameSettingsX01.checkIfMultipleTeamsToAdd();
      if (team != null)
        gameSettingsX01.addNewPlayerToSpecificTeam(playerToAdd, team);
      else
        showDialogForSelectingTeam(
            playerToAdd, gameSettingsX01.getTeams, gameSettingsX01, context);
    } else {
      gameSettingsX01.addPlayer(playerToAdd);

      //scroll automatically smoothly to top in single player
      await Future.delayed(const Duration(milliseconds: 100));
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (scrollControllerPlayers.hasClients)
          scrollControllerPlayers.animateTo(
              scrollControllerPlayers.position.maxScrollExtent,
              duration: Duration(milliseconds: 300),
              curve: Curves.fastOutSlowIn);
      });
    }

    newPlayerController.clear();
  }

  static void showDialogForAddingTeam(
      GameSettingsX01 gameSettingsX01, BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Form(
          key: _formKeyNewTeam,
          child: AlertDialog(
            title: const Text('Add Team'),
            content: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: newTeamController,
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value!.isEmpty)
                          return ('Please enter a Team name!');

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
                        hintText: 'Team',
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
                  ],
                );
              },
            ),
            actions: [
              TextButton(
                onPressed: () => {
                  newTeamController.clear(),
                  Navigator.of(context).pop(),
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => {
                  _submitNewTeam(gameSettingsX01, context),
                  newTeamController.clear(),
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        );
      },
    );
  }

  static void _submitNewTeam(
      GameSettingsX01 gameSettingsX01, BuildContext context) {
    if (!_formKeyNewTeam.currentState!.validate()) return;

    _formKeyNewTeam.currentState!.save();

    gameSettingsX01.addNewTeam(newTeamController.text);
    Navigator.of(context).pop();
  }

  static void showDialogForAddingPlayerOrTeam(
      GameSettingsX01 gameSettingsX01, BuildContext context) {
    String? teamOrPlayer = 'player';

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Wanna add a Team or Player?'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (gameSettingsX01.getTeams.length < MAX_TEAMS)
                    RadioListTile(
                      title: const Text('Add Team'),
                      value: 'team',
                      groupValue: teamOrPlayer,
                      onChanged: (String? value) {
                        setState(() => teamOrPlayer = value);
                      },
                    ),
                  if (gameSettingsX01.getTeams.length > 0)
                    RadioListTile(
                      title: const Text('Add Player'),
                      value: 'player',
                      groupValue: teamOrPlayer,
                      onChanged: (String? value) {
                        setState(() => teamOrPlayer = value);
                      },
                    ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => {
                Navigator.of(context).pop(),
                if (teamOrPlayer == 'team')
                  showDialogForAddingTeam(gameSettingsX01, context)
                else
                  showDialogForAddingPlayer(gameSettingsX01, context),
              },
              child: const Text('Continue'),
            ),
          ],
        );
      },
    );
  }

  static void showDialogForSelectingTeam(Player playerToAdd, List<Team> teams,
      GameSettingsX01 gameSettings, BuildContext context) {
    Team? selectedTeam;
    if (teams.length >= 2) {
      selectedTeam = teams[0]; //set first team as default
    }

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Which Team?'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Container(
                width: 0.6.w,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: teams.length,
                      itemBuilder: (BuildContext context, int index) {
                        final team = teams[index];

                        if (team.getPlayers.length != MAX_PLAYERS_PER_TEAM) {
                          return RadioListTile(
                            title: Text(team.getName),
                            value: team,
                            groupValue: selectedTeam,
                            onChanged: (Team? value) =>
                                setState(() => selectedTeam = value),
                          );
                        } else
                          return SizedBox.shrink();
                      },
                    ),
                  ],
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
              onPressed: () => _submitNewTeamForPlayer(
                  playerToAdd, selectedTeam, gameSettings, context),
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  static void _submitNewTeamForPlayer(Player player, Team? selectedTeam,
      GameSettingsX01 gameSettings, BuildContext context) {
    gameSettings.addNewPlayerToSpecificTeam(player, selectedTeam);

    Navigator.of(context).pop();
  }
}
