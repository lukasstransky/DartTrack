import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:sizer/sizer.dart';

class LegsAmount extends StatelessWidget {
  const LegsAmount({
    Key? key,
    required this.gameSettings,
  }) : super(key: key);

  final dynamic gameSettings;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 10.w,
            alignment: Alignment.center,
            child: Text(
              '(Legs)',
              style: TextStyle(
                fontSize: 8.sp,
                color: Utils.getTextColorForGameSettingsPage(),
              ),
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
                constraints: ResponsiveBreakpoints.of(context).isMobile
                    ? BoxConstraints()
                    : null,
                icon: Icon(
                  size: ICON_BUTTON_SIZE.h,
                  Icons.remove,
                  color: _shouldShowSubtractBtn()
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.secondary,
                ),
              ),
              Container(
                alignment: Alignment.center,
                width: 8.w,
                child: Text(
                  gameSettings.getLegs.toString(),
                  style: TextStyle(
                    fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
                    color: Utils.getTextColorForGameSettingsPage(),
                  ),
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
                constraints: ResponsiveBreakpoints.of(context).isMobile
                    ? BoxConstraints()
                    : null,
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

  _shouldShowAddBtn() {
    return gameSettings.getLegs == MAX_LEGS ||
        gameSettings.getLegs == (MAX_LEGS - 1) &&
            gameSettings is GameSettingsX01_P &&
            gameSettings.getDrawMode;
  }

  _addBtnPressed() {
    if (gameSettings.getLegs >= MAX_LEGS) {
      return;
    }

    //when draw mode is enabled -> prevent from being 1 more than max legs
    if (gameSettings is GameSettingsX01_P &&
        gameSettings.getDrawMode &&
        gameSettings.getLegs == (MAX_LEGS - 1)) {
      return;
    }

    if (gameSettings.getBestOfOrFirstTo == BestOfOrFirstToEnum.BestOf) {
      gameSettings.setLegs = gameSettings.getLegs + 2;
    } else {
      gameSettings.setLegs = gameSettings.getLegs + 1;
    }

    gameSettings.notify();
  }

  _shouldShowSubtractBtn() {
    return gameSettings.getLegs == MIN_LEGS ||
        (gameSettings.getSetsEnabled &&
            gameSettings.getLegs == MIN_LEGS_SETS_ENABLED_FIRST_TO &&
            gameSettings.getBestOfOrFirstTo == BestOfOrFirstToEnum.FirstTo) ||
        (gameSettings.getSetsEnabled &&
            gameSettings.getLegs == MIN_LEGS_SETS_ENABLED_BEST_OF &&
            gameSettings.getBestOfOrFirstTo == BestOfOrFirstToEnum.BestOf) ||
        (gameSettings.getLegs == (MIN_LEGS + 1) &&
            gameSettings is GameSettingsX01_P &&
            gameSettings.getDrawMode);
  }

  _subtractBtnPressed() {
    if (gameSettings.getLegs <= MIN_LEGS ||
        (gameSettings.getSetsEnabled &&
            gameSettings.getLegs <= MIN_LEGS_SETS_ENABLED_BEST_OF &&
            gameSettings.getBestOfOrFirstTo == BestOfOrFirstToEnum.BestOf) ||
        (gameSettings.getSetsEnabled &&
            gameSettings.getLegs <= MIN_LEGS_SETS_ENABLED_FIRST_TO &&
            gameSettings.getBestOfOrFirstTo == BestOfOrFirstToEnum.FirstTo)) {
      return;
    }

    //when draw mode is enabled -> prevent from legs being 0
    if (gameSettings is GameSettingsX01_P &&
        gameSettings.getBestOfOrFirstTo == BestOfOrFirstToEnum.BestOf &&
        gameSettings.getDrawMode &&
        gameSettings.getLegs == (MIN_LEGS + 1)) {
      return;
    }

    if (gameSettings.getBestOfOrFirstTo == BestOfOrFirstToEnum.BestOf) {
      gameSettings.setLegs = gameSettings.getLegs - 2;
    } else {
      gameSettings.setLegs = gameSettings.getLegs - 1;
    }

    if (gameSettings is GameSettingsX01_P && gameSettings.getLegs == MIN_LEGS) {
      gameSettings.setWinByTwoLegsDifference = false;
      gameSettings.setSuddenDeath = false;
      gameSettings.setMaxExtraLegs = DEFAULT_MAX_EXTRA_LEGS;
    }

    gameSettings.notify();
  }
}
