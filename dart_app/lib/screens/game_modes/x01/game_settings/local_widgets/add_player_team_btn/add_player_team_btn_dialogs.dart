import 'package:dart_app/constants.dart';
import 'package:dart_app/models/bot.dart';
import 'package:dart_app/models/game_settings/game_settings_p.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
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

  static bool showBotOption(GameSettings_P gameSettings_P) {
    if (gameSettings_P is GameSettingsX01_P) {
      if (gameSettings_P.getSingleOrTeam == SingleOrTeamEnum.Team) {
        return !(gameSettings_P.getCountOfBotPlayers() >= 1);
      }
      return !(gameSettings_P.getCountOfBotPlayers() >= 1) &&
          gameSettings_P.getPlayers.length <= 1;
    }
    return false;
  }

  static showDialogForAddingPlayer(
      GameSettings_P gameSettings_P, BuildContext context) {
    NewPlayer? newPlayer;
    if (gameSettings_P is GameSettingsX01_P) {
      newPlayer = gameSettings_P.getSingleOrTeam == SingleOrTeamEnum.Single
          ? NewPlayer.Bot
          : NewPlayer.Guest;
    } else {
      newPlayer = NewPlayer.Guest;
    }
    _resetBotAvgValue();

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => Form(
        key: _formKeyNewPlayer,
        child: AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.primary,
          contentPadding: EdgeInsets.only(
              bottom: DIALOG_CONTENT_PADDING_BOTTOM,
              top: DIALOG_CONTENT_PADDING_TOP,
              left: DIALOG_CONTENT_PADDING_LEFT,
              right: DIALOG_CONTENT_PADDING_RIGHT),
          title: Text(
            'Add new player',
            style: TextStyle(color: Colors.white),
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (showBotOption(gameSettings_P)) ...[
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
                                    'Level ${Utils.getLevelForBot(_selectedBotAvgValue)} Bot',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Container(
                                    transform: Matrix4.translationValues(
                                        -1.w, 0.0, 0.0),
                                    child: Text(
                                      ' (${_selectedBotAvgValue - BOT_AVG_SLIDER_VALUE_RANGE}-${_selectedBotAvgValue + BOT_AVG_SLIDER_VALUE_RANGE} avg.)',
                                      style: TextStyle(
                                          fontSize: 10.sp, color: Colors.white),
                                    ),
                                  ),
                                ] else ...[
                                  Text(
                                    'Bot',
                                    style: TextStyle(color: Colors.white),
                                  )
                                ]
                              ],
                            )
                          ],
                        ),
                      ),
                      leading: Theme(
                        data: Theme.of(context).copyWith(
                            unselectedWidgetColor:
                                Utils.getPrimaryColorDarken(context)),
                        child: Radio<NewPlayer>(
                          activeColor: Theme.of(context).colorScheme.secondary,
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
                    ),
                    if (newPlayer == NewPlayer.Bot)
                      SfSlider(
                        activeColor: Theme.of(context).colorScheme.secondary,
                        inactiveColor: Utils.getPrimaryColorDarken(context),
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
                          child: Text(
                            'Guest',
                            style: TextStyle(color: Colors.white),
                          )),
                      leading: Theme(
                        data: Theme.of(context).copyWith(
                          unselectedWidgetColor:
                              Utils.getPrimaryColorDarken(context),
                        ),
                        child: Radio<NewPlayer>(
                          activeColor: Theme.of(context).colorScheme.secondary,
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
                    ),
                    if (newPlayer == NewPlayer.Guest) GuestTextFormField(),
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
                gameSettings_P is GameSettingsX01_P &&
                        gameSettings_P.getSingleOrTeam ==
                            SingleOrTeamEnum.Team &&
                        gameSettings_P.getTeams.length < 4
                    ? Expanded(
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

                              showDialogForAddingPlayerOrTeam(
                                  gameSettings_P, context);
                            },
                          ),
                        ),
                      )
                    : SizedBox.shrink(),
                Expanded(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 3.w),
                      child: TextButton(
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary),
                        ),
                        onPressed: () {
                          _resetBotAvgValue();
                          newPlayerController.clear();
                          Navigator.of(context).pop();
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              Utils.getPrimaryMaterialStateColorDarken(context),
                        ),
                      ),
                    ),
                    TextButton(
                      child: Text(
                        'Submit',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                      onPressed: () =>
                          _submitNewPlayer(gameSettings_P, context, newPlayer),
                      style: ButtonStyle(
                        backgroundColor:
                            Utils.getPrimaryMaterialStateColorDarken(context),
                      ),
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

  static _submitNewPlayer(GameSettings_P gameSettings_P, BuildContext context,
      NewPlayer? newPlayer) async {
    if (!_formKeyNewPlayer.currentState!.validate()) {
      return;
    }
    _formKeyNewPlayer.currentState!.save();

    // create new player
    Player playerToAdd;
    if (!showBotOption(gameSettings_P)) {
      newPlayer = NewPlayer.Guest;
    }
    if (gameSettings_P is GameSettingsX01_P && newPlayer == NewPlayer.Bot) {
      final int botNameId = gameSettings_P.getCountOfBotPlayers() == 0 ? 1 : 2;

      playerToAdd = new Bot(
          name: 'Bot$botNameId',
          preDefinedAverage: _selectedBotAvgValue,
          level: int.parse(Utils.getLevelForBot(_selectedBotAvgValue)));
    } else {
      playerToAdd = new Player(name: newPlayerController.text);
    }

    Navigator.of(context).pop();

    // assign player to team
    if (gameSettings_P is GameSettingsX01_P &&
        gameSettings_P.getSingleOrTeam == SingleOrTeamEnum.Team) {
      final Team? team = _checkIfMultipleTeamsToAdd(gameSettings_P.getTeams);

      if (team != null) {
        _addNewPlayerToSpecificTeam(playerToAdd, team, gameSettings_P);
      } else {
        _showDialogForSelectingTeam(
            playerToAdd, gameSettings_P.getTeams, gameSettings_P, context);
      }
    } else {
      if (gameSettings_P is GameSettingsX01_P) {
        gameSettings_P.addPlayer(playerToAdd);
      } else {
        // for modes like score training no team should be assigned to a player
        gameSettings_P.getPlayers.add(playerToAdd);
        gameSettings_P.notifyListeners();
      }

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
      GameSettingsX01_P gameSettingsX01, BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Form(
          key: _formKeyNewTeam,
          child: AlertDialog(
            backgroundColor: Theme.of(context).colorScheme.primary,
            contentPadding: EdgeInsets.only(
                bottom: DIALOG_CONTENT_PADDING_BOTTOM,
                top: DIALOG_CONTENT_PADDING_TOP,
                left: DIALOG_CONTENT_PADDING_LEFT,
                right: DIALOG_CONTENT_PADDING_RIGHT),
            title: Text(
              'Add Team',
              style: TextStyle(color: Colors.white),
            ),
            content: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: newTeamController,
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return ('Please enter a Team name!');
                        }
                        if (gameSettingsX01.checkIfTeamNameExists(value)) {
                          return 'Teamname already exists!';
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
                        fillColor: Utils.darken(
                            Theme.of(context).colorScheme.primary, 10),
                        prefixIcon: Icon(
                          Icons.group,
                          color: Utils.getPrimaryColorDarken(context),
                        ),
                        hintText: 'Team',
                        filled: true,
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
                            showDialogForAddingPlayerOrTeam(
                                gameSettingsX01, context);
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
                            onPressed: () => {
                              newTeamController.clear(),
                              Navigator.of(context).pop(),
                            },
                            child: Text(
                              'Cancel',
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
                          onPressed: () => {
                            _submitNewTeam(gameSettingsX01, context),
                            newTeamController.clear(),
                          },
                          child: Text(
                            'Submit',
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
          ),
        );
      },
    );
  }

  static _submitNewTeam(
      GameSettingsX01_P gameSettingsX01, BuildContext context) {
    if (!_formKeyNewTeam.currentState!.validate()) return;

    _formKeyNewTeam.currentState!.save();

    gameSettingsX01.getTeams.add(new Team(name: newTeamController.text));
    gameSettingsX01.notify();
    Navigator.of(context).pop();
  }

  static _addNewPlayerToSpecificTeam(Player playerToAdd, Team? teamForNewPlayer,
      GameSettingsX01_P gameSettingsX01) {
    gameSettingsX01.getPlayers.add(playerToAdd);
    for (Team team in gameSettingsX01.getTeams)
      if (team == teamForNewPlayer)
        team.getPlayers.add(Player.clone(playerToAdd));

    gameSettingsX01.notify();
  }

  static showDialogForAddingPlayerOrTeam(
      GameSettingsX01_P gameSettingsX01, BuildContext context) {
    String? teamOrPlayer = 'player';

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
            'Add team or player?',
            style: TextStyle(color: Colors.white),
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (gameSettingsX01.getTeams.length < MAX_TEAMS)
                    Theme(
                      data: Theme.of(context).copyWith(
                        unselectedWidgetColor:
                            Utils.getPrimaryColorDarken(context),
                      ),
                      child: RadioListTile(
                        activeColor: Theme.of(context).colorScheme.secondary,
                        title: Container(
                          transform: Matrix4.translationValues(
                              DEFAULT_LIST_TILE_NEGATIVE_MARGIN.w, 0.0, 0.0),
                          child: Text(
                            'Team',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        value: 'team',
                        groupValue: teamOrPlayer,
                        onChanged: (String? value) {
                          setState(() => teamOrPlayer = value);
                        },
                      ),
                    ),
                  if (gameSettingsX01.getTeams.length > 0)
                    Theme(
                      data: Theme.of(context).copyWith(
                        unselectedWidgetColor:
                            Utils.getPrimaryColorDarken(context),
                      ),
                      child: RadioListTile(
                        activeColor: Theme.of(context).colorScheme.secondary,
                        title: Container(
                          transform: Matrix4.translationValues(
                              DEFAULT_LIST_TILE_NEGATIVE_MARGIN.w, 0.0, 0.0),
                          child: Text(
                            'Player',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        value: 'player',
                        groupValue: teamOrPlayer,
                        onChanged: (String? value) {
                          setState(() => teamOrPlayer = value);
                        },
                      ),
                    ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              child: Text(
                'Cancel',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.secondary),
              ),
              onPressed: () => Navigator.of(context).pop(),
              style: ButtonStyle(
                backgroundColor:
                    Utils.getPrimaryMaterialStateColorDarken(context),
              ),
            ),
            TextButton(
              child: Text(
                'Continue',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.secondary),
              ),
              onPressed: () => {
                Navigator.of(context).pop(),
                if (teamOrPlayer == 'team')
                  {
                    showDialogForAddingTeam(gameSettingsX01, context),
                  }
                else
                  {
                    showDialogForAddingPlayer(gameSettingsX01, context),
                  }
              },
              style: ButtonStyle(
                backgroundColor:
                    Utils.getPrimaryMaterialStateColorDarken(context),
              ),
            ),
          ],
        );
      },
    );
  }

  static Team _getTeamWithLeastPlayers(GameSettingsX01_P gameSettingsX01) {
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

    if (count == 1) {
      return team;
    }

    return null;
  }

  static _submitNewTeamForPlayer(Player player, Team? selectedTeam,
      GameSettingsX01_P gameSettings, BuildContext context) {
    _addNewPlayerToSpecificTeam(player, selectedTeam, gameSettings);

    Navigator.of(context).pop();
  }

  static _showDialogForSelectingTeam(Player playerToAdd, List<Team> teams,
      GameSettingsX01_P gameSettingsX01, BuildContext context) {
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
          backgroundColor: Theme.of(context).colorScheme.primary,
          contentPadding: EdgeInsets.only(
              bottom: DIALOG_CONTENT_PADDING_BOTTOM,
              top: DIALOG_CONTENT_PADDING_TOP,
              left: DIALOG_CONTENT_PADDING_LEFT,
              right: DIALOG_CONTENT_PADDING_RIGHT),
          title: Text(
            'Which team?',
            style: TextStyle(color: Colors.white),
          ),
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
                        final Team team = teams[index];

                        if (team.getPlayers.length != MAX_PLAYERS_PER_TEAM) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              unselectedWidgetColor:
                                  Utils.getPrimaryColorDarken(context),
                            ),
                            child: RadioListTile(
                              activeColor:
                                  Theme.of(context).colorScheme.secondary,
                              title: Container(
                                transform: Matrix4.translationValues(
                                    DEFAULT_LIST_TILE_NEGATIVE_MARGIN.w,
                                    0.0,
                                    0.0),
                                child: Text(
                                  team.getName,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              value: team,
                              groupValue: selectedTeam,
                              onChanged: (Team? value) =>
                                  setState(() => selectedTeam = value),
                            ),
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
                        color: Theme.of(context).colorScheme.secondary,
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
                              Utils.getPrimaryMaterialStateColorDarken(context),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => _submitNewTeamForPlayer(
                          playerToAdd, selectedTeam, gameSettingsX01, context),
                      child: Text(
                        'Submit',
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                      style: ButtonStyle(
                        backgroundColor:
                            Utils.getPrimaryMaterialStateColorDarken(context),
                      ),
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
    final gameSettingsX01 = context.read<GameSettingsX01_P>();

    return TextFormField(
      controller: newPlayerController,
      textInputAction: TextInputAction.done,
      validator: (value) {
        if (value!.isEmpty) {
          return ('Please enter a name!');
        }
        if (gameSettingsX01.checkIfPlayerNameExists(value)) {
          return 'Playername already exists!';
        }
        return null;
      },
      keyboardType: TextInputType.text,
      inputFormatters: [
        LengthLimitingTextInputFormatter(MAX_CHARACTERS_NEW_PLAYER_TEXTFIELD),
      ],
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.person,
          color: Utils.getPrimaryColorDarken(context),
        ),
        hintText: 'Name',
        fillColor: Utils.darken(Theme.of(context).colorScheme.primary, 10),
        filled: true,
        hintStyle: TextStyle(
          color: Utils.getPrimaryColorDarken(context),
        ),
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
