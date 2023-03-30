import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class BestOfOrFirstToX01 extends StatelessWidget {
  _switchBestOfOrFirstTo(BuildContext context, GameSettingsX01_P settings) {
    if (settings.getMode == BestOfOrFirstToEnum.BestOf) {
      settings.setMode = BestOfOrFirstToEnum.FirstTo;

      if (settings.getDrawMode) {
        settings.setDrawMode = false;
      }

      if (settings.getSetsEnabled) {
        settings.setLegs = DEFAULT_LEGS_FIRST_TO_SETS_ENABLED;
        settings.setSets = DEFAULT_SETS_FIRST_TO_SETS_ENABLED;
      } else {
        settings.setLegs = DEFAULT_LEGS_FIRST_TO_NO_SETS;
      }
    } else {
      settings.setMode = BestOfOrFirstToEnum.BestOf;
      settings.setWinByTwoLegsDifference = false;

      if (settings.getSetsEnabled) {
        settings.setSets = DEFAULT_SETS_BEST_OF_SETS_ENABLED;
        settings.setLegs = DEFAULT_LEGS_BEST_OF_SETS_ENABLED;
      } else {
        settings.setLegs = DEFAULT_LEGS_BEST_OF_NO_SETS;
      }
    }

    settings..notify();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: WIDTH_GAMESETTINGS.w,
        height: WIDGET_HEIGHT_GAMESETTINGS.h,
        margin: EdgeInsets.only(top: MARGIN_GAMESETTINGS.h),
        child: Selector<GameSettingsX01_P, BestOfOrFirstToEnum>(
          selector: (_, gameSettings) => gameSettings.getMode,
          builder: (_, mode, __) => Row(
            children: [
              BestOfBtn(
                switchBestOfOrFirstTo: _switchBestOfOrFirstTo,
                mode: mode,
              ),
              FirstToBtn(
                switchBestOfOrFirstTo: _switchBestOfOrFirstTo,
                mode: mode,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class BestOfBtn extends StatelessWidget {
  const BestOfBtn({
    Key? key,
    required Function this.switchBestOfOrFirstTo,
    required BestOfOrFirstToEnum this.mode,
  }) : super(key: key);

  final Function switchBestOfOrFirstTo;
  final BestOfOrFirstToEnum mode;

  @override
  Widget build(BuildContext context) {
    final GameSettingsX01_P gameSettingsX01 = context.read<GameSettingsX01_P>();

    return Expanded(
      child: ElevatedButton(
        onPressed: () {
          if (mode != BestOfOrFirstToEnum.BestOf) {
            switchBestOfOrFirstTo(context, gameSettingsX01);
          }
        },
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'Best of',
            style: TextStyle(
              color: Utils.getTextColorForGameSettingsBtn(
                  mode == BestOfOrFirstToEnum.BestOf, context),
            ),
          ),
        ),
        style: ButtonStyle(
          splashFactory: NoSplash.splashFactory,
          shadowColor: MaterialStateProperty.all(Colors.transparent),
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              side: BorderSide(
                color: Utils.getPrimaryColorDarken(context),
                width: GAME_SETTINGS_BTN_BORDER_WITH.w,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(BUTTON_BORDER_RADIUS),
                bottomLeft: Radius.circular(BUTTON_BORDER_RADIUS),
              ),
            ),
          ),
          backgroundColor: mode == BestOfOrFirstToEnum.BestOf
              ? Utils.getPrimaryMaterialStateColorDarken(context)
              : Utils.getColor(Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }
}

class FirstToBtn extends StatelessWidget {
  const FirstToBtn({
    Key? key,
    required Function this.switchBestOfOrFirstTo,
    required BestOfOrFirstToEnum this.mode,
  }) : super(key: key);

  final Function switchBestOfOrFirstTo;
  final BestOfOrFirstToEnum mode;

  @override
  Widget build(BuildContext context) {
    final GameSettingsX01_P gameSettingsX01 = context.read<GameSettingsX01_P>();

    return Expanded(
      child: SizedBox(
        child: ElevatedButton(
          onPressed: () {
            if (mode != BestOfOrFirstToEnum.FirstTo) {
              switchBestOfOrFirstTo(context, gameSettingsX01);
            }
          },
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'First to',
              style: TextStyle(
                color: Utils.getTextColorForGameSettingsBtn(
                    mode == BestOfOrFirstToEnum.FirstTo, context),
              ),
            ),
          ),
          style: ButtonStyle(
            splashFactory: NoSplash.splashFactory,
            shadowColor: MaterialStateProperty.all(Colors.transparent),
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                side: BorderSide(
                  color: Utils.getPrimaryColorDarken(context),
                  width: GAME_SETTINGS_BTN_BORDER_WITH.w,
                ),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(BUTTON_BORDER_RADIUS),
                  bottomRight: Radius.circular(BUTTON_BORDER_RADIUS),
                ),
              ),
            ),
            backgroundColor: mode == BestOfOrFirstToEnum.FirstTo
                ? Utils.getPrimaryMaterialStateColorDarken(context)
                : Utils.getColor(Theme.of(context).colorScheme.primary),
          ),
        ),
      ),
    );
  }
}
