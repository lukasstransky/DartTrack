import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/game_single_double_training_p.dart';
import 'package:dart_app/screens/game_modes/single_double_training/game_statistics/local_widgets/field_hits_sd_t.dart';
import 'package:dart_app/screens/game_modes/single_double_training/game_statistics/local_widgets/main_stats_sd_t.dart';
import 'package:dart_app/screens/game_modes/shared/game_stats/player_names.dart';
import 'package:dart_app/utils/app_bars/custom_app_bar.dart';
import 'package:dart_app/utils/app_bars/custom_app_bar_with_heart.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class GameStatsSingleDoubleTraining extends StatefulWidget {
  static const routeName = '/statisticsSingleDoubleTraining';

  const GameStatsSingleDoubleTraining({Key? key}) : super(key: key);

  @override
  State<GameStatsSingleDoubleTraining> createState() =>
      _GameStatsSingleDoubleTrainingState();
}

class _GameStatsSingleDoubleTrainingState
    extends State<GameStatsSingleDoubleTraining> {
  GameSingleDoubleTraining_P? _game;

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    if (arguments.isNotEmpty) {
      _game = arguments['game'];
    }
  }

  String _getHeader() {
    String result = '';

    // single or double training
    result +=
        '${_game!.getMode == GameMode.SingleTraining ? 'Single' : 'Double'} training';

    if (!_game!.getGameSettings.getIsTargetNumberEnabled) {
      result += ' - ';
      //asc, desc or random
      switch (_game!.getGameSettings.getMode) {
        case ModesSingleDoubleTraining.Ascending:
          result += 'ascending';
          break;
        case ModesSingleDoubleTraining.Descending:
          result += 'descending';
          break;
        case ModesSingleDoubleTraining.Random:
          result += 'random';
          break;
      }
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _game!.getIsGameFinished
          ? CustomAppBarWithHeart(
              title: 'Statistics',
              mode: _game!.getMode == GameMode.SingleTraining
                  ? 'Single training'
                  : 'Double training',
              isFavouriteGame: _game!.getIsFavouriteGame,
              gameId: _game!.getGameId,
            )
          : CustomAppBar(title: 'Statistics'),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 1.h),
              child: Text(
                _getHeader(),
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.white,
                ),
              ),
            ),
            if (_game!.getGameSettings.getIsTargetNumberEnabled)
              Container(
                padding: EdgeInsets.only(top: 0.5.h),
                child: Text(
                  'Target number: ${_game!.getGameSettings.getTargetNumber} (${_game!.getGameSettings.getAmountOfRounds} rounds)',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(
                top: 0.5.h,
                bottom: 1.h,
              ),
              child: Text(
                _game!.getFormattedDateTime(),
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: Utils.getTextColorDarken(context),
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PlayerNames(game: _game!),
                    MainStatsSingleDoubleTraining(game: _game!),
                    FieldHitsSingleDoubleTraining(game: _game!),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
