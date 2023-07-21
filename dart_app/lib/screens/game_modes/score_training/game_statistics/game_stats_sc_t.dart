import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_score_training_p.dart';
import 'package:dart_app/models/games/game_score_training_p.dart';
import 'package:dart_app/models/player_statistics/player_game_stats_score_training.dart';
import 'package:dart_app/screens/game_modes/score_training/game_statistics/local_widgets/game_stats_score_training/main_stats_sc_t.dart';
import 'package:dart_app/screens/game_modes/shared/game_stats/most_frequent_scores.dart';
import 'package:dart_app/screens/game_modes/shared/game_stats/player_or_team_names.dart';
import 'package:dart_app/screens/game_modes/shared/game_stats/rounded_scores_even.dart';
import 'package:dart_app/screens/game_modes/shared/game_stats/rounded_scores_odd.dart';
import 'package:dart_app/utils/app_bars/custom_app_bar.dart';
import 'package:dart_app/utils/app_bars/custom_app_bar_with_heart.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class GameStatsScoreTraining extends StatefulWidget {
  static const routeName = '/statisticsScoreTraining';

  const GameStatsScoreTraining({Key? key}) : super(key: key);

  @override
  State<GameStatsScoreTraining> createState() => _GameStatsScoreTrainingState();
}

class _GameStatsScoreTrainingState extends State<GameStatsScoreTraining> {
  GameScoreTraining_P? _game;
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

  bool _oneScorePerDartAtLeast() {
    for (PlayerGameStatsScoreTraining stats in _game!.getPlayerGameStatistics) {
      if (stats.getAllScoresPerDartAsStringCount.isNotEmpty) {
        return true;
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _game!.getIsGameFinished && !_showSimpleAppBar
          ? CustomAppBarWithHeart(
              title: 'Statistics',
              mode: GameMode.ScoreTraining,
              isFavouriteGame: _game!.getIsFavouriteGame,
              gameId: _game!.getGameId,
            )
          : CustomAppBar(title: 'Statistics'),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 1.h),
              child: Text(
                context
                    .read<GameSettingsScoreTraining_P>()
                    .getModeStringStatsScreen(),
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                top: 0.5.h,
                bottom: 2.h,
              ),
              child: Text(
                _game!.getFormattedDateTime(),
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: Utils.getTextColorDarken(context),
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PlayerOrTeamNames(game: _game!),
                  MainStatsScoreTraining(
                      gameScoreTraining_P: _game as GameScoreTraining_P),
                  Container(
                    padding: EdgeInsets.only(
                      left: PADDING_LEFT_STATISTICS.w,
                      top: PADDING_TOP_STATISTICS.h,
                    ),
                    child: !_roundedScoresOdd
                        ? RoundedScoresEven(
                            game_p: _game as GameScoreTraining_P,
                          )
                        : RoundedScoresOdd(
                            game_p: _game as GameScoreTraining_P,
                          ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: PADDING_LEFT_STATISTICS.w),
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
                          activeColor: Theme.of(context).colorScheme.secondary,
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
                    padding: EdgeInsets.only(left: PADDING_LEFT_STATISTICS.w),
                    child: MostFrequentScores(
                      game_p: _game as GameScoreTraining_P,
                      mostScoresPerDart: false,
                    ),
                  ),
                  if (_oneScorePerDartAtLeast())
                    Padding(
                      padding: EdgeInsets.only(
                        left: PADDING_LEFT_STATISTICS.w,
                      ),
                      child: MostFrequentScores(
                        game_p: _game as GameScoreTraining_P,
                        mostScoresPerDart: true,
                      ),
                    ),
                  SizedBox(
                    height: 3.h,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
