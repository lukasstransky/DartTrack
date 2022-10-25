import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/models/firestore/open_games_firestore.dart';
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
  _setNewGameSettingsFromOpenGame(GameSettingsX01 openGameSettings) {
    final settingsX01 = context.read<GameSettingsX01>();

    settingsX01.setEnableCheckoutCounting =
        openGameSettings.getEnableCheckoutCounting;
    settingsX01.setLegs = openGameSettings.getLegs;
    settingsX01.setSets = openGameSettings.getSets;
    settingsX01.setModeIn = openGameSettings.getModeIn;
    settingsX01.setModeOut = openGameSettings.getModeOut;
    settingsX01.setSingleOrTeam = openGameSettings.getSingleOrTeam;
    settingsX01.setWinByTwoLegsDifference =
        openGameSettings.getWinByTwoLegsDifference;
    settingsX01.setSuddenDeath = openGameSettings.getSuddenDeath;
    settingsX01.setPlayers = openGameSettings.getPlayers;

    if (START_POINT_POSSIBILITIES.contains(openGameSettings.getPoints))
      settingsX01.setPoints = openGameSettings.getPoints;
    else
      settingsX01.setCustomPoints = openGameSettings.getPoints;
  }

  _setNewGameValuesFromOpenGame(Game game, BuildContext context) {
    _setNewGameSettingsFromOpenGame(game.getGameSettings as GameSettingsX01);

    game.setPlayerGameStatistics = game.getPlayerGameStatistics;
    game.setDateTime = game.getDateTime;
    game.setGameId = game.getGameId;
    game.setName = game.getName;
    game.setGameSettings = game.getGameSettings;
    game.setCurrentPlayerToThrow = game.getCurrentPlayerToThrow;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(true, 'Open Games'),
      body: Consumer<OpenGamesFirestore>(
        builder: (_, openGamesFirestore, __) =>
            openGamesFirestore.openGames.length != 0
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
                              ),
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                      'Swipe left for Actions (Play & Delete)')),
                            ),
                            for (Game game in openGamesFirestore.openGames) ...[
                              Slidable(
                                key: ValueKey(game.getGameId),
                                child: StatsCardX01(
                                    isFinishScreen: false,
                                    gameX01: GameX01.createGameX01(game),
                                    openGame: true),
                                startActionPane: ActionPane(
                                  dismissible:
                                      DismissiblePane(onDismissed: () {}),
                                  motion: const ScrollMotion(),
                                  children: [
                                    SlidableAction(
                                      onPressed: (context) {
                                        _setNewGameValuesFromOpenGame(
                                            game, context);
                                        Navigator.of(context).pushNamed(
                                          '/gameX01',
                                          arguments: {'openGame': true},
                                        );
                                      },
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
                                                game.getGameId, context);
                                      },
                                      backgroundColor: Color(0xFFFE4A49),
                                      foregroundColor: Colors.white,
                                      icon: Icons.delete,
                                      label: 'Delete',
                                    ),
                                  ],
                                ),
                              ),
                            ]
                          ],
                        ),
                      ),
                    ),
                  )
                : Center(
                    child: Text('Currently there are no Open Games!'),
                  ),
      ),
    );
  }
}
