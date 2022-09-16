import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

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
          contentPadding: EdgeInsets.only(
              bottom: DIALOG_CONTENT_PADDING_BOTTOM,
              top: DIALOG_CONTENT_PADDING_TOP,
              left: DIALOG_CONTENT_PADDING_LEFT,
              right: DIALOG_CONTENT_PADDING_RIGHT),
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
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          textStyle: const TextStyle(
                            fontSize: 18,
                          ),
                          message: SUDDEN_DEATH_INFO,
                          preferBelow: false,
                        ),
                      ),
                      const Text('enable Sudden Death'),
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
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            textStyle: const TextStyle(
                              fontSize: 18,
                            ),
                            message: SUDDEN_DEATH_LEG_DIFFERENCE_INFO,
                            preferBelow: false,
                          ),
                        ),
                        const Text('after max. Legs'),
                        Padding(
                          padding: EdgeInsets.only(left: 3.w),
                          child: IconButton(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onPressed: () {
                              setState(() {
                                if (gameSettingsX01.getMaxExtraLegs == 1)
                                  return;
                                gameSettingsX01.setMaxExtraLegs =
                                    gameSettingsX01.getMaxExtraLegs - 1;
                                ;
                              });
                            },
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                            icon: Icon(Icons.remove,
                                color: gameSettingsX01.getMaxExtraLegs > 1
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.grey),
                          ),
                        ),
                        Container(
                          width: 5.w,
                          child: Center(
                            child: Text(
                              gameSettingsX01.getMaxExtraLegs.toString(),
                              style: TextStyle(fontSize: 18.sp),
                            ),
                          ),
                        ),
                        IconButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onPressed: () {
                            if (gameSettingsX01.getMaxExtraLegs >=
                                MAX_EXTRA_LEGS) return;
                            setState(() {
                              gameSettingsX01.setMaxExtraLegs =
                                  gameSettingsX01.getMaxExtraLegs + 1;
                              ;
                            });
                          },
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          icon: Icon(Icons.add,
                              color: gameSettingsX01.getMaxExtraLegs !=
                                      MAX_EXTRA_LEGS
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.grey),
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
                gameSettingsX01.notify(),
                Navigator.of(context).pop(),
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => {
                gameSettingsX01.switchWinByTwoLegsDifference(true),
                gameSettingsX01.notify(),
                Navigator.of(context).pop(),
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameSettingsX01>(
      builder: (_, gameSettingsX01, __) {
        if (!gameSettingsX01.getSetsEnabled &&
            gameSettingsX01.getLegs > 1 &&
            !gameSettingsX01.getDrawMode) {
          return Container(
            margin: EdgeInsets.only(top: MARGIN_GAMESETTINGS.h),
            width: WIDTH_GAMESETTINGS.w,
            child: Column(
              children: [
                Row(
                  children: [
                    const Text('Win by Two Legs Difference'),
                    Switch(
                      value: gameSettingsX01.getWinByTwoLegsDifference,
                      onChanged: (value) {
                        if (value) {
                          showDialogForSuddenDeath(context, gameSettingsX01);
                        } else {
                          gameSettingsX01.switchWinByTwoLegsDifference(value);
                        }
                      },
                    ),
                  ],
                ),
                if (gameSettingsX01.getSuddenDeath)
                  Container(
                    transform: Matrix4.translationValues(0.0, -1.h, 0.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '(Sudden Death Leg after max. ${gameSettingsX01.getMaxExtraLegs} additional Legs)',
                        style: TextStyle(fontSize: 8.sp),
                      ),
                    ),
                  ),
              ],
            ),
          );
        }
        return SizedBox.shrink();
      },
    );
  }
}
