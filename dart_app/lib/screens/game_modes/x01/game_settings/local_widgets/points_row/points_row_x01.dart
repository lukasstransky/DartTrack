import 'package:dart_app/constants.dart';
import 'package:dart_app/screens/game_modes/x01/game_settings/local_widgets/points_row/local_widgets/custom_points_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game_settings/local_widgets/points_row/local_widgets/points_btn_x01.dart';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class PointsRowX01 extends StatelessWidget {
  const PointsRowX01({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: WIDTH_GAMESETTINGS.w,
        margin: EdgeInsets.only(top: MARGIN_GAMESETTINGS.h),
        child: Row(
          children: [
            PointsBtnX01(points: 301),
            PointsBtnX01(points: 501),
            PointsBtnX01(points: 701),
            CustomPointsX01(),
          ],
        ),
      ),
    );
  }
}
