import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/game_single_double_training_p.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/models/player_statistics/player_game_stats_single_double_training.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class PlayerEntryGameSingleDoubleTraining extends StatelessWidget {
  const PlayerEntryGameSingleDoubleTraining({
    Key? key,
    required this.playerStats,
  }) : super(key: key);

  final PlayerGameStatsSingleDoubleTraining playerStats;

  Color _getBackgroundColor(BuildContext context) {
    if (Player.samePlayer(
        context.read<GameSingleDoubleTraining_P>().getCurrentPlayerToThrow,
        this.playerStats.getPlayer)) {
      return Utils.lighten(Theme.of(context).colorScheme.primary, 20);
    }

    return Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    final game = context.read<GameSingleDoubleTraining_P>();
    final bool isSingleMode = game.getMode == GameMode.SingleTraining;
    final bool isTwoPlayers =
        game.getPlayerGameStatistics.length == 2 ? true : false;

    final int FONTSIZE = isTwoPlayers ? 12 : 18;
    final int FONTSIZE_PERCENTAGE = isTwoPlayers ? 8 : 12;
    final int HEADER_WIDTH = isTwoPlayers ? 28 : 45;
    final int VALUE_WIDTH = isTwoPlayers ? 6 : 9;
    const int ROW_WIDTH = 80;
    final _padding = EdgeInsets.only(
      top: 2.h,
      left: 2.5.w,
      right: 2.5.w,
    );

    return Container(
      color: game.getPlayerGameStatistics.length > 1
          ? _getBackgroundColor(context)
          : Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            transform: Matrix4.translationValues(0.0, -15.0, 0.0),
            child: Text(
              playerStats.getPlayer.getName,
              style: TextStyle(
                color: Utils.getTextColorDarken(context),
                fontWeight: FontWeight.bold,
                fontSize: 20.sp,
              ),
            ),
          ),
          Container(
            padding: _padding,
            width: ROW_WIDTH.w,
            child: Row(
              children: [
                HeaderText(
                  width: HEADER_WIDTH,
                  fontSize: FONTSIZE,
                  textValue: 'Total points',
                ),
                ValueText(
                  width: VALUE_WIDTH,
                  fontSize: FONTSIZE,
                  textValue: playerStats.getTotalPoints.toString(),
                ),
              ],
            ),
          ),
          if (isSingleMode)
            Container(
              padding: _padding,
              width: ROW_WIDTH.w,
              child: Row(
                children: [
                  HeaderText(
                    width: HEADER_WIDTH,
                    fontSize: FONTSIZE,
                    textValue: 'Single hits',
                  ),
                  ValueText(
                    width: VALUE_WIDTH,
                    fontSize: FONTSIZE,
                    textValue: playerStats.getSingleHits.toString(),
                  ),
                  Text(
                    '(${playerStats.getSingleHitsPercentage()}%)',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: FONTSIZE_PERCENTAGE.sp,
                    ),
                  ),
                ],
              ),
            ),
          Container(
            padding: _padding,
            width: ROW_WIDTH.w,
            child: Row(
              children: [
                HeaderText(
                  width: HEADER_WIDTH,
                  fontSize: FONTSIZE,
                  textValue: 'Double hits',
                ),
                ValueText(
                  width: VALUE_WIDTH,
                  fontSize: FONTSIZE,
                  textValue: playerStats.getDoubleHits.toString(),
                ),
                Text(
                  '(${playerStats.getDoubleHitsPercentage()}%)',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: FONTSIZE_PERCENTAGE.sp,
                  ),
                ),
              ],
            ),
          ),
          if (isSingleMode)
            Container(
              padding: _padding,
              width: ROW_WIDTH.w,
              child: Row(
                children: [
                  HeaderText(
                    width: HEADER_WIDTH,
                    fontSize: FONTSIZE,
                    textValue: 'Tripple hits',
                  ),
                  ValueText(
                    width: VALUE_WIDTH,
                    fontSize: FONTSIZE,
                    textValue: playerStats.getTrippleHits.toString(),
                  ),
                  Text(
                    '(${playerStats.getTrippleHitsPercentage()}%)',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: FONTSIZE_PERCENTAGE.sp,
                    ),
                  ),
                ],
              ),
            ),
          Container(
            padding: _padding,
            width: ROW_WIDTH.w,
            child: Row(
              children: [
                HeaderText(
                  width: HEADER_WIDTH,
                  fontSize: FONTSIZE,
                  textValue: 'Missed',
                ),
                ValueText(
                  width: VALUE_WIDTH,
                  fontSize: FONTSIZE,
                  textValue: playerStats.getMissedHits.toString(),
                ),
                Text(
                  '(${playerStats.getMissedHitsPercentage()}%)',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: FONTSIZE_PERCENTAGE.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ValueText extends StatelessWidget {
  const ValueText({
    Key? key,
    required this.width,
    required this.fontSize,
    required this.textValue,
  }) : super(key: key);

  final int width;
  final int fontSize;
  final String textValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width.w,
      child: Text(
        textValue,
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize.sp,
        ),
      ),
    );
  }
}

class HeaderText extends StatelessWidget {
  const HeaderText({
    Key? key,
    required this.width,
    required this.fontSize,
    required this.textValue,
  }) : super(key: key);

  final int width;
  final int fontSize;
  final String textValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width.w,
      child: Text(
        textValue,
        style: TextStyle(
          color: Utils.getTextColorDarken(context),
          fontWeight: FontWeight.bold,
          fontSize: fontSize.sp,
        ),
      ),
    );
  }
}
