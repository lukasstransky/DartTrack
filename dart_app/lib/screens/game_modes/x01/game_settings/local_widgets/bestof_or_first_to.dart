import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/game_settings_x01.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class BestOfOrFirstTo extends StatelessWidget {
  _switchBestOfOrFirstTo(
      BuildContext context, GameSettingsX01 gameSettingsX01) {
    if (gameSettingsX01.getMode == BestOfOrFirstToEnum.BestOf) {
      gameSettingsX01.setMode = BestOfOrFirstToEnum.FirstTo;

      if (gameSettingsX01.getDrawMode) {
        gameSettingsX01.setDrawMode = false;
      }

      if (gameSettingsX01.getSetsEnabled) {
        gameSettingsX01.setLegs = DEFAULT_LEGS_FIRST_TO_SETS_ENABLED;
        gameSettingsX01.setSets = DEFAULT_SETS_FIRST_TO_SETS_ENABLED;
      } else {
        gameSettingsX01.setLegs = DEFAULT_LEGS_FIRST_TO_NO_SETS;
      }
    } else {
      gameSettingsX01.setMode = BestOfOrFirstToEnum.BestOf;
      gameSettingsX01.setWinByTwoLegsDifference = false;

      if (gameSettingsX01.getSetsEnabled) {
        gameSettingsX01.setSets = DEFAULT_SETS_BEST_OF_SETS_ENABLED;
        gameSettingsX01.setLegs = DEFAULT_LEGS_BEST_OF_SETS_ENABLED;
      } else {
        gameSettingsX01.setLegs = DEFAULT_LEGS_BEST_OF_NO_SETS;
      }
    }

    gameSettingsX01..notify();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Consumer<GameSettingsX01>(
        builder: (_, gameSettingsX01, __) => Container(
          width: WIDTH_GAMESETTINGS.w,
          height: Utils.getHeightForWidget(gameSettingsX01).h,
          margin: EdgeInsets.only(top: MARGIN_GAMESETTINGS.h),
          child: Row(
            children: [
              BestOfBtn(switchBestOfOrFirstTo: _switchBestOfOrFirstTo),
              FirstToBtn(switchBestOfOrFirstTo: _switchBestOfOrFirstTo)
            ],
          ),
        ),
      ),
    );
  }
}

class BestOfBtn extends StatelessWidget {
  const BestOfBtn({Key? key, required Function this.switchBestOfOrFirstTo})
      : super(key: key);

  final Function switchBestOfOrFirstTo;

  @override
  Widget build(BuildContext context) {
    final GameSettingsX01 gameSettingsX01 = context.read<GameSettingsX01>();
    final bool isBestOfMode =
        gameSettingsX01.getMode == BestOfOrFirstToEnum.BestOf;

    return Expanded(
      child: ElevatedButton(
        onPressed: () => {
          if (!isBestOfMode)
            {
              switchBestOfOrFirstTo(context, gameSettingsX01),
            }
        },
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'Best Of',
            style: TextStyle(
              color:
                  Utils.getTextColorForGameSettingsBtn(isBestOfMode, context),
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
                width: GAME_SETTINGS_BTN_BORDER_WITH,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(BUTTON_BORDER_RADIUS),
                bottomLeft: Radius.circular(BUTTON_BORDER_RADIUS),
              ),
            ),
          ),
          backgroundColor: isBestOfMode
              ? Utils.getPrimaryMaterialStateColorDarken(context)
              : Utils.getColor(Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }
}

class FirstToBtn extends StatelessWidget {
  const FirstToBtn({Key? key, required Function this.switchBestOfOrFirstTo})
      : super(key: key);

  final Function switchBestOfOrFirstTo;

  @override
  Widget build(BuildContext context) {
    final GameSettingsX01 gameSettingsX01 = context.read<GameSettingsX01>();
    final bool isFirstToMode =
        gameSettingsX01.getMode == BestOfOrFirstToEnum.FirstTo;

    return Expanded(
      child: SizedBox(
        child: ElevatedButton(
          onPressed: () {
            if (!isFirstToMode) switchBestOfOrFirstTo(context, gameSettingsX01);
          },
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'First To',
              style: TextStyle(
                color: Utils.getTextColorForGameSettingsBtn(
                    isFirstToMode, context),
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
                  width: GAME_SETTINGS_BTN_BORDER_WITH,
                ),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(BUTTON_BORDER_RADIUS),
                  bottomRight: Radius.circular(BUTTON_BORDER_RADIUS),
                ),
              ),
            ),
            backgroundColor: isFirstToMode
                ? Utils.getPrimaryMaterialStateColorDarken(context)
                : Utils.getColor(Theme.of(context).colorScheme.primary),
          ),
        ),
      ),
    );
  }
}
