import 'package:dart_app/constants.dart';
import 'package:dart_app/screens/game_modes/x01/ingame_settings/local_widgets/hide_show_settings/local_widgets/hide_show_average.dart';
import 'package:dart_app/screens/game_modes/x01/ingame_settings/local_widgets/hide_show_settings/local_widgets/hide_show_finish_ways.dart';
import 'package:dart_app/screens/game_modes/x01/ingame_settings/local_widgets/hide_show_settings/local_widgets/hide_show_last_throw.dart';
import 'package:dart_app/screens/game_modes/x01/ingame_settings/local_widgets/hide_show_settings/local_widgets/hide_show_throw_darts.dart';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class HideShow extends StatelessWidget {
  const HideShow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 23.5.h,
      padding: EdgeInsets.only(top: 1.h),
      child: Card(
        elevation: 5,
        child: Column(
          children: [
            Container(
              height: 5.h,
              padding: EdgeInsets.only(top: 0.5.h, left: 1.5.w),
              alignment: Alignment.centerLeft,
              child: Text(
                'Hide/Show',
                style: TextStyle(
                    fontSize: FONTSIZE_HEADINGS_IN_GAME_SETTINGS.sp,
                    color: Theme.of(context).colorScheme.primary),
              ),
            ),
            HideShowAverage(),
            HideShowFinishWays(),
            HideShowLastThrow(),
            HideShowThrownDarts(),
          ],
        ),
      ),
    );
  }
}
