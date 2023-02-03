import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_p.dart';
import 'package:dart_app/models/game_settings/game_settings_score_training_p.dart';
import 'package:dart_app/models/game_settings/game_settings_single_double_training_p.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/models/games/game_score_training_p.dart';
import 'package:dart_app/models/games/game_single_double_training_p.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/models/firestore/open_games_firestore.dart';
import 'package:dart_app/screens/game_modes/shared/finish/stats_card/stats_card.dart';
import 'package:dart_app/screens/game_modes/x01/finish/local_widgets/stats_card/stats_card_x01.dart';
import 'package:dart_app/services/firestore/firestore_service_games.dart';
import 'package:dart_app/utils/app_bars/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class OpenGames extends StatefulWidget {
  static const routeName = '/openGames';

  const OpenGames({Key? key}) : super(key: key);

  @override
  State<OpenGames> createState() => _OpenGamesState();
}

class _OpenGamesState extends State<OpenGames> {
  _setNewGameSettingsFromOpenGame(GameSettings_P openGameSettings) {
    if (openGameSettings is GameSettingsX01_P) {
      final settings = context.read<GameSettingsX01_P>();

      settings.setEnableCheckoutCounting =
          openGameSettings.getEnableCheckoutCounting;
      settings.setLegs = openGameSettings.getLegs;
      settings.setSets = openGameSettings.getSets;
      settings.setModeIn = openGameSettings.getModeIn;
      settings.setModeOut = openGameSettings.getModeOut;
      settings.setSingleOrTeam = openGameSettings.getSingleOrTeam;
      settings.setWinByTwoLegsDifference =
          openGameSettings.getWinByTwoLegsDifference;
      settings.setSuddenDeath = openGameSettings.getSuddenDeath;
      settings.setPlayers = openGameSettings.getPlayers;
      settings.setTeams = openGameSettings.getTeams;

      if (START_POINT_POSSIBILITIES.contains(openGameSettings.getPoints)) {
        settings.setPoints = openGameSettings.getPoints;
      } else {
        settings.setCustomPoints = openGameSettings.getPoints;
      }
    } else if (openGameSettings is GameSettingsScoreTraining_P) {
      final settings = context.read<GameSettingsScoreTraining_P>();

      settings.setMode = openGameSettings.getMode;
      settings.setMaxRoundsOrPoints = openGameSettings.getMaxRoundsOrPoints;
      settings.setInputMethod = openGameSettings.getInputMethod;
      settings.setPlayers = openGameSettings.getPlayers;
    } else if (openGameSettings is GameSettingsSingleDoubleTraining_P) {
      final settings = context.read<GameSettingsSingleDoubleTraining_P>();

      settings.setPlayers = openGameSettings.getPlayers;
      settings.setTargetNumber = openGameSettings.getTargetNumber;
      settings.setIsTargetNumberEnabled =
          openGameSettings.getIsTargetNumberEnabled;
      settings.setAmountOfRounds = openGameSettings.getAmountOfRounds;
    }
  }

