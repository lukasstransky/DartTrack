import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/score_training/game_settings_score_training_p.dart';
import 'package:dart_app/models/player.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class PlayerNames_st extends StatelessWidget {
  const PlayerNames_st({
    Key? key,
    required this.gameSettingsScoreTraining_P,
  }) : super(key: key);

  final GameSettingsScoreTraining_P gameSettingsScoreTraining_P;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: PADDING_TOP_STATISTICS),
      child: Row(
        children: [
          SizedBox(
            width: WIDTH_HEADINGS_STATISTICS.w,
          ),
          for (Player player in gameSettingsScoreTraining_P.getPlayers)
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
