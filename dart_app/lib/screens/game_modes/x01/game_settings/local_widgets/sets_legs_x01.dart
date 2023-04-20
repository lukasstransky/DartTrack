import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/screens/game_modes/shared/game_settings/sets_legs/legs_amount.dart';
import 'package:dart_app/screens/game_modes/shared/game_settings/sets_legs/sets_amount.dart';
import 'package:dart_app/screens/game_modes/shared/game_settings/sets_legs/sets_btn.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class SetsLegsX01 extends StatelessWidget {
  const SetsLegsX01({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GameSettingsX01_P gameSettingsX01 = context.read<GameSettingsX01_P>();

    return Center(
      child: Container(
        width: WIDTH_GAMESETTINGS.w,
        margin: EdgeInsets.only(top: MARGIN_GAMESETTINGS.h),
        child: Row(
          children: [
            Selector<GameSettingsX01_P, SelectorModelSetsAmount>(
              selector: (_, gameSettingsX01) => SelectorModelSetsAmount(
                mode: gameSettingsX01.getBestOfOrFirstTo,
                sets: gameSettingsX01.getSets,
                setsEnabled: gameSettingsX01.getSetsEnabled,
              ),
              builder: (_, selectorModel, __) => selectorModel.setsEnabled
                  ? SetsAmount(gameSettings: gameSettingsX01)
                  : SizedBox.shrink(),
            ),
            Selector<GameSettingsX01_P, SelectorModelSetsBtn>(
              selector: (_, gameSettingsX01) => SelectorModelSetsBtn(
                setsEnabled: gameSettingsX01.getSetsEnabled,
                singleOrTeam: gameSettingsX01.getSingleOrTeam,
              ),
              builder: (_, selectorModel, __) =>
                  SetsBtn(gameSettings: gameSettingsX01),
            ),
            Selector<GameSettingsX01_P, SelectorModelLegsAmount>(
              selector: (_, gameSettingsX01) => SelectorModelLegsAmount(
                mode: gameSettingsX01.getBestOfOrFirstTo,
                legs: gameSettingsX01.getLegs,
              ),
              builder: (_, selectorModel, __) =>
                  LegsAmount(gameSettings: gameSettingsX01),
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

class SelectorModelSetsBtn {
  final bool setsEnabled;
  final SingleOrTeamEnum singleOrTeam;

  SelectorModelSetsBtn({
    required this.setsEnabled,
    required this.singleOrTeam,
  });
}
