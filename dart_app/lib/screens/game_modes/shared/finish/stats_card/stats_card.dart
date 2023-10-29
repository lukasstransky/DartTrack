import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/models/games/game_cricket_p.dart';
import 'package:dart_app/models/games/game_score_training_p.dart';
import 'package:dart_app/models/games/game_single_double_training_p.dart';
import 'package:dart_app/models/player_statistics/player_game_stats_score_training.dart';
import 'package:dart_app/models/player_statistics/player_game_stats_single_double_training.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats_cricket.dart';
import 'package:dart_app/screens/game_modes/cricket/finish/local_widgets/player_entry_finish_c.dart';
import 'package:dart_app/screens/game_modes/score_training/finish/local_widgets/player_entry_finish_sc_t.dart';
import 'package:dart_app/screens/game_modes/shared/finish/stats_card/local_widgets/game_mode_details.dart';
import 'package:dart_app/screens/game_modes/shared/overall/list_divider.dart';
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
  int _playersOrTeamsLength = 0;
  List<PlayerOrTeamGameStats> _playerOrTeamStats = [];

  @override
  void initState() {
    if (widget.game is GameCricket_P &&
        widget.game.getGameSettings.getSingleOrTeam == SingleOrTeamEnum.Team) {
      _playersOrTeamsLength = widget.game.getTeamGameStatistics.length;
      _playerOrTeamStats = [...widget.game.getTeamGameStatistics];
    } else {
      _playersOrTeamsLength = widget.game.getPlayerGameStatistics.length;
      _playerOrTeamStats = [...widget.game.getPlayerGameStatistics];
    }
    _playerOrTeamStats.sort();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDraw = _isDraw();

    return Container(
      padding: EdgeInsets.only(top: widget.isFinishScreen ? 10.h : 0),
      child: GestureDetector(
        onTap: () {
          Utils.handleVibrationFeedback(context);
          if (!widget.isFinishScreen) {
            String route = '';
            if (widget.game is GameSingleDoubleTraining_P) {
              route = '/statisticsSingleDoubleTraining';
            } else if (widget.game is GameScoreTraining_P) {
              route = '/statisticsScoreTraining';
            } else if (widget.game is GameCricket_P) {
              route = '/statisticsCricket';
            }

            Navigator.pushNamed(context, route,
                arguments: {'game': widget.game});
          }
        },
        child: Container(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(CARD_SHAPE_ROUNDING),
            ),
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
                  if (i <= (_playersOrTeamsLength - 1))
                    _getPlayerOrTeamEntry(i, isDraw),
                  if (i == 0 && _playersOrTeamsLength != 1) ListDivider(),
                ],
                if (_showAllPlayersOrTeams) ...[
                  for (int i = 2; i < _playersOrTeamsLength; i++) ...[
                    ListDivider(),
                    _getPlayerOrTeamEntry(i, isDraw),
                  ],
                ],
                if (_playersOrTeamsLength > 2)
                  Center(
                    child: TextButton.icon(
                      onPressed: () {
                        Utils.handleVibrationFeedback(context);
                        setState(() {
                          _showAllPlayersOrTeams = !_showAllPlayersOrTeams;
                        });
                      },
                      icon: Icon(
                        size: ICON_BUTTON_SIZE.h,
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
                          fontSize:
                              Theme.of(context).textTheme.bodyMedium!.fontSize,
                        ),
                      ),
                      style: ButtonStyle(
                        splashFactory: InkRipple.splashFactory,
                        shadowColor: Utils.getColor(Utils.darken(
                                Theme.of(context).colorScheme.primary, 30)
                            .withOpacity(0.3)),
                        overlayColor:
                            MaterialStateProperty.resolveWith<Color>((states) {
                          if (states.contains(MaterialState.pressed))
                            return Utils.darken(
                                Theme.of(context).colorScheme.primary, 10);
                          return Colors.transparent;
                        }),
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

  _multipleWinnersForSingleDoubleTraining(int i) {
    return (_playerOrTeamStats[i] as PlayerGameStatsSingleDoubleTraining)
            .getTotalPoints ==
        (_playerOrTeamStats[0] as PlayerGameStatsSingleDoubleTraining)
            .getTotalPoints;
  }

  _multipleWinnersForScoreTraining(int i) {
    return (_playerOrTeamStats[i] as PlayerGameStatsScoreTraining)
            .getCurrentScore ==
        (_playerOrTeamStats[0] as PlayerGameStatsScoreTraining).getCurrentScore;
  }

  _getPlayerOrTeamEntry(int i, bool isDraw) {
    if (widget.game is GameSingleDoubleTraining_P) {
      return PlayerEntryFinishSingleDoubleTraining(
        i: _multipleWinnersForSingleDoubleTraining(i) ? 0 : i,
        game: widget.game as GameSingleDoubleTraining_P,
        playerStats:
            _playerOrTeamStats[i] as PlayerGameStatsSingleDoubleTraining,
        isOpenGame: widget.isOpenGame,
        isDraw: isDraw,
      );
    } else if (widget.game is GameScoreTraining_P) {
      return PlayerEntryFinishScoreTraining(
        i: _multipleWinnersForScoreTraining(i) ? 0 : i,
        game: widget.game as GameScoreTraining_P,
        playerStats: _playerOrTeamStats[i] as PlayerGameStatsScoreTraining,
        isOpenGame: widget.isOpenGame,
        isDraw: isDraw,
      );
    } else if (widget.game is GameCricket_P) {
      return PlayerOrTeamEntryFinishCricket(
        i: i,
        game: widget.game as GameCricket_P,
        stats: _playerOrTeamStats[i] as PlayerOrTeamGameStatsCricket,
        isOpenGame: widget.isOpenGame,
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

      if (widget.game.getPlayerGameStatistics.length == 0) {
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
}
