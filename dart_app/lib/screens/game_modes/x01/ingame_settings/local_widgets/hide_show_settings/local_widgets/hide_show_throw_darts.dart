import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class HideShowThrownDarts extends StatelessWidget {
  const HideShowThrownDarts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameSettingsX01 = context.read<GameSettingsX01>();

    return Container(
      height: HEIGHT_IN_GAME_SETTINGS_WIDGETS.h,
      padding: EdgeInsets.only(left: 2.5.w),
      child: Row(
        children: [
          Text(
            'Thrown Darts per Leg',
            style: TextStyle(
                fontSize: FONTSIZE_IN_GAME_SETTINGS.sp, color: Colors.white),
          ),
          Spacer(),
          Selector<GameSettingsX01, bool>(
            selector: (_, gameSettingsX01) =>
                gameSettingsX01.getShowThrownDartsPerLeg,
            builder: (_, showThrownDartsPerLeg, __) => Switch(
              value: showThrownDartsPerLeg,
              onChanged: (value) {
                gameSettingsX01.setShowThrownDartsPerLeg = value;
                gameSettingsX01.notify();
              },
              thumbColor: MaterialStateProperty.all(
                  Theme.of(context).colorScheme.secondary),
              activeColor: Theme.of(context).colorScheme.secondary,
              inactiveThumbColor: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ],
      ),
    );
  }
}
