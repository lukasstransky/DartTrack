import 'package:dart_app/constants.dart';
import 'package:dart_app/screens/game_modes/x01/game_settings/local_widgets/points_row/local_widgets/custom_points.dart';
import 'package:dart_app/screens/game_modes/x01/game_settings/local_widgets/points_row/local_widgets/points_btn.dart';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class PointsRow extends StatelessWidget {
  const PointsRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: WIDTH_GAMESETTINGS.w,
        margin: EdgeInsets.only(top: MARGIN_GAMESETTINGS.h),
        child: Row(
          children: [
            PointsBtn(points: 301),
            PointsBtn(points: 501),
            PointsBtn(points: 701),
            CustomPoints(),
          ],
        ),
      ),
    );
  }
}
