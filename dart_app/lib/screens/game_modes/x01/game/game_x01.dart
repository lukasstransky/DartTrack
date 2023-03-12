import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats_x01.dart';
import 'package:dart_app/models/team.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/multiple_player_team_stats/multiple_player_team_stats_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/round/point_btns_round_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/two_player_team_stats_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/three_darts/point_btns_three_darts_x01.dart';

import 'package:dart_app/utils/app_bars/x01/custom_app_bar_x01_game.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class GameX01 extends StatefulWidget {
  static const routeName = '/gameX01';

  @override
  GameX01State createState() => GameX01State();
}

class GameX01State extends State<GameX01> {
  @override
  didChangeDependencies() {
    final Map arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    // only init game for new game, not for open game
    if (arguments.isNotEmpty && !arguments['openGame']) {
      _init();
    }
    super.didChangeDependencies();
  }

  _init() {
    final GameX01_P gameX01 = context.read<GameX01_P>();
    final GameSettingsX01_P gameSettings = context.read<GameSettingsX01_P>();

    // if game is finished -> undo last throw will call init again
    if (gameSettings.getPlayers.length !=
        gameX01.getPlayerGameStatistics.length) {
      gameX01.reset();

      gameX01.setGameSettings = gameSettings;
      gameX01.setPlayerGameStatistics = [];

      if (gameSettings.getSingleOrTeam == SingleOrTeamEnum.Single) {
        gameX01.setCurrentPlayerToThrow = gameSettings.getPlayers.first;
      } else {
        gameX01.setCurrentTeamToThrow = gameSettings.getTeams.first;

        // reverse players in teams
        for (Team team in gameSettings.getTeams) {
          team.setPlayers = team.getPlayers.reversed.toList();
        }
        // set players in correct order
        List<Player> players = [];
        for (Team team in gameSettings.getTeams) {
          for (Player player in team.getPlayers) {
            players.add(player);
          }
        }
        gameSettings.setPlayers = players;

        gameX01.setCurrentPlayerToThrow =
            gameSettings.getTeams.first.getPlayers.first;
      }

      gameX01.setInit = true;
      final int points = gameSettings.getPointsOrCustom();

      for (Player player in gameSettings.getPlayers) {
        gameX01.getPlayerGameStatistics.add(
          new PlayerOrTeamGameStatsX01(
            mode: 'X01',
            player: player,
            currentPoints: points,
            dateTime: gameX01.getDateTime,
          ),
        );
      }

      if (gameSettings.getSingleOrTeam == SingleOrTeamEnum.Team) {
        for (Team team in gameSettings.getTeams) {
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
          Team team = gameSettings.findTeamForPlayer(
              playerStats.getPlayer.getName, gameSettings);
          playerStats.setTeam = team;
        }

        gameX01.getPlayerGameStatistics.sort((a, b) =>
            (a.getTeam as Team).getName.compareTo((b.getTeam as Team).getName));
      }

      if (gameSettings.getInputMethod == InputMethod.ThreeDarts) {
        gameX01.setCurrentPointType = PointType.Single;
      }
    }

    // set starting points
    for (PlayerOrTeamGameStatsX01 stats in gameX01.getPlayerGameStatistics) {
      stats.setStartingPoints = stats.getCurrentPoints;
    }

    for (PlayerOrTeamGameStatsX01 stats in gameX01.getTeamGameStatistics) {
      stats.setStartingPoints = stats.getCurrentPoints;
    }
  }

  _getTwoOrMultiplePlayerTeamStatsView(BuildContext context) {
    final GameSettingsX01_P gameSettingsX01_P =
        context.read<GameSettingsX01_P>();
    final bool isSingleMode =
        gameSettingsX01_P.getSingleOrTeam == SingleOrTeamEnum.Single;
    final bool isSingleGameWithTwoPlayers =
        isSingleMode && gameSettingsX01_P.getPlayers.length == 2;
    final bool isTeamGameWithTwoTeams =
        !isSingleMode && gameSettingsX01_P.getTeams.length == 2;

    if (isSingleGameWithTwoPlayers || isTeamGameWithTwoTeams) {
      return TwoPlayerTeamStatsX01(
        isSingleMode: isSingleGameWithTwoPlayers ? true : false,
      );
    }

    return MultiplePlayerTeamStatsX01(
      isSingleMode: isSingleMode,
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isTeamMode = context.read<GameSettingsX01_P>().getSingleOrTeam ==
        SingleOrTeamEnum.Team;

    return WillPopScope(
      onWillPop: () async => false, // ignore gestures
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CustomAppBarX01Game(),
        body: Selector<GameX01_P, bool>(
          selector: (_, game) => game.getShowLoadingSpinner,
          builder: (_, showLoadingSpinner, __) => showLoadingSpinner
              ? Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                )
              : Column(
                  children: [
                    _getTwoOrMultiplePlayerTeamStatsView(context),
                    if (isTeamMode) PlayerToThrowForTeamMode(context: context),
                    Selector<GameSettingsX01_P, InputMethod>(
                      selector: (_, gameSettingsX01) =>
                          gameSettingsX01.getInputMethod,
                      builder: (_, inputMethod, __) =>
                          inputMethod == InputMethod.Round
                              ? PointBtnsRoundX01()
                              : PointsBtnsThreeDartsX01(),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class PlayerToThrowForTeamMode extends StatelessWidget {
  const PlayerToThrowForTeamMode({
    Key? key,
    required this.context,
  }) : super(key: key);

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 5.h,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Utils.getPrimaryColorDarken(context),
            width: 3.0,
          ),
        ),
      ),
      padding: EdgeInsets.only(left: 50),
      child: Row(
        children: [
          Text(
            'Player to throw: ',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15.sp,
            ),
          ),
          Selector<GameX01_P, Player>(
            selector: (_, gameX01) => gameX01.getCurrentPlayerToThrow,
            builder: (_, currentPlayerToThrow, __) => Text(
              currentPlayerToThrow.getName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
