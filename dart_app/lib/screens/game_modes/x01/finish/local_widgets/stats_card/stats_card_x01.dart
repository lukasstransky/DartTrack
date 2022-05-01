import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/screens/game_modes/x01/finish/local_widgets/stats_card/local_widgets/player_entry.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class StatsCardX01 extends StatefulWidget {
  const StatsCardX01(
      {Key? key, required this.isFinishScreen, required this.game})
      : super(key: key);

  final bool isFinishScreen;
  final Game game;

  @override
  State<StatsCardX01> createState() => _StatsCardX01State();
}

class _StatsCardX01State extends State<StatsCardX01> {
  bool _showAllPlayers = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: widget.isFinishScreen ? 100 : 5),
      child: GestureDetector(
        onTap: () {
          if (!widget.isFinishScreen)
            Navigator.pushNamed(context, "/statisticsX01",
                arguments: {'game': widget.game});
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
                    Text(
                      widget.game.getGameSettings.getGameMode(),
                      style: TextStyle(
                          fontSize: 16.sp, fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    Text(
                      widget.game.getFormattedDateTime(),
                      style: TextStyle(fontSize: 12.sp),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10, bottom: 10),
                child: Text(
                    "X01 (" +
                        widget.game.getGameSettings.getGameModeDetails(true) +
                        ")",
                    style: TextStyle(fontSize: 14.sp)),
              ),

              for (int i = 0; i < 2; i++) ...[
                PlayerEntry(i: i, game: widget.game),
                if (i == 0)
                  Divider(
                    height: 20,
                    thickness: 1,
                    endIndent: 20,
                    color: Colors.black,
                  ),
              ],

              if (widget.game.getPlayerGameStatistics.length > 2) ...[
                if (_showAllPlayers) ...[
                  Divider(
                    height: 20,
                    thickness: 1,
                    endIndent: 20,
                    color: Colors.black,
                  ),
                  for (int i = 2;
                      i < widget.game.getPlayerGameStatistics.length;
                      i++) ...[
                    PlayerEntry(i: i, game: widget.game),
                    if (i != widget.game.getPlayerGameStatistics.length - 1)
                      Divider(
                        height: 20,
                        thickness: 1,
                        endIndent: 20,
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
                      "All Players",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ]

              //if (!isFinishScreen)
              /*Padding(
                  padding: EdgeInsets.only(right: 5),
                  child: Container(
                    height: 4.h,
                    transform: Matrix4.translationValues(0.0, -10.0, 0.0),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () => null,
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: const Text("More"),
                        ),
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).colorScheme.primary),
                        ),
                      ),
                    ),
                  ),
                ),*/

              /*Align(
                  alignment: Alignment.center,
                  child: Text("(Click Card to view Details)"),
                )*/

              /*Align(
                  alignment: Alignment.center,
                  child: TextButton.icon(
                    onPressed: null,
                    icon: Icon(
                      Icons.expand_more,
                      color: Colors.black,
                    ),
                    label: const Text(
                      "Full Stats",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),*/
            ],
          ),
        ),
      ),
    );
  }
}
