import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_p.dart';
import 'package:dart_app/models/game_settings/score_training/game_settings_score_training_p.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/models/games/score_training/game_score_training_p.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/models/firestore/open_games_firestore.dart';
import 'package:dart_app/screens/game_modes/score_training/finish/local_widgets/stats_card_score_training/stats_card_st.dart';
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
    }
  }

  _setNewGameValuesFromOpenGame(Game_P openGame, BuildContext context) {
    _setNewGameSettingsFromOpenGame(openGame.getGameSettings);

    if (openGame.getName == 'X01') {
      final gameX01 = context.read<GameX01_P>();

      gameX01.setPlayerGameStatistics = openGame.getPlayerGameStatistics;
      gameX01.setTeamGameStatistics = openGame.getTeamGameStatistics;
      gameX01.setDateTime = openGame.getDateTime;
      gameX01.setGameId = openGame.getGameId;
      gameX01.setName = openGame.getName;
      gameX01.setGameSettings = openGame.getGameSettings;
      gameX01.setCurrentPlayerToThrow = openGame.getCurrentPlayerToThrow;
      gameX01.setCurrentTeamToThrow = openGame.getCurrentTeamToThrow;
      gameX01.setIsOpenGame = openGame.getIsOpenGame;
      gameX01.setRevertPossible = openGame.getRevertPossible;
    } else if (openGame.getName == 'Score Training') {
      final gameScoreTraining = context.read<GameScoreTraining_P>();

      gameScoreTraining.setPlayerGameStatistics =
          openGame.getPlayerGameStatistics;
      gameScoreTraining.setDateTime = openGame.getDateTime;
      gameScoreTraining.setGameId = openGame.getGameId;
      gameScoreTraining.setName = openGame.getName;
      gameScoreTraining.setGameSettings = openGame.getGameSettings;
      gameScoreTraining.setCurrentPlayerToThrow =
          openGame.getCurrentPlayerToThrow;
      gameScoreTraining.setIsOpenGame = openGame.getIsOpenGame;
      gameScoreTraining.setRevertPossible = openGame.getRevertPossible;
    }
  }

  _continueGame(Game_P game_p) {
    _setNewGameValuesFromOpenGame(game_p, context);
    Navigator.of(context).pushNamed(
      game_p.getName == 'X01' ? '/gameX01' : '/gameScoreTraining',
      arguments: {'openGame': true},
    );
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
                                    : StatsCardScoreTraining(
                                        isFinishScreen: false,
                                        gameScoreTraining_P:
                                            GameScoreTraining_P.createGame(
                                                game_p),
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
