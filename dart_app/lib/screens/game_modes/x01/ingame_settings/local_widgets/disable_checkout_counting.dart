import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class DisableCheckoutCounting extends StatelessWidget {
  const DisableCheckoutCounting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 12.h,
      padding: EdgeInsets.only(top: 1.h),
      margin: EdgeInsets.only(bottom: 5.h),
      child: Card(
        elevation: 5,
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(top: 0.5.h, left: 1.5.w, bottom: 1.h),
              child: Text(
                'Checkout Counting',
                style: TextStyle(
                    fontSize: FONTSIZE_HEADINGS_IN_GAME_SETTINGS.sp,
                    color: Theme.of(context).colorScheme.primary),
              ),
            ),
            DisableCheckoutCountingBtn(context),
          ],
        ),
      ),
    );
  }

  Container DisableCheckoutCountingBtn(BuildContext context) {
    final gameSettingsX01 = context.read<GameSettingsX01>();

    return Container(
      height: HEIGHT_IN_GAME_SETTINGS_WIDGETS.h,
      padding: EdgeInsets.only(left: 2.5.w),
      child: Row(
        children: [
          ElevatedButton(
            onPressed: () => {
              gameSettingsX01.setCheckoutCountingFinallyDisabled = true,
              gameSettingsX01.notify(),
            },
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: const Text('Disable'),
            ),
            style: ButtonStyle(
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
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
                "(can't be re-enabled for this game)",
                style: new TextStyle(fontSize: 10.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
