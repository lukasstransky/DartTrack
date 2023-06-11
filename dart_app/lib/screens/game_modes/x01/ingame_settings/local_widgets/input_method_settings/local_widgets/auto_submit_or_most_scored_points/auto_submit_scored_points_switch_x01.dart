import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/firestore/stats_firestore_x01_p.dart';
import 'package:dart_app/screens/game_modes/x01/ingame_settings/local_widgets/input_method_settings/local_widgets/auto_submit_or_most_scored_points/local_widgets/auto_submit_or_show_points_switch.dart';
import 'package:dart_app/screens/game_modes/x01/ingame_settings/local_widgets/input_method_settings/local_widgets/auto_submit_or_most_scored_points/local_widgets/fetch_from_stats_btn.dart';
import 'package:dart_app/screens/game_modes/x01/ingame_settings/local_widgets/input_method_settings/local_widgets/auto_submit_or_most_scored_points/local_widgets/most_scored_point_value.dart';
import 'package:dart_app/screens/game_modes/x01/ingame_settings/local_widgets/input_method_settings/local_widgets/auto_submit_or_most_scored_points/local_widgets/reset_most_scored_points_btn.dart';
import 'package:dart_app/services/firestore/firestore_service_games.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class AutoSubmitOrScoredPointsSwitchX01 extends StatefulWidget {
  const AutoSubmitOrScoredPointsSwitchX01({Key? key}) : super(key: key);

  @override
  State<AutoSubmitOrScoredPointsSwitchX01> createState() =>
      _AutoSubmitOrScoredPointsSwitchX01State();
}

class _AutoSubmitOrScoredPointsSwitchX01State
    extends State<AutoSubmitOrScoredPointsSwitchX01> {
  @override
  void initState() {
    super.initState();
    _checkIfAtLeastOneX01GameIsPlayed();
  }

  // for "fetch from stats" btn for most scored points
  _checkIfAtLeastOneX01GameIsPlayed() async {
    await context
        .read<FirestoreServiceGames>()
        .checkIfAtLeastOneX01GameIsPlayed(context);
  }

  @override
  Widget build(BuildContext context) {
    final GameSettingsX01_P gameSettingsX01 = context.read<GameSettingsX01_P>();
    final StatsFirestoreX01_P statisticsFirestore =
        context.read<StatsFirestoreX01_P>();
    final bool showMostScoredPoints = gameSettingsX01.getShowMostScoredPoints;

    return Container(
      height: _calcCardHeight(gameSettingsX01, statisticsFirestore).h,
      child: Column(
        children: [
          AutoSubmitOrShowMostScoredPointsSwitch(),
          if (gameSettingsX01.getInputMethod == InputMethod.Round &&
              showMostScoredPoints) ...[
            Selector<GameSettingsX01_P, List<String>>(
              selector: (_, gameSettingsX01) =>
                  gameSettingsX01.getMostScoredPoints,
              shouldRebuild: (previous, next) => true,
              builder: (_, mostScoredPoints, __) => Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        for (int i = 0; i < mostScoredPoints.length; i += 2)
                          MostScoredPointValue(i: i),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        for (int i = 1; i < mostScoredPoints.length; i += 2)
                          MostScoredPointValue(i: i),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ResetMostScoredPointsBtn(),
                FetchFromStatsBtn(),
              ],
            )
          ],
        ],
      ),
    );
  }

  int _calcCardHeight(GameSettingsX01_P gameSettingsX01,
      StatsFirestoreX01_P statisticsFirestoreX01) {
    if (gameSettingsX01.getInputMethod == InputMethod.Round &&
        gameSettingsX01.getShowMostScoredPoints) {
      return 27;
    }

    return 6;
  }
}
