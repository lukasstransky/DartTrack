import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/screens/game_modes/shared/select_input_method/select_input_method.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/three_darts/local_widgets/eleven_to_fifteen_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/three_darts/local_widgets/one_to_five_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/three_darts/local_widgets/other_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/three_darts/local_widgets/single_double_tripple_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/three_darts/local_widgets/six_to_ten_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/three_darts/local_widgets/sixteen_to_twenty_x01.dart';
import 'package:dart_app/screens/game_modes/x01/game/local_widgets/three_darts/local_widgets/thrown_darts_x01.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class PointsBtnsThreeDartsX01 extends StatelessWidget {
  const PointsBtnsThreeDartsX01({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GameX01_P gameX01 = context.read<GameX01_P>();
    final GameSettingsX01_P gameSettingsX01 = context.read<GameSettingsX01_P>();
    if (gameX01.getPlayerGameStatistics.isEmpty) {
      return SizedBox.shrink();
    }

    return Selector<GameX01_P, SelectorModel>(
      selector: (_, gameX01) => SelectorModel(
        currentThreeDarts: gameX01.getCurrentThreeDarts,
        currentPointType: gameX01.getCurrentPointType,
      ),
      builder: (_, selectorModel, __) => Utils.wrapExpandedIfLandscape(
        context,
        Container(
          height: Utils.isLandscape(context)
              ? null
              : gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Single
                  ? 43.h
                  : 40.h,
          child: Column(
            children: [
              Container(
                height: 6.h,
                child: ThrownDartsX01(),
              ),
              Selector<GameSettingsX01_P, bool>(
                selector: (_, gameSettings) =>
                    gameSettings.getShowInputMethodInGameScreen,
                builder: (_, showInputMethodInGameScreen, __) =>
                    showInputMethodInGameScreen
                        ? SelectInputMethod(mode: GameMode.X01)
                        : SizedBox.shrink(),
              ),
              OtherX01(),
              OneToFiveX01(),
              SixToTenX01(),
              ElevenToFifteenX01(),
              SixteenToTwentyX01(),
              SingleDoubleOrTrippleX01(
                  stats: gameX01.getCurrentPlayerGameStats()),
            ],
          ),
        ),
      ),
    );
  }
}

class SelectorModel {
  final List<String> currentThreeDarts;
  final PointType currentPointType;

  SelectorModel({
    required this.currentThreeDarts,
    required this.currentPointType,
  });
}
