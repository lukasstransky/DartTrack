import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_cricket_p.dart';
import 'package:dart_app/models/games/game_cricket_p.dart';
import 'package:dart_app/models/games/game_score_training_p.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class PointBtnThreeDarts extends StatelessWidget {
  const PointBtnThreeDarts({
    Key? key,
    required this.pointValue,
    required this.mode,
  }) : super(key: key);

  final String pointValue;
  final GameMode mode;

  @override
  Widget build(BuildContext context) {
    final GameCricket_P gameCricket = context.read<GameCricket_P>();
    final GameSettingsCricket_P gameSettingsCricket =
        context.read<GameSettingsCricket_P>();
    final GameScoreTraining_P gameScoreTraining =
        context.read<GameScoreTraining_P>();

    final int _amountOfDartsThrown =
        _getAmountOfDartsThrown(gameCricket, gameScoreTraining);
    final bool _isTrippleBull = mode == GameMode.Cricket &&
        gameCricket.getCurrentPointType == PointType.Tripple &&
        pointValue == 'Bull';
    final bool _disableBust = pointValue == 'Bust' && _amountOfDartsThrown != 0;
    final bool _isBtnNotClickable =
        _amountOfDartsThrown == 3 || _isTrippleBull || _disableBust;
    final String pointValueWithDoubleOrTripplePrefix =
        _getPointValueWithDoubleOrTripplePrefix(gameCricket, gameScoreTraining);

    return Container(
      decoration: BoxDecoration(
        border: Utils.getBorder(context, pointValue, mode),
      ),
      child: ElevatedButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          ),
          backgroundColor: _isBtnNotClickable
              ? MaterialStateProperty.all(
                  Utils.darken(Theme.of(context).colorScheme.primary, 25),
                )
              : MaterialStateProperty.all(
                  Theme.of(context).colorScheme.primary),
          overlayColor: _isBtnNotClickable
              ? MaterialStateProperty.all(Colors.transparent)
              : Utils.getColorOrPressed(
                  Theme.of(context).colorScheme.primary,
                  Utils.darken(Theme.of(context).colorScheme.primary, 25),
                ),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            pointValueWithDoubleOrTripplePrefix,
            style: TextStyle(
              fontSize: 16.sp,
              color: Utils.getTextColorDarken(context),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        onPressed: () {
          if (!_isBtnNotClickable) {
            _pointBtnClicked(pointValueWithDoubleOrTripplePrefix, gameCricket,
                gameScoreTraining, gameSettingsCricket, context);
          }
        },
      ),
    );
  }

  String _getPointValueWithDoubleOrTripplePrefix(
      GameCricket_P gameCricket, GameScoreTraining_P gameScoreTraining) {
    String pointValueWithDoubleOrTripplePrefix = '';
    if (mode == GameMode.ScoreTraining || mode == GameMode.Cricket) {
      if (pointValue == 'Bust') {
        pointValueWithDoubleOrTripplePrefix = 'Bust';
      } else {
        late PointType currentPointType;
        if (mode == GameMode.Cricket) {
          currentPointType = gameCricket.getCurrentPointType;
        } else if (mode == GameMode.ScoreTraining) {
          currentPointType = gameScoreTraining.getCurrentPointType;
        }
        pointValueWithDoubleOrTripplePrefix =
            Utils.appendTrippleOrDouble(currentPointType, pointValue);
      }
    }

    return pointValueWithDoubleOrTripplePrefix;
  }

  _pointBtnClicked(
      String pointValueWithDoubleOrTripplePrefix,
      GameCricket_P gameCricket,
      GameScoreTraining_P gameScoreTraining,
      GameSettingsCricket_P gameSettingsCricket,
      BuildContext context) {
    if (mode == GameMode.ScoreTraining) {
      gameScoreTraining.submitPointsThreeDartsMode(pointValue,
          pointValueWithDoubleOrTripplePrefix, gameScoreTraining, context);
    } else if (mode == GameMode.Cricket) {
      gameCricket.submitThrow(gameSettingsCricket, pointValue,
          pointValueWithDoubleOrTripplePrefix, context);
    }
  }

  int _getAmountOfDartsThrown(
      GameCricket_P gameCricket, GameScoreTraining_P gameScoreTraining) {
    if (mode == GameMode.ScoreTraining) {
      return gameScoreTraining.getAmountOfDartsThrown();
    } else if (mode == GameMode.Cricket) {
      return gameCricket.getAmountOfDartsThrown();
    }
    return 0;
  }
}
