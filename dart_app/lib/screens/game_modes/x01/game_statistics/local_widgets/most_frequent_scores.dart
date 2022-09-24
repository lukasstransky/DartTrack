import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/models/player_statistics/player_game_statistics_x01.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class MostFrequentScores extends StatefulWidget {
  const MostFrequentScores(
      {Key? key, required this.game, required this.mostScoresPerDart})
      : super(key: key);

  final Game? game;
  final bool mostScoresPerDart;

  @override
  State<MostFrequentScores> createState() => _MostFrequentScoresState();
}

class _MostFrequentScoresState extends State<MostFrequentScores> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (PlayerGameStatisticsX01 stats
        in widget.game!.getPlayerGameStatistics) {
      Utils.sortMapIntInt(stats.getPreciseScores);
      Utils.sortMapStringInt(stats.getAllScoresPerDartAsStringCount);
    }
  }

  bool _showFirst10 = false;

  bool moreThanFiveScores() {
    for (PlayerGameStatisticsX01 stats
        in widget.game!.getPlayerGameStatistics) {
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: PADDING_TOP_STATISTICS),
          child: Container(
            width: 100.w,
            transform: Matrix4.translationValues(-2.5.w, 0.0, 0.0),
            child: Text(
              widget.mostScoresPerDart
                  ? 'Most Frequent Scores per Dart'
                  : 'Most Frequent Scores',
              style: TextStyle(
                  fontSize: FONTSIZE_HEADING_STATISTICS.sp,
                  color: Theme.of(context).primaryColor),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: PADDING_TOP_STATISTICS),
          child: Row(
            children: [
              Column(
                children: [
                  for (int i = 0; i < (_showFirst10 ? 10 : 5); i++)
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 5),
                          child: Container(
                            width: 20.w,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text((i + 1).toString() + '.',
                                    style: TextStyle(
                                        fontSize: FONTSIZE_STATISTICS.sp)),
                              ),
                            ),
                          ),
                        ),
                        for (PlayerGameStatisticsX01 stats
                            in widget.game!.getPlayerGameStatistics)
                          Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Container(
                              width: 30.w,
                              child: (widget.mostScoresPerDart
                                          ? stats
                                              .getAllScoresPerDartAsStringCount
                                              .keys
                                              .length
                                          : stats
                                              .getPreciseScores.keys.length) >
                                      i
                                  ? Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                          (widget.mostScoresPerDart
                                                  ? Utils.sortMapStringIntByKey(
                                                          stats
                                                              .getAllScoresPerDartAsStringCount)
                                                      .keys
                                                      .elementAt(i)
                                                      .toString()
                                                  : Utils.sortMapIntIntByKey(
                                                          stats
                                                              .getPreciseScores)
                                                      .keys
                                                      .elementAt(i)
                                                      .toString()) +
                                              ' (' +
                                              (widget.mostScoresPerDart
                                                  ? Utils.sortMapStringIntByKey(
                                                          stats
                                                              .getAllScoresPerDartAsStringCount)
                                                      .values
                                                      .elementAt(i)
                                                      .toString()
                                                  : Utils.sortMapIntIntByKey(
                                                          stats
                                                              .getPreciseScores)
                                                      .values
                                                      .elementAt(i)
                                                      .toString()) +
                                              'x)',
                                          style: TextStyle(
                                              fontSize:
                                                  FONTSIZE_STATISTICS.sp)),
                                    )
                                  : Align(
                                      alignment: Alignment.centerRight,
                                      child: Text('-',
                                          style: TextStyle(
                                              fontSize:
                                                  FONTSIZE_STATISTICS.sp)),
                                    ),
                            ),
                          ),
                      ],
                    )
                ],
              ),
            ],
          ),
        ),
        if (moreThanFiveScores())
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
                  color: Colors.black,
                ),
                label: Text(
                  _showFirst10 ? 'Show Less' : 'Show More',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
