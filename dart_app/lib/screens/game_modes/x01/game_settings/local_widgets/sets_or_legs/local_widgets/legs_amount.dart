import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:tuple/tuple.dart';

class LegsAmount extends StatefulWidget {
  LegsAmount({Key? key}) : super(key: key);

  @override
  State<LegsAmount> createState() => _LegsAmountState();
}

class _LegsAmountState extends State<LegsAmount> {
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
                      if (tuple.item2 <= 1) {
                        return;
                      }

                      if (tuple.item1 == BestOfOrFirstToEnum.BestOf) {
                        gameSettingsX01.setLegs = tuple.item2 - 2;
                      } else {
                        gameSettingsX01.setLegs = tuple.item2 - 1;
                      }

                      if (gameSettingsX01.getLegs == 1) {
                        gameSettingsX01.setWinByTwoLegsDifference = false;
                        gameSettingsX01.setSuddenDeath = false;
                        gameSettingsX01.setMaxExtraLegs =
                            DEFAULT_MAX_EXTRA_LEGS;
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
                        style: TextStyle(fontSize: 18.sp),
                      ),
                    ),
                  ),
                  IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onPressed: () {
                      if (tuple.item2 >= MAX_LEGS) return;
                      if (tuple.item1 == BestOfOrFirstToEnum.BestOf) {
                        gameSettingsX01.setLegs = tuple.item2 + 2;
                      } else {
                        gameSettingsX01.setLegs = tuple.item2 + 1;
                      }
                      gameSettingsX01.notify();
                    },
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(),
                    icon: Icon(Icons.add,
                        color: tuple.item2 != MAX_LEGS
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey),
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
