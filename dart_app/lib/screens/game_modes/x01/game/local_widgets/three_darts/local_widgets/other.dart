import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/models/games/x01/helper/submit_x01_helper.dart';
import 'package:dart_app/models/player_statistics/x01/player_or_team_game_statistics_x01.dart';
import 'package:dart_app/screens/game_modes/shared/game/revert_btn.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/submit_points_btn_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/three_darts/local_widgets/point_btn_three_darts.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class Other extends StatelessWidget {
  const Other({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GameX01_P gameX01 = context.read<GameX01_P>();
    final GameSettingsX01_P gameSettingsX01 = context.read<GameSettingsX01_P>();

    bool _isBustClickable(GameX01_P gameX01) {
      // for weird bug when ending game (3 dart mode)
      if (gameX01.getPlayerGameStatistics.isEmpty) {
        return false;
      }

      final PlayerOrTeamGameStatisticsX01 stats =
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: RevertBtn(game_p: gameX01),
          ),
          Expanded(
            child: gameX01.shouldPointBtnBeDisabled('25')
                ? PointBtnThreeDart(
                    point: '25',
                    activeBtn: false,
                  )
                : PointBtnThreeDart(
                    point: '25',
                    activeBtn: true,
                  ),
          ),
          Expanded(
            child: gameX01.shouldPointBtnBeDisabled('Bull')
                ? PointBtnThreeDart(
                    point: 'Bull',
                    activeBtn: false,
                  )
                : PointBtnThreeDart(
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
                    width: 3,
                  ),
                  right: BorderSide(
                    color: Utils.getPrimaryColorDarken(context),
                    width: 3,
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
                      fontSize: 16.sp,
                      color: Utils.getTextColorDarken(context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                onPressed: () => {
                  if (_isBustClickable(gameX01)) SubmitX01Helper.bust(context)
                },
              ),
            ),
          ),
          Expanded(
            child: gameX01.shouldPointBtnBeDisabled('0')
                ? PointBtnThreeDart(
                    point: '0',
                    activeBtn: false,
                  )
                : PointBtnThreeDart(
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
    );
  }
}
