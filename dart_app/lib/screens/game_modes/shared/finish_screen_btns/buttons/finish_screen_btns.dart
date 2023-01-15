import 'package:dart_app/screens/game_modes/shared/finish_screen_btns/buttons/local_widgets/new_game_btn.dart';
import 'package:dart_app/screens/game_modes/shared/finish_screen_btns/buttons/local_widgets/statistics_btn.dart';
import 'package:dart_app/screens/game_modes/shared/finish_screen_btns/buttons/local_widgets/undo_last_throw_btn.dart';

import 'package:flutter/material.dart';

class FinishScreenBtns extends StatelessWidget {
  const FinishScreenBtns({Key? key, required this.gameMode}) : super(key: key);

  final String gameMode;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StatisticsBtn(gameMode: gameMode),
        NewGameBtn(gameMode: gameMode),
        UndoLastThrowBtn(gameMode: gameMode),
      ],
    );
  }
}
