import 'package:dart_app/constants.dart';
import 'package:dart_app/models/bot.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/models/team.dart';
import 'package:dart_app/services/auth_service.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class StartGameBtn extends StatelessWidget {
  _showDialogNoUserInPlayerWarning(
      BuildContext context, GameSettingsX01_P gameSettingsX01) {
    final String currentUserName =
        context.read<AuthService>().getPlayer!.getName;

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.primary,
        contentPadding: EdgeInsets.only(
            bottom: DIALOG_CONTENT_PADDING_BOTTOM,
            top: DIALOG_CONTENT_PADDING_TOP,
            left: DIALOG_CONTENT_PADDING_LEFT,
            right: DIALOG_CONTENT_PADDING_RIGHT),
        title: Text(
          'Game will not be stored for Statistics!',
          style: TextStyle(color: Colors.white),
        ),
        content: RichText(
          text: TextSpan(
            text: 'No player with the current username ',
            style: TextStyle(color: Colors.white),
            children: <TextSpan>[
              TextSpan(
                text: '\'$currentUserName\'',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: ' is present, therefore the game will not be stored.',
                style: TextStyle(color: Colors.white),
              ),
              TextSpan(
                text:
                    '\n\n(In order to store the game, change the name of one player to \'$currentUserName\')',
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

  _showDialogForBeginner(
      BuildContext context, GameSettingsX01_P gameSettingsX01) {
    final List<Player> players = gameSettingsX01.getPlayers;
    Player? selectedPlayer = gameSettingsX01.getPlayers[0];

    final List<Team> teams = gameSettingsX01.getTeams;
    Team? selectedTeam = gameSettingsX01.getTeams[0];

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.primary,
        contentPadding: EdgeInsets.only(
            bottom: DIALOG_CONTENT_PADDING_BOTTOM,
            top: DIALOG_CONTENT_PADDING_TOP,
            left: DIALOG_CONTENT_PADDING_LEFT,
            right: DIALOG_CONTENT_PADDING_RIGHT),
        title: Text(
          'Who will begin?',
          style: TextStyle(color: Colors.white),
        ),
        content: StatefulBuilder(
          builder: ((context, setState) {
            if (gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Single ||
                _onePlayerPerTeam(gameSettingsX01))
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
                                      'Level ${player.getLevel} Bot',
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
              gameSettingsX01.notify(),
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
            onPressed: () => {
              if (gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Single)
                _setBeginnerPlayer(selectedPlayer, gameSettingsX01.getPlayers)
              else
                _setBeginnerTeam(selectedTeam, gameSettingsX01.getTeams),
              Navigator.of(context).pushNamed(
                '/gameX01',
                arguments: {'openGame': false},
              ),
            },
            child: Text(
              'Start Game',
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
      if (team.getPlayers.length > 1) return false;
    }

    gameSettingsX01.setSingleOrTeam = SingleOrTeamEnum.Single;

    return true;
  }

  bool _activateStartGameBtn(GameSettingsX01_P gameSettingsX01) {
    if (gameSettingsX01.getPlayers.length < 2) {
      return false;
    } else if (gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Team) {
      if (_anyEmptyTeam(gameSettingsX01))
        return false;
      else if (gameSettingsX01.getTeams.length < 2) return false;
    }

    return true;
  }

  bool _anyEmptyTeam(GameSettingsX01_P gameSettingsX01) {
    for (Team team in gameSettingsX01.getTeams)
      if (team.getPlayers.isEmpty) return true;

    return false;
  }

  _setBeginnerTeam(Team? teamToSet, List<Team> teams) {
    int index = 0;

    for (int i = 0; i < teams.length; i++) if (teams[i] == teamToSet) index = i;

    //otherwise team is already first in list
    if (index != 0) {
      final Team temp = teams[0];
      teams[0] = teamToSet as Team;
      teams[index] = temp;
    }
  }

  _setBeginnerPlayer(Player? playerToSet, List<Player> players) {
    int index = 0;

    for (int i = 0; i < players.length; i++)
      if (players[i] == playerToSet) index = i;

    //otherwise player is already first in list
    if (index != 0) {
      final Player temp = players[0];
      players[0] = playerToSet as Player;
      players[index] = temp;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Consumer<GameSettingsX01_P>(builder: (_, gameSettingsX01, __) {
          return Container(
            width: 60.w,
            height: Utils.getHeightForWidget(gameSettingsX01).h,
            child: TextButton(
              child: Text(
                'Start game',
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
              onPressed: () => {
                if (_activateStartGameBtn(gameSettingsX01))
                  {
                    //todo comment out
                    /*if (!gameSettingsX01.isCurrentUserInPlayers(context))
                      {
                        _showDialogNoUserInPlayerWarning(
                            context, gameSettingsX01),
                      }
                    else
                      {*/
                    _showDialogForBeginner(context, gameSettingsX01),
                    //}
                  }
              },
            ),
          );
        }),
      ),
    );
  }
}
