import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class DisableCheckoutCountingX01 extends StatelessWidget {
  const DisableCheckoutCountingX01({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 13.h,
      padding: EdgeInsets.only(top: 2.h),
      margin: EdgeInsets.only(bottom: 5.h),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(CARD_SHAPE_ROUNDING),
        ),
        color: Utils.darken(Theme.of(context).colorScheme.primary, 10),
        elevation: 5,
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(
                top: 0.5.h,
                left: 1.5.w,
                bottom: 1.5.h,
              ),
              child: Text(
                'Checkout counting',
                style: TextStyle(
                  fontSize: FONTSIZE_HEADINGS_IN_GAME_SETTINGS.sp,
                  color: Utils.getTextColorDarken(context),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            DisableCheckoutCountingBtn(context),
          ],
        ),
      ),
    );
  }

  Container DisableCheckoutCountingBtn(BuildContext context) {
    final gameSettingsX01 = context.read<GameSettingsX01_P>();

    return Container(
      height: HEIGHT_IN_GAME_SETTINGS_WIDGETS.h,
      padding: EdgeInsets.only(left: 1.5.w),
      child: Row(
        children: [
          ElevatedButton(
            onPressed: () {
              Utils.handleVibrationFeedback(context);
              gameSettingsX01.setCheckoutCountingFinallyDisabled = true;
              gameSettingsX01.notify();
            },
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'Disable',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
            ),
            style: ButtonStyle(
              splashFactory: NoSplash.splashFactory,
              shadowColor: MaterialStateProperty.all(Colors.transparent),
              overlayColor: MaterialStateProperty.all(Colors.transparent),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  side: BorderSide(
                    color: Utils.getPrimaryColorDarken(context),
                    width: GAME_SETTINGS_BTN_BORDER_WITH.w,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                ),
              ),
              backgroundColor: MaterialStateProperty.all(
                  Theme.of(context).colorScheme.primary),
            ),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Padding(
              padding: EdgeInsets.only(left: 2.w),
              child: Text(
                "(Can't be re-enabled for this game)",
                style: new TextStyle(
                  fontSize: 10.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
