import 'package:dart_app/constants.dart';
import 'package:dart_app/models/bot.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/player_stats_in_game/local_widgets/finish_ways_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/player_stats_in_game/local_widgets/game_stats_x01.dart';
import 'package:dart_app/screens/game_modes/shared/game/leg_beginner_asset.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/player_stats_in_game/local_widgets/sets_legs_score_x01.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:provider/provider.dart';

class PlayerOrTeamStatsInGameX01 extends StatelessWidget {
  const PlayerOrTeamStatsInGameX01(
      {Key? key, required this.currPlayerOrTeamGameStatsX01})
      : super(key: key);

  final PlayerOrTeamGameStatsX01? currPlayerOrTeamGameStatsX01;

  @override
  Widget build(BuildContext context) {
    final GameX01_P gameX01 = context.read<GameX01_P>();
    final GameSettingsX01_P gameSettingsX01 = context.read<GameSettingsX01_P>();
    final bool isSingleMode =
        gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Single;
    final bool isNotLastPlayerOrTeam =
        _isNotLastPlayerOrTeam(gameX01, gameSettingsX01);

    final double screenWidth = MediaQuery.of(context).size.width;
    final EdgeInsets safeAreaPadding = gameX01.getSafeAreaPadding;
    // if it's landscape, extract safe area padding
    final double width = (Utils.isLandscape(context)
            ? (screenWidth - safeAreaPadding.left - safeAreaPadding.right) / 2
            : screenWidth) /
        2;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Utils.getPrimaryColorDarken(context),
            width: GENERAL_BORDER_WIDTH.w,
          ),
          right: isNotLastPlayerOrTeam
              ? BorderSide(
                  color: Utils.getPrimaryColorDarken(context),
                  width: GENERAL_BORDER_WIDTH.w,
                )
              : BorderSide.none,
          bottom: Utils.isLandscape(context) && safeAreaPadding.bottom > 0
              ? BorderSide(
                  color: Utils.getPrimaryColorDarken(context),
                  width: GENERAL_BORDER_WIDTH.w,
                )
              : BorderSide.none,
          left: Utils.isLandscape(context) &&
                  isNotLastPlayerOrTeam &&
                  safeAreaPadding.left > 0
              ? BorderSide(
                  color: Utils.getPrimaryColorDarken(context),
                  width: GENERAL_BORDER_WIDTH.w,
                )
              : BorderSide.none,
        ),
      ),
      width: width,
      child: Container(
        color: Utils.getBackgroundColorForCurrentPlayerOrTeam(
            gameX01, gameSettingsX01, currPlayerOrTeamGameStatsX01!, context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LegBeginnerDartAsset(
              playerOrTeamStats: this.currPlayerOrTeamGameStatsX01,
              game: gameX01,
              gameSettings: gameSettingsX01,
            ),
            Container(
              transform: Matrix4.translationValues(
                  0.0, isSingleMode ? -15 : -25.0, 0.0),
              child: Column(
                children: [
                  if (isSingleMode) single(context) else team(context),
                  SetsLegsScoreX01(
                      currPlayerOrTeamGameStatsX01:
                          this.currPlayerOrTeamGameStatsX01),
                  GameStatsX01(currentStats: this.currPlayerOrTeamGameStatsX01),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isNotLastPlayerOrTeam(
      GameX01_P gameX01, GameSettingsX01_P gameSettingsX01_P) {
    if (gameSettingsX01_P.getSingleOrTeam == SingleOrTeamEnum.Team) {
      return gameX01.getTeamGameStatistics
              .indexOf(currPlayerOrTeamGameStatsX01) !=
          gameX01.getTeamGameStatistics.length - 1;
    }
    return gameX01.getPlayerGameStatistics
            .indexOf(currPlayerOrTeamGameStatsX01) !=
        gameX01.getPlayerGameStatistics.length - 1;
  }

  Column team(BuildContext context) {
    final double fontSizePoints = Utils.getResponsiveValue(
      context: context,
      mobileValue: 50,
      tabletValue: 40,
    );
    final double fontSizeTeamName = Utils.getResponsiveValue(
      context: context,
      mobileValue: 18,
      tabletValue: 16,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          transform: Matrix4.translationValues(0.0, 0.5.h, 0.0),
          padding: EdgeInsets.only(left: 1.w, right: 1.w),
          child: Column(
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  currPlayerOrTeamGameStatsX01!.getTeam.getName,
                  style: TextStyle(
                    fontSize: fontSizeTeamName.sp,
                    color: Utils.getTextColorDarken(context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  currPlayerOrTeamGameStatsX01!.getTeam.getCurrentPlayerToThrow
                          is Bot
                      ? 'Lvl. ${currPlayerOrTeamGameStatsX01!.getTeam.getCurrentPlayerToThrow.getLevel} Bot'
                      : currPlayerOrTeamGameStatsX01!
                          .getTeam.getCurrentPlayerToThrow.getName,
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
                    color: Utils.getTextColorDarken(context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        Center(
          child: Text(
            currPlayerOrTeamGameStatsX01!.getCurrentPoints.toString(),
            style: TextStyle(
              fontSize: fontSizePoints.sp,
              color: Colors.white,
            ),
          ),
        ),
        Center(
          child: Container(
            transform: Matrix4.translationValues(0.0, -1.5.h, 0.0),
            child: Selector<GameSettingsX01_P, bool>(
              selector: (_, gameSettings) => gameSettings.getShowFinishWays,
              builder: (_, __, ___) => FinishWaysX01(
                  currPlayerOrTeamGameStatsX01:
                      this.currPlayerOrTeamGameStatsX01),
            ),
          ),
        ),
      ],
    );
  }

  Column single(BuildContext context) {
    final double fontSizePoints = Utils.getResponsiveValue(
      context: context,
      mobileValue: 50,
      tabletValue: 40,
    );

    return Column(
      children: [
        Selector<GameSettingsX01_P, bool>(
          selector: (_, gameSettings) => gameSettings.getShowFinishWays,
          builder: (_, __, ___) => Center(
            child: FinishWaysX01(
                currPlayerOrTeamGameStatsX01:
                    this.currPlayerOrTeamGameStatsX01),
          ),
        ),
        Center(
          child: Container(
            padding: EdgeInsets.only(top: 0.5.h),
            child: Text(
              currPlayerOrTeamGameStatsX01!.getCurrentPoints.toString(),
              style: TextStyle(
                fontSize: fontSizePoints.sp,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Center(
          child: Container(
            transform: Matrix4.translationValues(0.0, -0.5.h, 0.0),
            padding: EdgeInsets.only(left: 1.w, right: 1.w),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                currPlayerOrTeamGameStatsX01!.getPlayer is Bot
                    ? 'Bot - lvl. ${currPlayerOrTeamGameStatsX01!.getPlayer.getLevel} '
                    : currPlayerOrTeamGameStatsX01!.getPlayer.getName,
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
                  color: Utils.getTextColorDarken(context),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
