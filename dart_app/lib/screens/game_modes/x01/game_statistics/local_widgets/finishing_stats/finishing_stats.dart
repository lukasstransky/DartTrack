import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/screens/game_modes/x01/game_statistics/local_widgets/finishing_stats/local_widgets/best_leg.dart';
import 'package:dart_app/screens/game_modes/x01/game_statistics/local_widgets/finishing_stats/local_widgets/checkout_darts.dart';
import 'package:dart_app/screens/game_modes/x01/game_statistics/local_widgets/finishing_stats/local_widgets/checkout_percent.dart';
import 'package:dart_app/screens/game_modes/x01/game_statistics/local_widgets/finishing_stats/local_widgets/darts_per_leg_avg.dart';
import 'package:dart_app/screens/game_modes/x01/game_statistics/local_widgets/finishing_stats/local_widgets/highest_finish.dart';
import 'package:dart_app/screens/game_modes/x01/game_statistics/local_widgets/finishing_stats/local_widgets/worst_leg.dart';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class FinishingStats extends StatelessWidget {
  const FinishingStats({Key? key, required this.gameX01}) : super(key: key);

  final GameX01_P gameX01;

  @override
  Widget build(BuildContext context) {
    final GameSettingsX01_P gameSettingsX01 = gameX01.getGameSettings;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: PADDING_TOP_STATISTICS),
          child: Container(
            transform: Matrix4.translationValues(-10.0, 0.0, 0.0),
            child: Text(
              'Finishing',
              style: TextStyle(
                fontSize: FONTSIZE_HEADING_STATISTICS.sp,
                color: Colors.white,
              ),
            ),
          ),
        ),
        if (gameSettingsX01.getEnableCheckoutCounting) ...[
          CheckoutPercent(gameX01: gameX01),
          CheckoutDarts(gameX01: gameX01),
        ],
        HighestFinish(gameX01: gameX01),
        BestLeg(gameX01: gameX01),
        WorstLeg(gameX01: gameX01),
        DartsPerLegAvg(gameX01: gameX01),
      ],
    );
  }
}
