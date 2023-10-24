import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_cricket_p.dart';
import 'package:dart_app/models/game_settings/game_settings_p.dart';
import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/models/games/game_cricket_p.dart';
import 'package:dart_app/models/games/game_score_training_p.dart';
import 'package:dart_app/models/games/game_single_double_training_p.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/models/player_statistics/player_game_stats_score_training.dart';
import 'package:dart_app/models/player_statistics/player_game_stats_single_double_training.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats_cricket.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:sizer/sizer.dart';

class NameAndRanking extends StatelessWidget {
  const NameAndRanking({
    Key? key,
    required this.i,
    required this.game,
    required this.stats,
    required this.isOpenGame,
    this.isDraw = false,
  }) : super(key: key);

  final int i;
  final Game_P game;
  final PlayerOrTeamGameStats stats;
  final bool isOpenGame;
  final bool isDraw;

  int _getPosition() {
    if (game is GameX01_P || game is GameCricket_P) {
      final dynamic playersOrTeamsStatsList = Utils.getPlayersOrTeamStatsList(
          game, game.getGameSettings.getSingleOrTeam == SingleOrTeamEnum.Team);

      return checkForSameAmountOfSetsLegs(i, playersOrTeamsStatsList);
    } else if (game is GameScoreTraining_P) {
      // for winner
      if (i == 0) {
        return 1;
      }
      if (i == 1) {
        return 2;
      }

      final dynamic playersOrTeamsStatsList = game.getPlayerGameStatistics;

      if (playersOrTeamsStatsList.length != 0) {
        for (int j = 1; j < i; j++) {
          if ((playersOrTeamsStatsList[j] as PlayerGameStatsScoreTraining)
                  .getCurrentScore ==
              ((playersOrTeamsStatsList[i] as PlayerGameStatsScoreTraining)
                  .getCurrentScore)) {
            return j + 1;
          }
        }
      }
    } else if (game is GameSingleDoubleTraining_P) {
      // for winner
      if (i == 0) {
        return 1;
      }
      if (i == 1) {
        return 2;
      }

      final dynamic playersOrTeamsStatsList = game.getPlayerGameStatistics;

      if (playersOrTeamsStatsList.length != 0) {
        for (int j = 1; j < i; j++) {
          if ((playersOrTeamsStatsList[j]
                      as PlayerGameStatsSingleDoubleTraining)
                  .getTotalPoints ==
              ((playersOrTeamsStatsList[i]
                      as PlayerGameStatsSingleDoubleTraining)
                  .getTotalPoints)) {
            return j + 1;
          }
        }
      }
    }

    return i + 1;
  }

  @override
  Widget build(BuildContext context) {
    final double _trophySize = Utils.getResponsiveValue(
      context: context,
      mobileValue: 14,
      tabletValue: 12,
    );
    final double _fontSizeNameFirst = Utils.getResponsiveValue(
      context: context,
      mobileValue: 14,
      tabletValue: 12,
    );

    return Expanded(
      child: Container(
        padding: EdgeInsets.only(left: 5.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            !isDraw && !isOpenGame
                ? Container(
                    width: 5.w,
                    child: Text(
                      '${_getPosition()}.',
                      style: TextStyle(
                        fontSize: i == 0 && !isOpenGame
                            ? _fontSizeNameFirst.sp
                            : Theme.of(context).textTheme.bodyMedium!.fontSize,
                        fontWeight: FontWeight.bold,
                        color: Utils.getTextColorDarken(context),
                      ),
                    ),
                  )
                : SizedBox.shrink(),
            if (i == 0 && !isOpenGame && !isDraw)
              Container(
                padding: EdgeInsets.only(left: 3.w),
                child: Icon(
                  Entypo.trophy,
                  size: _trophySize.sp,
                  color: Color(0xffFFD700),
                ),
              )
            else
              Container(
                padding: EdgeInsets.only(left: 3.w),
                child: Icon(
                  Entypo.trophy,
                  size: _trophySize.sp,
                  color:
                      Utils.darken(Theme.of(context).colorScheme.primary, 15),
                ),
              ),
            Flexible(
              child: Container(
                padding: EdgeInsets.only(left: 3.w),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    _getPlayerOrTeamName(game.getGameSettings, stats),
                    style: TextStyle(
                      fontSize: i == 0 || isOpenGame
                          ? _fontSizeNameFirst.sp
                          : Theme.of(context).textTheme.bodyMedium!.fontSize,
                      color: Utils.getTextColorDarken(context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  checkForSameAmountOfSetsLegs(int indexOfPlayerOrTeam, dynamic statsList) {
    if (indexOfPlayerOrTeam == 0) {
      return 1;
    } else if (indexOfPlayerOrTeam == 1) {
      return 2;
    }

    for (int i = 1; i < indexOfPlayerOrTeam; i++) {
      if (game.getGameSettings.getSetsEnabled) {
        if ((statsList[i] as PlayerOrTeamGameStatsCricket).getSetsWon ==
            (statsList[indexOfPlayerOrTeam] as PlayerOrTeamGameStatsCricket)
                .getSetsWon) {
          return i + 1;
        }
      } else {
        if ((statsList[i] as PlayerOrTeamGameStatsCricket).getLegsWonTotal ==
            (statsList[indexOfPlayerOrTeam] as PlayerOrTeamGameStatsCricket)
                .getLegsWonTotal) {
          return i + 1;
        }
      }
    }

    return indexOfPlayerOrTeam + 1;
  }
}

String _getPlayerOrTeamName(
    GameSettings_P gameSettings, PlayerOrTeamGameStats stats) {
  if (gameSettings is GameSettingsCricket_P &&
      gameSettings.getSingleOrTeam == SingleOrTeamEnum.Team) {
    if (stats.getTeam == null) {
      return '';
    }
    return stats.getTeam.getName;
  }

  return stats.getPlayer.getName;
}
