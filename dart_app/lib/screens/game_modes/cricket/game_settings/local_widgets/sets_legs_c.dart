import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_cricket_p.dart';
import 'package:dart_app/screens/game_modes/shared/game_settings/sets_legs/legs_amount.dart';
import 'package:dart_app/screens/game_modes/shared/game_settings/sets_legs/sets_amount.dart';
import 'package:dart_app/screens/game_modes/shared/game_settings/sets_legs/sets_btn.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class SetsLegsCricket extends StatelessWidget {
  const SetsLegsCricket({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GameSettingsCricket_P gameSettingsCricket =
        context.read<GameSettingsCricket_P>();

    return Center(
      child: Container(
        width: WIDTH_GAMESETTINGS.w,
        margin: EdgeInsets.only(top: MARGIN_GAMESETTINGS.h),
        child: Row(
          children: [
            Selector<GameSettingsCricket_P, SelectorModelSetsAmount>(
              selector: (_, gameSettingsCricket) => SelectorModelSetsAmount(
                mode: gameSettingsCricket.getBestOfOrFirstTo,
                sets: gameSettingsCricket.getSets,
                setsEnabled: gameSettingsCricket.getSetsEnabled,
              ),
              builder: (_, selectorModel, __) => selectorModel.setsEnabled
                  ? SetsAmount(gameSettings: gameSettingsCricket)
                  : SizedBox.shrink(),
            ),
            Selector<GameSettingsCricket_P, bool>(
              selector: (_, gameSettingsCricket) =>
                  gameSettingsCricket.getSetsEnabled,
              builder: (_, setsEnabled, __) =>
                  SetsBtn(gameSettings: gameSettingsCricket),
            ),
            Selector<GameSettingsCricket_P, SelectorModelLegsAmount>(
              selector: (_, gameSettingsCricket) => SelectorModelLegsAmount(
                mode: gameSettingsCricket.getBestOfOrFirstTo,
                legs: gameSettingsCricket.getLegs,
              ),
              builder: (_, selectorModel, __) =>
                  LegsAmount(gameSettings: gameSettingsCricket),
            ),
          ],
        ),
      ),
    );
  }
}

class SelectorModelLegsAmount {
  final BestOfOrFirstToEnum mode;
  final int legs;

  SelectorModelLegsAmount({
    required this.mode,
    required this.legs,
  });
}

class SelectorModelSetsAmount {
  final BestOfOrFirstToEnum mode;
  final int sets;
  final bool setsEnabled;

  SelectorModelSetsAmount({
    required this.mode,
    required this.sets,
    required this.setsEnabled,
  });
}
