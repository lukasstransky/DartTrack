import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class SingleOrDoubleInWidget extends StatelessWidget {
  const SingleOrDoubleInWidget({
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
          selector: (_, gameSettingsX01) => gameSettingsX01.getModeIn,
          builder: (_, modeIn, __) => Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: HEIGHT_GAMESETTINGS_WIDGETS.h,
                  child: ElevatedButton(
                    onPressed: () => modeIn == SingleOrDouble.DoubleField
                        ? gameSettingsX01.switchSingleOrDoubleIn()
                        : null,
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: const Text("Single In"),
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
                      backgroundColor: modeIn == SingleOrDouble.DoubleField
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
                    onPressed: () => modeIn == SingleOrDouble.SingleField
                        ? gameSettingsX01.switchSingleOrDoubleIn()
                        : null,
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: const Text("Double In"),
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
                      backgroundColor: modeIn == SingleOrDouble.SingleField
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
