import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_single_double_training_p.dart';
import 'package:dart_app/models/games/game_single_double_training_p.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:tuple/tuple.dart';

class FieldToHitSingleDoubleTraining extends StatelessWidget {
  const FieldToHitSingleDoubleTraining({Key? key}) : super(key: key);

  String _getFieldToHit(String field, BuildContext context) {
    if (context.read<GameSingleDoubleTraining_P>().getMode ==
        GameMode.DoubleTraining) {
      field = 'D${field}';
    }

    return field;
  }

  @override
  Widget build(BuildContext context) {
    return Selector<GameSingleDoubleTraining_P, Tuple2<int, int>>(
      selector: (_, game) => new Tuple2(
          game.getCurrentFieldToHit, game.getAmountOfRoundsRemaining),
      builder: (_, tuple, __) => Container(
        height: tuple.item2 == -1 ? 8.h : 10.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Utils.getPrimaryColorDarken(context),
              width: GENERAL_BORDER_WIDTH,
            ),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 35.w,
                    height: 6.h,
                    child: Center(
                      child: Text(
                        'Field to hit:',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.sp,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 20.w,
                    height: 6.h,
                    padding: const EdgeInsets.only(left: 10),
                    transform: Matrix4.translationValues(0.0, -2.0, 0.0),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _getFieldToHit(tuple.item1.toString(), context),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (context
                .read<GameSettingsSingleDoubleTraining_P>()
                .getIsTargetNumberEnabled)
              Container(
                transform: Matrix4.translationValues(0.0, -5.0, 0.0),
                child: Text(
                  '(Remaining Rounds: ${tuple.item2})',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14.sp,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
