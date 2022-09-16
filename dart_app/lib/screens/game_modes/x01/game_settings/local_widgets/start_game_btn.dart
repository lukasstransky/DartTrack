import 'package:dart_app/constants.dart';
import 'package:dart_app/models/bot.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/models/team.dart';
import 'package:dart_app/services/auth_service.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class StartGameBtn extends StatelessWidget {
  void _showDialogNoUserInPlayerWarning(
      BuildContext context, GameSettingsX01 gameSettingsX01) {
    String currentUserName = context.read<AuthService>().getPlayer!.getName;

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.only(
            bottom: DIALOG_CONTENT_PADDING_BOTTOM,
            top: DIALOG_CONTENT_PADDING_TOP,
            left: DIALOG_CONTENT_PADDING_LEFT,
            right: DIALOG_CONTENT_PADDING_RIGHT),
        title: const Text('Game will not be stored for Statistics!'),
        content: RichText(
          text: TextSpan(
            text: 'No player with the current username ',
            style: DefaultTextStyle.of(context).style,
            children: <TextSpan>[
              TextSpan(
                  text: '\'$currentUserName\'',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(
                  text: ' is present, therefore the game will not be stored.'),
              TextSpan(
                  text:
                      '\n\n(In order to store the game, change the name of one player to \'$currentUserName\')'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => {
              Navigator.of(context).pop(),
              _showDialogForBeginner(context, gameSettingsX01),
            },
            child: const Text('Continue anyways'),
          ),
        ],
      ),
    );
  }

  void _showDialogForBeginner(
      BuildContext context, GameSettingsX01 gameSettingsX01) {
    final List<Player> players = gameSettingsX01.getPlayers;
    Player? selectedPlayer = gameSettingsX01.getPlayers[0];

    final List<Team> teams = gameSettingsX01.getTeams;
    Team? selectedTeam = gameSettingsX01.getTeams[0];

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.only(
            bottom: DIALOG_CONTENT_PADDING_BOTTOM,
            top: DIALOG_CONTENT_PADDING_TOP,
            left: DIALOG_CONTENT_PADDING_LEFT,
            right: DIALOG_CONTENT_PADDING_RIGHT),
        title: const Text('Who will begin?'),
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

                    return RadioListTile(
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
                                    ),
                                  ),
                                  Container(
                                    transform: Matrix4.translationValues(
                                        0.0, -0.5.w, 0.0),
                                    child: Text(
                                      ' (${player.getPreDefinedAverage.round() - BOT_AVG_SLIDER_VALUE_RANGE}-${player.getPreDefinedAverage.round() + BOT_AVG_SLIDER_VALUE_RANGE} avg.)',
                                      style: TextStyle(
                                        fontSize: 8.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Text(player.getName),
                      ),
                      value: player,
                      groupValue: selectedPlayer,
                      onChanged: (Player? value) {
                        setState(() => selectedPlayer = value);
                      },
                    );
                  },
                ),
              );
            if (gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Team)
              return Container(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: teams.length,
                  reverse: true,
                  itemBuilder: (BuildContext context, int index) {
                    final team = teams[index];

                    return RadioListTile(
                      title: Container(
                        transform: Matrix4.translationValues(
                            DEFAULT_LIST_TILE_NEGATIVE_MARGIN.w, 0.0, 0.0),
                        child: Text(team.getName),
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
            return SizedBox.shrink();
          }),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => {
              if (gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Single)
                gameSettingsX01.setBeginnerPlayer(selectedPlayer)
              else
                gameSettingsX01.setBeginnerTeam(selectedTeam),
              Navigator.of(context).pushNamed(
                '/gameX01',
                arguments: {'openGame': false},
              ),
            },
            child: const Text('Start Game'),
          ),
        ],
      ),
    );
  }

  bool _onePlayerPerTeam(GameSettingsX01 gameSettingsX01) {
    for (Team team in gameSettingsX01.getTeams) {
      if (team.getPlayers.length != 1) {
        return false;
      }
    }
    gameSettingsX01.setSingleOrTeam = SingleOrTeamEnum.Single;
    return true;
  }

  bool _activateStartGameBtn(GameSettingsX01 gameSettingsX01) {
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

  bool _anyEmptyTeam(GameSettingsX01 gameSettingsX01) {
    for (Team team in gameSettingsX01.getTeams) {
      if (team.getPlayers.isEmpty) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Consumer<GameSettingsX01>(builder: (_, gameSettingsX01, __) {
          return Container(
            width: 60.w,
            height: Utils.getHeightForWidget(gameSettingsX01).h,
            child: TextButton(
              child: const Text(
                'Start Game',
                style: TextStyle(color: Colors.white),
              ),
              style: ButtonStyle(
                overlayColor: _activateStartGameBtn(gameSettingsX01)
                    ? Utils.getDefaultOverlayColor(context)
                    : MaterialStateProperty.all(Colors.transparent),
                splashFactory: _activateStartGameBtn(gameSettingsX01)
                    ? InkRipple.splashFactory
                    : NoSplash.splashFactory,
                shadowColor: MaterialStateProperty.all(Colors.transparent),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                ),
                backgroundColor: _activateStartGameBtn(gameSettingsX01)
                    ? Utils.getColor(Theme.of(context).colorScheme.primary)
                    : Utils.getColor(Utils.darken(
                        Theme.of(context).colorScheme.primary, 30)),
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
