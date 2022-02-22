import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:sizer/sizer.dart';

class SetsLegsWidget extends StatelessWidget {
  const SetsLegsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: WIDTH_GAMESETTINGS.w,
        margin: EdgeInsets.only(top: MARGIN_GAMESETTINGS.h),
        child: Consumer<GameSettingsX01>(
          builder: (_, gameSettingsX01, __) => Row(
            children: [
              Expanded(
                child: NumberPicker(
                  itemHeight: HEIGHT_GAMESETTINGS_WIDGETS.h,
                  value: gameSettingsX01.getSets,
                  itemCount: gameSettingsX01.getSetsEnabled ? 1 : 0,
                  minValue: 1,
                  step: 2,
                  maxValue: MAX_SETS,
                  onChanged: (value) {
                    gameSettingsX01.setSets = value;
                  },
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: HEIGHT_GAMESETTINGS_WIDGETS.h,
                  child: ElevatedButton(
                    onPressed: () => gameSettingsX01.setsClicked(),
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: const Text("Sets"),
                    ),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            bottomLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                          ),
                        ),
                      ),
                      backgroundColor: gameSettingsX01.getSetsEnabled == true
                          ? MaterialStateProperty.all(
                              Theme.of(context).colorScheme.primary)
                          : MaterialStateProperty.all<Color>(Colors.grey),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: NumberPicker(
                  itemHeight: HEIGHT_GAMESETTINGS_WIDGETS.h,
                  value: gameSettingsX01.getLegs,
                  itemCount: 1,
                  minValue: 1,
                  maxValue: MAX_LEGS,
                  onChanged: (value) => gameSettingsX01.setLegs = value,
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: HEIGHT_GAMESETTINGS_WIDGETS.h,
                  child: ElevatedButton(
                    onPressed: () => gameSettingsX01.legsClicked(),
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: const Text("Legs"),
                    ),
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                            topLeft: Radius.circular(10.0),
                            bottomLeft: Radius.circular(10.0),
                          ),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all(
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
