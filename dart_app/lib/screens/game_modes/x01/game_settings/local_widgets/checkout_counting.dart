import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class CheckoutCounting extends StatelessWidget {
  const CheckoutCounting({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameSettingsX01 =
        Provider.of<GameSettingsX01>(context, listen: false);

    return Container(
      width: WIDTH_GAMESETTINGS.w,
      margin: EdgeInsets.only(top: MARGIN_GAMESETTINGS.h),
      child: SizedBox(
        height: HEIGHT_GAMESETTINGS_WIDGETS.h,
        child: Row(
          children: [
            const Text("Counting of Checkout %"),
            Selector<GameSettingsX01, bool>(
              selector: (_, gameSettingsX01) =>
                  gameSettingsX01.getEnableCheckoutCounting,
              builder: (_, enableCheckCounting, __) => Switch(
                value: enableCheckCounting,
                onChanged: (value) {
                  gameSettingsX01.setEnableCheckoutCounting = value;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
