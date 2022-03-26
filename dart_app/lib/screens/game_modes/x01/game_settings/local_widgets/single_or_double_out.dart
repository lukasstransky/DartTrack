import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class SingleOrDoubleOut extends StatelessWidget {
  const SingleOrDoubleOut({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameSettingsX01 =
        Provider.of<GameSettingsX01>(context, listen: false);

    return Center(
      child: Container(
        width: WIDTH_GAMESETTINGS.w,
        margin: EdgeInsets.only(top: MARGIN_GAMESETTINGS.h),
        child: Selector<GameSettingsX01, SingleOrDouble>(
          selector: (_, gameSettingsX01) => gameSettingsX01.getModeOut,
          builder: (_, modeOut, __) => Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: HEIGHT_GAMESETTINGS_WIDGETS.h,
                  child: ElevatedButton(
                    onPressed: () => modeOut == SingleOrDouble.DoubleField
                        ? gameSettingsX01.switchSingleOrDoubleOut()
                        : null,
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: const Text("Single Out"),
                    ),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            bottomLeft: Radius.circular(10.0),
                          ),
                        ),
                      ),
                      backgroundColor: modeOut == SingleOrDouble.DoubleField
                          ? MaterialStateProperty.all<Color>(Colors.grey)
                          : MaterialStateProperty.all(
                              Theme.of(context).colorScheme.primary),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: HEIGHT_GAMESETTINGS_WIDGETS.h,
                  child: ElevatedButton(
                    onPressed: () => modeOut == SingleOrDouble.SingleField
                        ? gameSettingsX01.switchSingleOrDoubleOut()
                        : null,
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: const Text("Double Out"),
                    ),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                          ),
                        ),
                      ),
                      backgroundColor: modeOut == SingleOrDouble.SingleField
                          ? MaterialStateProperty.all<Color>(Colors.grey)
                          : MaterialStateProperty.all(
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
