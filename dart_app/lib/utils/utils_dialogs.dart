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
import 'package:responsive_framework/responsive_framework.dart';
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DIALOG_SHAPE_ROUNDING),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        contentPadding: ResponsiveBreakpoints.of(context).isMobile
            ? DIALOG_CONTENT_PADDING_MOBILE
            : null,
        title: Text(
          'Game will not be stored!',
          style: TextStyle(
            color: Colors.white,
            fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
          ),
        ),
        content: Container(
          width: DIALOG_NORMAL_WIDTH.w,
          child: RichText(
            text: TextSpan(
              text: 'No player with the current logged in username ',
              style: TextStyle(
                color: Colors.white,
                fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
              ),
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
        ),
        actions: [
          TextButton(
            onPressed: () {
              Utils.handleVibrationFeedback(context);
              Navigator.of(context).pop();
            },
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
              ),
            ),
            style: ButtonStyle(
              splashFactory: NoSplash.splashFactory,
              shadowColor: MaterialStateProperty.all(Colors.transparent),
              overlayColor: MaterialStateProperty.all(Colors.transparent),
              backgroundColor:
                  Utils.getPrimaryMaterialStateColorDarken(context),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(DIALOG_BTN_SHAPE_ROUNDING),
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Utils.handleVibrationFeedback(context);
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
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
              ),
            ),
            style: ButtonStyle(
              splashFactory: NoSplash.splashFactory,
              shadowColor: MaterialStateProperty.all(Colors.transparent),
              overlayColor: MaterialStateProperty.all(Colors.transparent),
              backgroundColor:
                  Utils.getPrimaryMaterialStateColorDarken(context),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(DIALOG_BTN_SHAPE_ROUNDING),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static showDialogForBeginner(
      BuildContext context, dynamic gameSettings, GameMode mode) {
    final List<Player> players = gameSettings.getPlayers;
    Player? selectedPlayer = gameSettings.getPlayers[0];

    final List<Team> teams = gameSettings.getTeams;
    Team? selectedTeam = gameSettings.getTeams[0];

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DIALOG_SHAPE_ROUNDING),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        contentPadding: ResponsiveBreakpoints.of(context).isMobile
            ? DIALOG_CONTENT_PADDING_MOBILE
            : null,
        title: Text(
          'Who will begin?',
          style: TextStyle(
            color: Colors.white,
            fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
          ),
        ),
        content: Container(
          width: DIALOG_NORMAL_WIDTH.w,
          child: StatefulBuilder(
            builder: ((context, setState) {
              if (gameSettings.getSingleOrTeam == SingleOrTeamEnum.Single ||
                  _onePlayerPerTeam(gameSettings))
                return Container(
                  width: double.maxFinite,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: players.length,
                    itemBuilder: (BuildContext context, int index) {
                      final player = players[index];

                      return Theme(
                        data: ThemeData(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                        ),
                        child: ListTile(
                          title: player is Bot
                              ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Bot - lvl. ${player.getLevel}',
                                      style: TextStyle(
                                        fontSize: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .fontSize,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Container(
                                      transform: Matrix4.translationValues(
                                          0.0, -0.5.w, 0.0),
                                      child: Text(
                                        ' (${player.getPreDefinedAverage.round() - BOT_AVG_SLIDER_VALUE_RANGE} - ${player.getPreDefinedAverage.round() + BOT_AVG_SLIDER_VALUE_RANGE} avg.)',
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
                            child: Radio<Player>(
                              activeColor:
                                  Theme.of(context).colorScheme.secondary,
                              value: player,
                              groupValue: selectedPlayer,
                              onChanged: (value) {
                                Utils.handleVibrationFeedback(context);
                                setState(
                                  () {
                                    Utils.handleVibrationFeedback(context);
                                    setState(() => selectedPlayer = value);
                                  },
                                );
                              },
                            ),
                          ),
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
                                  Utils.handleVibrationFeedback(context);
                                  setState(() => selectedTeam = value);
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Utils.handleVibrationFeedback(context);
              Navigator.of(context).pop();
              gameSettings.notify();
            },
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
              ),
            ),
            style: ButtonStyle(
              splashFactory: NoSplash.splashFactory,
              shadowColor: MaterialStateProperty.all(Colors.transparent),
              overlayColor: MaterialStateProperty.all(Colors.transparent),
              backgroundColor:
                  Utils.getPrimaryMaterialStateColorDarken(context),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(DIALOG_BTN_SHAPE_ROUNDING),
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Utils.handleVibrationFeedback(context);
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
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
              ),
            ),
            style: ButtonStyle(
              splashFactory: NoSplash.splashFactory,
              shadowColor: MaterialStateProperty.all(Colors.transparent),
              overlayColor: MaterialStateProperty.all(Colors.transparent),
              backgroundColor:
                  Utils.getPrimaryMaterialStateColorDarken(context),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(DIALOG_BTN_SHAPE_ROUNDING),
                ),
              ),
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DIALOG_SHAPE_ROUNDING),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        contentPadding: ResponsiveBreakpoints.of(context).isMobile
            ? DIALOG_CONTENT_PADDING_MOBILE
            : null,
        title: Text(
          'End game',
          style: TextStyle(
            color: Colors.white,
            fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
          ),
        ),
        content: Container(
          width: DIALOG_NORMAL_WIDTH.w,
          child: Text(
            'Do you want to save the game for finishing it later?',
            style: TextStyle(
              color: Colors.white,
              fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
            ),
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () {
                    Utils.handleVibrationFeedback(context);
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      fontSize:
                          Theme.of(context).textTheme.bodyMedium!.fontSize,
                    ),
                  ),
                  style: ButtonStyle(
                    splashFactory: NoSplash.splashFactory,
                    shadowColor: MaterialStateProperty.all(Colors.transparent),
                    overlayColor: MaterialStateProperty.all(Colors.transparent),
                    backgroundColor:
                        Utils.getPrimaryMaterialStateColorDarken(context),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(DIALOG_BTN_SHAPE_ROUNDING),
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.only(right: 2.5.w),
                    child: TextButton(
                      onPressed: () {
                        Utils.handleVibrationFeedback(context);
                        Navigator.of(context).pop();
                        _resetValuesAndNavigateToHome(context, game_p);
                      },
                      child: Text(
                        'No',
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
                  ),
                  TextButton(
                    onPressed: () async {
                      Utils.handleVibrationFeedback(context);
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
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(DIALOG_BTN_SHAPE_ROUNDING),
                        ),
                      ),
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
    players = new List.from(players);
    players.insert(0, firstPlayer as Player);

    gameSettings_P.setPlayers = players;
  }
}
