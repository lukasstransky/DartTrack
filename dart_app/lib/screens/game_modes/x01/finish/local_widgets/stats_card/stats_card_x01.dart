import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/screens/game_modes/x01/finish/local_widgets/stats_card/local_widgets/game_details_x01.dart';
import 'package:dart_app/screens/game_modes/x01/finish/local_widgets/stats_card/local_widgets/player_entry_finish_x01.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class StatsCardX01 extends StatefulWidget {
  const StatsCardX01(
      {Key? key,
      required this.isFinishScreen,
      required this.gameX01,
      required this.isOpenGame})
      : super(key: key);

  final bool isFinishScreen;
  final GameX01_P gameX01;
  final bool isOpenGame;

  @override
  State<StatsCardX01> createState() => _StatsCardX01State();
}

class _StatsCardX01State extends State<StatsCardX01> {
  bool _showAllPlayersOrTeams = false;

  @override
  Widget build(BuildContext context) {
    final GameSettingsX01_P gameSettingsX01 = widget.gameX01.getGameSettings;

    return Container(
      padding: EdgeInsets.only(top: widget.isFinishScreen ? 15.h : 0.h),
      child: GestureDetector(
        onTap: () {
          if (!widget.isFinishScreen)
            Navigator.pushNamed(context, '/statisticsX01',
                arguments: {'game': widget.gameX01});
        },
        child: Card(
          margin: EdgeInsets.zero,
          color: Utils.darken(Theme.of(context).colorScheme.primary, 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GameDetailsX01(gameX01: widget.gameX01),
              for (int i = 0; i < 2; i++) ...[
                PlayerEntryFinishX01(
                    i: i, gameX01: widget.gameX01, openGame: widget.isOpenGame),
                if (i == 0) ListDivider(),
              ],
              if (Utils.getPlayersOrTeamStatsList(
                          widget.gameX01, gameSettingsX01)
                      .length >
                  2) ...[
                if (_showAllPlayersOrTeams) ...[
                  ListDivider(),
                  for (int i = 2;
                      i <
                          Utils.getPlayersOrTeamStatsList(
                                  widget.gameX01, gameSettingsX01)
                              .length;
                      i++) ...[
                    PlayerEntryFinishX01(
                      i: i,
                      gameX01: widget.gameX01,
                      openGame: widget.isOpenGame,
                    ),
                    if (i !=
                        Utils.getPlayersOrTeamStatsList(
                                    widget.gameX01, gameSettingsX01)
                                .length -
                            1)
                      ListDivider(),
                  ]
                ],
                Center(
                  child: TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _showAllPlayersOrTeams = !_showAllPlayersOrTeams;
                      });
                    },
                    icon: Icon(
                      _showAllPlayersOrTeams
                          ? Icons.expand_less
                          : Icons.expand_more,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    label: Text(
                      'Show ${_showAllPlayersOrTeams ? 'less' : 'all'} ${gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Single ? 'players' : 'teams'}',
                      style: TextStyle(
                        color: Colors.white,
                      ),
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

class ListDivider extends StatelessWidget {
  const ListDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
        height: 2.h,
        thickness: 1,
        endIndent: 10,
        indent: 10,
        color: Utils.getTextColorDarken(context));
  }
}
