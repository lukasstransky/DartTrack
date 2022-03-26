import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:sizer/sizer.dart';

final GlobalKey<FormState> _formKeyLegDifference = GlobalKey<FormState>();

class WinByTwoLegsDifference extends StatelessWidget {
  const WinByTwoLegsDifference({Key? key}) : super(key: key);

  void showDialogForSuddenDeath(
      BuildContext context, GameSettingsX01 GameSettingsX01) {
    final deviceSize = MediaQuery.of(context).size;

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => Form(
        key: _formKeyLegDifference,
        child: AlertDialog(
          title: const Text("Sudden Death"),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.only(right: deviceSize.width * 0.03),
                        child: Tooltip(
                          child: Icon(
                            Icons.info_outline,
                            color: Colors.grey,
                          ),
                          margin: const EdgeInsets.all(15.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.blue,
                          ),
                          textStyle: const TextStyle(
                            fontSize: 24,
                          ),
                          message: SUDDEN_DEATH_INFO,
                          preferBelow: false,
                        ),
                      ),
                      const Text("Enable Sudden Death"),
                      Switch(
                        value: GameSettingsX01.getSuddenDeath,
                        onChanged: (value) {
                          setState(() {
                            GameSettingsX01.setSuddenDeath = value;
                          });
                        },
                      ),
                    ],
                  ),
                  if (GameSettingsX01.getSuddenDeath == true)
                    Row(
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.only(right: deviceSize.width * 0.03),
                          child: Tooltip(
                            child: Icon(
                              Icons.info_outline,
                              color: Colors.grey,
                            ),
                            margin: const EdgeInsets.all(15.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.blue,
                            ),
                            textStyle: const TextStyle(
                              fontSize: 24,
                            ),
                            message: SUDDEN_DEATH_LEG_DIFFERENCE_INFO,
                            preferBelow: false,
                          ),
                        ),
                        const Text("after max. Legs"),
                        NumberPicker(
                          value: GameSettingsX01.getMaxExtraLegs,
                          itemCount: 1,
                          minValue: 1,
                          maxValue: MAX_EXTRA_LEGS,
                          onChanged: (value) {
                            setState(() {
                              GameSettingsX01.setMaxExtraLegs = value;
                            });
                          },
                        ),
                      ],
                    ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => {
                GameSettingsX01.switchWinByTwoLegsDifference(false),
                Navigator.of(context).pop(),
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gameSettingsX01 =
        Provider.of<GameSettingsX01>(context, listen: false);

    return Container(
      width: WIDTH_GAMESETTINGS.w,
      margin: EdgeInsets.only(top: MARGIN_GAMESETTINGS.h),
      child: Selector<GameSettingsX01, bool>(
        selector: (_, gameSettingsX01) =>
            gameSettingsX01.getWinByTwoLegsDifference,
        builder: (_, winByTwoLegsDifference, __) => SizedBox(
          height: HEIGHT_GAMESETTINGS_WIDGETS.h,
          child: Row(
            children: [
              const Text("Win by Two Legs Difference"),
              Switch(
                value: winByTwoLegsDifference,
                onChanged: (value) {
                  gameSettingsX01.switchWinByTwoLegsDifference(value);
                  if (winByTwoLegsDifference == false)
                    showDialogForSuddenDeath(context, gameSettingsX01);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
