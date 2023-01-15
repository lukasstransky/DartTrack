import 'package:dart_app/models/games/score_training/game_score_training_p.dart';
import 'package:dart_app/screens/game_modes/score_training/finish/local_widgets/stats_card_score_training/local_widgets/game_mode_details_score_training.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'local_widgets/player_entry_finish_score_training.dart';

class StatsCardScoreTraining extends StatefulWidget {
  const StatsCardScoreTraining({
    Key? key,
    required this.isFinishScreen,
    required this.gameScoreTraining_P,
    required this.isOpenGame,
  }) : super(key: key);

  final bool isFinishScreen;
  final GameScoreTraining_P gameScoreTraining_P;
  final bool isOpenGame;

  @override
  State<StatsCardScoreTraining> createState() => _StatsCardScoreTrainingState();
}

class _StatsCardScoreTrainingState extends State<StatsCardScoreTraining> {
  bool _showAllPlayersOrTeams = false;
  int _playersLength = 0;

  @override
  void initState() {
    _playersLength = widget.gameScoreTraining_P.getPlayerGameStatistics.length;
    _sortPlayersByScore();
    super.initState();
  }

  _sortPlayersByScore() {
    widget.gameScoreTraining_P.getPlayerGameStatistics.sort();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: widget.isFinishScreen ? 15.h : 0),
      child: GestureDetector(
        onTap: () {
          if (!widget.isFinishScreen)
            Navigator.pushNamed(context, '/statisticsScoreTraining',
                arguments: {'game': widget.gameScoreTraining_P});
        },
        child: Container(
          child: Card(
            margin: EdgeInsets.zero,
            color: Utils.darken(Theme.of(context).colorScheme.primary, 15),
            child: Column(
              children: [
                GameModeDetails(
                  gameScoreTraining_P: widget.gameScoreTraining_P,
                  isOpenGame: widget.isOpenGame,
                ),
                for (int i = 0; i < 2; i++) ...[
                  if (i <= (_playersLength - 1))
                    PlayerEntryFinishScoreTraining(
                      i: i,
                      gameScoreTraining_P: widget.gameScoreTraining_P,
                      isOpenGame: widget.isOpenGame,
                    ),
                  if (i == 0 && _playersLength != 1) ListDivider(),
                ],
                if (_showAllPlayersOrTeams) ...[
                  ListDivider(),
                  for (int i = 2; i < _playersLength; i++) ...[
                    PlayerEntryFinishScoreTraining(
                      i: i,
                      gameScoreTraining_P: widget.gameScoreTraining_P,
                      isOpenGame: widget.isOpenGame,
                    ),
                  ],
                ],
                if (_playersLength > 2)
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
                        _showAllPlayersOrTeams
                            ? 'Show less players'
                            : 'Show all players',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
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
        height: 20,
        thickness: 1,
        endIndent: 10,
        indent: 10,
        color: Utils.getTextColorDarken(context));
  }
}
