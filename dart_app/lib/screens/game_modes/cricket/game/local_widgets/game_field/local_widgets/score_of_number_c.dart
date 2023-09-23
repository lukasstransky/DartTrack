import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_cricket_p.dart';
import 'package:dart_app/models/games/game_cricket_p.dart';
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
    required this.i,
  }) : super(key: key);

  final PlayerOrTeamGameStatsCricket playerOrTeamStats;
  final int numberToCheck;
  final int i;

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
            left: Utils.showLeftBorder(settings, i)
                ? BorderSide(
                    width: GENERAL_BORDER_WIDTH.w,
                    color: Utils.getPrimaryColorDarken(context),
                  )
                : BorderSide.none,
            right: Utils.showRightBorder(settings, i)
                ? BorderSide(
                    width: GENERAL_BORDER_WIDTH.w,
                    color: Utils.getPrimaryColorDarken(context),
                  )
                : BorderSide.none,
            bottom: numberToCheck == 25
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

  _getCorrectAsset(int? amountOfScores, bool isNumberClosed) {
    if (amountOfScores != null && amountOfScores != 0) {
      if (amountOfScores == 1) {
        return Icon(
          size: ICON_BUTTON_SIZE.h,
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
