import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:tuple/tuple.dart';

class CheckoutCounting extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final gameSettingsX01 =
        Provider.of<GameSettingsX01>(context, listen: false);

    return Selector<GameSettingsX01, Tuple2<bool, SingleOrDouble>>(
      selector: (_, gameSettingsX01) => Tuple2(
          gameSettingsX01.getEnableCheckoutCounting,
          gameSettingsX01.getModeOut),
      builder: (_, tuple, __) {
        if (tuple.item2 == SingleOrDouble.DoubleField) {
          return Container(
            width: WIDTH_GAMESETTINGS.w,
            margin: EdgeInsets.only(top: MARGIN_GAMESETTINGS.h),
            height: WIDGET_HEIGHT_GAMESETTINGS.h,
            child: Row(
              children: [
                const Text('Counting of Checkout %'),
                Switch(
                  value: tuple.item1,
                  onChanged: (value) {
                    gameSettingsX01.setEnableCheckoutCounting = value;
                    gameSettingsX01.notify();
                  },
                ),
              ],
            ),
          );
        } else
          return SizedBox.shrink();
      },
    );
  }
}
