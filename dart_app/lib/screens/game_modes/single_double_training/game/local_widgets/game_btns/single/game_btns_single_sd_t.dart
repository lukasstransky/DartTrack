import 'package:dart_app/models/games/game_single_double_training_p.dart';
import 'package:dart_app/screens/game_modes/single_double_training/game/local_widgets/game_btns/single/local_widgets/double_field_btn_sd_t.dart';
import 'package:dart_app/screens/game_modes/single_double_training/game/local_widgets/game_btns/single/local_widgets/miss_btn_sd_t.dart';
import 'package:dart_app/screens/game_modes/single_double_training/game/local_widgets/game_btns/single/local_widgets/single_field_btn_sd_t.dart';
import 'package:dart_app/screens/game_modes/single_double_training/game/local_widgets/game_btns/single/local_widgets/tripple_field_btn_sd_t.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameBtnsSingleTraining extends StatelessWidget {
  const GameBtnsSingleTraining({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final game = context.read<GameSingleDoubleTraining_P>();

    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MissBtnSingleTraining(game: game),
                SingleFieldBtnSingleTraining(game: game),
              ],
            ),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DoubleFieldBtnSingleTraining(game: game),
                TrippleFieldBtnSingleTraining(game: game),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
