import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/screens/game_modes/shared/select_input_method/select_input_method.dart';
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

class PointsBtnsThreeDartsX01 extends StatelessWidget {
  const PointsBtnsThreeDartsX01({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GameX01_P gameX01 = context.read<GameX01_P>();
    if (gameX01.getPlayerGameStatistics.isEmpty) {
      return SizedBox.shrink();
    }

    return Consumer2<GameX01_P, GameSettingsX01_P>(
      builder: (_, gameX01, gameSettingsX01, __) => Expanded(
        child: Column(
          children: [
            Container(
              height: 6.h,
              child: ThrownDarts(),
            ),
            if (gameSettingsX01.getShowInputMethodInGameScreen)
              SelectInputMethod(mode: "X01"),
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
