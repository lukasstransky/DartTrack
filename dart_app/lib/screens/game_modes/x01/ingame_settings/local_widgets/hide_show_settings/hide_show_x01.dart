import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/models/games/x01/game_x01_p.dart';
import 'package:dart_app/screens/game_modes/x01/ingame_settings/local_widgets/hide_show_settings/local_widgets/hide_show_average_x01.dart';
import 'package:dart_app/screens/game_modes/x01/ingame_settings/local_widgets/hide_show_settings/local_widgets/hide_show_finish_ways_x01.dart';
import 'package:dart_app/screens/game_modes/x01/ingame_settings/local_widgets/hide_show_settings/local_widgets/hide_show_last_throw_x01.dart';
import 'package:dart_app/screens/game_modes/x01/ingame_settings/local_widgets/hide_show_settings/local_widgets/hide_show_throw_darts_x01.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class HideShowX01 extends StatelessWidget {
  const HideShowX01({Key? key}) : super(key: key);

  bool _showOtherOptions(BuildContext context) {
    final GameSettingsX01_P gameSettingsX01 = context.read<GameSettingsX01_P>();
    final GameX01_P gameX01 = context.read<GameX01_P>();
    final bool isSingleMode =
        gameSettingsX01.getSingleOrTeam == SingleOrTeamEnum.Single;

    return (isSingleMode && gameSettingsX01.getPlayers.length == 2) ||
        (!isSingleMode && gameSettingsX01.getTeams.length == 2) ||
        !gameX01.getInit;
  }

  @override
  Widget build(BuildContext context) {
    final bool showOtherOptions = _showOtherOptions(context);

    return Container(
      height: showOtherOptions ? 23.5.h : 19.h,
      padding: EdgeInsets.only(
        top: 1.0.h,
        left: 0.5.w,
        right: 0.5.w,
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(CARD_SHAPE_ROUNDING),
        ),
        elevation: 5,
        margin: EdgeInsets.all(0),
        color: Utils.darken(Theme.of(context).colorScheme.primary, 10),
        child: Column(
          children: [
            Container(
              height: 5.h,
              padding: EdgeInsets.only(left: 1.5.w),
              alignment: Alignment.centerLeft,
              child: Text(
                'Hide/Show',
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.titleLarge!.fontSize,
                  color: Utils.getTextColorDarken(context),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (showOtherOptions) HideShowFinishWaysX01(),
            HideShowAverageX01(),
            HideShowLastThrowX01(),
            HideShowThrownDartsX01(),
          ],
        ),
      ),
    );
  }
}
