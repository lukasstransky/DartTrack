import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/games/x01/game_x01.dart';
import 'package:dart_app/models/player_statistics/x01/player_or_team_game_statistics_x01.dart';
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
  bool _showFirst10 = false;

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    for (PlayerOrTeamGameStatisticsX01 stats
        in context.read<GameX01>().getPlayerGameStatistics) {
      Utils.sortMapIntInt(stats.getPreciseScores);
      Utils.sortMapStringInt(stats.getAllScoresPerDartAsStringCount);
    }
  }

  bool _moreThanFiveScores(GameX01 gameX01, GameSettingsX01_P gameSettingsX01) {
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

  bool _atLeastOneRoundPlayedWithThreeDartsMode(
      GameSettingsX01_P gameSettingsX01) {
    for (PlayerOrTeamGameStatisticsX01 stats
        in Utils.getPlayersOrTeamStatsList(widget.gameX01, gameSettingsX01)) {
      if (stats.getAllScoresPerDart.isNotEmpty) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final GameSettingsX01_P gameSettingsX01 = widget.gameX01.getGameSettings;
    final bool atLeastOneRoundPlayedWithThreeDartsMode =
        _atLeastOneRoundPlayedWithThreeDartsMode(gameSettingsX01);

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
                for (PlayerOrTeamGameStatisticsX01 stats
                    in Utils.getPlayersOrTeamStatsList(
                        widget.gameX01, gameSettingsX01))
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
