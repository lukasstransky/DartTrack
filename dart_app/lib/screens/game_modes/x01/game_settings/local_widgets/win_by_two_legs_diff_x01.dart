import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/utils/button_styles.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

final GlobalKey<FormState> _formKeyLegDifference = GlobalKey<FormState>();

class WinByTwoLegsDifferenceX01 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GameSettingsX01_P gameSettingsX01 = context.read<GameSettingsX01_P>();
    final double scaleFactorSwitch = Utils.getSwitchScaleFactor(context);
    final double textSwitchSpace = Utils.getResponsiveValue(
      context: context,
      mobileValue: 0,
      tabletValue: TEXT_SWITCH_SPACE_TABLET,
    );
    final double paddingTop = Utils.getResponsiveValue(
      context: context,
      mobileValue: 1,
      tabletValue: 2,
    );

    return Selector<GameSettingsX01_P, SelectorModel>(
      selector: (_, gameSettingsX01) => SelectorModel(
        drawMode: gameSettingsX01.getDrawMode,
        legs: gameSettingsX01.getLegs,
        maxExtraLegs: gameSettingsX01.getMaxExtraLegs,
        suddenDeath: gameSettingsX01.getSuddenDeath,
        winByTwoLegsDifference: gameSettingsX01.getWinByTwoLegsDifference,
        setsEnabled: gameSettingsX01.getSetsEnabled,
      ),
      builder: (_, selectorModel, __) {
        final bool disableSwitch = selectorModel.legs == 1 ||
            selectorModel.drawMode ||
            selectorModel.setsEnabled;

        return Container(
          padding: EdgeInsets.only(top: paddingTop.h),
          width: WIDTH_GAMESETTINGS.w,
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Win by two legs difference',
                    style: TextStyle(
                      color: disableSwitch ? Colors.white70 : Colors.white,
                      fontSize:
                          Theme.of(context).textTheme.bodyMedium!.fontSize,
                    ),
                  ),
                  SizedBox(
                    width: textSwitchSpace.w,
                  ),
                  Transform.scale(
                    scale: scaleFactorSwitch,
                    child: Switch(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      thumbColor: disableSwitch
                          ? MaterialStateProperty.all(Colors.grey)
                          : MaterialStateProperty.all(
                              Theme.of(context).colorScheme.secondary),
                      value: selectorModel.winByTwoLegsDifference,
                      onChanged: (value) {
                        if (disableSwitch) {
                          String msg = '';
                          if (selectorModel.legs == 1) {
                            msg = 'At least 2 legs are required!';
                          } else if (selectorModel.setsEnabled) {
                            msg = 'Not possible with set mode enabled!';
                          } else {
                            msg = 'Not possible with draw mode enabled!';
                          }
                          Fluttertoast.showToast(
                            msg: msg,
                            toastLength: Toast.LENGTH_LONG,
                            fontSize: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .fontSize!,
                          );
                          return;
                        }

                        Utils.handleVibrationFeedback(context);
                        if (value) {
                          _showDialogForSuddenDeath(context, gameSettingsX01);
                        } else {
                          _resetWinByTwoLegsDifference(gameSettingsX01);
                        }
                      },
                    ),
                  ),
                ],
              ),
              if (selectorModel.suddenDeath)
                Container(
                  transform: Matrix4.translationValues(0.0, -0.5.h, 0.0),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '(Sudden death leg after max. ${selectorModel.maxExtraLegs} additional ' +
                        (selectorModel.maxExtraLegs == 1 ? 'leg)' : 'legs)'),
                    style: TextStyle(
                      fontSize: 9.sp,
                      color: Colors.white70,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

_showDialogForSuddenDeath(
    BuildContext context, GameSettingsX01_P gameSettingsX01) {
  final double scaleFactorSwitch = Utils.getSwitchScaleFactor(context);
  final double textSwitchSpace = Utils.getResponsiveValue(
    context: context,
    mobileValue: 0,
    tabletValue: TEXT_SWITCH_SPACE_TABLET,
  );

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
        contentPadding:
            Utils.isMobile(context) ? DIALOG_CONTENT_PADDING_MOBILE : null,
        title: Text(
          'Sudden death',
          style: TextStyle(
            color: Colors.white,
            fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
          ),
        ),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    IconButton(
                      splashRadius: SPLASH_RADIUS,
                      splashColor: Utils.darken(
                          Theme.of(context).colorScheme.primary, 10),
                      highlightColor: Utils.darken(
                          Theme.of(context).colorScheme.primary, 10),
                      icon: Icon(
                        size: ICON_BUTTON_SIZE.h,
                        Icons.info_outline,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      onPressed: () {
                        Utils.handleVibrationFeedback(context);
                        _showInfoDialogForSuddenDeath(context);
                      },
                    ),
                    SizedBox(
                      width: textSwitchSpace.w,
                    ),
                    Flexible(
                      child: Text(
                        'Enable sudden death',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize:
                              Theme.of(context).textTheme.bodyMedium!.fontSize,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: textSwitchSpace.w,
                    ),
                    Transform.scale(
                      scale: scaleFactorSwitch,
                      child: Switch(
                        thumbColor: MaterialStateProperty.all(
                            Theme.of(context).colorScheme.secondary),
                        activeColor: Theme.of(context).colorScheme.secondary,
                        inactiveThumbColor:
                            Theme.of(context).colorScheme.secondary,
                        value: gameSettingsX01.getSuddenDeath,
                        onChanged: (value) {
                          Utils.handleVibrationFeedback(context);
                          setState(() {
                            gameSettingsX01.setSuddenDeath = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                if (gameSettingsX01.getSuddenDeath)
                  Row(
                    children: [
                      IconButton(
                        splashRadius: SPLASH_RADIUS,
                        splashColor: Utils.darken(
                            Theme.of(context).colorScheme.primary, 10),
                        highlightColor: Utils.darken(
                            Theme.of(context).colorScheme.primary, 10),
                        icon: Icon(
                          size: ICON_BUTTON_SIZE.h,
                          Icons.info_outline,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        onPressed: () {
                          Utils.handleVibrationFeedback(context);
                          _showInfoDialogForMaxExtraLegs(context);
                        },
                      ),
                      SizedBox(
                        width: textSwitchSpace.w,
                      ),
                      Flexible(
                        child: Text(
                          'After max. legs',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .fontSize,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 3.w),
                        child: IconButton(
                          splashRadius: SPLASH_RADIUS,
                          splashColor: Utils.darken(
                              Theme.of(context).colorScheme.primary, 10),
                          highlightColor: Utils.darken(
                              Theme.of(context).colorScheme.primary, 10),
                          onPressed: gameSettingsX01.getMaxExtraLegs <= 1
                              ? null
                              : () {
                                  Utils.handleVibrationFeedback(context);
                                  setState(() {
                                    if (gameSettingsX01.getMaxExtraLegs == 1)
                                      return;
                                    gameSettingsX01.setMaxExtraLegs =
                                        gameSettingsX01.getMaxExtraLegs - 1;
                                    ;
                                  });
                                },
                          padding: EdgeInsets.zero,
                          constraints:
                              Utils.isMobile(context) ? BoxConstraints() : null,
                          icon: Icon(
                            Icons.remove,
                            size: ICON_BUTTON_SIZE.h,
                            color: gameSettingsX01.getMaxExtraLegs > 1
                                ? Theme.of(context).colorScheme.secondary
                                : Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        width: 8.w,
                        child: Center(
                          child: Text(
                            gameSettingsX01.getMaxExtraLegs.toString(),
                            style: TextStyle(
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .fontSize,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: IconButton(
                          splashRadius: SPLASH_RADIUS,
                          splashColor: Utils.darken(
                              Theme.of(context).colorScheme.primary, 10),
                          highlightColor: Utils.darken(
                              Theme.of(context).colorScheme.primary, 10),
                          onPressed:
                              gameSettingsX01.getMaxExtraLegs == MAX_EXTRA_LEGS
                                  ? null
                                  : () {
                                      Utils.handleVibrationFeedback(context);
                                      if (gameSettingsX01.getMaxExtraLegs >=
                                          MAX_EXTRA_LEGS) return;
                                      setState(() {
                                        gameSettingsX01.setMaxExtraLegs =
                                            gameSettingsX01.getMaxExtraLegs + 1;
                                        ;
                                      });
                                    },
                          padding: EdgeInsets.zero,
                          constraints:
                              Utils.isMobile(context) ? BoxConstraints() : null,
                          icon: Icon(
                            Icons.add,
                            size: ICON_BUTTON_SIZE.h,
                            color: gameSettingsX01.getMaxExtraLegs !=
                                    MAX_EXTRA_LEGS
                                ? Theme.of(context).colorScheme.secondary
                                : Theme.of(context).colorScheme.primary,
                          ),
                        ),
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
              Utils.handleVibrationFeedback(context);
              Navigator.of(context).pop();
              _resetWinByTwoLegsDifference(gameSettingsX01);
            },
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
              ),
            ),
            style: ButtonStyles.darkPrimaryColorBtnStyle(context).copyWith(
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
              Utils.handleVibrationFeedback(context);
              _submitWinByTwoLegsDifference(gameSettingsX01);
              Navigator.of(context).pop();
            },
            child: Text(
              'Submit',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
              ),
            ),
            style: ButtonStyles.darkPrimaryColorBtnStyle(context).copyWith(
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
      contentPadding:
          Utils.isMobile(context) ? DIALOG_CONTENT_PADDING_MOBILE : null,
      title: Text(
        'Information',
        style: TextStyle(
          color: Colors.white,
          fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
        ),
      ),
      content: Container(
          width: TEXT_DIALOG_WIDTH.w,
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                color: Colors.white,
                fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
              ),
              children: [
                TextSpan(
                    text:
                        "If the score is tied after the regular number of legs, a deciding leg is played, called "),
                TextSpan(
                  text: "Sudden death",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                    text:
                        ".\nWhoever wins this leg, is the winner of the match."),
              ],
            ),
          )),
      actions: [
        TextButton(
          onPressed: () {
            Utils.handleVibrationFeedback(context);
            Navigator.of(context).pop();
          },
          child: Text(
            'Continue',
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
            ),
          ),
          style: ButtonStyles.darkPrimaryColorBtnStyle(context).copyWith(
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
      contentPadding:
          Utils.isMobile(context) ? DIALOG_CONTENT_PADDING_MOBILE : null,
      title: Text(
        'Information',
        style: TextStyle(
          color: Colors.white,
          fontSize: Theme.of(context).textTheme.titleSmall!.fontSize,
        ),
      ),
      content: Container(
          width: TEXT_DIALOG_WIDTH.w,
          child: RichText(
            text: TextSpan(
              style: TextStyle(
                color: Colors.white,
                fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
              ),
              children: <TextSpan>[
                TextSpan(
                  text:
                      "The additional maximum number of legs until the Sudden death leg, is specified here. By default, it is set to 2 legs.\nFor example, in case of",
                ),
                TextSpan(
                  text: " First to 5 legs,",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: " the Sudden death leg is played after a",
                ),
                TextSpan(
                  text: " 7:7",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: " score.",
                ),
              ],
            ),
          )),
      actions: [
        TextButton(
          onPressed: () {
            Utils.handleVibrationFeedback(context);
            Navigator.of(context).pop();
          },
          child: Text(
            'Continue',
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontSize: Theme.of(context).textTheme.bodyMedium!.fontSize,
            ),
          ),
          style: ButtonStyles.darkPrimaryColorBtnStyle(context).copyWith(
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
  final int legs;
  final bool drawMode;
  final bool winByTwoLegsDifference;
  final bool suddenDeath;
  final int maxExtraLegs;
  final bool setsEnabled;

  SelectorModel({
    required this.legs,
    required this.drawMode,
    required this.winByTwoLegsDifference,
    required this.suddenDeath,
    required this.maxExtraLegs,
    required this.setsEnabled,
  });
}
