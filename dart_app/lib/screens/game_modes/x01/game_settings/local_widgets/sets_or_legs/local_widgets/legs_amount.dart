import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:tuple/tuple.dart';

class LegsAmount extends StatefulWidget {
  @override
  State<LegsAmount> createState() => _LegsAmountState();
}

class _LegsAmountState extends State<LegsAmount> {
  _subtractBtnPressed(GameSettingsX01 gameSettingsX01, Tuple2 tuple) {
    if (tuple.item2 <= MIN_LEGS) {
      return;
    }

    //when draw mode is enabled -> prevent from legs being 0
    if (tuple.item1 == BestOfOrFirstToEnum.BestOf &&
        gameSettingsX01.getDrawMode &&
        gameSettingsX01.getLegs == (MIN_LEGS + 1)) {
      return;
    }

    if (tuple.item1 == BestOfOrFirstToEnum.BestOf) {
      gameSettingsX01.setLegs = tuple.item2 - 2;
    } else {
      gameSettingsX01.setLegs = tuple.item2 - 1;
    }

    if (gameSettingsX01.getLegs == MIN_LEGS) {
      gameSettingsX01.setWinByTwoLegsDifference = false;
      gameSettingsX01.setSuddenDeath = false;
      gameSettingsX01.setMaxExtraLegs = DEFAULT_MAX_EXTRA_LEGS;
    }

    gameSettingsX01.notify();
  }

  _addBtnPressed(GameSettingsX01 gameSettingsX01, Tuple2 tuple) {
    if (tuple.item2 >= MAX_LEGS) return;

    //when draw mode is enabled -> prevent from being 1 more than max legs
    if (gameSettingsX01.getDrawMode && tuple.item2 == (MAX_LEGS - 1)) {
      return;
    }

    if (tuple.item1 == BestOfOrFirstToEnum.BestOf) {
      gameSettingsX01.setLegs = tuple.item2 + 2;
    } else {
      gameSettingsX01.setLegs = tuple.item2 + 1;
    }

    gameSettingsX01.notify();
  }

  _shouldShowSubtractBtnGrey(int legs, GameSettingsX01 gameSettingsX01) {
    return legs == MIN_LEGS ||
        legs == (MIN_LEGS + 1) && gameSettingsX01.getDrawMode;
  }

  _shouldShowAddBtnGrey(int legs, GameSettingsX01 gameSettingsX01) {
    return legs == MAX_LEGS ||
        legs == (MAX_LEGS - 1) && gameSettingsX01.getDrawMode;
  }

  @override
  Widget build(BuildContext context) {
    final gameSettingsX01 =
        Provider.of<GameSettingsX01>(context, listen: false);

    return Expanded(
      child: Container(
        child: Column(
          children: [
            Container(
              width: 10.w,
              child: Center(
                child: Text(
                  '(Legs)',
                  style: TextStyle(fontSize: 8.sp),
                ),
              ),
            ),
            Selector<GameSettingsX01, Tuple2<BestOfOrFirstToEnum, int>>(
              selector: (_, gameSettingsX01) =>
                  Tuple2(gameSettingsX01.getMode, gameSettingsX01.getLegs),
              builder: (_, tuple, __) => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onPressed: () {
                      _subtractBtnPressed(gameSettingsX01, tuple);
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
                      _addBtnPressed(gameSettingsX01, tuple);
                    },
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    icon: Icon(Icons.add,
                        color:
                            _shouldShowAddBtnGrey(tuple.item2, gameSettingsX01)
                                ? Colors.grey
                                : Theme.of(context).colorScheme.primary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
