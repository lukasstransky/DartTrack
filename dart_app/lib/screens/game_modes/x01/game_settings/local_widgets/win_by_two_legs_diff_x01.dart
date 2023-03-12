import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

final GlobalKey<FormState> _formKeyLegDifference = GlobalKey<FormState>();

class WinByTwoLegsDifferenceX01 extends StatelessWidget {
  _showDialogForSuddenDeath(
      BuildContext context, GameSettingsX01_P gameSettingsX01) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => Form(
        key: _formKeyLegDifference,
        child: AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.primary,
          contentPadding: dialogContentPadding,
          title: const Text(
            'Sudden death',
            style: TextStyle(color: Colors.white),
          ),
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
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          textStyle: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                          message: SUDDEN_DEATH_INFO,
                          preferBelow: false,
                        ),
                      ),
                      const Text(
                        'Enable sudden death',
                        style: TextStyle(color: Colors.white),
                      ),
                      Switch(
                        thumbColor: MaterialStateProperty.all(
                            Theme.of(context).colorScheme.secondary),
                        activeColor: Theme.of(context).colorScheme.secondary,
                        inactiveThumbColor:
                            Theme.of(context).colorScheme.secondary,
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
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            textStyle: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                            message: SUDDEN_DEATH_LEG_DIFFERENCE_INFO,
                            preferBelow: false,
                          ),
                        ),
                        const Text(
                          'After max. legs',
                          style: TextStyle(color: Colors.white),
                        ),
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
                                    ? Theme.of(context).colorScheme.secondary
                                    : Theme.of(context).colorScheme.primary),
                          ),
                        ),
                        Container(
                          width: 5.w,
                          child: Center(
                            child: Text(
                              gameSettingsX01.getMaxExtraLegs.toString(),
                              style: TextStyle(
                                fontSize: 18.sp,
                                color: Colors.white,
                              ),
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
                                  ? Theme.of(context).colorScheme.secondary
                                  : Theme.of(context).colorScheme.primary),
                        ),
                      ],
                    ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                _resetWinByTwoLegsDifference(gameSettingsX01);
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.secondary),
              ),
              style: ButtonStyle(
                backgroundColor:
                    Utils.getPrimaryMaterialStateColorDarken(context),
              ),
            ),
            TextButton(
              onPressed: () {
                _submitWinByTwoLegsDifference(gameSettingsX01);
                Navigator.of(context).pop();
              },
              child: Text(
                'Submit',
                style:
                    TextStyle(color: Theme.of(context).colorScheme.secondary),
              ),
              style: ButtonStyle(
                backgroundColor:
                    Utils.getPrimaryMaterialStateColorDarken(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _resetWinByTwoLegsDifference(GameSettingsX01_P gameSettingsX01) {
    gameSettingsX01.setWinByTwoLegsDifference = false;
    gameSettingsX01.setSuddenDeath = false;
    gameSettingsX01.setMaxExtraLegs = STANDARD_MAX_EXTRA_LEGS;

    gameSettingsX01.notify();
  }

  _submitWinByTwoLegsDifference(GameSettingsX01_P gameSettingsX01) {
    gameSettingsX01.setWinByTwoLegsDifference = true;

    gameSettingsX01.notify();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameSettingsX01_P>(
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
                    Text(
                      'Win by two legs difference',
                      style: TextStyle(
                        color: Utils.getTextColorForGameSettingsPage(),
                      ),
                    ),
                    Switch(
                      thumbColor: MaterialStateProperty.all(
                          Theme.of(context).colorScheme.secondary),
                      activeColor: Theme.of(context).colorScheme.secondary,
                      inactiveThumbColor:
                          Theme.of(context).colorScheme.secondary,
                      value: gameSettingsX01.getWinByTwoLegsDifference,
                      onChanged: (value) {
                        if (value) {
                          _showDialogForSuddenDeath(context, gameSettingsX01);
                        } else {
                          _resetWinByTwoLegsDifference(gameSettingsX01);
                        }
                      },
                    ),
                  ],
                ),
                if (gameSettingsX01.getSuddenDeath)
                  Container(
                    transform: Matrix4.translationValues(0.0, -1.h, 0.0),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '(Sudden death leg after max. ${gameSettingsX01.getMaxExtraLegs} additional ' +
                          (gameSettingsX01.getMaxExtraLegs == 1
                              ? 'leg)'
                              : 'legs)'),
                      style: TextStyle(
                        fontSize: 8.sp,
                        color: Colors.white70,
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
