import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/game_cricket_p.dart';
import 'package:dart_app/models/games/game_score_training_p.dart';
import 'package:dart_app/models/games/game_single_double_training_p.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/utils/button_styles.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class StatisticsBtn extends StatelessWidget {
  const StatisticsBtn({
    Key? key,
    required this.gameMode,
  }) : super(key: key);

  final GameMode gameMode;

  _statisticsBtnClicked(BuildContext context) {
    if (gameMode == GameMode.X01) {
      Navigator.of(context).pushNamed('/statisticsX01', arguments: {
        'game': context.read<GameX01_P>(),
        'showSimpleAppBar': true
      });
    } else if (gameMode == GameMode.ScoreTraining) {
      Navigator.of(context).pushNamed('/statisticsScoreTraining', arguments: {
        'game': context.read<GameScoreTraining_P>(),
        'showSimpleAppBar': true
      });
    } else if (gameMode == GameMode.SingleTraining ||
        gameMode == GameMode.DoubleTraining) {
      Navigator.of(context).pushNamed('/statisticsSingleDoubleTraining',
          arguments: {
            'game': context.read<GameSingleDoubleTraining_P>(),
            'showSimpleAppBar': true
          });
    } else if (gameMode == GameMode.Cricket) {
      Navigator.of(context).pushNamed('/statisticsCricket', arguments: {
        'game': context.read<GameCricket_P>(),
        'showSimpleAppBar': true
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 3.h),
      child: Container(
        width: 40.w,
        height: 6.h,
        child: ElevatedButton(
          onPressed: () {
            Utils.handleVibrationFeedback(context);
            _statisticsBtnClicked(context);
          },
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'Statistics',
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          style: ButtonStyles.darkPrimaryColorBtnStyle(context).copyWith(
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
