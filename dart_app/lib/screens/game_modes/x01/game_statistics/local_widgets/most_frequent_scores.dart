import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_statistics_x01.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class MostFrequentScores extends StatefulWidget {
  const MostFrequentScores(
      {Key? key, required this.mostScoresPerDart, required this.gameX01})
      : super(key: key);

  final bool mostScoresPerDart;
  final GameX01 gameX01;

  @override
  State<MostFrequentScores> createState() => _MostFrequentScoresState();
}

class _MostFrequentScoresState extends State<MostFrequentScores> {
  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    for (PlayerOrTeamGameStatisticsX01 stats
        in context.read<GameX01>().getPlayerGameStatistics) {
      Utils.sortMapIntInt(stats.getPreciseScores);
      Utils.sortMapStringInt(stats.getAllScoresPerDartAsStringCount);
    }
  }

  bool _showFirst10 = false;

  bool _moreThanFiveScores(GameX01 gameX01, GameSettingsX01 gameSettingsX01) {
    for (PlayerOrTeamGameStatisticsX01 stats
        in Utils.getPlayersOrTeamStatsList(gameX01, gameSettingsX01)) {
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
    final GameSettingsX01 gameSettingsX01 = widget.gameX01.getGameSettings;

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
                color: Theme.of(context).primaryColor),
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
                        Container(
                          width: 20.w,
                          padding: EdgeInsets.only(top: 5),
                          alignment: Alignment.centerLeft,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              '${i + 1}.',
                              style:
                                  TextStyle(fontSize: FONTSIZE_STATISTICS.sp),
                            ),
                          ),
                        ),
                        for (PlayerOrTeamGameStatisticsX01 stats
                            in Utils.getPlayersOrTeamStatsList(
                                widget.gameX01, gameSettingsX01))
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
                                    child: Text(
                                      (widget.mostScoresPerDart
                                              ? Utils.sortMapStringIntByKey(stats
                                                      .getAllScoresPerDartAsStringCount)
                                                  .keys
                                                  .elementAt(i)
                                                  .toString()
                                              : Utils.sortMapIntIntByKey(
                                                      stats.getPreciseScores)
                                                  .keys
                                                  .elementAt(i)
                                                  .toString()) +
                                          ' (' +
                                          (widget.mostScoresPerDart
                                              ? Utils.sortMapStringIntByKey(stats
                                                      .getAllScoresPerDartAsStringCount)
                                                  .values
                                                  .elementAt(i)
                                                  .toString()
                                              : Utils.sortMapIntIntByKey(
                                                      stats.getPreciseScores)
                                                  .values
                                                  .elementAt(i)
                                                  .toString()) +
                                          'x)',
                                      style: TextStyle(
                                          fontSize: FONTSIZE_STATISTICS.sp),
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
            ],
          ),
        ),
        if (_moreThanFiveScores(widget.gameX01, gameSettingsX01))
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
