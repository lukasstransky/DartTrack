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
    final _padding = EdgeInsets.only(
      top: 2.h,
      left: 2.5.w,
      right: 2.5.w,
    );
    final double FONTSIZE = isTwoPlayers
        ? Theme.of(context).textTheme.bodyMedium!.fontSize!
        : Theme.of(context).textTheme.titleSmall!.fontSize!;

    return Container(
      color: game.getPlayerGameStatistics.length > 1
          ? _getBackgroundColor(context)
          : Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            transform: Matrix4.translationValues(0.0, -2.h, 0.0),
            padding: EdgeInsets.only(left: 1.w, right: 1.w),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                playerStats.getPlayer.getName,
                style: TextStyle(
                  color: Utils.getTextColorDarken(context),
                  fontWeight: FontWeight.bold,
                  fontSize: Theme.of(context).textTheme.titleLarge!.fontSize,
                ),
              ),
            ),
          ),
          Container(
            padding: _padding,
            width: 60.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                HeaderText(
                  fontSize: FONTSIZE,
                  textValue: 'Total points:',
                ),
                ValueText(
                  fontSize: FONTSIZE,
                  textValue: playerStats.getTotalPoints.toString(),
                ),
              ],
            ),
          ),
          if (isSingleMode)
            Container(
              width: 60.w,
              padding: _padding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  HeaderText(
                    fontSize: FONTSIZE,
                    textValue: 'Single hits:',
                  ),
                  ValueText(
                    fontSize: FONTSIZE,
                    textValue: playerStats.getSingleHits.toString(),
                  ),
                ],
              ),
            ),
          Container(
            width: 60.w,
            padding: _padding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                HeaderText(
                  fontSize: FONTSIZE,
                  textValue: 'Double hits:',
                ),
                ValueText(
                  fontSize: FONTSIZE,
                  textValue: playerStats.getDoubleHits.toString(),
                ),
              ],
            ),
          ),
          if (isSingleMode)
            Container(
              width: 60.w,
              padding: _padding,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  HeaderText(
                    fontSize: FONTSIZE,
                    textValue: 'Tripple hits:',
                  ),
                  ValueText(
                    fontSize: FONTSIZE,
                    textValue: playerStats.getTrippleHits.toString(),
                  ),
                ],
              ),
            ),
          Container(
            width: 60.w,
            padding: _padding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                HeaderText(
                  fontSize: FONTSIZE,
                  textValue: 'Missed:',
                ),
                ValueText(
                  fontSize: FONTSIZE,
                  textValue: playerStats.getMissedHits.toString(),
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
    required this.fontSize,
    required this.textValue,
  }) : super(key: key);

  final double fontSize;
  final String textValue;

  @override
  Widget build(BuildContext context) {
    return Text(
      textValue,
      style: TextStyle(
        color: Colors.white,
        fontSize: fontSize,
      ),
    );
  }
}

class HeaderText extends StatelessWidget {
  const HeaderText({
    Key? key,
    required this.fontSize,
    required this.textValue,
  }) : super(key: key);

  final double fontSize;
  final String textValue;

  @override
  Widget build(BuildContext context) {
    return Text(
      textValue,
      style: TextStyle(
        color: Utils.getTextColorDarken(context),
        fontWeight: FontWeight.bold,
        fontSize: fontSize,
      ),
    );
  }
}
