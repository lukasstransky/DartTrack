import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_cricket_p.dart';
import 'package:dart_app/models/games/game_cricket_p.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats_cricket.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
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
      height: _getHeight(_isNoScoreMode, _isSingleMode, context),
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
                      Text(
                        playerOrTeamGameStatistics[i]
                            .getCurrentPoints
                            .toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize:
                              Theme.of(context).textTheme.titleSmall!.fontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ] else ...[
                      Column(
                        children: [
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

double _getHeight(bool isNoScoreMode, bool isSingleMode, BuildContext context) {
  if (isNoScoreMode && isSingleMode) {
    if (ResponsiveBreakpoints.of(context).isMobile) {
      return 5.h;
    } else if (ResponsiveBreakpoints.of(context).isTablet ||
        ResponsiveBreakpoints.of(context).isDesktop) {
      return 7.h;
    } else {
      return 7.h;
    }
  } else if (isNoScoreMode && !isSingleMode) {
    if (ResponsiveBreakpoints.of(context).isMobile) {
      return 7.h;
    } else if (ResponsiveBreakpoints.of(context).isTablet ||
        ResponsiveBreakpoints.of(context).isDesktop) {
      return 9.h;
    } else {
      return 9.h;
    }
  } else if (isSingleMode) {
    if (ResponsiveBreakpoints.of(context).isMobile) {
      return 8.h;
    } else if (ResponsiveBreakpoints.of(context).isTablet ||
        ResponsiveBreakpoints.of(context).isDesktop) {
      return 10.h;
    } else {
      return 10.h;
    }
  }

  // team mode
  if (ResponsiveBreakpoints.of(context).isMobile) {
    return 10.h;
  } else if (ResponsiveBreakpoints.of(context).isTablet ||
      ResponsiveBreakpoints.of(context).isDesktop) {
    return 13.h;
  } else {
    return 14.h;
  }
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
            color: Utils.getTextColorDarken(context),
            fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
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
      padding: EdgeInsets.only(left: 0.5.h, right: 0.5.h),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          isSingleMode
              ? playerOrTeamStats.getPlayer.getName
              : playerOrTeamStats.getTeam.getName,
          style: TextStyle(
            color: Utils.getTextColorDarken(context),
            fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
