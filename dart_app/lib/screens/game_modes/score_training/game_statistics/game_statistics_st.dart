import 'package:dart_app/models/game_settings/score_training/game_settings_score_training_p.dart';
import 'package:dart_app/models/games/score_training/game_score_training_p.dart';
import 'package:dart_app/models/player_statistics/score_training/player_game_statistics_score_training.dart';
import 'package:dart_app/screens/game_modes/score_training/game_statistics/local_widgets/game_stats_score_training/game_stats_st.dart';
import 'package:dart_app/screens/game_modes/score_training/game_statistics/local_widgets/game_stats_score_training/player_names_st.dart';
import 'package:dart_app/screens/game_modes/shared/game_stats/most_frequent_scores.dart';
import 'package:dart_app/screens/game_modes/shared/game_stats/rounded_scores_even.dart';
import 'package:dart_app/screens/game_modes/shared/game_stats/rounded_scores_odd.dart';
import 'package:dart_app/utils/app_bars/custom_app_bar.dart';
import 'package:dart_app/utils/app_bars/custom_app_bar_with_heart.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class GameStatistics_st extends StatefulWidget {
  static const routeName = '/statisticsScoreTraining';

  const GameStatistics_st({Key? key}) : super(key: key);

  @override
  State<GameStatistics_st> createState() => _GameStatistics_stState();
}

class _GameStatistics_stState extends State<GameStatistics_st> {
  GameScoreTraining_P? _gameScoreTraining_P;
  bool _roundedScoresOdd = false;

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    if (arguments.isNotEmpty) {
      _gameScoreTraining_P = arguments['game'];
    }
  }

  bool _oneScorePerDartAtLeast() {
    for (PlayerGameStatisticsScoreTraining stats
        in _gameScoreTraining_P!.getPlayerGameStatistics) {
      if (stats.getAllScoresPerDartAsStringCount.isNotEmpty) {
        return true;
      }
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final _padding = EdgeInsets.only(left: 20, bottom: 10);

    return Scaffold(
      appBar: _gameScoreTraining_P!.getIsGameFinished
          ? CustomAppBarWithHeart(
              title: 'Statistics',
              mode: 'Score Training',
              isFavouriteGame: _gameScoreTraining_P!.getIsFavouriteGame,
              gameId: _gameScoreTraining_P!.getGameId,
            )
          : CustomAppBar(title: 'Statistics'),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 10),
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
              padding: EdgeInsets.only(top: 5),
              child: Text(
                _gameScoreTraining_P!.getFormattedDateTime(),
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
                  Padding(
                    padding: EdgeInsets.only(
                      left: 20,
                      top: 5,
                    ),
                    child: PlayerNames_st(
                      gameSettingsScoreTraining_P:
                          context.read<GameSettingsScoreTraining_P>(),
                    ),
                  ),
                  Padding(
                    padding: _padding,
                    child: GameStats_st(
                        gameScoreTraining_P:
                            _gameScoreTraining_P as GameScoreTraining_P),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: !_roundedScoresOdd
                        ? RoundedScoresEven(
                            game_p: _gameScoreTraining_P as GameScoreTraining_P,
                          )
                        : RoundedScoresOdd(
                            game_p: _gameScoreTraining_P as GameScoreTraining_P,
                          ),
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
                          activeColor: Theme.of(context).colorScheme.secondary,
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
                    padding: _padding,
                    child: MostFrequentScores(
                      game_p: _gameScoreTraining_P as GameScoreTraining_P,
                      mostScoresPerDart: false,
                    ),
                  ),
                  if (_oneScorePerDartAtLeast())
                    Padding(
                      padding: _padding,
                      child: MostFrequentScores(
                        game_p: _gameScoreTraining_P as GameScoreTraining_P,
                        mostScoresPerDart: true,
                      ),
                    ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: SizedBox.shrink(),
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
