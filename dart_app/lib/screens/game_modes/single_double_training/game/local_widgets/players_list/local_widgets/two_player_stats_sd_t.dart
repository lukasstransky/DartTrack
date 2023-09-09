import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/game_single_double_training_p.dart';
import 'package:dart_app/screens/game_modes/single_double_training/game/local_widgets/players_list/local_widgets/player_entry_game_sd_t.dart';
import 'package:dart_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class TwoPlayerStatsSingleDoubleTraining extends StatelessWidget {
  const TwoPlayerStatsSingleDoubleTraining({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GameSingleDoubleTraining_P game =
        context.read<GameSingleDoubleTraining_P>();

    return Row(
      children: [
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
                left: game.getSafeAreaPadding.left > 0
                    ? BorderSide(
                        color: Utils.getPrimaryColorDarken(context),
                        width: GENERAL_BORDER_WIDTH.w,
                      )
                    : BorderSide.none,
                bottom: game.getSafeAreaPadding.bottom > 0 &&
                        Utils.isLandscape(context)
                    ? BorderSide(
                        color: Utils.getPrimaryColorDarken(context),
                        width: GENERAL_BORDER_WIDTH.w,
                      )
                    : BorderSide.none,
              ),
            ),
            child: PlayerEntryGameSingleDoubleTraining(
              playerStats: game.getPlayerGameStatistics[0],
            ),
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
                bottom: game.getSafeAreaPadding.bottom > 0 &&
                        Utils.isLandscape(context)
                    ? BorderSide(
                        color: Utils.getPrimaryColorDarken(context),
                        width: GENERAL_BORDER_WIDTH.w,
                      )
                    : BorderSide.none,
              ),
            ),
            child: PlayerEntryGameSingleDoubleTraining(
              playerStats: game.getPlayerGameStatistics[1],
            ),
          ),
        ),
      ],
    );
  }
}
