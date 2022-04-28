import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/screens/game_modes/x01/game_statistics/local_widgets/finishing_stats.dart';
import 'package:dart_app/screens/game_modes/x01/game_statistics/local_widgets/game_stats.dart';
import 'package:dart_app/screens/game_modes/x01/game_statistics/local_widgets/most_frequent_scores.dart';
import 'package:dart_app/screens/game_modes/x01/game_statistics/local_widgets/most_frequent_scores_per.dart';
import 'package:dart_app/screens/game_modes/x01/game_statistics/local_widgets/rounded_scores.dart';
import 'package:dart_app/screens/game_modes/x01/game_statistics/local_widgets/scoring_stats.dart';
import 'package:dart_app/utils/custom_app_bar.dart';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class GameStatistics extends StatefulWidget {
  static const routeName = "/statisticsX01";

  const GameStatistics({Key? key}) : super(key: key);

  @override
  State<GameStatistics> createState() => _GameStatisticsState();
}

class _GameStatisticsState extends State<GameStatistics> {
  Game? _game;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;
    if (arguments.isNotEmpty) {
      _game = arguments.entries.first.value;
    }
  }

  String _getHeader() {
    String result = "";

    //mode
    _game!.getGameSettings.getMode == BestOfOrFirstToEnum.BestOf
        ? result += "Best Of "
        : result += "First To ";

    //sets
    if (_game!.getGameSettings.getSetsEnabled) {
      result += _game!.getGameSettings.getSets.toString() + " Sets ";
    }

    //legs
    if (_game!.getGameSettings.getLegs == 1) {
      result += _game!.getGameSettings.getLegs.toString() + " Leg - ";
    } else {
      result += _game!.getGameSettings.getLegs.toString() + " Legs - ";
    }

    //points
    _game!.getGameSettings.getCustomPoints != -1
        ? result += _game!.getGameSettings.getCustomPoints.toString()
        : result += _game!.getGameSettings.getPoints.toString();

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(true, "Statistics"),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
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
                children: [
                  Chip(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    label: Text(
                      _game!.getGameSettings.getModeIn ==
                              SingleOrDouble.SingleField
                          ? "Single In"
                          : "Double In",
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
                        _game!.getGameSettings.getModeOut ==
                                SingleOrDouble.SingleField
                            ? "Single Out"
                            : "Double Out",
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
                          "Sudden Death",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GameStats(game: _game),
                    ScoringStats(game: _game),
                    FinishingStats(game: _game),
                    RoundedScores(game: _game),
                    MostFrequentScores(game: _game),
                    if (_game!.getGameSettings.getInputMethod ==
                        InputMethod.ThreeDarts) ...[
                      MostFrequentScoresPerDart(game: _game),
                    ]
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
