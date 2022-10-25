import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:tuple/tuple.dart';

class SetsAmount extends StatelessWidget {
  _subtractBtnPressed(Tuple2 tuple, GameSettingsX01 gameSettingsX01) {
    if (tuple.item2 <= MIN_SETS) return;

    //when draw mode is enabled -> prevent from sets being 0
    if (gameSettingsX01.getDrawMode && tuple.item2 == (MIN_SETS + 1)) {
      return;
    }

    if (tuple.item1 == BestOfOrFirstToEnum.BestOf) {
      gameSettingsX01.setSets = tuple.item2 - 2;
    } else {
      gameSettingsX01.setSets = tuple.item2 - 1;
    }

    gameSettingsX01.notify();
  }

  _addBtnPressed(Tuple2 tuple, GameSettingsX01 gameSettingsX01) {
    if (tuple.item2 >= MAX_SETS) return;

    //when draw mode is enabled -> prevent from being 1 more than max sets
    if (gameSettingsX01.getDrawMode && tuple.item2 == (MAX_SETS - 1)) {
      return;
    }

    if (tuple.item1 == BestOfOrFirstToEnum.BestOf) {
      gameSettingsX01.setSets = tuple.item2 + 2;
    } else {
      gameSettingsX01.setSets = tuple.item2 + 1;
    }

    gameSettingsX01.notify();
  }

  _shouldShowSubtractBtnGrey(int sets, GameSettingsX01 gameSettingsX01) {
    return sets == MIN_SETS ||
        sets == (MIN_SETS + 1) && gameSettingsX01.getDrawMode;
  }

  _shouldShowAddBtnGrey(int sets, GameSettingsX01 gameSettingsX01) {
    return sets == MAX_SETS ||
        sets == (MAX_SETS - 1) && gameSettingsX01.getDrawMode;
  }

  @override
  Widget build(BuildContext context) {
    final gameSettingsX01 = context.read<GameSettingsX01>();

    return Expanded(
      child: Column(
        children: [
          Container(
            width: 10.w,
            child: Center(
              child: Text(
                '(Sets)',
                style: TextStyle(fontSize: 8.sp),
              ),
            ),
          ),
          Selector<GameSettingsX01, Tuple2<BestOfOrFirstToEnum, int>>(
            selector: (_, gameSettingsX01) =>
                Tuple2(gameSettingsX01.getMode, gameSettingsX01.getSets),
            builder: (_, tuple, __) => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: () {
                    _subtractBtnPressed(tuple, gameSettingsX01);
                  },
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  icon: Icon(Icons.remove,
                      color: _shouldShowSubtractBtnGrey(
                              tuple.item2, gameSettingsX01)
                          ? Colors.grey
                          : Theme.of(context).colorScheme.primary),
                ),
                Container(
                  width: 10.w,
                  child: Center(
                    child: Text(
                      tuple.item2.toString(),
                      style: TextStyle(fontSize: 18.sp),
                    ),
                  ),
                ),
                IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: () {
                    _addBtnPressed(tuple, gameSettingsX01);
                  },
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  icon: Icon(Icons.add,
                      color: _shouldShowAddBtnGrey(tuple.item2, gameSettingsX01)
                          ? Colors.grey
                          : Theme.of(context).colorScheme.primary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
