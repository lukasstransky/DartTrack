import 'package:dart_app/models/game_settings/game_settings_single_double_training_p.dart';
import 'package:dart_app/models/games/game.dart';
import 'package:dart_app/models/games/game_score_training_p.dart';
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

  String _getMode() {
    String result = '';

    if (isDraw) {
      result = 'Draw - ';
    }
    if (game is GameSingleDoubleTraining_P) {
      result += game.getName;
    } else if (game is GameScoreTraining_P) {
      result += 'Score training';
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final bool isTargetNumberEnabled = game is GameSingleDoubleTraining_P &&
        (game.getGameSettings as GameSettingsSingleDoubleTraining_P)
            .getIsTargetNumberEnabled;

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
              'Rounds: ${game.getGameSettings.getAmountOfRounds}',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.white,
              ),
            ),
          ),
      ],
    );
  }
}
