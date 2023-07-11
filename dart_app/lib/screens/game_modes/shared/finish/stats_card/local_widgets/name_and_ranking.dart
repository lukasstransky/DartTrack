import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_cricket_p.dart';
import 'package:dart_app/models/game_settings/game_settings_p.dart';
import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/models/games/game_cricket_p.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
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

  @override
  Widget build(BuildContext context) {
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
                      '${(game is GameX01_P || game is GameCricket_P) ? checkForSameAmountOfSetsLegs(i, Utils.getPlayersOrTeamStatsList(game, game.getGameSettings.getSingleOrTeam == SingleOrTeamEnum.Team)) : i + 1}.',
                      style: TextStyle(
                        fontSize: i == 0 && !isOpenGame ? 14.sp : 12.sp,
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
                  size: 14.sp,
                  color: Color(0xffFFD700),
                ),
              )
            else
              Container(
                padding: EdgeInsets.only(left: 3.w),
                child: Icon(
                  Entypo.trophy,
                  size: 14.sp,
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
                      fontSize: i == 0 || isOpenGame ? 14.sp : 12.sp,
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
    return stats.getTeam.getName;
  }

  return stats.getPlayer.getName;
}
