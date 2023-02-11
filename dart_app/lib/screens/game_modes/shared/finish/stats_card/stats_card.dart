import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/models/games/game_score_training_p.dart';
import 'package:dart_app/models/games/game_single_double_training_p.dart';
import 'package:dart_app/models/player_statistics/player_game_stats_score_training.dart';
import 'package:dart_app/models/player_statistics/player_game_stats_single_double_training.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats.dart';
import 'package:dart_app/screens/game_modes/score_training/finish/local_widgets/player_entry_finish_sc_t.dart';
import 'package:dart_app/screens/game_modes/shared/finish/stats_card/local_widgets/game_mode_details.dart';
import 'package:dart_app/screens/game_modes/single_double_training/finish/local_widgets/player_entry_finish_sd_t.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class StatsCard extends StatefulWidget {
  const StatsCard({
    Key? key,
    required this.isFinishScreen,
    required this.game,
    required this.isOpenGame,
  }) : super(key: key);

  final bool isFinishScreen;
  final Game_P game;
  final bool isOpenGame;

  @override
  State<StatsCard> createState() => _StatsCardState();
}

class _StatsCardState extends State<StatsCard> {
  bool _showAllPlayersOrTeams = false;
  int _playersLength = 0;
  List<PlayerOrTeamGameStats> _playerStats = [];

  @override
  void initState() {
    _playersLength = widget.game.getPlayerGameStatistics.length;
    _playerStats = [...widget.game.getPlayerGameStatistics];
    _playerStats.sort();

    super.initState();
  }

  _getPlayerEntry(int i, bool isDraw) {
    if (widget.game is GameSingleDoubleTraining_P) {
      return PlayerEntryFinishSingleDoubleTraining(
        i: i,
        game: widget.game as GameSingleDoubleTraining_P,
        playerStats: _playerStats[i] as PlayerGameStatsSingleDoubleTraining,
        isOpenGame: widget.isOpenGame,
        isDraw: isDraw,
      );
    } else if (widget.game is GameScoreTraining_P) {
      return PlayerEntryFinishScoreTraining(
        i: i,
        game: widget.game as GameScoreTraining_P,
        playerStats: _playerStats[i] as PlayerGameStatsScoreTraining,
        isOpenGame: widget.isOpenGame,
        isDraw: isDraw,
      );
    }
  }

  bool _isDraw() {
    if (widget.game.getPlayerGameStatistics.length == 1) {
      return false;
    }

    if (widget.game is GameSingleDoubleTraining_P) {
      final int totalPointsOfFirstPlayer =
          widget.game.getPlayerGameStatistics[0].getTotalPoints;

      for (int i = 1; i < widget.game.getPlayerGameStatistics.length; i++) {
        if (totalPointsOfFirstPlayer !=
            widget.game.getPlayerGameStatistics[i].getTotalPoints) {
          return false;
        }
      }

      return true;
    } else if (widget.game is GameScoreTraining_P) {
      if (widget.game.getGameSettings.getMode ==
          ScoreTrainingModeEnum.MaxPoints) {
        return false;
      }

      final int totalPointsOfFirstPlayer =
          widget.game.getPlayerGameStatistics[0].getCurrentScore;

      for (int i = 1; i < widget.game.getPlayerGameStatistics.length; i++) {
        if (totalPointsOfFirstPlayer !=
            widget.game.getPlayerGameStatistics[i].getCurrentScore) {
          return false;
        }
      }

      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final bool isDraw = _isDraw();

    return Container(
      padding: EdgeInsets.only(top: widget.isFinishScreen ? 10.h : 0),
      child: GestureDetector(
        onTap: () {
          if (!widget.isFinishScreen) {
            String route = '';
            if (widget.game is GameSingleDoubleTraining_P) {
              route = '/statisticsSingleDoubleTraining';
            } else if (widget.game is GameScoreTraining_P) {
              route = '/statisticsScoreTraining';
            }
            Navigator.pushNamed(context, route,
                arguments: {'game': widget.game});
          }
        },
        child: Container(
          child: Card(
            margin: EdgeInsets.zero,
            color: Utils.darken(Theme.of(context).colorScheme.primary, 15),
            child: Column(
              children: [
                GameModeDetails(
                  game: widget.game,
                  isOpenGame: widget.isOpenGame,
                  isDraw: isDraw,
                ),
                for (int i = 0; i < 2; i++) ...[
                  if (i <= (_playersLength - 1)) _getPlayerEntry(i, isDraw),
                  if (i == 0 && _playersLength != 1) ListDivider(),
                ],
                if (_showAllPlayersOrTeams) ...[
                  for (int i = 2; i < _playersLength; i++) ...[
                    ListDivider(),
                    _getPlayerEntry(i, isDraw),
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
