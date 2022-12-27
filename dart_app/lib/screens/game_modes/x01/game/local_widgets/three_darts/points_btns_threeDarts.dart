import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/models/games/game_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/select_input_method.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/three_darts/local_widgets/eleven_to_fifteen.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/three_darts/local_widgets/one_to_five.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/three_darts/local_widgets/other.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/three_darts/local_widgets/single_double_tripple.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/three_darts/local_widgets/six_to_ten.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/three_darts/local_widgets/sixteen_to_twenty.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/three_darts/local_widgets/thrown_darts.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class PointsBtnsThreeDarts extends StatelessWidget {
  const PointsBtnsThreeDarts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GameX01 gameX01 = context.read<GameX01>();
    if (gameX01.getPlayerGameStatistics.isEmpty) {
      return SizedBox.shrink();
    }

    return Consumer2<GameX01, GameSettingsX01>(
      builder: (_, gameX01, gameSettingsX01, __) => Expanded(
        child: Column(
          children: [
            Container(
              height: 6.h,
              child: ThrownDarts(),
            ),
            if (gameSettingsX01.getShowInputMethodInGameScreen)
              SelectInputMethod(),
            Other(),
            OneToFive(),
            SixToTen(),
            ElevenToFifteen(),
            SixteenToTwenty(),
            SingleDoubleOrTripple(stats: gameX01.getCurrentPlayerGameStats()),
          ],
        ),
      ),
    );
  }
}
