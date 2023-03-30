import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class LegsAmountX01 extends StatefulWidget {
  @override
  State<LegsAmountX01> createState() => _LegsAmountX01State();
}

class _LegsAmountX01State extends State<LegsAmountX01> {
  _subtractBtnPressed(
      GameSettingsX01_P gameSettingsX01, SelectorModel selectorModel) {
    if (selectorModel.legs <= MIN_LEGS) {
      return;
    }

    //when draw mode is enabled -> prevent from legs being 0
    if (selectorModel.mode == BestOfOrFirstToEnum.BestOf &&
        gameSettingsX01.getDrawMode &&
        gameSettingsX01.getLegs == (MIN_LEGS + 1)) {
      return;
    }

    if (selectorModel.mode == BestOfOrFirstToEnum.BestOf) {
      gameSettingsX01.setLegs = selectorModel.legs - 2;
    } else {
      gameSettingsX01.setLegs = selectorModel.legs - 1;
    }

    if (gameSettingsX01.getLegs == MIN_LEGS) {
      gameSettingsX01.setWinByTwoLegsDifference = false;
      gameSettingsX01.setSuddenDeath = false;
      gameSettingsX01.setMaxExtraLegs = DEFAULT_MAX_EXTRA_LEGS;
    }

    gameSettingsX01.notify();
  }

  _addBtnPressed(
      GameSettingsX01_P gameSettingsX01, SelectorModel selectorModel) {
    if (selectorModel.legs >= MAX_LEGS) {
      return;
    }

    //when draw mode is enabled -> prevent from being 1 more than max legs
    if (gameSettingsX01.getDrawMode && selectorModel.legs == (MAX_LEGS - 1)) {
      return;
    }

    if (selectorModel.mode == BestOfOrFirstToEnum.BestOf) {
      gameSettingsX01.setLegs = selectorModel.legs + 2;
    } else {
      gameSettingsX01.setLegs = selectorModel.legs + 1;
    }

    gameSettingsX01.notify();
  }

  _shouldShowSubtractBtnGrey(int legs, GameSettingsX01_P gameSettingsX01) {
    return legs == MIN_LEGS ||
        legs == (MIN_LEGS + 1) && gameSettingsX01.getDrawMode;
  }

  _shouldShowAddBtnGrey(int legs, GameSettingsX01_P gameSettingsX01) {
    return legs == MAX_LEGS ||
        legs == (MAX_LEGS - 1) && gameSettingsX01.getDrawMode;
  }

  @override
  Widget build(BuildContext context) {
    final gameSettingsX01 = context.read<GameSettingsX01_P>();

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
          Selector<GameSettingsX01_P, SelectorModel>(
            selector: (_, gameSettingsX01) => SelectorModel(
              mode: gameSettingsX01.getMode,
              legs: gameSettingsX01.getLegs,
            ),
            builder: (_, selectorModel, __) => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: () =>
                      _subtractBtnPressed(gameSettingsX01, selectorModel),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  icon: Icon(Icons.remove,
                      color: _shouldShowSubtractBtnGrey(
                              selectorModel.legs, gameSettingsX01)
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.secondary),
                ),
                Container(
                  width: 10.w,
                  alignment: Alignment.center,
                  child: Text(
                    selectorModel.legs.toString(),
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: Utils.getTextColorForGameSettingsPage(),
                    ),
                  ),
                ),
                IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: () =>
                      _addBtnPressed(gameSettingsX01, selectorModel),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  icon: Icon(Icons.add,
                      color: _shouldShowAddBtnGrey(
                              selectorModel.legs, gameSettingsX01)
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.secondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SelectorModel {
  final BestOfOrFirstToEnum mode;
  final int legs;

  SelectorModel({
    required this.mode,
    required this.legs,
  });
}