  _setNewGameValuesFromOpenGame(Game_P openGame, BuildContext context) {
    _setNewGameSettingsFromOpenGame(openGame.getGameSettings);

    late Game_P game;
    if (openGame.getName == 'X01') {
      game = context.read<GameX01_P>();

      game.setTeamGameStatistics = openGame.getTeamGameStatistics;
      game.setCurrentTeamToThrow = openGame.getCurrentTeamToThrow;
    } else if (openGame.getName == 'Score Training') {
      game = context.read<GameScoreTraining_P>();
    } else if (openGame.getName == 'Single Training' ||
        openGame.getName == 'Double Training') {
      game = context.read<GameSingleDoubleTraining_P>();
    }

    game.setCurrentThreeDarts = openGame.getCurrentThreeDarts;
    game.setPlayerGameStatistics = openGame.getPlayerGameStatistics;
    game.setDateTime = openGame.getDateTime;
    game.setGameId = openGame.getGameId;
    game.setName = openGame.getName;
    game.setGameSettings = openGame.getGameSettings;
    game.setCurrentPlayerToThrow = openGame.getCurrentPlayerToThrow;
    game.setIsOpenGame = openGame.getIsOpenGame;
    game.setRevertPossible = openGame.getRevertPossible;

    if (openGame.getName == 'Single Training' ||
        openGame.getName == 'Double Training') {
      final game = context.read<GameSingleDoubleTraining_P>();

      openGame = openGame as GameSingleDoubleTraining_P;
      game.setCurrentFieldToHit = openGame.getCurrentFieldToHit;
      game.setRandomFieldsGenerated = openGame.getRandomFieldsGenerated;
      game.setAmountOfRoundsRemaining = openGame.getAmountOfRoundsRemaining;
      game.setAllFieldsToHit = openGame.getAllFieldsToHit;
      game.setMode = openGame.getName == 'Single Training'
          ? GameMode.SingleTraining
          : GameMode.DoubleTraining;
    }
  }

  _continueGame(Game_P game_p) {
    _setNewGameValuesFromOpenGame(game_p, context);

    if (game_p.getName == 'X01') {
      Navigator.of(context).pushNamed(
        '/gameX01',
        arguments: {'openGame': true},
      );
    } else if (game_p.getName == 'Score Training') {
      Navigator.of(context).pushNamed(
        '/gameScoreTraining',
        arguments: {'openGame': true},
      );
    } else if (game_p.getName == 'Single Training' ||
        game_p.getName == 'Double Training') {
      Navigator.of(context).pushNamed(
        '/gameSingleDoubleTraining',
        arguments: {
          'openGame': true,
          'mode': game_p.getName == 'Single Training'
              ? GameMode.SingleTraining
              : GameMode.DoubleTraining,
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Open Games'),
      body: Consumer<OpenGamesFirestore>(
        builder: (_, openGamesFirestore, __) => openGamesFirestore
                    .openGames.length !=
                0
            ? SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Center(
                  child: Container(
                    width: 90.w,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            top: 10,
                            left: 5,
                            bottom: 10,
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Swipe left for actions (play & delete)',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        for (Game_P game_p in openGamesFirestore.openGames) ...[
                          Column(
                            children: [
                              Slidable(
                                key: ValueKey(game_p.getGameId),
                                child: game_p.getName == 'X01'
                                    ? StatsCardX01(
                                        isFinishScreen: false,
                                        gameX01: GameX01_P.createGame(game_p),
                                        isOpenGame: true,
                                      )
                                    : game_p.getName == 'Score Training'
                                        ? StatsCard(
                                            isFinishScreen: false,
                                            game:
                                                GameScoreTraining_P.createGame(
                                                    game_p),
                                            isOpenGame: true,
                                          )
                                        : StatsCard(
                                            isFinishScreen: false,
                                            game: GameSingleDoubleTraining_P
                                                .createGame(game_p),
                                            isOpenGame: true,
                                          ),
                                startActionPane: ActionPane(
                                  dismissible:
                                      DismissiblePane(onDismissed: () {}),
                                  motion: const ScrollMotion(),
                                  children: [
                                    SlidableAction(
                                      onPressed: (context) =>
                                          _continueGame(game_p),
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      foregroundColor: Colors.white,
                                      icon: Icons.arrow_forward,
                                      label: 'Play',
                                    ),
                                    SlidableAction(
                                      onPressed: (context) {
                                        context
                                            .read<FirestoreServiceGames>()
                                            .deleteOpenGame(
                                                game_p.getGameId, context);
                                      },
                                      backgroundColor: Color(0xFFFE4A49),
                                      foregroundColor: Colors.white,
                                      icon: Icons.delete,
                                      label: 'Delete',
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 2.h,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ],
                          ),
                        ]
                      ],
                    ),
                  ),
                ),
              )
            : Center(
                child: Text(
                  'Currently there are no Open Games!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                  ),
                ),
              ),
      ),
    );
  }
}
