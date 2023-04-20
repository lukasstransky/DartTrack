import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_cricket_p.dart';
import 'package:dart_app/screens/game_modes/shared/game_settings/best_of_or_first_to_btn.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BestOfOrFirstToCricket extends StatelessWidget {
  const BestOfOrFirstToCricket({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Selector<GameSettingsCricket_P, BestOfOrFirstToEnum>(
        selector: (_, gameSettingsCricket) =>
            gameSettingsCricket.getBestOfOrFirstTo,
        builder: (_, bestOfOrFirstTo, __) => BestOfOrFirstToBtn(
            gameSettingsProvider: context.read<GameSettingsCricket_P>()),
      ),
    );
  }
}
