import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class SingleOrDoubleIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final gameSettingsX01 =
        Provider.of<GameSettingsX01>(context, listen: false);

    return Center(
      child: Container(
        width: WIDTH_GAMESETTINGS.w,
        margin: EdgeInsets.only(top: MARGIN_GAMESETTINGS.h),
        child: Selector<GameSettingsX01, SingleOrDouble>(
          selector: (_, gameSettingsX01) => gameSettingsX01.getModeIn,
          builder: (_, modeIn, __) => Row(
            children: [
              Expanded(
                child: Container(
                  height: WIDGET_HEIGHT_GAMESETTINGS.h,
                  child: ElevatedButton(
                    onPressed: () => modeIn == SingleOrDouble.DoubleField
                        ? gameSettingsX01.switchSingleOrDoubleIn()
                        : null,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: const Text('Single In'),
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
                      backgroundColor: modeIn == SingleOrDouble.DoubleField
                          ? Utils.getColor(Colors.grey)
                          : Utils.getColor(
                              Theme.of(context).colorScheme.primary),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: WIDGET_HEIGHT_GAMESETTINGS.h,
                  child: ElevatedButton(
                    onPressed: () => modeIn == SingleOrDouble.SingleField
                        ? gameSettingsX01.switchSingleOrDoubleIn()
                        : null,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: const Text('Double In'),
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
                      backgroundColor: modeIn == SingleOrDouble.SingleField
                          ? Utils.getColor(Colors.grey)
                          : Utils.getColor(
                              Theme.of(context).colorScheme.primary),
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
