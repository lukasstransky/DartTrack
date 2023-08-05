import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SetsAmount extends StatelessWidget {
  const SetsAmount({
    Key? key,
    required this.gameSettings,
  }) : super(key: key);

  final dynamic gameSettings;

  _addBtnPressed() {
    if (gameSettings.getSets >= MAX_SETS) {
      return;
    }

    //when draw mode is enabled -> prevent from being 1 more than max sets
    if (gameSettings is GameSettingsX01_P &&
        gameSettings.getDrawMode &&
        gameSettings.getSets == (MAX_SETS - 1)) {
      return;
    }

    if (gameSettings.getBestOfOrFirstTo == BestOfOrFirstToEnum.BestOf) {
      gameSettings.setSets = gameSettings.getSets + 2;
    } else {
      gameSettings.setSets = gameSettings.getSets + 1;
    }

    gameSettings.notify();
  }

  _shouldShowAddBtn() {
    return gameSettings.getSets == MAX_SETS ||
        (gameSettings.getSets == (MAX_SETS - 1) &&
            gameSettings is GameSettingsX01_P &&
            gameSettings.getDrawMode);
  }

  _shouldShowSubtractBtn() {
    return (gameSettings.getSets == MIN_SETS_BEST_OF &&
            gameSettings.getBestOfOrFirstTo == BestOfOrFirstToEnum.BestOf) ||
        (gameSettings.getSets == MIN_SETS_FIRST_TO &&
            gameSettings.getBestOfOrFirstTo == BestOfOrFirstToEnum.FirstTo) ||
        (gameSettings.getSets == (MIN_SETS + 1) &&
            gameSettings is GameSettingsX01_P &&
            gameSettings.getDrawMode);
  }

  _subtractBtnPressed() {
    if ((gameSettings.getSets <= MIN_SETS_BEST_OF &&
            gameSettings.getBestOfOrFirstTo == BestOfOrFirstToEnum.BestOf) ||
        (gameSettings.getSets <= MIN_SETS_FIRST_TO &&
            gameSettings.getBestOfOrFirstTo == BestOfOrFirstToEnum.FirstTo)) {
      return;
    }

    //when draw mode is enabled -> prevent from sets being 0
    if (gameSettings is GameSettingsX01_P &&
        gameSettings.getDrawMode &&
        gameSettings.getSets == (MIN_SETS + 1)) {
      return;
    }

    if (gameSettings.getBestOfOrFirstTo == BestOfOrFirstToEnum.BestOf) {
      gameSettings.setSets = gameSettings.getSets - 2;
    } else {
      gameSettings.setSets = gameSettings.getSets - 1;
    }

    gameSettings.notify();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Center(
            child: Text(
              '(Sets)',
              style: TextStyle(
                  fontSize: 8.sp,
                  color: Utils.getTextColorForGameSettingsPage()),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: () {
                  Utils.handleVibrationFeedback(context);
                  _subtractBtnPressed();
                },
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
                icon: Icon(
                  size: ICON_BUTTON_SIZE.h,
                  Icons.remove,
                  color: _shouldShowSubtractBtn()
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.secondary,
                ),
              ),
              Container(
                width: 10.w,
                alignment: Alignment.center,
                child: Text(
                  gameSettings.getSets.toString(),
                  style: TextStyle(
                      fontSize: 18.sp,
                      color: Utils.getTextColorForGameSettingsPage()),
                ),
              ),
              IconButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: () {
                  Utils.handleVibrationFeedback(context);
                  _addBtnPressed();
                },
                padding: EdgeInsets.zero,
                constraints: BoxConstraints(),
                icon: Icon(
                  size: ICON_BUTTON_SIZE.h,
                  Icons.add,
                  color: _shouldShowAddBtn()
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.secondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
