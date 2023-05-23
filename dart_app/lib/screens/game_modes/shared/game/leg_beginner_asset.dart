import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class LegBeginnerDartAsset extends StatelessWidget {
  const LegBeginnerDartAsset({
    Key? key,
    required this.playerOrTeamStats,
    required this.game,
    required this.gameSettings,
  }) : super(key: key);

  final PlayerOrTeamGameStats? playerOrTeamStats;
  final dynamic game;
  final dynamic gameSettings;

  bool _showLegBeginnerDartAsset(BuildContext context) {
    if (gameSettings.getSingleOrTeam == SingleOrTeamEnum.Single) {
      return game.getPlayerOrTeamLegStartIndex ==
          game.getPlayerGameStatistics.indexOf(playerOrTeamStats);
    }
    return game.getPlayerOrTeamLegStartIndex ==
        game.getTeamGameStatistics.indexOf(playerOrTeamStats);
  }

  @override
  Widget build(BuildContext context) {
    final bool isGameX01 = game is GameX01_P;

    return Container(
      height: isGameX01 ? 6.h : 5.h,
      alignment: Alignment.topLeft,
      transform: Matrix4.translationValues(0.0, isGameX01 ? 0 : -1.5.h, 0.0),
      padding: EdgeInsets.only(left: isGameX01 ? 2.w : 0),
      child: _showLegBeginnerDartAsset(context)
          ? Image.asset(
              'assets/dart_arrow.png',
              color: Utils.getTextColorDarken(context),
            )
          : SizedBox.shrink(),
    );
  }
}
