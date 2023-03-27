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
    final game = context.read<GameSingleDoubleTraining_P>();
    const double WIDTH = 50;

    return Row(
      children: [
        Container(
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
          width: WIDTH.w,
          child: PlayerEntryGameSingleDoubleTraining(
            playerStats: game.getPlayerGameStatistics[0],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Utils.getPrimaryColorDarken(context),
                width: GENERAL_BORDER_WIDTH.w,
              ),
            ),
          ),
          width: WIDTH.w,
          child: PlayerEntryGameSingleDoubleTraining(
            playerStats: game.getPlayerGameStatistics[1],
          ),
        ),
      ],
    );
  }
}
