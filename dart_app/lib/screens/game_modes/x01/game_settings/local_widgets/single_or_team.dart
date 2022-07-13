import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class SingleOrTeam extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final gameSettingsX01 =
        Provider.of<GameSettingsX01>(context, listen: false);

    return Center(
      child: Container(
        width: WIDTH_GAMESETTINGS.w,
        margin: EdgeInsets.only(top: MARGIN_GAMESETTINGS.h),
        child: Selector<GameSettingsX01, SingleOrTeamEnum>(
          selector: (_, gameSettingsX01) => gameSettingsX01.getSingleOrTeam,
          builder: (_, singleOrTeam, __) => Row(
            children: [
              Expanded(
                child: Container(
                  height: WIDGET_HEIGHT_GAMESETTINGS.h,
                  child: ElevatedButton(
                    onPressed: () => singleOrTeam == SingleOrTeamEnum.Team
                        ? gameSettingsX01.switchSingleOrTeamMode()
                        : null,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: const Text('Single'),
                    ),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(BUTTON_BORDER_RADIUS),
                            bottomLeft: Radius.circular(BUTTON_BORDER_RADIUS),
                          ),
                        ),
                      ),
                      backgroundColor: singleOrTeam == SingleOrTeamEnum.Single
                          ? Utils.getColor(
                              Theme.of(context).colorScheme.primary)
                          : Utils.getColor(Colors.grey),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: WIDGET_HEIGHT_GAMESETTINGS.h,
                  child: ElevatedButton(
                    onPressed: () => singleOrTeam == SingleOrTeamEnum.Single
                        ? gameSettingsX01.switchSingleOrTeamMode()
                        : null,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: const Text('Teams'),
                    ),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(BUTTON_BORDER_RADIUS),
                            bottomRight: Radius.circular(BUTTON_BORDER_RADIUS),
                          ),
                        ),
                      ),
                      backgroundColor: singleOrTeam == SingleOrTeamEnum.Team
                          ? Utils.getColor(
                              Theme.of(context).colorScheme.primary)
                          : Utils.getColor(Colors.grey),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
