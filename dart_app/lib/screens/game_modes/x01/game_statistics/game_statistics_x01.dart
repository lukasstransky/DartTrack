import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats_x01.dart';
import 'package:dart_app/screens/game_modes/shared/overall/custom_chip.dart';
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
  bool _showSimpleAppBar = false;

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    if (arguments.isNotEmpty) {
      if (arguments.containsKey('game')) {
        _game = arguments['game'];
      }
      if (arguments.containsKey('showSimpleAppBar'))
        _showSimpleAppBar = arguments['showSimpleAppBar'];
    }
  }

  String _getHeader() {
    String result = '';

    //mode
    _game!.getGameSettings.getBestOfOrFirstTo == BestOfOrFirstToEnum.BestOf
        ? result += 'Best of '
        : result += 'First to ';

    //sets
    if (_game!.getGameSettings.getSetsEnabled) {
      if (_game!.getGameSettings.getSets == 1) {
        result += _game!.getGameSettings.getSets.toString() + ' set ';
      } else {
        result += _game!.getGameSettings.getSets.toString() + ' sets ';
      }
    }

    //legs
    if (_game!.getGameSettings.getLegs == 1) {
      result += _game!.getGameSettings.getLegs.toString() + ' leg - ';
    } else {
      result += _game!.getGameSettings.getLegs.toString() + ' legs - ';
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

  String getModeString(ModeOutIn mode, bool isOut) {
    switch (mode) {
      case ModeOutIn.Single:
        return isOut ? 'Single out' : 'Single in';
      case ModeOutIn.Double:
        return isOut ? 'Double out' : 'Double in';
      case ModeOutIn.Master:
        return isOut ? 'Master out' : 'Master in';
    }
  }

  @override
  Widget build(BuildContext context) {
    final EdgeInsets _padding = EdgeInsets.only(
      left: PADDING_LEFT_STATISTICS.w,
      bottom: 1.h,
    );
    final EdgeInsets _paddingOnlyLeft =
        EdgeInsets.only(left: PADDING_LEFT_STATISTICS.w);

    return Scaffold(
      appBar: _game!.getIsGameFinished && !_showSimpleAppBar
          ? CustomAppBarWithHeart(
              title: 'X01 - Statistics',
              mode: GameMode.X01,
              isFavouriteGame: _game!.getIsFavouriteGame,
              gameId: _game!.getGameId,
            )
          : CustomAppBar(title: 'X01 - Statistics'),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 1.h),
              child: Text(
                _getHeader(),
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 0.5.h),
              child: Text(
                _game!.getFormattedDateTime(),
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: Utils.getTextColorDarken(context),
                ),
              ),
            ),
            Column(
              children: [
                Container(
                  padding: EdgeInsets.only(top: 1.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomChip(
                        label: Text(
                          getModeString(
                              _game!.getGameSettings.getModeIn, false),
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Utils.getPrimaryColorDarken(context),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 1.5.w),
                        child: CustomChip(
                          label: Text(
                            getModeString(
                                _game!.getGameSettings.getModeOut, true),
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Utils.getPrimaryColorDarken(context),
                        ),
                      ),
                      if (_game!.getGameSettings.getSuddenDeath)
                        Container(
                          padding: EdgeInsets.only(left: 1.5.w),
                          child: CustomChip(
                            label: Text(
                              'Sudden death',
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Utils.getPrimaryColorDarken(context),
                          ),
                        ),
                      if (_game!.getGameSettings.getDrawMode)
                        Container(
                          padding: EdgeInsets.only(left: 1.5.w),
                          child: CustomChip(
                            label: Text(
                              'Draw enabled',
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Utils.getPrimaryColorDarken(context),
                          ),
                        ),
                    ],
                  ),
                ),
                Container(
                  transform: Matrix4.translationValues(0.0, -8, 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (!_game!.getGameSettings.getSuddenDeath &&
                          _game!.getGameSettings.getWinByTwoLegsDifference)
                        Padding(
                          padding: EdgeInsets.only(left: 1.w, top: 2.h),
                          child: CustomChip(
                            label: Text(
                              'Win by two legs difference',
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Utils.getPrimaryColorDarken(context),
                          ),
                        ),
                    ],
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
                      padding: EdgeInsets.only(left: 5.w),
                      child: !_roundedScoresOdd
                          ? RoundedScoresEven(game_p: _game as GameX01_P)
                          : RoundedScoresOdd(game_p: _game as GameX01_P),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5.w),
                      child: Row(
                        children: [
                          const Text(
                            'Show odd rounded scores',
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
                              Utils.handleVibrationFeedback(context);
                              setState(() {
                                _roundedScoresOdd = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: _paddingOnlyLeft,
                      child: MostFrequentScores(
                        mostScoresPerDart: false,
                        game_p: _game as GameX01_P,
                      ),
                    ),
                    if (_oneScorePerDartAtLeast())
                      Padding(
                        padding: _paddingOnlyLeft,
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
                          padding: EdgeInsets.only(bottom: 3.h),
                          child:
                              DetailedLegsListX01(gameX01: _game as GameX01_P),
                        ),
                      ],
                    ],
                    Container(
                      height: 3.h,
                    )
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
