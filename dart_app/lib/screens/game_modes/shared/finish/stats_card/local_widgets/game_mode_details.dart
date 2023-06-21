import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_cricket_p.dart';
import 'package:dart_app/models/game_settings/game_settings_single_double_training_p.dart';
import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/models/games/game_cricket_p.dart';
import 'package:dart_app/models/games/game_single_double_training_p.dart';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class GameModeDetails extends StatelessWidget {
  const GameModeDetails({
    Key? key,
    required this.game,
    required this.isOpenGame,
    required this.isDraw,
  }) : super(key: key);

  final Game_P game;
  final bool isOpenGame;
  final bool isDraw;

  @override
  Widget build(BuildContext context) {
    final bool isTargetNumberEnabled = game is GameSingleDoubleTraining_P &&
        (game.getGameSettings as GameSettingsSingleDoubleTraining_P)
            .getIsTargetNumberEnabled;
    final bool setsEnabled =
        game is GameCricket_P && game.getGameSettings.getSetsEnabled;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(
            top: 1.h,
            left: 2.w,
            right: 2.w,
          ),
          child: Row(
            children: [
              Text(
                _getMode(),
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              Text(
                game.getFormattedDateTime(),
                style: TextStyle(
                  fontSize: 10.sp,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        if (setsEnabled)
          Container(
            padding: EdgeInsets.only(
              left: 2.w,
            ),
            child: Text(
              _getBestOfOrFirstToStringWithSetsAndLegs(),
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        Container(
          padding: EdgeInsets.only(
            left: 2.w,
            bottom: isTargetNumberEnabled ? 0 : 1.h,
          ),
          child: Text(
            game.getGameSettings.getModeStringFinishScreen(isOpenGame, game),
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.white,
            ),
          ),
        ),
        if (isTargetNumberEnabled)
          Container(
            padding: EdgeInsets.only(
              left: 2.w,
              bottom: 1.h,
            ),
            child: Text(
              game.getIsOpenGame && !game.getIsGameFinished
                  ? 'Remaining rounds: ${(game as GameSingleDoubleTraining_P).getAmountOfRoundsRemaining}'
                  : 'Rounds: ${game.getGameSettings.getAmountOfRounds}',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.white,
              ),
            ),
          ),
      ],
    );
  }

  String _getMode() {
    String result = '';

    if (!isOpenGame && isDraw) {
      result = 'Draw - ';
    }

    result += game.getName;

    if (game is GameCricket_P && !game.getGameSettings.getSetsEnabled) {
      final GameSettingsCricket_P settings = game.getGameSettings;
      if (settings.getBestOfOrFirstTo == BestOfOrFirstToEnum.BestOf) {
        result += ' - Best of ';
      } else {
        result += ' - First to ';
      }

      if (settings.getLegs > 1) {
        result += '${settings.getLegs.toString()} legs';
      } else {
        result += '${settings.getLegs.toString()} leg';
      }
    }

    return result;
  }

  String _getBestOfOrFirstToStringWithSetsAndLegs() {
    final GameSettingsCricket_P settings =
        game.getGameSettings as GameSettingsCricket_P;

    String result = '';

    if (settings.getBestOfOrFirstTo == BestOfOrFirstToEnum.BestOf) {
      result += 'Best of ';
    } else {
      result += 'First to ';
    }

    if (settings.getSets > 1) {
      result += '${settings.getSets.toString()} sets - ';
    } else {
      result += '${settings.getSets.toString()} set - ';
    }

    if (settings.getLegs > 1) {
      result += '${settings.getLegs.toString()} legs';
    } else {
      result += '${settings.getLegs.toString()} leg';
    }

    return result;
  }
}
