import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_cricket_p.dart';
import 'package:dart_app/models/games/game_cricket_p.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats_cricket.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class ScoreOfNumber extends StatelessWidget {
  const ScoreOfNumber({
    Key? key,
    required this.playerOrTeamStats,
    required this.numberToCheck,
  }) : super(key: key);

  final PlayerOrTeamGameStatsCricket playerOrTeamStats;
  final int numberToCheck;

  @override
  Widget build(BuildContext context) {
    final GameSettingsCricket_P settings =
        context.read<GameSettingsCricket_P>();
    final int? amountOfScores =
        playerOrTeamStats.getScoresOfNumbers[numberToCheck];
    final bool isNumberClosed =
        context.read<GameCricket_P>().isNumberClosed(numberToCheck, settings);

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: _isNumberOpenForPlayerOrTeam(amountOfScores, isNumberClosed)
              ? Utils.darken(Theme.of(context).colorScheme.primary, 20)
              : Colors.transparent,
          border: Border(
            top: BorderSide(
              width: GENERAL_BORDER_WIDTH.w,
              color: Utils.getPrimaryColorDarken(context),
            ),
            left: _showLeftBorder(settings, playerOrTeamStats)
                ? BorderSide(
                    width: GENERAL_BORDER_WIDTH.w,
                    color: Utils.getPrimaryColorDarken(context),
                  )
                : BorderSide.none,
          ),
        ),
        child: Center(
          child: _getCorrectAsset(amountOfScores, isNumberClosed),
        ),
      ),
    );
  }

  bool _showLeftBorder(GameSettingsCricket_P gameSettingsCricket,
      PlayerOrTeamGameStatsCricket playerOrTeamStats) {
    final bool isSingleMode =
        gameSettingsCricket.getSingleOrTeam == SingleOrTeamEnum.Single;

    if ((isSingleMode && gameSettingsCricket.getPlayers.length == 2) ||
        (!isSingleMode && gameSettingsCricket.getTeams.length == 2)) {
      return false;
    } else if (isSingleMode &&
        Player.samePlayer(gameSettingsCricket.getPlayers.first,
            playerOrTeamStats.getPlayer)) {
      return false;
    } else if (!isSingleMode &&
        gameSettingsCricket.getTeams.first == playerOrTeamStats.getTeam) {
      return false;
    } else if ((isSingleMode && gameSettingsCricket.getPlayers.length == 4) ||
        (!isSingleMode && gameSettingsCricket.getTeams.length == 4)) {
      int index = -1;
      if (isSingleMode) {
        for (int i = 0; i < gameSettingsCricket.getPlayers.length; i++) {
          if (gameSettingsCricket.getPlayers[i].getName ==
              playerOrTeamStats.getPlayer.getName) {
            index = i;
            break;
          }
        }
      } else if (!isSingleMode) {
        for (int i = 0; i < gameSettingsCricket.getTeams.length; i++) {
          if (gameSettingsCricket.getTeams[i].getName ==
              playerOrTeamStats.getTeam.getName) {
            index = i;
            break;
          }
        }
      }
      if (index % 2 == 0) {
        return false;
      }
    }

    return true;
  }

  _getCorrectAsset(int? amountOfScores, bool isNumberClosed) {
    if (amountOfScores != null && amountOfScores != 0) {
      if (amountOfScores == 1) {
        return Icon(
          LineAwesomeIcons.slash,
          color: Colors.white,
        );
      } else if (amountOfScores == 2) {
        return SvgPicture.asset(
          'assets/cross.svg',
          height: 3.h,
          colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
        );
      } else if (amountOfScores >= 3) {
        return SvgPicture.asset(
          'assets/cross-circle.svg',
          height: 3.h,
          colorFilter: ColorFilter.mode(
              isNumberClosed ? Colors.white54 : Colors.white, BlendMode.srcIn),
        );
      }
    }

    return SizedBox.shrink();
  }

  bool _isNumberOpenForPlayerOrTeam(int? amountOfScores, bool isNumberClosed) {
    if ((amountOfScores != null && amountOfScores < 3) || isNumberClosed) {
      return false;
    }

    return true;
  }
}
