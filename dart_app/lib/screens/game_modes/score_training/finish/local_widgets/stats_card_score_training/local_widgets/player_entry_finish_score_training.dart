import 'package:dart_app/models/games/score_training/game_score_training_p.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:sizer/sizer.dart';

class PlayerEntryFinishScoreTraining extends StatelessWidget {
  const PlayerEntryFinishScoreTraining(
      {Key? key,
      required this.i,
      required this.gameScoreTraining_P,
      required this.isOpenGame})
      : super(key: key);

  final int i;
  final GameScoreTraining_P gameScoreTraining_P;
  final bool isOpenGame;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: (i == gameScoreTraining_P.getPlayerGameStatistics.length - 1)
            ? 1.h
            : 0,
      ),
      child: Row(
        children: [
          NameAndRanking(
            i: i,
            gameScoreTraining_P: gameScoreTraining_P,
            isOpenGame: isOpenGame,
          ),
          ScoringStats(gameScoreTraining_P: gameScoreTraining_P, i: i),
        ],
      ),
    );
  }
}

class NameAndRanking extends StatelessWidget {
  const NameAndRanking({
    Key? key,
    required this.i,
    required this.gameScoreTraining_P,
    required this.isOpenGame,
  }) : super(key: key);

  final int i;
  final GameScoreTraining_P gameScoreTraining_P;
  final bool isOpenGame;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(
          left: 5.w,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 5.w,
              child: Text(
                '${(i + 1)}.',
                style: TextStyle(
                  fontSize: i == 0 ? 14.sp : 12.sp,
                  fontWeight: FontWeight.bold,
                  color: Utils.getTextColorDarken(context),
                ),
              ),
            ),
            if (i == 0 && !isOpenGame)
              Container(
                padding: EdgeInsets.only(left: 3.w),
                transform: Matrix4.translationValues(0.0, -2.0, 0.0),
                child: Icon(
                  Entypo.trophy,
                  size: 12.sp,
                  color: Color(0xffFFD700),
                ),
              ),
            Container(
              padding: EdgeInsets.only(left: 3.w),
              child: Text(
                gameScoreTraining_P
                    .getPlayerGameStatistics[i].getPlayer.getName,
                style: TextStyle(
                  fontSize: i == 0 ? 14.sp : 12.sp,
                  color: Utils.getTextColorDarken(context),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ScoringStats extends StatelessWidget {
  const ScoringStats({
    Key? key,
    required this.gameScoreTraining_P,
    required this.i,
  }) : super(key: key);

  final GameScoreTraining_P gameScoreTraining_P;
  final int i;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(
          left: 4.w,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Points: ${gameScoreTraining_P.getPlayerGameStatistics[i].getCurrentScore}',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.white,
              ),
            ),
            Text(
              'Average: ${gameScoreTraining_P.getPlayerGameStatistics[i].getAverage()}',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.white,
              ),
            ),
            Text(
              'Highest score: ${gameScoreTraining_P.getPlayerGameStatistics[i].getHighestScore()}',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
