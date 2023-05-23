import 'package:dart_app/constants.dart';
import 'package:dart_app/models/bot.dart';
import 'package:dart_app/models/firestore/open_games_firestore.dart';
import 'package:dart_app/models/game_settings/game_settings_p.dart';
import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/models/team.dart';
import 'package:dart_app/services/auth_service.dart';
import 'package:dart_app/services/firestore/firestore_service_games.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class UtilsDialogs {
  static showDialogNoUserInPlayerWarning(
      BuildContext context, GameSettings_P gameSettings, GameMode mode) {
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
                text: '$username',
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
            onPressed: () {
              Navigator.of(context).pop();
              if (mode == GameMode.X01 || mode == GameMode.Cricket) {
                showDialogForBeginner(context, gameSettings, mode);
              } else if (mode == GameMode.SingleTraining ||
                  mode == GameMode.DoubleTraining) {
                Navigator.of(context).pushNamed(
                  '/gameSingleDoubleTraining',
                  arguments: {
                    'openGame': false,
                    'mode': mode.name,
                  },
                );
              } else if (mode == GameMode.ScoreTraining) {
                Navigator.of(context).pushNamed(
                  '/gameScoreTraining',
                  arguments: {
                    'openGame': false,
                    'mode': mode,
                  },
                );
              }
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

  static showDialogForBeginner(
      BuildContext context, dynamic gameSettings, GameMode mode) {
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
                      data: ThemeData(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
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

                  return Theme(
                    data: ThemeData(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                    ),
                    child: RadioListTile(
                      activeColor: Theme.of(context).colorScheme.secondary,
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
                    ),
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

              if (mode == GameMode.X01) {
                Navigator.of(context).pushNamed(
                  '/gameX01',
                  arguments: {'openGame': false},
                );
              } else if (mode == GameMode.Cricket) {
                Navigator.of(context).pushNamed(
                  '/gameCricket',
                  arguments: {
                    'openGame': false,
                    'mode': mode,
                  },
                );
              }
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

  static showDialogForSavingGame(BuildContext context, Game_P game_p) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context1) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.primary,
        contentPadding: dialogContentPadding,
        title: const Text(
          'End game',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Do you want to save the game for finishing it later?',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Continue',
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        Utils.getPrimaryMaterialStateColorDarken(context),
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.only(right: 2.5.w),
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _resetValuesAndNavigateToHome(context, game_p);
                      },
                      child: Text(
                        'No',
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
                    onPressed: () async {
                      Navigator.of(context, rootNavigator: true).pop();

                      game_p.setShowLoadingSpinner = true;
                      game_p.notify();

                      context.read<OpenGamesFirestore>().setLoadOpenGames =
                          true;
                      await context
                          .read<FirestoreServiceGames>()
                          .postOpenGame(game_p, context);

                      _resetValuesAndNavigateToHome(context, game_p);
                    },
                    child: Text(
                      'Yes',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary),
                    ),
                    style: ButtonStyle(
                      backgroundColor:
                          Utils.getPrimaryMaterialStateColorDarken(context),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  static _resetValuesAndNavigateToHome(BuildContext context, dynamic game_p) {
    game_p.reset();
    Navigator.of(context).pushNamed('/home');
  }

  static bool _onePlayerPerTeam(dynamic gameSettings) {
    for (Team team in gameSettings.getTeams) {
      if (team.getPlayers.length > 1) {
        return false;
      }
    }

    gameSettings.setSingleOrTeam = SingleOrTeamEnum.Single;

    return true;
  }

  static _setBeginnerTeam(Team? firstTeam, GameSettings_P gameSettings_P) {
    List<Team> teams = [...gameSettings_P.getTeams];

    teams.removeWhere((p) => p.getName == firstTeam!.getName);
    teams.insert(0, firstTeam as Team);

    gameSettings_P.setTeams = teams;
  }

  static _setBeginnerPlayer(
      Player? firstPlayer, GameSettings_P gameSettings_P) {
    List<Player> players = [...gameSettings_P.getPlayers];

    players.removeWhere((p) => p.getName == firstPlayer!.getName);
    players = new List.from(players.reversed);
    players.insert(0, firstPlayer as Player);

    gameSettings_P.setPlayers = players;
  }
}
