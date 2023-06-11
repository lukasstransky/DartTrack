import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_cricket_p.dart';
import 'package:dart_app/models/game_settings/game_settings_p.dart';
import 'package:dart_app/models/game_settings/game_settings_score_training_p.dart';
import 'package:dart_app/models/game_settings/game_settings_single_double_training_p.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/models/games/game_cricket_p.dart';
import 'package:dart_app/models/games/game_score_training_p.dart';
import 'package:dart_app/models/games/game_single_double_training_p.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/models/firestore/open_games_firestore.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats.dart';
import 'package:dart_app/models/team.dart';
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
      settings.setMaxExtraLegs = openGameSettings.getMaxExtraLegs;
      settings.setDrawMode = openGameSettings.getDrawMode;
      settings.setPlayers = openGameSettings.getPlayers;
      settings.setTeams = openGameSettings.getTeams;
      settings.setSetsEnabled = openGameSettings.getSetsEnabled;
      settings.setInputMethod = openGameSettings.getInputMethod;

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
    } else if (openGameSettings is GameSettingsCricket_P) {
      final settings = context.read<GameSettingsCricket_P>();

      settings.setPlayers = openGameSettings.getPlayers;
      settings.setTeams = openGameSettings.getTeams;
      settings.setSingleOrTeam = openGameSettings.getSingleOrTeam;
      settings.setBestOfOrFirstTo = openGameSettings.getBestOfOrFirstTo;
      settings.setMode = openGameSettings.getMode;
      settings.setLegs = openGameSettings.getLegs;
      settings.setSets = openGameSettings.getSets;
      settings.setSetsEnabled = openGameSettings.getSetsEnabled;
    }
  }

  _setNewGameValuesFromOpenGame(Game_P openGame, BuildContext context) {
    _setNewGameSettingsFromOpenGame(openGame.getGameSettings);

    late Game_P game;
    if (openGame.getName == GameMode.X01.name) {
      game = context.read<GameX01_P>();
      openGame = openGame as GameX01_P;
      game = game as GameX01_P;

      game.setTeamGameStatistics = openGame.getTeamGameStatistics;
      game.setCurrentTeamToThrow = openGame.getCurrentTeamToThrow;
      game.setGameSettings = context.read<GameSettingsX01_P>();
      game.setPlayerOrTeamLegStartIndex = openGame.getPlayerOrTeamLegStartIndex;
      game.setReachedSuddenDeath = openGame.getReachedSuddenDeath;
      game.setCurrentPlayerOfTeamsBeforeLegFinish =
          openGame.getCurrentPlayerOfTeamsBeforeLegFinish;
      game.setLegSetWithPlayerOrTeamWhoFinishedIt =
          openGame.getLegSetWithPlayerOrTeamWhoFinishedIt;
    } else if (openGame.getName == GameMode.ScoreTraining.name) {
      game = context.read<GameScoreTraining_P>();

      game.setGameSettings = context.read<GameSettingsScoreTraining_P>();
    } else if (openGame.getName == GameMode.SingleTraining.name ||
        openGame.getName == GameMode.DoubleTraining.name) {
      game = context.read<GameSingleDoubleTraining_P>();
      game = game as GameSingleDoubleTraining_P;
      openGame = openGame as GameSingleDoubleTraining_P;

      game.setGameSettings = context.read<GameSettingsSingleDoubleTraining_P>();
      game.setCurrentFieldToHit = openGame.getCurrentFieldToHit;
      game.setRandomFieldsGenerated = openGame.getRandomFieldsGenerated;
      game.setAmountOfRoundsRemaining = openGame.getAmountOfRoundsRemaining;
      game.setAllFieldsToHit = openGame.getAllFieldsToHit;
      game.setMode = openGame.getName == GameMode.SingleTraining.name
          ? GameMode.SingleTraining
          : GameMode.DoubleTraining;
      game.setRandomModeFinished = false;
    } else if (openGame.getName == GameMode.Cricket.name) {
      game = context.read<GameCricket_P>();
      game = game as GameCricket_P;
      openGame = openGame as GameCricket_P;

      game.setGameSettings = context.read<GameSettingsCricket_P>();
      game.setTeamGameStatistics = openGame.getTeamGameStatistics;
      game.setCurrentTeamToThrow = openGame.getCurrentTeamToThrow;
      game.setPlayerOrTeamLegStartIndex = openGame.getPlayerOrTeamLegStartIndex;
      game.setLegSetWithPlayerOrTeamWhoFinishedIt =
          openGame.getLegSetWithPlayerOrTeamWhoFinishedIt;
      game.setCurrentPlayerOfTeamsBeforeLegFinish =
          openGame.getCurrentPlayerOfTeamsBeforeLegFinish;
    }

    game.setCurrentThreeDarts = openGame.getCurrentThreeDarts;
    // in order to have same references (hash code) for team
    if ((game is GameCricket_P || game is GameX01_P) &&
        game.getGameSettings.getSingleOrTeam == SingleOrTeamEnum.Team) {
      for (PlayerOrTeamGameStats stats in openGame.getPlayerGameStatistics) {
        final Team team =
            game.getGameSettings.findTeamForPlayer(stats.getPlayer.getName);
        stats.setTeam = team;

        for (PlayerOrTeamGameStats teamStats
            in openGame.getTeamGameStatistics) {
          if (teamStats.getTeam.getName == team.getName) {
            teamStats.setTeam = team;
          }
        }
      }
    }
    game.setPlayerGameStatistics = openGame.getPlayerGameStatistics;
    game.setDateTime = openGame.getDateTime;
    game.setGameId = openGame.getGameId;
    game.setName = openGame.getName;
    game.setCurrentPlayerToThrow = openGame.getCurrentPlayerToThrow;
    game.setIsOpenGame = openGame.getIsOpenGame;
    game.setRevertPossible = openGame.getRevertPossible;
  }

  _continueGame(Game_P game_p) {
    context.read<OpenGamesFirestore>().setLoadOpenGames = true;
    _setNewGameValuesFromOpenGame(game_p, context);

    if (game_p.getName == GameMode.X01.name) {
      Navigator.of(context).pushNamed(
        '/gameX01',
        arguments: {'openGame': true},
      );
    } else if (game_p.getName == GameMode.ScoreTraining.name) {
      Navigator.of(context).pushNamed(
        '/gameScoreTraining',
        arguments: {'openGame': true},
      );
    } else if (game_p.getName == GameMode.SingleTraining.name ||
        game_p.getName == GameMode.DoubleTraining.name) {
      Navigator.of(context).pushNamed(
        '/gameSingleDoubleTraining',
        arguments: {
          'openGame': true,
          'mode': game_p.getName,
        },
      );
    } else if (game_p.getName == GameMode.Cricket.name) {
      Navigator.of(context).pushNamed(
        '/gameCricket',
        arguments: {
          'openGame': true,
          'mode': game_p.getName,
        },
      );
    }
  }

  _getCard(Game_P game) {
    if (game.getName == GameMode.X01.name) {
      return StatsCardX01(
        isFinishScreen: false,
        gameX01: GameX01_P.createGame(game),
        isOpenGame: true,
      );
    } else if (game.getName == GameMode.ScoreTraining.name) {
      return StatsCard(
        isFinishScreen: false,
        game: GameScoreTraining_P.createGame(game),
        isOpenGame: true,
      );
    } else if (game.getName == GameMode.SingleTraining.name ||
        game.getName == GameMode.DoubleTraining.name) {
      return StatsCard(
        isFinishScreen: false,
        game: GameSingleDoubleTraining_P.createGame(game),
        isOpenGame: true,
      );
    } else if (game.getName == GameMode.Cricket.name) {
      return StatsCard(
        isFinishScreen: false,
        game: GameCricket_P.createGame(game),
        isOpenGame: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Open games'),
      body: Selector<OpenGamesFirestore, List<Game_P>>(
        selector: (_, openGamesFirestore) => openGamesFirestore.openGames,
        shouldRebuild: (previous, next) => true,
        builder: (_, openGames, __) => openGames.length != 0
            ? SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Center(
                  child: Container(
                    width: 90.w,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: 1.h,
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
                        for (Game_P game_p in openGames) ...[
                          Column(
                            children: [
                              Slidable(
                                key: UniqueKey(),
                                child: _getCard(game_p),
                                startActionPane: ActionPane(
                                  dismissible: DismissiblePane(onDismissed: () {
                                    setState(() {});
                                  }),
                                  motion: const ScrollMotion(),
                                  children: [
                                    SlidableAction(
                                      onPressed: (context) =>
                                          _continueGame(game_p),
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white,
                                      icon: Icons.arrow_forward,
                                      label: 'Play',
                                    ),
                                    SlidableAction(
                                      onPressed: (context) {
                                        if (mounted) {
                                          context
                                              .read<FirestoreServiceGames>()
                                              .deleteOpenGame(
                                                  game_p.getGameId,
                                                  context.read<
                                                      OpenGamesFirestore>());
                                        }
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
                  'Currently there are no open games!',
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
