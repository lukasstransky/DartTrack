import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class BestOfOrFirstTo extends StatelessWidget {
  const BestOfOrFirstTo({
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
        child: Selector<GameSettingsX01, BestOfOrFirstToEnum>(
          selector: (_, gameSettingsX01) => gameSettingsX01.getMode,
          builder: (_, mode, __) => Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: HEIGHT_GAMESETTINGS_WIDGETS.h,
                  child: ElevatedButton(
                    onPressed: () => mode == BestOfOrFirstToEnum.FirstTo
                        ? gameSettingsX01.switchBestOfOrFirstTo()
                        : null,
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: const Text("Best Of"),
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
                      backgroundColor: mode == BestOfOrFirstToEnum.BestOf
                          ? MaterialStateProperty.all(
                              Theme.of(context).colorScheme.primary)
                          : MaterialStateProperty.all<Color>(Colors.grey),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: HEIGHT_GAMESETTINGS_WIDGETS.h,
                  child: ElevatedButton(
                    onPressed: () => mode == BestOfOrFirstToEnum.BestOf
                        ? gameSettingsX01.switchBestOfOrFirstTo()
                        : null,
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: const Text("First To"),
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
                      backgroundColor: mode == BestOfOrFirstToEnum.FirstTo
                          ? MaterialStateProperty.all(
                              Theme.of(context).colorScheme.primary)
                          : MaterialStateProperty.all<Color>(Colors.grey),
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
