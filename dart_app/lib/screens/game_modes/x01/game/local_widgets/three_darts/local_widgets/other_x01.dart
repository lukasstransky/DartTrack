import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/models/games/x01/helper/submit_x01_helper.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_stats_x01.dart';
import 'package:dart_app/screens/game_modes/shared/game/revert_btn.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/submit_points_btn_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/three_darts/local_widgets/point_btn_three_darts_x01.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class OtherX01 extends StatelessWidget {
  const OtherX01({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GameX01_P gameX01 = context.read<GameX01_P>();
    final GameSettingsX01_P gameSettingsX01 = context.read<GameSettingsX01_P>();

    bool _isBustClickable(GameX01_P gameX01) {
      // for weird bug when ending game (3 dart mode)
      if (gameX01.getPlayerGameStatistics.isEmpty) {
        return false;
      }

      final PlayerOrTeamGameStatsX01 stats =
          gameX01.getCurrentPlayerGameStats();
      final int currentPoints = stats.getCurrentPoints;

      if (gameX01.getAmountOfDartsThrown() == 0) {
        return true;
      }

      if (currentPoints <= 59 &&
          gameX01.getAmountOfDartsThrown() != 3 &&
          stats.getCurrentPoints != 0) {
        return true;
      }

      return false;
    }

    return Expanded(
      child: Selector<GameSettingsX01_P, bool>(
        selector: (_, game) => game.getAutomaticallySubmitPoints,
        builder: (_, automaticallySubmitPoints, __) => Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Selector<GameX01_P, bool>(
                selector: (_, game) => game.getRevertPossible,
                builder: (_, revertPossible, __) => RevertBtn(game_p: gameX01),
              ),
            ),
            Expanded(
              child: gameX01.shouldPointBtnBeDisabled('25')
                  ? PointBtnThreeDartX01(
                      point: '25',
                      activeBtn: false,
                    )
                  : PointBtnThreeDartX01(
                      point: '25',
                      activeBtn: true,
                    ),
            ),
            Expanded(
              child: gameX01.shouldPointBtnBeDisabled('Bull')
                  ? PointBtnThreeDartX01(
                      point: 'Bull',
                      activeBtn: false,
                    )
                  : PointBtnThreeDartX01(
                      point: 'Bull',
                      activeBtn: true,
                    ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Utils.getPrimaryColorDarken(context),
                      width: GENERAL_BORDER_WIDTH.w,
                    ),
                    right: BorderSide(
                      color: Utils.getPrimaryColorDarken(context),
                      width: GENERAL_BORDER_WIDTH.w,
                    ),
                  ),
                ),
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero,
                      ),
                    ),
                    backgroundColor: _isBustClickable(gameX01)
                        ? MaterialStateProperty.all(
                            Theme.of(context).colorScheme.primary)
                        : MaterialStateProperty.all(Utils.darken(
                            Theme.of(context).colorScheme.primary, 25)),
                    overlayColor: _isBustClickable(gameX01)
                        ? Utils.getColorOrPressed(
                            Theme.of(context).colorScheme.primary,
                            Utils.darken(
                                Theme.of(context).colorScheme.primary, 25),
                          )
                        : MaterialStateProperty.all(Colors.transparent),
                  ),
                  child: FittedBox(
                    child: Text(
                      'Bust',
                      style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.titleSmall!.fontSize,
                        color: Utils.getTextColorDarken(context),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  onPressed: () {
                    if (_isBustClickable(gameX01)) {
                      Utils.handleVibrationFeedback(context);
                      SubmitX01Helper.bust(context);
                    }
                  },
                ),
              ),
            ),
            Expanded(
              child: gameX01.shouldPointBtnBeDisabled('0')
                  ? PointBtnThreeDartX01(
                      point: '0',
                      activeBtn: false,
                    )
                  : PointBtnThreeDartX01(
                      point: '0',
                      activeBtn: true,
                    ),
            ),
            if (!gameSettingsX01.getAutomaticallySubmitPoints)
              Expanded(
                child: SubmitPointsBtnX01(),
              ),
          ],
        ),
      ),
    );
  }
}
