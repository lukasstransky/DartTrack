import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/models/player_statistics/player_game_statistics_x01.dart';
import 'package:dart_app/screens/game_modes/x01/finish/local_widgets/stats_card/local_widgets/player_entry.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class StatsCardX01 extends StatefulWidget {
  const StatsCardX01(
      {Key? key,
      required this.isFinishScreen,
      required this.gameX01,
      required this.openGame})
      : super(key: key);

  final bool isFinishScreen;
  final GameX01 gameX01;
  final bool openGame;

  @override
  State<StatsCardX01> createState() => _StatsCardX01State();
}

class _StatsCardX01State extends State<StatsCardX01> {
  bool _showAllPlayers = false;

  bool _isGameDraw() {
    for (PlayerGameStatisticsX01 stats
        in widget.gameX01.getPlayerGameStatistics) {
      if (stats.getGameDraw) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: widget.isFinishScreen ? 100 : 5),
      child: GestureDetector(
        onTap: () {
          if (!widget.isFinishScreen)
            Navigator.pushNamed(context, '/statisticsX01',
                arguments: {'game': widget.gameX01});
        },
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        _isGameDraw()
                            ? 'Draw - ${widget.gameX01.getGameSettings.getGameMode()}'
                            : '${widget.gameX01.getGameSettings.getGameMode()}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12.sp),
                      ),
                    ),
                    Spacer(),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        widget.gameX01.getFormattedDateTime(),
                        style: TextStyle(fontSize: 10.sp),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10, bottom: 10),
                child: Text(
                    'X01 (${widget.gameX01.getGameSettings.getGameModeDetails(true)})',
                    style: TextStyle(fontSize: 12.sp)),
              ),
              for (int i = 0; i < 2; i++) ...[
                PlayerEntry(
                    i: i, gameX01: widget.gameX01, openGame: widget.openGame),
                if (i == 0)
                  Divider(
                    height: 20,
                    thickness: 1,
                    endIndent: 10,
                    indent: 10,
                    color: Colors.black,
                  ),
              ],
              if (widget.gameX01.getPlayerGameStatistics.length > 2) ...[
                if (_showAllPlayers) ...[
                  Divider(
                    height: 20,
                    thickness: 1,
                    endIndent: 10,
                    indent: 10,
                    color: Colors.black,
                  ),
                  for (int i = 2;
                      i < widget.gameX01.getPlayerGameStatistics.length;
                      i++) ...[
                    PlayerEntry(
                        i: i,
                        gameX01: widget.gameX01,
                        openGame: widget.openGame),
                    if (i != widget.gameX01.getPlayerGameStatistics.length - 1)
                      Divider(
                        height: 20,
                        thickness: 1,
                        endIndent: 10,
                        indent: 10,
                        color: Colors.black,
                      ),
                  ]
                ],
                Center(
                  child: TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _showAllPlayers = !_showAllPlayers;
                      });
                    },
                    icon: Icon(
                      _showAllPlayers ? Icons.expand_less : Icons.expand_more,
                      color: Colors.black,
                    ),
                    label: const Text(
                      'All Players',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
