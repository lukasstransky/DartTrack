import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_cricket_p.dart';
import 'package:dart_app/models/games/game_cricket_p.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats_cricket.dart';
import 'package:dart_app/screens/game_modes/shared/game/leg_beginner_asset.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class PlayerOrTeamNamesAndScores extends StatelessWidget {
  const PlayerOrTeamNamesAndScores({
    Key? key,
    required this.evenPlayersOrTeams,
    required this.playerOrTeamGameStatistics,
  }) : super(key: key);

  final bool evenPlayersOrTeams;
  final dynamic playerOrTeamGameStatistics;

  @override
  Widget build(BuildContext context) {
    final GameCricket_P gameCricket = context.read<GameCricket_P>();
    final GameSettingsCricket_P gameSettingsCricket =
        context.read<GameSettingsCricket_P>();
    final int _halfLength = playerOrTeamGameStatistics.length ~/ 2;
    final bool _isNoScoreMode =
        gameSettingsCricket.getMode == CricketMode.NoScore;
    final bool _isSingleMode =
        gameSettingsCricket.getSingleOrTeam == SingleOrTeamEnum.Single;

    return Container(
      height: _getHeight(_isNoScoreMode, _isSingleMode),
      child: Row(
        children: [
          if (!evenPlayersOrTeams)
            Container(
              width: 20.w,
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(
                    width: GENERAL_BORDER_WIDTH.w,
                    color: Utils.getPrimaryColorDarken(context),
                  ),
                ),
              ),
            ),
          for (int i = 0; i < playerOrTeamGameStatistics.length; i++) ...[
            if (evenPlayersOrTeams && i == _halfLength)
              Container(
                width: 20.w,
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      width: GENERAL_BORDER_WIDTH.w,
                      color: Utils.getPrimaryColorDarken(context),
                    ),
                    right: BorderSide(
                      width: GENERAL_BORDER_WIDTH.w,
                      color: Utils.getPrimaryColorDarken(context),
                    ),
                  ),
                ),
              ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Utils.getBackgroundColorForCurrentPlayerOrTeam(
                      gameCricket,
                      gameSettingsCricket,
                      playerOrTeamGameStatistics[i],
                      context),
                  border: Border(
                    top: BorderSide(
                      width: GENERAL_BORDER_WIDTH.w,
                      color: Utils.getPrimaryColorDarken(context),
                    ),
                    left: Utils.showLeftBorderCricket(i, gameSettingsCricket)
                        ? BorderSide(
                            width: GENERAL_BORDER_WIDTH.w,
                            color: Utils.getPrimaryColorDarken(context),
                          )
                        : BorderSide.none,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (!_isNoScoreMode) ...[
                      Row(
                        children: [
                          Flexible(
                            flex: 5,
                            child: LegBeginnerDartAsset(
                              playerOrTeamStats: playerOrTeamGameStatistics[i],
                              game: gameCricket,
                              gameSettings: gameSettingsCricket,
                            ),
                          ),
                          Flexible(
                            flex: 6,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                playerOrTeamGameStatistics[i]
                                    .getCurrentPoints
                                    .toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      PlayerOrTeamName(
                        isNoScoreMode: _isNoScoreMode,
                        isSingleMode: _isSingleMode,
                        playerOrTeamStats: playerOrTeamGameStatistics[i],
                      ),
                      if (!_isSingleMode)
                        CurrentPlayerOfTeam(
                          isNoScoreMode: _isNoScoreMode,
                          playerOrTeamStats: playerOrTeamGameStatistics[i],
                          isSingleMode: _isSingleMode,
                        ),
                    ] else ...[
                      Column(
                        children: [
                          Center(
                            child: IntrinsicHeight(
                              child: Stack(
                                children: [
                                  Positioned(
                                    left: 0,
                                    child: LegBeginnerDartAsset(
                                      playerOrTeamStats:
                                          playerOrTeamGameStatistics[i],
                                      game: gameCricket,
                                      gameSettings: gameSettingsCricket,
                                    ),
                                  ),
                                  Align(
                                    child: PlayerOrTeamName(
                                      isNoScoreMode: _isNoScoreMode,
                                      isSingleMode: _isSingleMode,
                                      playerOrTeamStats:
                                          playerOrTeamGameStatistics[i],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          if (!_isSingleMode)
                            CurrentPlayerOfTeam(
                              isNoScoreMode: _isNoScoreMode,
                              playerOrTeamStats: playerOrTeamGameStatistics[i],
                              isSingleMode: _isSingleMode,
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

double _getHeight(bool isNoScoreMode, bool isSingleMode) {
  if (isNoScoreMode && isSingleMode) {
    return 5.h;
  } else if (isNoScoreMode && !isSingleMode) {
    return 7.h;
  } else if (isSingleMode) {
    return 8.h;
  }

  // team mode
  return 10.h;
}

class CurrentPlayerOfTeam extends StatelessWidget {
  const CurrentPlayerOfTeam({
    Key? key,
    required this.isNoScoreMode,
    required this.playerOrTeamStats,
    required this.isSingleMode,
  }) : super(key: key);

  final bool isNoScoreMode;
  final PlayerOrTeamGameStatsCricket playerOrTeamStats;
  final bool isSingleMode;

  @override
  Widget build(BuildContext context) {
    if (!isSingleMode && playerOrTeamStats.getTeam == null) {
      return SizedBox.shrink();
    }

    return Container(
      transform:
          isNoScoreMode ? null : Matrix4.translationValues(0.0, -0.5.h, 0.0),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          playerOrTeamStats.getTeam.getCurrentPlayerToThrow.getName,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class PlayerOrTeamName extends StatelessWidget {
  const PlayerOrTeamName({
    Key? key,
    required this.isNoScoreMode,
    required this.playerOrTeamStats,
    required this.isSingleMode,
  }) : super(key: key);

  final bool isNoScoreMode;
  final PlayerOrTeamGameStatsCricket playerOrTeamStats;
  final bool isSingleMode;

  @override
  Widget build(BuildContext context) {
    if (!isSingleMode && playerOrTeamStats.getTeam == null) {
      return SizedBox.shrink();
    }

    return Container(
      transform:
          isNoScoreMode ? null : Matrix4.translationValues(0.0, -0.5.h, 0.0),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          isSingleMode
              ? playerOrTeamStats.getPlayer.getName
              : playerOrTeamStats.getTeam.getName,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
