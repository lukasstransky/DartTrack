import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_statistics_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game_statistics/local_widgets/checkouts.dart';
import 'package:dart_app/screens/game_modes/x01/game_statistics/local_widgets/detailed_legs_list.dart';
import 'package:dart_app/screens/game_modes/x01/game_statistics/local_widgets/finishing_stats/finishing_stats.dart';
import 'package:dart_app/screens/game_modes/x01/game_statistics/local_widgets/game_stats/game_stats.dart';
import 'package:dart_app/screens/game_modes/x01/game_statistics/local_widgets/leg_average_compared.dart';
import 'package:dart_app/screens/game_modes/x01/game_statistics/local_widgets/leg_thrown_darts_compared.dart';
import 'package:dart_app/screens/game_modes/x01/game_statistics/local_widgets/most_frequent_scores.dart';
import 'package:dart_app/screens/game_modes/x01/game_statistics/local_widgets/rounded_scores_even.dart';
import 'package:dart_app/screens/game_modes/x01/game_statistics/local_widgets/rounded_scorse_odd.dart';
import 'package:dart_app/screens/game_modes/x01/game_statistics/local_widgets/scoring_stats/scoring_stats.dart';
import 'package:dart_app/utils/app_bars/custom_app_bar.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class GameStatistics extends StatefulWidget {
  static const routeName = '/statisticsX01';

  @override
  State<GameStatistics> createState() => _GameStatisticsState();
}

class _GameStatisticsState extends State<GameStatistics> {
  final _padding = EdgeInsets.only(left: 20, bottom: 10);
  final _paddingLastItem = EdgeInsets.only(left: 20, bottom: 30);

  GameX01? _game;
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
    for (PlayerOrTeamGameStatisticsX01 playerOrTeamGameStatsX01
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
    for (PlayerOrTeamGameStatisticsX01 stats
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
    return Scaffold(
      appBar: CustomAppBar(true, 'Statistics'),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                _getHeader(),
                style: TextStyle(fontSize: 16.sp),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 5),
              child: Text(
                _game!.getFormattedDateTime(),
                style: TextStyle(fontSize: 12.sp),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Chip(
                  backgroundColor: Theme.of(context).colorScheme.primary,
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
                    backgroundColor: Theme.of(context).colorScheme.primary,
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
              child: Selector<GameX01, bool>(
                selector: (_, gameX01) => gameX01.getAreTeamStatsDisplayed,
                builder: (_, areTeamStatsDisplayed, __) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: _padding,
                      child: GameStats(gameX01: _game as GameX01),
                    ),
                    Padding(
                      padding: _padding,
                      child: ScoringStats(gameX01: _game as GameX01),
                    ),
                    Padding(
                      padding: _padding,
                      child: FinishingStats(gameX01: _game as GameX01),
                    ),
                    if (_oneLegWonAtLeast())
                      Padding(
                        padding: _padding,
                        child: Checkouts(gameX01: _game as GameX01),
                      ),
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: !_roundedScoresOdd
                          ? RoundedScoresEven(gameX01: _game as GameX01)
                          : RoundedScoresOdd(gameX01: _game as GameX01),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Row(
                        children: [
                          const Text('Show Odd Rounded Scores'),
                          Switch(
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
                          mostScoresPerDart: false, gameX01: _game as GameX01),
                    ),
                    if (_oneScorePerDartAtLeast())
                      Padding(
                        padding: _paddingLastItem,
                        child: MostFrequentScores(
                            mostScoresPerDart: true, gameX01: _game as GameX01),
                      ),
                    if (_oneLegWonAtLeast()) ...[
                      Padding(
                        padding: _padding,
                        child: LegAvgCompared(gameX01: _game as GameX01),
                      ),
                      if (!Utils.playerStatsDisplayedInTeamMode(
                          _game as GameX01,
                          (_game as GameX01).getGameSettings)) ...[
                        Padding(
                          padding: _padding,
                          child:
                              LegThrownDartsCompared(gameX01: _game as GameX01),
                        ),
                        Padding(
                          padding: EdgeInsets.only(bottom: 30),
                          child: DetailedLegsList(gameX01: _game as GameX01),
                        ),
                      ]
                    ]
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
