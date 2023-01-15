import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/models/games/score_training/game_score_training_p.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class MostFrequentScores extends StatefulWidget {
  const MostFrequentScores(
      {Key? key, required this.mostScoresPerDart, required this.game_p})
      : super(key: key);

  final bool mostScoresPerDart;
  final Game_P game_p;

  @override
  State<MostFrequentScores> createState() => _MostFrequentScoresState();
}

class _MostFrequentScoresState extends State<MostFrequentScores> {
  bool _showFirst10 = false;

  @override
  didChangeDependencies() {
    super.didChangeDependencies();

    final dynamic players = _getPlayerStats();

    for (int i = 0; i < players.length; i++) {
      final dynamic stats = players[i];
      Utils.sortMapIntInt(stats.getPreciseScores);
      Utils.sortMapStringInt(stats.getAllScoresPerDartAsStringCount);
    }
  }

  dynamic _getPlayerStats() {
    if (widget.game_p is GameX01_P) {
      if (widget.game_p.getIsGameFinished) {
        return widget.game_p.getPlayerGameStatistics;
      }
      return context.read<GameX01_P>().getPlayerGameStatistics;
    } else if (widget.game_p is GameScoreTraining_P) {
      if (widget.game_p.getIsGameFinished) {
        return widget.game_p.getPlayerGameStatistics;
      }
      return context.read<GameScoreTraining_P>().getPlayerGameStatistics;
    }
  }

  bool _moreThanFiveScores() {
    final dynamic playerOrTeamStats =
        Utils.getPlayerOrTeamStatsDynamic(widget.game_p, context);

    for (int i = 0; i < playerOrTeamStats.length; i++) {
      final dynamic stats = playerOrTeamStats[i];
      if (widget.mostScoresPerDart &&
          stats.getAllScoresPerDartAsStringCount.length > 5) {
        return true;
      }
      if (!widget.mostScoresPerDart && stats.getPreciseScores.length > 5) {
        return true;
      }
    }

    return false;
  }

  bool _atLeastOneRoundPlayedWithThreeDartsMode() {
    final dynamic playerOrTeamStats =
        Utils.getPlayerOrTeamStatsDynamic(widget.game_p, context);

    for (int i = 0; i < playerOrTeamStats.length; i++) {
      final dynamic stats = playerOrTeamStats[i];
      if (stats.getAllScoresPerDartAsStringCount.isNotEmpty) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final bool atLeastOneRoundPlayedWithThreeDartsMode =
        _atLeastOneRoundPlayedWithThreeDartsMode();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 100.w,
          padding: EdgeInsets.only(top: PADDING_TOP_STATISTICS),
          transform: Matrix4.translationValues(-2.5.w, 0.0, 0.0),
          child: Text(
            widget.mostScoresPerDart
                ? 'Most Frequent Scores per Dart'
                : 'Most Frequent Scores',
            style: TextStyle(
              fontSize: FONTSIZE_HEADING_STATISTICS.sp,
              color: Colors.white,
            ),
          ),
        ),
        if (widget.mostScoresPerDart &&
            atLeastOneRoundPlayedWithThreeDartsMode) ...[
          Padding(
            padding: EdgeInsets.only(top: PADDING_TOP_STATISTICS),
            child: Row(
              children: [
                Container(
                  width: 40.w,
                  padding: EdgeInsets.only(top: 5),
                  alignment: Alignment.centerLeft,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '3-dart-mode rounds',
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                        color: Utils.getTextColorDarken(context),
                      ),
                    ),
                  ),
                ),
                for (dynamic stats in Utils.getPlayerOrTeamStatsDynamic(
                    widget.game_p, context))
                  Container(
                    width: 30.w,
                    padding: EdgeInsets.only(top: 5),
                    alignment: Alignment.centerLeft,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        '${stats.getThreeDartModeRoundsCount}/${stats.getTotalRoundsCount}',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
        Padding(
          padding: EdgeInsets.only(
              top: atLeastOneRoundPlayedWithThreeDartsMode &&
                      widget.mostScoresPerDart
                  ? 0
                  : PADDING_TOP_STATISTICS),
          child: Column(
            children: [
              for (int i = 0; i < (_showFirst10 ? 10 : 5); i++)
                Row(
                  children: [
                    Container(
                      width: 20.w,
                      padding: EdgeInsets.only(top: 5),
                      alignment: Alignment.centerLeft,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '${i + 1}.',
                          style: TextStyle(
                            fontSize: FONTSIZE_STATISTICS.sp,
                            fontWeight: FontWeight.bold,
                            color: Utils.getTextColorDarken(context),
                          ),
                        ),
                      ),
                    ),
                    for (dynamic stats in Utils.getPlayerOrTeamStatsDynamic(
                        widget.game_p, context))
                      Container(
                        width: 30.w,
                        padding: EdgeInsets.only(top: 5),
                        child: (widget.mostScoresPerDart
                                    ? stats.getAllScoresPerDartAsStringCount
                                        .keys.length
                                    : stats.getPreciseScores.keys.length) >
                                i
                            ? Align(
                                alignment: Alignment.centerRight,
                                child: RichText(
                                  text: TextSpan(
                                    text: (widget.mostScoresPerDart
                                        ? Utils.sortMapStringIntByKey(stats
                                                .getAllScoresPerDartAsStringCount)
                                            .keys
                                            .elementAt(i)
                                            .toString()
                                        : Utils.sortMapIntIntByKey(
                                                stats.getPreciseScores)
                                            .keys
                                            .elementAt(i)
                                            .toString()),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: FONTSIZE_STATISTICS.sp,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text:
                                            ' (${(widget.mostScoresPerDart ? Utils.sortMapStringIntByKey(stats.getAllScoresPerDartAsStringCount).values.elementAt(i).toString() : Utils.sortMapIntIntByKey(stats.getPreciseScores).values.elementAt(i).toString())}x)',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 11.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Container(
                                alignment: Alignment.centerRight,
                                padding: EdgeInsets.only(right: 7.w),
                                child: Text(
                                  '-',
                                  style: TextStyle(
                                      fontSize: FONTSIZE_STATISTICS.sp),
                                ),
                              ),
                      ),
                  ],
                )
            ],
          ),
        ),
        if (_moreThanFiveScores())
          Container(
            width: 100.w,
            transform: Matrix4.translationValues(-5.w, 0.0, 0.0),
            child: Center(
              child: TextButton.icon(
                onPressed: () {
                  setState(() {
                    _showFirst10 = !_showFirst10;
                  });
                },
                icon: Icon(
                  _showFirst10 ? Icons.expand_less : Icons.expand_more,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                label: Text(
                  _showFirst10 ? 'Show Less' : 'Show More',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
