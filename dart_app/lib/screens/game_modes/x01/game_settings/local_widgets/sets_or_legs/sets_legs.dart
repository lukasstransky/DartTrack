import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/screens/game_modes/x01/game_settings/local_widgets/sets_or_legs/local_widgets/legs_amount.dart';
import 'package:dart_app/screens/game_modes/x01/game_settings/local_widgets/sets_or_legs/local_widgets/sets_amount.dart';
import 'package:dart_app/screens/game_modes/x01/game_settings/local_widgets/sets_or_legs/local_widgets/sets_btn.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class SetsLegs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: WIDTH_GAMESETTINGS.w,
        margin: EdgeInsets.only(top: MARGIN_GAMESETTINGS.h),
        child: Row(
          children: [
            Selector<GameSettingsX01_P, bool>(
              selector: (_, gameSettingsX01) => gameSettingsX01.getSetsEnabled,
              builder: (_, setsEnabled, __) =>
                  setsEnabled ? SetsAmount() : SizedBox.shrink(),
            ),
            SetsBtn(),
            LegsAmount(),
          ],
        ),
      ),
    );
  }
}
