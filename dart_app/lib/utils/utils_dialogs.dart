import 'package:dart_app/constants.dart';
import 'package:dart_app/models/bot.dart';
import 'package:dart_app/models/firestore/open_games_firestore.dart';
import 'package:dart_app/models/game_settings/game_settings_cricket_p.dart';
import 'package:dart_app/models/game_settings/game_settings_p.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/models/games/game_cricket_p.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/models/team.dart';
import 'package:dart_app/models/user_p.dart';
import 'package:dart_app/services/auth_service.dart';
import 'package:dart_app/services/firestore/firestore_service_games.dart';
import 'package:dart_app/utils/ad_management/banner_ads_manager_p.dart';
import 'package:dart_app/utils/button_styles.dart';
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DIALOG_SHAPE_ROUNDING),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        contentPadding:
            Utils.isMobile(context) ? DIALOG_CONTENT_PADDING_MOBILE : null,
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
            style: ButtonStyles.darkPrimaryColorBtnStyle(context).copyWith(
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
                    'mode': mode.name,
                  },
                );
              } else if (mode == GameMode.ScoreTraining) {
                Navigator.of(context).pushNamed('/gameScoreTraining');
              }
            },
            child: Text(
              'Continue anyways',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
              ),
            ),
            style: ButtonStyles.darkPrimaryColorBtnStyle(context).copyWith(
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
        contentPadding:
            Utils.isMobile(context) ? DIALOG_CONTENT_PADDING_MOBILE : null,
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
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Bot - lvl. ${player.getLevel}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .fontSize,
                                          ),
                                        ),
                                        Text(
                                          ' (${player.getPreDefinedAverage.round() - BOT_AVG_SLIDER_VALUE_RANGE} - ${player.getPreDefinedAverage.round() + BOT_AVG_SLIDER_VALUE_RANGE} avg.)',
                                          style: TextStyle(
                                            fontSize: 8.sp,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    )
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
            style: ButtonStyles.darkPrimaryColorBtnStyle(context).copyWith(
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
                context
                    .read<GameX01_P>()
                    .init(context.read<GameSettingsX01_P>());
                Navigator.of(context).pushNamed('/gameX01');
              } else if (mode == GameMode.Cricket) {
                context
                    .read<GameCricket_P>()
                    .init(context.read<GameSettingsCricket_P>());
                Navigator.of(context).pushNamed('/gameCricket');
              }
            },
            child: Text(
              'Start',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
              ),
            ),
            style: ButtonStyles.darkPrimaryColorBtnStyle(context).copyWith(
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
        contentPadding:
            Utils.isMobile(context) ? DIALOG_CONTENT_PADDING_MOBILE : null,
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
                  style:
                      ButtonStyles.darkPrimaryColorBtnStyle(context).copyWith(
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
                        if (context.read<User_P>().getAdsEnabled) {
                          context
                              .read<BannerAdManager_P>()
                              .disposeCorrectBannerAd(game_p);
                        }

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
                      style: ButtonStyles.darkPrimaryColorBtnStyle(context)
                          .copyWith(
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
                      final bool isConnected =
                          await Utils.hasInternetConnection();
                      if (!isConnected) {
                        return;
                      }

                      Utils.handleVibrationFeedback(context);

                      Navigator.of(context, rootNavigator: true).pop();

                      context.read<OpenGamesFirestore>().setLoadOpenGames =
                          true;
                      await context
                          .read<FirestoreServiceGames>()
                          .postOpenGame(game_p, context);

                      _resetValuesAndNavigateToHome(context, game_p);
                      if (context.read<User_P>().getAdsEnabled) {
                        await context
                            .read<BannerAdManager_P>()
                            .disposeCorrectBannerAd(game_p);
                      }
                    },
                    child: Text(
                      'Yes',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary,
                        fontSize:
                            Theme.of(context).textTheme.bodyMedium!.fontSize,
                      ),
                    ),
                    style:
                        ButtonStyles.darkPrimaryColorBtnStyle(context).copyWith(
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
    Navigator.of(context).pushReplacementNamed('/home');
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
