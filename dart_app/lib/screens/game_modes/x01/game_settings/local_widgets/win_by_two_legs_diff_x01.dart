import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

final GlobalKey<FormState> _formKeyLegDifference = GlobalKey<FormState>();

class WinByTwoLegsDifferenceX01 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GameSettingsX01_P gameSettingsX01 = context.read<GameSettingsX01_P>();

    return Selector<GameSettingsX01_P, SelectorModel>(
      selector: (_, gameSettingsX01) => SelectorModel(
        drawMode: gameSettingsX01.getDrawMode,
        legs: gameSettingsX01.getLegs,
        maxExtraLegs: gameSettingsX01.getMaxExtraLegs,
        setsEnabled: gameSettingsX01.getSetsEnabled,
        suddenDeath: gameSettingsX01.getSuddenDeath,
        winByTwoLegsDifference: gameSettingsX01.getWinByTwoLegsDifference,
      ),
      builder: (_, selectorModel, __) {
        if (selectorModel.legs > 1 && !selectorModel.drawMode) {
          return Container(
            margin: EdgeInsets.only(top: MARGIN_GAMESETTINGS.h),
            width: WIDTH_GAMESETTINGS.w,
            child: Column(
              children: [
                Row(
                  children: [
                    const Text(
                      'Win by two legs difference',
                      style: TextStyle(color: Colors.white),
                    ),
                    Switch(
                      thumbColor: MaterialStateProperty.all(
                          Theme.of(context).colorScheme.secondary),
                      activeColor: Theme.of(context).colorScheme.secondary,
                      inactiveThumbColor:
                          Theme.of(context).colorScheme.secondary,
                      value: selectorModel.winByTwoLegsDifference,
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
                if (selectorModel.suddenDeath)
                  Container(
                    transform: Matrix4.translationValues(0.0, -1.h, 0.0),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '(Sudden death leg after max. ${selectorModel.maxExtraLegs} additional ' +
                          (selectorModel.maxExtraLegs == 1 ? 'leg)' : 'legs)'),
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

_showDialogForSuddenDeath(
    BuildContext context, GameSettingsX01_P gameSettingsX01) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => Form(
      key: _formKeyLegDifference,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(DIALOG_SHAPE_ROUNDING),
        ),
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
                    IconButton(
                      icon: Icon(
                        Icons.info_outline,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      onPressed: () => _showInfoDialogForSuddenDeath(context),
                    ),
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: const Text(
                          'Enable sudden death',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
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
                if (gameSettingsX01.getSuddenDeath)
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.info_outline,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        onPressed: () =>
                            _showInfoDialogForMaxExtraLegs(context),
                      ),
                      Flexible(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: const Text(
                            'After max. legs',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 3.w),
                        child: IconButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onPressed: () {
                            setState(() {
                              if (gameSettingsX01.getMaxExtraLegs == 1) return;
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
                        width: 10.w,
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
                          if (gameSettingsX01.getMaxExtraLegs >= MAX_EXTRA_LEGS)
                            return;
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
              Navigator.of(context).pop();
              _resetWinByTwoLegsDifference(gameSettingsX01);
            },
            child: Text(
              'Cancel',
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
            style: ButtonStyle(
              splashFactory: NoSplash.splashFactory,
              shadowColor: MaterialStateProperty.all(Colors.transparent),
              overlayColor: MaterialStateProperty.all(Colors.transparent),
              backgroundColor:
                  Utils.getPrimaryMaterialStateColorDarken(context),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(DIALOG_BTN_SHAPE_ROUNDING),
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              _submitWinByTwoLegsDifference(gameSettingsX01);
              Navigator.of(context).pop();
            },
            child: Text(
              'Submit',
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
            style: ButtonStyle(
              splashFactory: NoSplash.splashFactory,
              shadowColor: MaterialStateProperty.all(Colors.transparent),
              overlayColor: MaterialStateProperty.all(Colors.transparent),
              backgroundColor:
                  Utils.getPrimaryMaterialStateColorDarken(context),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(DIALOG_BTN_SHAPE_ROUNDING),
                ),
              ),
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

_showInfoDialogForSuddenDeath(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DIALOG_SHAPE_ROUNDING),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      contentPadding: dialogContentPadding,
      title: Text(
        'Information',
        style: TextStyle(color: Colors.white),
      ),
      content: Text(
        SUDDEN_DEATH_INFO,
        style: TextStyle(color: Colors.white),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Continue',
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
          ),
          style: ButtonStyle(
            splashFactory: NoSplash.splashFactory,
            shadowColor: MaterialStateProperty.all(Colors.transparent),
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            backgroundColor: Utils.getPrimaryMaterialStateColorDarken(context),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(DIALOG_BTN_SHAPE_ROUNDING),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

_showInfoDialogForMaxExtraLegs(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DIALOG_SHAPE_ROUNDING),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      contentPadding: dialogContentPadding,
      title: Text(
        'Information',
        style: TextStyle(color: Colors.white),
      ),
      content: Text(
        SUDDEN_DEATH_LEG_DIFFERENCE_INFO,
        style: TextStyle(color: Colors.white),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'Continue',
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
          ),
          style: ButtonStyle(
            splashFactory: NoSplash.splashFactory,
            shadowColor: MaterialStateProperty.all(Colors.transparent),
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            backgroundColor: Utils.getPrimaryMaterialStateColorDarken(context),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(DIALOG_BTN_SHAPE_ROUNDING),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class SelectorModel {
  final bool setsEnabled;
  final int legs;
  final bool drawMode;
  final bool winByTwoLegsDifference;
  final bool suddenDeath;
  final int maxExtraLegs;

  SelectorModel({
    required this.setsEnabled,
    required this.legs,
    required this.drawMode,
    required this.winByTwoLegsDifference,
    required this.suddenDeath,
    required this.maxExtraLegs,
  });
}
