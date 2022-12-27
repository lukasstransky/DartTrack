import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/models/games/helper/submit_helper.dart';
import 'package:dart_app/models/player_statistics/player_or_team_game_statistics_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/revert_btn.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/submit_points_btn.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/three_darts/local_widgets/point_btn_three_darts.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class Other extends StatelessWidget {
  const Other({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GameX01 gameX01 = context.read<GameX01>();
    final GameSettingsX01 gameSettingsX01 = context.read<GameSettingsX01>();

    bool _isBustClickable(GameX01 gameX01) {
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
            child: RevertBtn(),
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
                onPressed: () =>
                    {if (_isBustClickable(gameX01)) Submit.bust(context)},
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
              child: SubmitPointsBtn(),
            ),
        ],
      ),
    );
  }
}
