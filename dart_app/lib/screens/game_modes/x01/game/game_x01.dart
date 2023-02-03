import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats_x01.dart';
import 'package:dart_app/models/team.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/round/point_btns_round_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/single_players_list_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/team_players_list_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/three_darts/point_btns_three_darts_x01.dart';

import 'package:dart_app/utils/app_bars/x01/custom_app_bar_x01_game.dart';
import 'package:dart_app/utils/globals.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameX01 extends StatefulWidget {
  static const routeName = '/gameX01';

  @override
  GameX01State createState() => GameX01State();
}

class GameX01State extends State<GameX01> {
  @override
  initState() {
    super.initState();
    newItemScrollController();
  }

  @override
  didChangeDependencies() {
    final Map arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    // only init game for new game, not for open game
    if (arguments.isNotEmpty && !arguments['openGame']) {
      _init();
    }
    newItemScrollController();
    super.didChangeDependencies();
  }

  _init() {
    final GameX01_P gameX01 = context.read<GameX01_P>();
    final GameSettingsX01_P gameSettingsX01 = context.read<GameSettingsX01_P>();

    // if game is finished -> undo last throw will call init again
    if (gameSettingsX01.getPlayers.length !=
        gameX01.getPlayerGameStatistics.length) {
      gameX01.reset();

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
        gameX01.getPlayerGameStatistics.add(
          new PlayerOrTeamGameStatsX01(
            mode: 'X01',
            player: player,
            currentPoints: points,
            dateTime: gameX01.getDateTime,
          ),
        );
      }

      if (gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Team) {
        for (Team team in gameSettingsX01.getTeams) {
          gameX01.getTeamGameStatistics.add(
            new PlayerOrTeamGameStatsX01.Team(
              team: team,
              mode: 'X01',
              currentPoints: points,
              dateTime: gameX01.getDateTime,
            ),
          );
          team.setCurrentPlayerToThrow = team.getPlayers.first;
        }

        for (PlayerOrTeamGameStats teamStats in gameX01.getTeamGameStatistics) {
          teamStats.getTeam.setCurrentPlayerToThrow =
              teamStats.getTeam.getPlayers.first;
        }

        // set team for player stats in order to sort them
        for (PlayerOrTeamGameStats playerStats
            in gameX01.getPlayerGameStatistics) {
          Team team = gameSettingsX01.findTeamForPlayer(
              playerStats.getPlayer.getName, gameSettingsX01);
          playerStats.setTeam = team;
        }

        gameX01.getPlayerGameStatistics.sort((a, b) =>
            (a.getTeam as Team).getName.compareTo((b.getTeam as Team).getName));
      }

      if (gameSettingsX01.getInputMethod == InputMethod.ThreeDarts) {
        gameX01.setCurrentPointType = PointType.Single;
      }
    }

    for (PlayerOrTeamGameStatsX01 stats in gameX01.getPlayerGameStatistics) {
      stats.setStartingPoints = stats.getCurrentPoints;
    }

    for (PlayerOrTeamGameStatsX01 stats in gameX01.getTeamGameStatistics) {
      stats.setStartingPoints = stats.getCurrentPoints;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBarX01Game(),
      body: Column(
        children: [
          if (context.read<GameSettingsX01_P>().getSingleOrTeam ==
              SingleOrTeamEnum.Single)
            SinglePlayersListX01()
          else
            TeamPlayersListX01(),
          Selector<GameSettingsX01_P, InputMethod>(
            selector: (_, gameX01) => gameX01.getInputMethod,
            builder: (_, inputMethod, __) => inputMethod == InputMethod.Round
                ? PointBtnsRoundX01()
                : PointsBtnsThreeDartsX01(),
          )
        ],
      ),
    );
  }
}
