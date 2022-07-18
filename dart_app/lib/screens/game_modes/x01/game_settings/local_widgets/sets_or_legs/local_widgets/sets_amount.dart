import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:tuple/tuple.dart';

class SetsAmount extends StatelessWidget {
  const SetsAmount({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameSettingsX01 =
        Provider.of<GameSettingsX01>(context, listen: false);

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
                    if (tuple.item2 <= 1) return;

                    if (tuple.item1 == BestOfOrFirstToEnum.BestOf) {
                      gameSettingsX01.setSets = tuple.item2 - 2;
                    } else {
                      gameSettingsX01.setSets = tuple.item2 - 1;
                    }
                    gameSettingsX01.notify();
                  },
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  icon: Icon(Icons.remove,
                      color: tuple.item2 != 1
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey),
                ),
                Container(
                  width: 10.w,
                  child: Center(
                    child: Text(
                      tuple.item2.toString(),
                      style: TextStyle(fontSize: 20.sp),
                    ),
                  ),
                ),
                IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: () {
                    if (tuple.item2 >= MAX_SETS) return;

                    if (tuple.item1 == BestOfOrFirstToEnum.BestOf) {
                      gameSettingsX01.setSets = tuple.item2 + 2;
                    } else {
                      gameSettingsX01.setSets = tuple.item2 + 1;
                    }
                    gameSettingsX01.notify();
                  },
                  padding: EdgeInsets.zero,
                  constraints: BoxConstraints(),
                  icon: Icon(Icons.add,
                      color: tuple.item2 != MAX_SETS
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
