import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_statistics.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_statistics_x01.dart';
import 'package:dart_app/models/team.dart';
import 'package:dart_app/screens/game_modes/x01/game/player_stats_in_game/player_or_team_stats_in_game.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/round/points_btns_round.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/three_darts/points_btns_threeDarts.dart';
import 'package:dart_app/utils/app_bars/custom_app_bar_x01_game.dart';
import 'package:dart_app/utils/globals.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class Game extends StatefulWidget {
  static const routeName = '/gameX01';

  @override
  GameState createState() => GameState();
}

class GameState extends State<Game> {
  @override
  initState() {
    super.initState();
    newItemScrollController();
  }

  @override
  didChangeDependencies() {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    // only init game for new game, not for open game
    if (arguments.isNotEmpty && !arguments['openGame']) {
      _init();
    }
    super.didChangeDependencies();
  }

  _init() {
    final GameX01 gameX01 = context.read<GameX01>();
    final GameSettingsX01 gameSettingsX01 = context.read<GameSettingsX01>();

    // if game is finished -> undo last throw will call init again
    if (gameSettingsX01.getPlayers.length !=
        gameX01.getPlayerGameStatistics.length) {
      gameX01.setGameSettings = gameSettingsX01;
      gameX01.setPlayerGameStatistics = [];

      if (gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Single) {
        gameX01.setCurrentPlayerToThrow = gameSettingsX01.getPlayers.first;
      } else {
        gameX01.setCurrentTeamToThrow = gameSettingsX01.getTeams.first;
        gameX01.setCurrentPlayerToThrow =
            gameSettingsX01.getTeams.first.getPlayers.first;
      }

      gameX01.setInit = true;
      final int points = gameSettingsX01.getPointsOrCustom();

      for (Player player in gameSettingsX01.getPlayers) {
        gameX01.getPlayerGameStatistics.add(new PlayerOrTeamGameStatisticsX01(
            mode: 'X01',
            player: player,
            currentPoints: points,
            dateTime: gameX01.getDateTime));
      }

      if (gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Team) {
        for (Team team in gameSettingsX01.getTeams) {
          gameX01.getTeamGameStatistics.add(
              new PlayerOrTeamGameStatisticsX01.Team(
                  team: team,
                  mode: 'X01',
                  currentPoints: points,
                  dateTime: gameX01.getDateTime));
          team.setCurrentPlayerToThrow = team.getPlayers.first;
        }

        for (PlayerOrTeamGameStatistics teamStats
            in gameX01.getTeamGameStatistics) {
          teamStats.getTeam.setCurrentPlayerToThrow =
              teamStats.getTeam.getPlayers.first;
        }

        // set team for player stats in order to sort them
        for (PlayerOrTeamGameStatistics playerStats
            in gameX01.getPlayerGameStatistics) {
          Team team = gameSettingsX01.findTeamForPlayer(
              playerStats.getPlayer.getName, gameSettingsX01);
          playerStats.setTeam = team;
        }

        gameX01.getPlayerGameStatistics.sort((a, b) =>
            (a.getTeam as Team).getName.compareTo((b.getTeam as Team).getName));
      }

      if (gameSettingsX01.getInputMethod == InputMethod.ThreeDarts)
        gameX01.setCurrentPointType = PointType.Single;
    }

    for (PlayerOrTeamGameStatisticsX01 stats in gameX01.getPlayerGameStatistics)
      stats.setStartingPoints = stats.getCurrentPoints;

    for (PlayerOrTeamGameStatisticsX01 stats in gameX01.getTeamGameStatistics)
      stats.setStartingPoints = stats.getCurrentPoints;
  }

  _showDialogForSuddenDeath() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: EdgeInsets.only(
            bottom: DIALOG_CONTENT_PADDING_BOTTOM,
            top: DIALOG_CONTENT_PADDING_TOP,
            left: DIALOG_CONTENT_PADDING_LEFT,
            right: DIALOG_CONTENT_PADDING_RIGHT),
        title: Text('Sudden Death'),
        content: Text(
            "The 'Sudden Death' leg is reached. The player who wins this leg also wins the game."),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Got It'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final GameSettingsX01 gameSettingsX01 = context.read<GameSettingsX01>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBarX01Game(),
      body: Column(
        children: [
          if (gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Single)
            Container(
              height: 35.h,
              child: Selector<GameX01, List<PlayerOrTeamGameStatistics>>(
                selector: (_, gameX01) => gameX01.getPlayerGameStatistics,
                shouldRebuild: (previous, next) => true,
                builder: (_, playerStats, __) =>
                    ScrollablePositionedList.builder(
                  itemScrollController: newItemScrollController(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: playerStats.length,
                  itemBuilder: (BuildContext context, int index) {
                    // todo: weird bug -> when starting single game -> end -> start as team game -> enter points -> error
                    if (gameSettingsX01.getSingleOrTeam ==
                        SingleOrTeamEnum.Single) {
                      return PlayerOrTeamStatsInGame(
                        currPlayerOrTeamGameStatsX01:
                            playerStats[index] as PlayerOrTeamGameStatisticsX01,
                      );
                    }
                    return SizedBox.shrink();
                  },
                ),
              ),
            )
          else
            Container(
              height: 35.h,
              child: Selector<GameX01, List<PlayerOrTeamGameStatistics>>(
                selector: (_, gameX01) => gameX01.getTeamGameStatistics,
                shouldRebuild: (previous, next) => true,
                builder: (_, teamStats, __) => ScrollablePositionedList.builder(
                  itemScrollController: newItemScrollController(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: teamStats.length,
                  itemBuilder: (BuildContext context, int index) {
                    return PlayerOrTeamStatsInGame(
                      currPlayerOrTeamGameStatsX01:
                          teamStats[index] as PlayerOrTeamGameStatisticsX01,
                    );
                  },
                ),
              ),
            ),
          Selector<GameSettingsX01, InputMethod>(
            selector: (_, gameX01) => gameX01.getInputMethod,
            builder: (_, inputMethod, __) => inputMethod == InputMethod.Round
                ? PointsBtnsRound()
                : PointsBtnsThreeDarts(),
          )
        ],
      ),
    );
  }
}
