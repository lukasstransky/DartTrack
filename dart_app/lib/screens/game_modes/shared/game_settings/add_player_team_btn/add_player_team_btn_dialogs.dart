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

  static bool _isTeamMode(GameSettings_P gameSettings_P) {
    if (gameSettings_P is GameSettingsX01_P) {
      return gameSettings_P.getSingleOrTeam == SingleOrTeamEnum.Team;
    } else if (gameSettings_P is GameSettingsCricket_P) {
      return gameSettings_P.getSingleOrTeam == SingleOrTeamEnum.Team;
    }

    return false;
  }

  static showDialogForAddingPlayer(
      GameSettings_P gameSettings_P, BuildContext context) async {
    NewPlayer? newPlayer;
    if (gameSettings_P is GameSettingsX01_P) {
      newPlayer = gameSettings_P.getSingleOrTeam == SingleOrTeamEnum.Single
          ? NewPlayer.Bot
          : NewPlayer.Guest;
    } else {
      newPlayer = NewPlayer.Guest;
    }
    _resetBotAvgValue();

    Utils.forcePortraitMode(context);

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => Form(
        key: _formKeyNewPlayer,
        child: AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(DIALOG_SHAPE_ROUNDING),
          ),
          contentPadding:
              Utils.isMobile(context) ? DIALOG_CONTENT_PADDING_MOBILE : null,
          title: Text(
            'Add player',
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (showBotOption(gameSettings_P)) ...[
                      ListTile(
                        title: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (newPlayer == NewPlayer.Bot) ...[
                                  Text(
                                    'Bot - lvl. ${Utils.getLevelForBot(_selectedBotAvgValue)}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .fontSize,
                                    ),
                                  ),
                                  Text(
                                    ' (${_selectedBotAvgValue - BOT_AVG_SLIDER_VALUE_RANGE} - ${_selectedBotAvgValue + BOT_AVG_SLIDER_VALUE_RANGE} avg.)',
                                    style: TextStyle(
                                      fontSize: 8.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                ] else ...[
                                  Text(
                                    'Bot',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .fontSize,
                                    ),
                                  )
                                ]
                              ],
                            )
                          ],
                        ),
                        leading: Theme(
                          data: Theme.of(context).copyWith(
                              unselectedWidgetColor:
                                  Utils.getPrimaryColorDarken(context)),
                          child: Radio<NewPlayer>(
                            activeColor:
                                Theme.of(context).colorScheme.secondary,
                            value: NewPlayer.Bot,
                            groupValue: newPlayer,
                            onChanged: (value) {
                              Utils.handleVibrationFeedback(context);
                              setState(
                                () {
                                  newPlayerController.text = '';
                                  newPlayer = value;
                                },
                              );
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
                            Utils.handleVibrationFeedback(context);
                            setState(() {
                              _selectedBotAvgValue = newValue.round();
                            });
                          },
                        ),
                      ListTile(
                        title: Text(
                          'Guest',
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
                                Utils.getPrimaryColorDarken(context),
                          ),
                          child: Radio<NewPlayer>(
                            activeColor:
                                Theme.of(context).colorScheme.secondary,
                            value: NewPlayer.Guest,
                            groupValue: newPlayer,
                            onChanged: (value) {
                              Utils.handleVibrationFeedback(context);
                              setState(
                                () {
                                  _resetBotAvgValue();
                                  newPlayer = value;
                                },
                              );
                            },
                          ),
                        ),
                      ),
                      if (newPlayer == NewPlayer.Guest)
                        GuestTextFormField(gameSettings_P: gameSettings_P),
                    ] else
                      GuestTextFormField(gameSettings_P: gameSettings_P),
                  ],
                );
              },
            ),
          ),
          actions: [
            Row(
              children: [
                _isTeamMode(gameSettings_P) &&
                        gameSettings_P.getTeams.length < 4
                    ? Container(
                        width: 20.w,
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            size: ICON_BUTTON_SIZE.h,
                            Icons.arrow_back,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          onPressed: () {
                            Utils.handleVibrationFeedback(context);
                            Navigator.of(context).pop();

                            showDialogForAddingPlayerOrTeam(
                                gameSettings_P, context);
                          },
                        ),
                      )
                    : SizedBox.shrink(),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
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
                        onPressed: () {
                          Utils.handleVibrationFeedback(context);
                          Navigator.of(context).pop();
                          _resetBotAvgValue();
                          newPlayerController.clear();
                        },
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
                      SizedBox(
                        width: ACTION_BTNS_SPACING.w,
                      ),
                      Flexible(
                        child: TextButton(
                          child: Text(
                            _shouldDisplayContinue(gameSettings_P)
                                ? 'Continue'
                                : 'Submit',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .fontSize,
                            ),
                          ),
                          onPressed: () {
                            Utils.handleVibrationFeedback(context);
                            _submitNewPlayer(
                                gameSettings_P, context, newPlayer);
                          },
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
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
  }

  static _shouldDisplayContinue(GameSettings_P gameSettings) {
    if (!(gameSettings is GameSettingsX01_P ||
        gameSettings is GameSettingsCricket_P)) {
      return false;
    }

    if (gameSettings is GameSettingsX01_P) {
      if (gameSettings.getSingleOrTeam == SingleOrTeamEnum.Single) {
        return false;
      }
    } else if (gameSettings is GameSettingsCricket_P) {
      if (gameSettings.getSingleOrTeam == SingleOrTeamEnum.Single) {
        return false;
      }
    }

    if (gameSettings.getTeams.length == 1) {
      return false;
    }

    int counter = 0;
    for (Team team in gameSettings.getTeams) {
      if (team.getPlayers.length < MAX_PLAYERS_PER_TEAM) {
        counter++;
      }
    }
    if (counter >= 2) {
      return true;
    }

    return false;
  }

  static _submitNewPlayer(GameSettings_P gameSettings_P, BuildContext context,
      NewPlayer? newPlayer) async {
    newPlayerController.text = newPlayerController.text.trim();
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

    if (_isTeamMode(gameSettings_P)) {
      final Team? team = _checkIfMultipleTeamsToAdd(gameSettings_P.getTeams);

      if (team != null) {
        _addNewPlayerToSpecificTeam(playerToAdd, team, gameSettings_P);
      } else {
        _showDialogForSelectingTeam(
            playerToAdd, gameSettings_P.getTeams, gameSettings_P, context);
      }
    } else {
      if (gameSettings_P is GameSettingsX01_P ||
          gameSettings_P is GameSettingsCricket_P) {
        gameSettings_P.addPlayer(playerToAdd);
      } else {
        // for modes like score training no team should be assigned to a player
        gameSettings_P.getPlayers.add(playerToAdd);
        gameSettings_P.notify();
      }
    }

    newPlayerController.clear();
  }

  static showDialogForAddingTeam(
      GameSettings_P gameSettings, BuildContext context) async {
    bool showBackBtn = false;
    for (Team team in gameSettings.getTeams) {
      if (team.getPlayers.length != MAX_PLAYERS_PER_TEAM &&
          gameSettings.getPlayers.length < MAX_PLAYERS_X01) {
        showBackBtn = true;
      }
    }

    Utils.forcePortraitMode(context);

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Form(
          key: _formKeyNewTeam,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(DIALOG_SHAPE_ROUNDING),
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            contentPadding:
                Utils.isMobile(context) ? DIALOG_CONTENT_PADDING_MOBILE : null,
            title: Text(
              'Add team',
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
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        autofocus: true,
                        controller:
                            newTextControllerForAddingNewTeamInGameSettingsX01(),
                        textInputAction: TextInputAction.done,
                        validator: (value) {
                          if (value!.trim().isEmpty) {
                            return ('Please enter a team name!');
                          }
                          if (gameSettings.checkIfTeamNameExists(value)) {
                            Utils.setCursorForTextControllerToEnd(
                                newTeamController);
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
                          fillColor: Utils.darken(
                              Theme.of(context).colorScheme.primary, 10),
                          prefixIcon: Icon(
                            size: ICON_BUTTON_SIZE.h,
                            Icons.group,
                            color: Utils.getPrimaryColorDarken(context),
                          ),
                          hintText: 'Team',
                          filled: true,
                          hintStyle: TextStyle(
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .fontSize,
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
            ),
            actions: [
              Row(
                children: [
                  if (showBackBtn)
                    Container(
                      width: 20.w,
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          size: ICON_BUTTON_SIZE.h,
                          Icons.arrow_back,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        onPressed: () {
                          Utils.handleVibrationFeedback(context);
                          Navigator.of(context).pop();
                          showDialogForAddingPlayerOrTeam(
                              gameSettings, context);
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
                            newTeamController.clear();
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
                        SizedBox(
                          width: ACTION_BTNS_SPACING.w,
                        ),
                        TextButton(
                          onPressed: () {
                            Utils.handleVibrationFeedback(context);
                            _submitNewTeam(gameSettings, context);
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

    await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
  }

  static _submitNewTeam(GameSettings_P gameSettings, BuildContext context) {
    newTeamController.text = newTeamController.text.trim();
    if (!_formKeyNewTeam.currentState!.validate()) {
      return;
    }

    _formKeyNewTeam.currentState!.save();

    gameSettings.getTeams.add(new Team(name: newTeamController.text));
    gameSettings.notify();

    Navigator.of(context).pop();
  }

  static _addNewPlayerToSpecificTeam(
      Player playerToAdd, Team? teamForNewPlayer, GameSettings_P gameSettings) {
    gameSettings.getPlayers.add(playerToAdd);
    for (Team team in gameSettings.getTeams)
      if (team == teamForNewPlayer) {
        team.getPlayers.add(Player.clone(playerToAdd));
      }

    gameSettings.notify();
  }

  static showDialogForAddingPlayerOrTeam(
      GameSettings_P gameSettings, BuildContext context) {
    String? teamOrPlayer = 'player';

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
            'Add team or player?',
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (gameSettings.getTeams.length < MAX_TEAMS)
                      Theme(
                        data: Theme.of(context).copyWith(
                          unselectedWidgetColor:
                              Utils.getPrimaryColorDarken(context),
                        ),
                        child: Theme(
                          data: ThemeData(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                          ),
                          child: ListTile(
                            title: Text(
                              'Team',
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
                              child: Radio<String>(
                                activeColor:
                                    Theme.of(context).colorScheme.secondary,
                                value: 'team',
                                groupValue: teamOrPlayer,
                                onChanged: (value) {
                                  Utils.handleVibrationFeedback(context);
                                  setState(
                                    () {
                                      Utils.handleVibrationFeedback(context);
                                      setState(() => teamOrPlayer = value);
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    if (gameSettings.getTeams.length > 0)
                      ListTile(
                        title: Text(
                          'Player',
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
                          child: Radio<String>(
                            activeColor:
                                Theme.of(context).colorScheme.secondary,
                            value: 'player',
                            groupValue: teamOrPlayer,
                            onChanged: (value) {
                              Utils.handleVibrationFeedback(context);
                              setState(
                                () {
                                  Utils.handleVibrationFeedback(context);
                                  setState(() => teamOrPlayer = value);
                                },
                              );
                            },
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          actions: [
            TextButton(
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                ),
              ),
              onPressed: () {
                Utils.handleVibrationFeedback(context);
                Navigator.of(context).pop();
              },
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(DIALOG_BTN_SHAPE_ROUNDING),
                  ),
                ),
                splashFactory: NoSplash.splashFactory,
                shadowColor: MaterialStateProperty.all(Colors.transparent),
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                backgroundColor:
                    Utils.getPrimaryMaterialStateColorDarken(context),
              ),
            ),
            TextButton(
              child: Text(
                'Continue',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                ),
              ),
              onPressed: () {
                Utils.handleVibrationFeedback(context);
                Navigator.of(context).pop();
                if (teamOrPlayer == 'team') {
                  showDialogForAddingTeam(gameSettings, context);
                } else {
                  showDialogForAddingPlayer(gameSettings, context);
                }
              },
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(DIALOG_BTN_SHAPE_ROUNDING),
                  ),
                ),
                splashFactory: NoSplash.splashFactory,
                shadowColor: MaterialStateProperty.all(Colors.transparent),
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                backgroundColor:
                    Utils.getPrimaryMaterialStateColorDarken(context),
              ),
            ),
          ],
        );
      },
    );
  }

  static Team _getTeamWithLeastPlayers(GameSettings_P gameSettings) {
    Team teamWithLeastPlayers = gameSettings.getTeams[0];
    for (Team team in gameSettings.getTeams) {
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
      GameSettings_P gameSettings, BuildContext context) {
    _addNewPlayerToSpecificTeam(player, selectedTeam, gameSettings);

    Navigator.of(context).pop();
  }

  static _showDialogForSelectingTeam(Player playerToAdd, List<Team> teams,
      GameSettings_P gameSettings, BuildContext context) {
    Team? selectedTeam;
    if (teams.length >= 2) {
      selectedTeam =
          AddPlayerTeamBtnDialogs._getTeamWithLeastPlayers(gameSettings);
    }
    teams = teams.reversed.toList();

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
            'Which team?',
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
                                          Utils.handleVibrationFeedback(
                                              context);
                                          setState(() => selectedTeam = value);
                                        },
                                      );
                                    },
                                  ),
                                ),
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
          ),
          actions: [
            Row(
              children: [
                Container(
                  width: 20.w,
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    padding: EdgeInsets.zero,
                    icon: Icon(
                      size: ICON_BUTTON_SIZE.h,
                      Icons.arrow_back,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    onPressed: () {
                      Utils.handleVibrationFeedback(context);
                      Navigator.of(context).pop();
                      showDialogForAddingPlayer(gameSettings, context);
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
                          fontSize:
                              Theme.of(context).textTheme.bodyMedium!.fontSize,
                        ),
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
                    SizedBox(
                      width: ACTION_BTNS_SPACING.w,
                    ),
                    TextButton(
                      onPressed: () {
                        Utils.handleVibrationFeedback(context);
                        _submitNewTeamForPlayer(
                            playerToAdd, selectedTeam, gameSettings, context);
                      },
                      child: Text(
                        'Submit',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize:
                              Theme.of(context).textTheme.bodyMedium!.fontSize,
                        ),
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
                ))
              ],
            ),
          ],
        );
      },
    );
  }
}

class GuestTextFormField extends StatefulWidget {
  const GuestTextFormField({
    Key? key,
    required this.gameSettings_P,
  }) : super(key: key);

  final GameSettings_P gameSettings_P;

  @override
  State<GuestTextFormField> createState() => _GuestTextFormFieldState();
}

class _GuestTextFormFieldState extends State<GuestTextFormField> {
  @override
  void initState() {
    super.initState();
    newTextControllerForAddingNewPlayerInGameSettingsX01();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: true,
      controller: newPlayerController,
      textInputAction: TextInputAction.done,
      validator: (value) {
        if (value!.trim().isEmpty) {
          return ('Please enter a name!');
        }
        if (widget.gameSettings_P.checkIfPlayerNameExists(value)) {
          Utils.setCursorForTextControllerToEnd(newPlayerController);
          return 'Name already exists!';
        }
        return null;
      },
      keyboardType: TextInputType.text,
      inputFormatters: [
        LengthLimitingTextInputFormatter(MAX_CHARACTERS_NEW_PLAYER_TEXTFIELD),
      ],
      style: TextStyle(
        color: Colors.white,
        fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
      ),
      decoration: InputDecoration(
        errorStyle: TextStyle(fontSize: DIALOG_ERROR_MSG_FONTSIZE.sp),
        prefixIcon: Icon(
          size: ICON_BUTTON_SIZE.h,
          Icons.person,
          color: Utils.getPrimaryColorDarken(context),
        ),
        hintText: 'Name',
        fillColor: Utils.darken(Theme.of(context).colorScheme.primary, 10),
        filled: true,
        hintStyle: TextStyle(
          fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
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
