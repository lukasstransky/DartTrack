import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:sizer/sizer.dart';
import 'package:tuple/tuple.dart';

final GlobalKey<FormState> _formKeyLegDifference = GlobalKey<FormState>();

class WinByTwoLegsDifference extends StatelessWidget {
  void showDialogForSuddenDeath(
      BuildContext context, GameSettingsX01 gameSettingsX01) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => Form(
        key: _formKeyLegDifference,
        child: AlertDialog(
          title: const Text('Sudden Death'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 1.w),
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
                      const Text('Enable Sudden Death'),
                      Switch(
                        value: gameSettingsX01.getSuddenDeath,
                        onChanged: (value) {
                          setState(() {
                            gameSettingsX01.setSuddenDeath = value;
                          });
                        },
                      ),
                    ],
                  ),
                  if (gameSettingsX01.getSuddenDeath == true)
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 1.w),
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
                        const Text('after max. Legs'),
                        NumberPicker(
                          value: gameSettingsX01.getMaxExtraLegs,
                          itemCount: 1,
                          minValue: 1,
                          maxValue: MAX_EXTRA_LEGS,
                          onChanged: (value) {
                            setState(() {
                              gameSettingsX01.setMaxExtraLegs = value;
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
                gameSettingsX01.switchWinByTwoLegsDifference(false),
                Navigator.of(context).pop(),
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Submit'),
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

    return Selector<GameSettingsX01,
            Tuple4<bool, BestOfOrFirstToEnum, int, bool>>(
        selector: (_, gameSettingsX01) => Tuple4(
            gameSettingsX01.getSetsEnabled,
            gameSettingsX01.getMode,
            gameSettingsX01.getLegs,
            gameSettingsX01.getWinByTwoLegsDifference),
        builder: (_, tuple, __) {
          if (tuple.item1 == false &&
              tuple.item2 == BestOfOrFirstToEnum.FirstTo &&
              tuple.item3 > 1) {
            return Container(
              width: WIDTH_GAMESETTINGS.w,
              margin: EdgeInsets.only(top: MARGIN_GAMESETTINGS.h),
              child: Container(
                height: WIDGET_HEIGHT_GAMESETTINGS.h,
                child: Row(
                  children: [
                    const Text('Win by Two Legs Difference'),
                    Switch(
                      value: tuple.item4,
                      onChanged: (value) {
                        gameSettingsX01.switchWinByTwoLegsDifference(value);
                        if (!tuple.item4)
                          showDialogForSuddenDeath(context, gameSettingsX01);
                      },
                    ),
                  ],
                ),
              ),
            );
          }
          return SizedBox.shrink();
        });
  }
}
