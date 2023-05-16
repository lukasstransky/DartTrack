import 'package:dart_app/constants.dart';
import 'package:dart_app/models/games/game_score_training_p.dart';
import 'package:dart_app/screens/game_modes/shared/game/point_btns_three_darts/local_widgets/eleven_to_fifteen.dart';
import 'package:dart_app/screens/game_modes/shared/game/point_btns_three_darts/local_widgets/one_to_five.dart';
import 'package:dart_app/screens/game_modes/shared/game/point_btns_three_darts/local_widgets/other.dart';
import 'package:dart_app/screens/game_modes/shared/game/point_btns_three_darts/local_widgets/single_double_or_tripple.dart';
import 'package:dart_app/screens/game_modes/shared/game/point_btns_three_darts/local_widgets/six_to_ten.dart';
import 'package:dart_app/screens/game_modes/shared/game/point_btns_three_darts/local_widgets/sixteen_to_twenty.dart';
import 'package:dart_app/screens/game_modes/shared/game/point_btns_three_darts/local_widgets/thrown_darts.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PointBtnsThreeDarts extends StatelessWidget {
  const PointBtnsThreeDarts({Key? key, required this.mode}) : super(key: key);

  final GameMode mode;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Selector<GameScoreTraining_P, List<String>>(
        selector: (_, gameScoreTraining_P) =>
            gameScoreTraining_P.getCurrentThreeDarts,
        shouldRebuild: (previous, next) => true,
        builder: (_, currentThreeDarts, __) => Column(
          children: [
            ThrownDarts(mode: mode),
            OtherBtns(mode: mode),
            OneToFiveBtnsThreeDarts(mode: mode),
            SixToTenBtnsThreeDarts(mode: mode),
            ElevenToFifteenBtnsThreeDarts(mode: mode),
            SixteenToTwentyBtnsThreeDarts(mode: mode),
            SingleDoubleOrTrippleBtns(mode: mode),
          ],
        ),
      ),
    );
  }
}
