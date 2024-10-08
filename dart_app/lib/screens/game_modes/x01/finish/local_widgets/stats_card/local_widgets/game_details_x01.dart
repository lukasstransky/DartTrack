import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class GameDetailsX01 extends StatelessWidget {
  const GameDetailsX01({Key? key, required this.gameX01}) : super(key: key);

  final GameX01_P gameX01;

  @override
  Widget build(BuildContext context) {
    final GameSettingsX01_P gameSettingsX01 = gameX01.getGameSettings;
    final List<PlayerOrTeamGameStats> statsList =
        Utils.getPlayersOrTeamStatsList(gameX01,
            gameX01.getGameSettings.getSingleOrTeam == SingleOrTeamEnum.Team);
    final bool isDraw = gameX01.isGameDraw(statsList);
    final double _fontSizeDateTime = Utils.getResponsiveValue(
      context: context,
      mobileValue: 10,
      tabletValue: 8,
    );
    final double _fontSizeMode = Utils.getResponsiveValue(
      context: context,
      mobileValue: 14,
      tabletValue: 12,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: 1.h,
            left: 2.w,
            right: 2.w,
          ),
          child: Row(
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'X01 ${isDraw ? '- Draw' : ''}${(gameSettingsX01.getSetsEnabled || isDraw) ? '' : '- ' + Utils.getBestOfOrFirstToString(gameSettingsX01)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: _fontSizeMode.sp,
                    color: Colors.white,
                  ),
                ),
              ),
              Spacer(),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  gameX01.getFormattedDateTime(),
                  style: TextStyle(
                    fontSize: _fontSizeDateTime.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (gameSettingsX01.getSetsEnabled || isDraw)
          Padding(
            padding: EdgeInsets.only(left: 2.w),
            child: Text(
              '${Utils.getBestOfOrFirstToString(gameSettingsX01)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
                color: Colors.white,
              ),
            ),
          ),
        Padding(
          padding: EdgeInsets.only(left: 2.w),
          child: Text(
            '${gameSettingsX01.getGameModeDetails(true)}',
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
              color: Colors.white,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
              left: 2.w,
              bottom: gameSettingsX01.getWinByTwoLegsDifference &&
                      gameSettingsX01.getSuddenDeath
                  ? 1.h
                  : 0),
          child: Text(
            gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Single
                ? 'Single mode'
                : 'Team mode',
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
              color: Colors.white,
            ),
          ),
        ),
        if (gameSettingsX01.getDrawMode && !isDraw)
          Padding(
            padding: EdgeInsets.only(left: 2.w),
            child: Text(
              'Draw enabled',
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                color: Colors.white,
              ),
            ),
          ),
        if (gameSettingsX01.getWinByTwoLegsDifference) ...[
          Padding(
            padding: EdgeInsets.only(
                left: 2.w, bottom: !gameSettingsX01.getSuddenDeath ? 1.h : 0),
            child: Text(
              'Win by two legs difference',
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                color: Colors.white,
              ),
            ),
          ),
          if (gameSettingsX01.getSuddenDeath)
            Padding(
              padding: EdgeInsets.only(
                left: 2.w,
                bottom: 1.h,
              ),
              child: Row(
                children: [
                  Text(
                    'Sudden death (after max. ${gameSettingsX01.getMaxExtraLegs} leg${gameSettingsX01.getMaxExtraLegs == 1 ? '' : 's'})',
                    style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.bodyMedium!.fontSize,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ],
    );
  }
}
