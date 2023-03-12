import 'package:dart_app/constants.dart';
import 'package:dart_app/models/bot.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/models/team.dart';
import 'package:dart_app/services/auth_service.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class StartGameBtnX01 extends StatelessWidget {
  _showDialogNoUserInPlayerWarning(
      BuildContext context, GameSettingsX01_P gameSettingsX01) {
    final String username =
        context.read<AuthService>().getUsernameFromSharedPreferences() ?? '';

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.primary,
        contentPadding: dialogContentPadding,
        title: Text(
          'Game will not be stored!',
          style: TextStyle(color: Colors.white),
        ),
        content: RichText(
          text: TextSpan(
            text: 'No player with the current logged in username ',
            style: TextStyle(color: Colors.white),
            children: <TextSpan>[
              TextSpan(
                text: '\'$username\'',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: ' is present, therefore the game will not be stored.',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
            style: ButtonStyle(
              backgroundColor:
                  Utils.getPrimaryMaterialStateColorDarken(context),
            ),
          ),
          TextButton(
            onPressed: () => {
              Navigator.of(context).pop(),
              _showDialogForBeginner(context, gameSettingsX01),
            },
            child: Text(
              'Continue anyways',
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
            style: ButtonStyle(
              backgroundColor:
                  Utils.getPrimaryMaterialStateColorDarken(context),
            ),
          ),
        ],
      ),
    );
  }

  _showDialogForBeginner(BuildContext context, GameSettingsX01_P gameSettings) {
    final List<Player> players = gameSettings.getPlayers;
    Player? selectedPlayer =
        gameSettings.getPlayers[gameSettings.getPlayers.length - 1];

    final List<Team> teams = gameSettings.getTeams;
    Team? selectedTeam = gameSettings.getTeams[0];

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.primary,
        contentPadding: dialogContentPadding,
        title: Text(
          'Who will begin?',
          style: TextStyle(color: Colors.white),
        ),
        content: StatefulBuilder(
          builder: ((context, setState) {
            if (gameSettings.getSingleOrTeam == SingleOrTeamEnum.Single ||
                _onePlayerPerTeam(gameSettings))
              return Container(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  reverse: true,
                  itemCount: players.length,
                  itemBuilder: (BuildContext context, int index) {
                    final player = players[index];

                    return Theme(
                      data: Theme.of(context).copyWith(
                        unselectedWidgetColor:
                            Utils.getPrimaryColorDarken(context),
                      ),
                      child: RadioListTile(
                        activeColor: Theme.of(context).colorScheme.secondary,
                        title: Container(
                          transform: Matrix4.translationValues(
                              DEFAULT_LIST_TILE_NEGATIVE_MARGIN.w, 0.0, 0.0),
                          child: player is Bot
                              ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Bot - level ${player.getLevel}',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Container(
                                      transform: Matrix4.translationValues(
                                          0.0, -0.5.w, 0.0),
                                      child: Text(
                                        ' (${player.getPreDefinedAverage.round() - BOT_AVG_SLIDER_VALUE_RANGE}-${player.getPreDefinedAverage.round() + BOT_AVG_SLIDER_VALUE_RANGE} avg.)',
                                        style: TextStyle(
                                          fontSize: 8.sp,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Text(
                                  player.getName,
                                  style: TextStyle(color: Colors.white),
                                ),
                        ),
                        value: player,
                        groupValue: selectedPlayer,
                        onChanged: (Player? value) {
                          setState(() => selectedPlayer = value);
                        },
                      ),
                    );
                  },
                ),
              );

            return Container(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: teams.length,
                itemBuilder: (BuildContext context, int index) {
                  final team = teams[index];

                  return RadioListTile(
                    title: Container(
                      transform: Matrix4.translationValues(
                          DEFAULT_LIST_TILE_NEGATIVE_MARGIN.w, 0.0, 0.0),
                      child: Text(
                        team.getName,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
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
          }),
        ),
        actions: [
          TextButton(
            onPressed: () => {
              gameSettings.notify(),
              Navigator.of(context).pop(),
            },
            child: Text(
              'Cancel',
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
            style: ButtonStyle(
              backgroundColor:
                  Utils.getPrimaryMaterialStateColorDarken(context),
            ),
          ),
          TextButton(
            onPressed: () {
              if (gameSettings.getSingleOrTeam == SingleOrTeamEnum.Single) {
                _setBeginnerPlayer(selectedPlayer, gameSettings);
              } else {
                _setBeginnerTeam(selectedTeam, gameSettings);
              }

              Navigator.of(context).pushNamed(
                '/gameX01',
                arguments: {'openGame': false},
              );
            },
            child: Text(
              'Start',
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
            style: ButtonStyle(
              backgroundColor:
                  Utils.getPrimaryMaterialStateColorDarken(context),
            ),
          ),
        ],
      ),
    );
  }

  bool _onePlayerPerTeam(GameSettingsX01_P gameSettingsX01) {
    for (Team team in gameSettingsX01.getTeams) {
      if (team.getPlayers.length > 1) {
        return false;
      }
    }

    gameSettingsX01.setSingleOrTeam = SingleOrTeamEnum.Single;

    return true;
  }

  bool _activateStartGameBtn(GameSettingsX01_P gameSettingsX01) {
    if (gameSettingsX01.getPlayers.length < 2) {
      return false;
    } else if (gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Team) {
      if (_anyEmptyTeam(gameSettingsX01)) {
        return false;
      } else if (gameSettingsX01.getTeams.length < 2) {
        return false;
      }
    }

    return true;
  }

  bool _anyEmptyTeam(GameSettingsX01_P gameSettingsX01) {
    for (Team team in gameSettingsX01.getTeams) {
      if (team.getPlayers.isEmpty) {
        return true;
      }
    }

    return false;
  }

  _setBeginnerTeam(Team? firstTeam, GameSettingsX01_P gameSettingsX01_P) {
    List<Team> teams = [...gameSettingsX01_P.getTeams];

    teams.removeWhere((p) => p.getName == firstTeam!.getName);
    teams.insert(0, firstTeam as Team);

    gameSettingsX01_P.setTeams = teams;
  }

  _setBeginnerPlayer(Player? firstPlayer, GameSettingsX01_P gameSettingsX01_P) {
    List<Player> players = [...gameSettingsX01_P.getPlayers];

    players.removeWhere((p) => p.getName == firstPlayer!.getName);
    players = new List.from(players.reversed);
    players.insert(0, firstPlayer as Player);

    gameSettingsX01_P.setPlayers = players;
  }

  @override
  Widget build(BuildContext context) {
    final String currentUsername =
        context.read<AuthService>().getUsernameFromSharedPreferences() ?? '';

    return Expanded(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Consumer<GameSettingsX01_P>(builder: (_, gameSettingsX01, __) {
          return Container(
            width: 60.w,
            height: 5.h,
            child: TextButton(
              child: Text(
                'Start',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              style: ButtonStyle(
                splashFactory: NoSplash.splashFactory,
                shadowColor: MaterialStateProperty.all(Colors.transparent),
                overlayColor: MaterialStateProperty.all(Colors.transparent),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
                backgroundColor: _activateStartGameBtn(gameSettingsX01)
                    ? Utils.getPrimaryMaterialStateColorDarken(context)
                    : Utils.getColor(Utils.darken(
                        Theme.of(context).colorScheme.primary, 60)),
              ),
              onPressed: () {
                if (_activateStartGameBtn(gameSettingsX01)) {
                  if (!gameSettingsX01.isCurrentUserInPlayers(context) &&
                      currentUsername != 'Guest') {
                    _showDialogNoUserInPlayerWarning(context, gameSettingsX01);
                  } else {
                    _showDialogForBeginner(context, gameSettingsX01);
                  }
                } else {
                  Fluttertoast.showToast(
                      msg: 'At least two players are required!',
                      toastLength: Toast.LENGTH_LONG);
                }
              },
            ),
          );
        }),
      ),
    );
  }
}
