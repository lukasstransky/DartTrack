import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_p.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class PlayerNames extends StatelessWidget {
  const PlayerNames({
    Key? key,
    required this.settings,
  }) : super(key: key);

  final GameSettings_P settings;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: PADDING_LEFT_STATISTICS,
        top: PADDING_TOP_STATISTICS,
      ),
      child: Row(
        children: [
          SizedBox(
            width: WIDTH_HEADINGS_STATISTICS.w,
          ),
          for (Player player in settings.getPlayers)
            Container(
              width: WIDTH_DATA_STATISTICS.w,
              child: Text(
                player.getName,
                style: TextStyle(
                  fontSize: FONTSIZE_STATISTICS.sp,
                  color: Utils.getTextColorDarken(context),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
