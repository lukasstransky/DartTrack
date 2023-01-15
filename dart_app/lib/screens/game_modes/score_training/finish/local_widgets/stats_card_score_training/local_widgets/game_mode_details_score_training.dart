import 'package:dart_app/models/games/score_training/game_score_training_p.dart';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class GameModeDetails extends StatelessWidget {
  const GameModeDetails({
    Key? key,
    required this.gameScoreTraining_P,
    required this.isOpenGame,
  }) : super(key: key);

  final GameScoreTraining_P gameScoreTraining_P;
  final bool isOpenGame;

  @override
  Widget build(BuildContext context) {
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
                'Score Training',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              Text(
                gameScoreTraining_P.getFormattedDateTime(),
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
            bottom: 1.h,
          ),
          child: Text(
            gameScoreTraining_P.getGameSettings
                .getModeStringFinishScreen(isOpenGame, gameScoreTraining_P),
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
