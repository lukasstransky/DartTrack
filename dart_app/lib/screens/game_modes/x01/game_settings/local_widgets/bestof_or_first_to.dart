import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class BestOfOrFirstTo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final gameSettingsX01 =
        Provider.of<GameSettingsX01>(context, listen: false);

    return Center(
      child: Container(
        width: WIDTH_GAMESETTINGS.w,
        margin: EdgeInsets.only(top: MARGIN_GAMESETTINGS.h),
        child: Selector<GameSettingsX01, BestOfOrFirstToEnum>(
          selector: (_, gameSettingsX01) => gameSettingsX01.getMode,
          builder: (_, mode, __) => Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: WIDGET_HEIGHT_GAMESETTINGS.h,
                  child: ElevatedButton(
                    onPressed: () => mode == BestOfOrFirstToEnum.FirstTo
                        ? gameSettingsX01.switchBestOfOrFirstTo()
                        : null,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: const Text('Best Of'),
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
                      backgroundColor: mode == BestOfOrFirstToEnum.BestOf
                          ? Utils.getColor(
                              Theme.of(context).colorScheme.primary)
                          : Utils.getColor(Colors.grey),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: WIDGET_HEIGHT_GAMESETTINGS.h,
                  child: ElevatedButton(
                    onPressed: () => mode == BestOfOrFirstToEnum.BestOf
                        ? gameSettingsX01.switchBestOfOrFirstTo()
                        : null,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: const Text('First To'),
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
                      backgroundColor: mode == BestOfOrFirstToEnum.FirstTo
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
