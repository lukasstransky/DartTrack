import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game_statistics/local_widgets/checkouts_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game_statistics/local_widgets/detailed_legs_list_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game_statistics/local_widgets/finishing_stats/finishing_stats_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game_statistics/local_widgets/game_stats/game_stats_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game_statistics/local_widgets/leg_average_compared_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game_statistics/local_widgets/leg_thrown_darts_compared_x01.dart';
import 'package:dart_app/screens/game_modes/shared/game_stats/most_frequent_scores.dart';
import 'package:dart_app/screens/game_modes/shared/game_stats/rounded_scores_even.dart';
import 'package:dart_app/screens/game_modes/shared/game_stats/rounded_scores_odd.dart';
import 'package:dart_app/screens/game_modes/x01/game_statistics/local_widgets/scoring_stats/scoring_stats_x01.dart';
import 'package:dart_app/utils/app_bars/custom_app_bar.dart';
import 'package:dart_app/utils/app_bars/custom_app_bar_with_heart.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class GameStatisticsX01 extends StatefulWidget {
  static const routeName = '/statisticsX01';

  @override
  State<GameStatisticsX01> createState() => _GameStatisticsX01State();
}

class _GameStatisticsX01State extends State<GameStatisticsX01> {
  GameX01_P? _game;
  bool _roundedScoresOdd = false;

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    if (arguments.isNotEmpty) {
      _game = arguments['game'];
    }
  }

  String _getHeader() {
    String result = '';

    //mode
    _game!.getGameSettings.getMode == BestOfOrFirstToEnum.BestOf
        ? result += 'Best Of '
        : result += 'First To ';

    //sets
    if (_game!.getGameSettings.getSetsEnabled) {
      if (_game!.getGameSettings.getSets == 1) {
        result += _game!.getGameSettings.getSets.toString() + ' Set ';
      } else {
        result += _game!.getGameSettings.getSets.toString() + ' Sets ';
      }
    }

    //legs
    if (_game!.getGameSettings.getLegs == 1) {
      result += _game!.getGameSettings.getLegs.toString() + ' Leg - ';
    } else {
      result += _game!.getGameSettings.getLegs.toString() + ' Legs - ';
    }

    //points
    _game!.getGameSettings.getCustomPoints != -1
        ? result += _game!.getGameSettings.getCustomPoints.toString()
        : result += _game!.getGameSettings.getPoints.toString();

    return result;
  }

  bool _oneLegWonAtLeast() {
    for (PlayerOrTeamGameStatsX01 playerOrTeamGameStatsX01
        in (_game!.getGameSettings.getSingleOrTeam == SingleOrTeamEnum.Single
            ? _game!.getPlayerGameStatistics
            : _game!.getTeamGameStatistics)) {
      if (playerOrTeamGameStatsX01.getLegsWon > 0 ||
          playerOrTeamGameStatsX01.getSetsWon > 0) {
        return true;
      }
    }
    return false;
  }

  bool _oneScorePerDartAtLeast() {
    for (PlayerOrTeamGameStatsX01 stats
        in (_game!.getGameSettings.getSingleOrTeam == SingleOrTeamEnum.Single
            ? _game!.getPlayerGameStatistics
            : _game!.getTeamGameStatistics)) {
      if (stats.getAllScoresPerDart.isNotEmpty) {
        return true;
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final _padding = EdgeInsets.only(left: 20, bottom: 10);
    final _paddingLastItem = EdgeInsets.only(left: 20, bottom: 30);

    return Scaffold(
      appBar: _game!.getIsGameFinished
          ? CustomAppBarWithHeart(
              title: 'Statistics',
              mode: 'X01',
              isFavouriteGame: _game!.getIsFavouriteGame,
              gameId: _game!.getGameId,
            )
          : CustomAppBar(title: 'Statistics'),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                _getHeader(),
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 5),
              child: Text(
                _game!.getFormattedDateTime(),
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: Utils.getTextColorDarken(context),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Chip(
                  backgroundColor: Utils.getPrimaryColorDarken(context),
                  label: Text(
                    _game!.getGameSettings.getModeIn == ModeOutIn.Single
                        ? 'Single In'
                        : 'Double In',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Chip(
                    backgroundColor: Utils.getPrimaryColorDarken(context),
                    label: Text(
                      _game!.getGameSettings.getModeOut == ModeOutIn.Single
                          ? 'Single Out'
                          : 'Double Out',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                if (_game!.getGameSettings.getSuddenDeath)
                  Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Chip(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      label: Text(
                        'Sudden Death',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Selector<GameX01_P, bool>(
                selector: (_, gameX01) => gameX01.getAreTeamStatsDisplayed,
                builder: (_, areTeamStatsDisplayed, __) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: _padding,
                      child: GameStatsX01(gameX01: _game as GameX01_P),
                    ),
                    Padding(
                      padding: _padding,
                      child: ScoringStatsX01(gameX01: _game as GameX01_P),
                    ),
                    Padding(
                      padding: _padding,
                      child: FinishingStatsX01(gameX01: _game as GameX01_P),
                    ),
                    if (_oneLegWonAtLeast())
                      Padding(
                        padding: _padding,
                        child: CheckoutsX01(gameX01: _game as GameX01_P),
                      ),
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: !_roundedScoresOdd
                          ? RoundedScoresEven(game_p: _game as GameX01_P)
                          : RoundedScoresOdd(game_p: _game as GameX01_P),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Row(
                        children: [
                          const Text(
                            'Show Odd Rounded Scores',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          Switch(
                            thumbColor: MaterialStateProperty.all(
                                Theme.of(context).colorScheme.secondary),
                            activeColor:
                                Theme.of(context).colorScheme.secondary,
                            inactiveThumbColor:
                                Theme.of(context).colorScheme.secondary,
                            value: _roundedScoresOdd,
                            onChanged: (value) {
                              setState(() {
                                _roundedScoresOdd = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: _paddingLastItem,
                      child: MostFrequentScores(
                        mostScoresPerDart: false,
                        game_p: _game as GameX01_P,
                      ),
                    ),
                    if (_oneScorePerDartAtLeast())
                      Padding(
                        padding: _paddingLastItem,
                        child: MostFrequentScores(
                          mostScoresPerDart: true,
                          game_p: _game as GameX01_P,
                        ),
                      ),
                    if (_oneLegWonAtLeast()) ...[
                      Padding(
                        padding: _padding,
                        child: LegAvgComparedX01(gameX01: _game as GameX01_P),
                      ),
                      if (!Utils.playerStatsDisplayedInTeamMode(
                          _game as GameX01_P,
                          (_game as GameX01_P).getGameSettings)) ...[
                        Padding(
                          padding: _padding,
                          child: LegThrownDartsComparedX01(
                              gameX01: _game as GameX01_P),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 30),
                          child:
                              DetailedLegsListX01(gameX01: _game as GameX01_P),
                        ),
                      ],
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
