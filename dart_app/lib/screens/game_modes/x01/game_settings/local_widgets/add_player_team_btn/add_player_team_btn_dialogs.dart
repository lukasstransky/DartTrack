import 'package:dart_app/constants.dart';
import 'package:dart_app/models/bot.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/models/team.dart';
import 'package:dart_app/utils/globals.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class AddPlayerTeamBtnDialogs {
  static final GlobalKey<FormState> _formKeyNewTeam = GlobalKey<FormState>();
  static final GlobalKey<FormState> _formKeyNewPlayer = GlobalKey<FormState>();

  static int _selectedBotAvgValue = 0;

  static _resetBotAvgValue() {
    _selectedBotAvgValue = DEFAULT_BOT_AVG_SLIDER_VALUE;
  }

  static bool showBotOption(GameSettingsX01 gameSettingsX01) {
    if (gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Team) {
      return gameSettingsX01.getCountOfBotPlayers() < 2;
    }
    return !(gameSettingsX01.getCountOfBotPlayers() >= 1) &&
        gameSettingsX01.getPlayers.length <= 1;
  }

  static showDialogForAddingPlayer(
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
          contentPadding: EdgeInsets.only(
              bottom: DIALOG_CONTENT_PADDING_BOTTOM,
              top: DIALOG_CONTENT_PADDING_TOP,
              left: DIALOG_CONTENT_PADDING_LEFT,
              right: DIALOG_CONTENT_PADDING_RIGHT),
          title: const Text('Add New Player'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (showBotOption(gameSettingsX01)) ...[
                    ListTile(
                      title: Container(
                        transform: Matrix4.translationValues(
                            DEFAULT_LIST_TILE_NEGATIVE_MARGIN.w, 0.0, 0.0),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (newPlayer == NewPlayer.Bot) ...[
                                  Text(
                                      'Level ${Utils.getLevelForBot(_selectedBotAvgValue)} Bot'),
                                  Container(
                                    transform: Matrix4.translationValues(
                                        -1.w, 0.0, 0.0),
                                    child: Text(
                                      ' (${_selectedBotAvgValue - BOT_AVG_SLIDER_VALUE_RANGE}-${_selectedBotAvgValue + BOT_AVG_SLIDER_VALUE_RANGE} avg.)',
                                      style: TextStyle(fontSize: 10.sp),
                                    ),
                                  ),
                                ] else ...[
                                  const Text('Bot')
                                ]
                              ],
                            )
                          ],
                        ),
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
                            _selectedBotAvgValue = newValue.round();
                          });
                        },
                      ),
                    ListTile(
                      title: Container(
                          transform: Matrix4.translationValues(
                              DEFAULT_LIST_TILE_NEGATIVE_MARGIN.w, 0.0, 0.0),
                          child: const Text('Guest')),
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
                            return ('Please enter a name!');
                          }
                          if (gameSettingsX01.checkIfPlayerNameExists(
                              value, true)) {
                            return 'Playername already existsssss!';
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
                  ] else ...[
                    GuestTextFormField(),
                  ]
                ],
              );
            },
          ),
          actions: [
            Row(
              children: [
                gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Team &&
                        gameSettingsX01.getTeams.length < 4
                    ? Expanded(
                        child: Container(
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

                                showDialogForAddingPlayerOrTeam(
                                    gameSettingsX01, context);
                              },
                            ),
                          ),
                        ),
                      )
                    : SizedBox.shrink(),
                Expanded(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        _resetBotAvgValue();
                        newPlayerController.clear();
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        _submitNewPlayer(gameSettingsX01, context, newPlayer);
                      },
                      child: const Text('Submit'),
                    ),
                  ],
                ))
              ],
            ),
          ],
        ),
      ),
    );
  }

  static _submitNewPlayer(GameSettingsX01 gameSettingsX01, BuildContext context,
      NewPlayer? newPlayer) async {
    if (!_formKeyNewPlayer.currentState!.validate()) return;
    _formKeyNewPlayer.currentState!.save();

    Player playerToAdd;
    if (!showBotOption(gameSettingsX01)) {
      newPlayer = NewPlayer.Guest;
    }
    if (newPlayer == NewPlayer.Bot) {
      final int botNameId = gameSettingsX01.getCountOfBotPlayers() == 0 ? 1 : 2;
      playerToAdd = new Bot(
          name: 'Bot$botNameId',
          preDefinedAverage: _selectedBotAvgValue,
          level: int.parse(Utils.getLevelForBot(_selectedBotAvgValue)));
    } else
      playerToAdd = new Player(name: newPlayerController.text);

    Navigator.of(context).pop();

    if (gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Team) {
      final Team? team = _checkIfMultipleTeamsToAdd(gameSettingsX01.getTeams);
      if (team != null)
        _addNewPlayerToSpecificTeam(playerToAdd, team, gameSettingsX01);
      else
        _showDialogForSelectingTeam(
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

  static showDialogForAddingTeam(
      GameSettingsX01 gameSettingsX01, BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Form(
          key: _formKeyNewTeam,
          child: AlertDialog(
            contentPadding: EdgeInsets.only(
                bottom: DIALOG_CONTENT_PADDING_BOTTOM,
                top: DIALOG_CONTENT_PADDING_TOP,
                left: DIALOG_CONTENT_PADDING_LEFT,
                right: DIALOG_CONTENT_PADDING_RIGHT),
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
              Row(
                children: [
                  if (gameSettingsX01.getTeams.isNotEmpty)
                    Expanded(
                      child: Container(
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
                              showDialogForAddingPlayerOrTeam(
                                  gameSettingsX01, context);
                            },
                          ),
                        ),
                      ),
                    ),
                  Expanded(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
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
                        ]),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  static _submitNewTeam(GameSettingsX01 gameSettingsX01, BuildContext context) {
    if (!_formKeyNewTeam.currentState!.validate()) return;

    _formKeyNewTeam.currentState!.save();

    gameSettingsX01.getTeams.add(new Team(name: newTeamController.text));
    gameSettingsX01.notify();
    Navigator.of(context).pop();
  }

  static _addNewPlayerToSpecificTeam(Player playerToAdd, Team? teamForNewPlayer,
      GameSettingsX01 gameSettingsX01) {
    gameSettingsX01.getPlayers.add(playerToAdd);
    for (Team team in gameSettingsX01.getTeams)
      if (team == teamForNewPlayer)
        team.getPlayers.add(Player.clone(playerToAdd));

    gameSettingsX01.notify();
  }

  static showDialogForAddingPlayerOrTeam(
      GameSettingsX01 gameSettingsX01, BuildContext context) {
    String? teamOrPlayer = 'player';

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
          title: const Text('Add Team or Player?'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (gameSettingsX01.getTeams.length < MAX_TEAMS)
                    RadioListTile(
                      title: Container(
                          transform: Matrix4.translationValues(
                              DEFAULT_LIST_TILE_NEGATIVE_MARGIN.w, 0.0, 0.0),
                          child: const Text('Team')),
                      value: 'team',
                      groupValue: teamOrPlayer,
                      onChanged: (String? value) {
                        setState(() => teamOrPlayer = value);
                      },
                    ),
                  if (gameSettingsX01.getTeams.length > 0)
                    RadioListTile(
                      title: Container(
                          transform: Matrix4.translationValues(
                              DEFAULT_LIST_TILE_NEGATIVE_MARGIN.w, 0.0, 0.0),
                          child: const Text('Player')),
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

  static Team _getTeamWithLeastPlayers(GameSettingsX01 gameSettingsX01) {
    Team teamWithLeastPlayers = gameSettingsX01.getTeams[0];
    for (Team team in gameSettingsX01.getTeams) {
      if (team.getPlayers.length < teamWithLeastPlayers.getPlayers.length) {
        teamWithLeastPlayers = team;
      }
    }
    return teamWithLeastPlayers;
  }

  //checks if player can be added to only one team -> return that team (prevent to show only 1 radio button in selecting team dialog)
  static Team? _checkIfMultipleTeamsToAdd(List<Team> teams) {
    int count = 0;
    Team? team;

    for (Team t in teams) {
      if (t.getPlayers.length < MAX_PLAYERS_PER_TEAM) {
        count++;
        team = t;
      }
    }

    if (count == 1) return team;

    return null;
  }

  static _submitNewTeamForPlayer(Player player, Team? selectedTeam,
      GameSettingsX01 gameSettings, BuildContext context) {
    _addNewPlayerToSpecificTeam(player, selectedTeam, gameSettings);

    Navigator.of(context).pop();
  }

  static _showDialogForSelectingTeam(Player playerToAdd, List<Team> teams,
      GameSettingsX01 gameSettingsX01, BuildContext context) {
    Team? selectedTeam;
    if (teams.length >= 2) {
      selectedTeam =
          AddPlayerTeamBtnDialogs._getTeamWithLeastPlayers(gameSettingsX01);
    }
    teams = teams.reversed.toList();

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
                      reverse: true,
                      itemBuilder: (BuildContext context, int index) {
                        final team = teams[index];

                        if (team.getPlayers.length != MAX_PLAYERS_PER_TEAM) {
                          return RadioListTile(
                            title: Container(
                                transform: Matrix4.translationValues(
                                    DEFAULT_LIST_TILE_NEGATIVE_MARGIN.w,
                                    0.0,
                                    0.0),
                                child: Text(team.getName)),
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
                        showDialogForAddingPlayer(gameSettingsX01, context);
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
                        _submitNewTeamForPlayer(playerToAdd, selectedTeam,
                            gameSettingsX01, context);
                      },
                      child: const Text('Submit'),
                    ),
                  ],
                ))
              ],
            ),
          ],
        );
      },
    );
  }
}

class GuestTextFormField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final gameSettingsX01 = context.read<GameSettingsX01>();

    return TextFormField(
      controller: newPlayerController,
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
        LengthLimitingTextInputFormatter(MAX_CHARACTERS_NEW_PLAYER_TEXTFIELD),
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
}
