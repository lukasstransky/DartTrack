import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/screens/game_modes/x01/game_statistics/local_widgets/finishing_stats/local_widgets/best_leg_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game_statistics/local_widgets/finishing_stats/local_widgets/checkout_darts_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game_statistics/local_widgets/finishing_stats/local_widgets/checkout_percent_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game_statistics/local_widgets/finishing_stats/local_widgets/darts_per_leg_avg_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game_statistics/local_widgets/finishing_stats/local_widgets/highest_finish_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game_statistics/local_widgets/finishing_stats/local_widgets/worst_leg_x01.dart';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class FinishingStatsX01 extends StatelessWidget {
  const FinishingStatsX01({Key? key, required this.gameX01}) : super(key: key);

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
          CheckoutPercentX01(gameX01: gameX01),
          CheckoutDartsX01(gameX01: gameX01),
        ],
        HighestFinishX01(gameX01: gameX01),
        BestLegX01(gameX01: gameX01),
        WorstLegX01(gameX01: gameX01),
        DartsPerLegAvgX01(gameX01: gameX01),
      ],
    );
  }
}
