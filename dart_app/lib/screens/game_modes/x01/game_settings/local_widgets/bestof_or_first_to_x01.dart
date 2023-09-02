import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/screens/game_modes/shared/game_settings/best_of_or_first_to_btn.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BestOfOrFirstToX01 extends StatelessWidget {
  const BestOfOrFirstToX01({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Selector<GameSettingsX01_P, SelectorModel>(
        selector: (_, gameSettingsX01) => SelectorModel(
          mode: gameSettingsX01.getBestOfOrFirstTo,
          singleOrTeam: gameSettingsX01.getSingleOrTeam,
        ),
        builder: (_, selectorModel, __) =>
            BestOfOrFirstToBtn(gameSettings: context.read<GameSettingsX01_P>()),
      ),
    );
  }
}

class SelectorModel {
  final BestOfOrFirstToEnum mode;
  final SingleOrTeamEnum singleOrTeam;

  SelectorModel({
    required this.mode,
    required this.singleOrTeam,
  });
}
