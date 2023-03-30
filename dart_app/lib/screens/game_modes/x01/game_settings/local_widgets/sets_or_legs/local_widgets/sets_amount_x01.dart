import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class SetsAmountX01 extends StatelessWidget {
  _subtractBtnPressed(
      SelectorModel selectorModel, GameSettingsX01_P gameSettingsX01) {
    if (selectorModel.sets <= MIN_SETS) {
      return;
    }

    //when draw mode is enabled -> prevent from sets being 0
    if (gameSettingsX01.getDrawMode && selectorModel.sets == (MIN_SETS + 1)) {
      return;
    }

    if (selectorModel.mode == BestOfOrFirstToEnum.BestOf) {
      gameSettingsX01.setSets = selectorModel.sets - 2;
    } else {
      gameSettingsX01.setSets = selectorModel.sets - 1;
    }

    gameSettingsX01.notify();
  }

  _addBtnPressed(
      SelectorModel selectorModel, GameSettingsX01_P gameSettingsX01) {
    if (selectorModel.sets >= MAX_SETS) {
      return;
    }

    //when draw mode is enabled -> prevent from being 1 more than max sets
    if (gameSettingsX01.getDrawMode && selectorModel.sets == (MAX_SETS - 1)) {
      return;
    }

    if (selectorModel.mode == BestOfOrFirstToEnum.BestOf) {
      gameSettingsX01.setSets = selectorModel.sets + 2;
    } else {
      gameSettingsX01.setSets = selectorModel.sets + 1;
    }

    gameSettingsX01.notify();
  }

  _shouldShowSubtractBtnGrey(int sets, GameSettingsX01_P gameSettingsX01) {
    return sets == MIN_SETS ||
        sets == (MIN_SETS + 1) && gameSettingsX01.getDrawMode;
  }

  _shouldShowAddBtnGrey(int sets, GameSettingsX01_P gameSettingsX01) {
    return sets == MAX_SETS ||
        sets == (MAX_SETS - 1) && gameSettingsX01.getDrawMode;
  }

  @override
  Widget build(BuildContext context) {
    final gameSettingsX01 = context.read<GameSettingsX01_P>();

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
          Selector<GameSettingsX01_P, SelectorModel>(
            selector: (_, gameSettingsX01) => SelectorModel(
              mode: gameSettingsX01.getMode,
              sets: gameSettingsX01.getSets,
            ),
            builder: (_, selectorModel, __) => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: () =>
                      _subtractBtnPressed(selectorModel, gameSettingsX01),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  icon: Icon(Icons.remove,
                      color: _shouldShowSubtractBtnGrey(
                              selectorModel.sets, gameSettingsX01)
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.secondary),
                ),
                Container(
                  width: 10.w,
                  alignment: Alignment.center,
                  child: Text(
                    selectorModel.sets.toString(),
                    style: TextStyle(
                        fontSize: 18.sp,
                        color: Utils.getTextColorForGameSettingsPage()),
                  ),
                ),
                IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: () =>
                      _addBtnPressed(selectorModel, gameSettingsX01),
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  icon: Icon(Icons.add,
                      color: _shouldShowAddBtnGrey(
                              selectorModel.sets, gameSettingsX01)
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
  final int sets;

  SelectorModel({
    required this.mode,
    required this.sets,
  });
}
