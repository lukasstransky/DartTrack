import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class ModeInX01 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Consumer<GameSettingsX01_P>(
        builder: (_, gameSettingsX01, __) => Container(
          width: WIDTH_GAMESETTINGS.w,
          height: Utils.getHeightForWidget(gameSettingsX01).h,
          margin: EdgeInsets.only(top: MARGIN_GAMESETTINGS.h),
          child: Row(
            children: [
              SingleInBtn(),
              DoubleInBtn(),
              MasterInBtn(),
            ],
          ),
        ),
      ),
    );
  }
}

class MasterInBtn extends StatelessWidget {
  const MasterInBtn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GameSettingsX01_P gameSettingsX01 = context.read<GameSettingsX01_P>();
    final bool isMasterModeIn = gameSettingsX01.getModeIn == ModeOutIn.Master;

    return Expanded(
      child: ElevatedButton(
        onPressed: () => {
          gameSettingsX01.setModeIn = ModeOutIn.Master,
          gameSettingsX01.notify()
        },
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'Master in',
            style: TextStyle(
              color:
                  Utils.getTextColorForGameSettingsBtn(isMasterModeIn, context),
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
          backgroundColor: isMasterModeIn
              ? Utils.getPrimaryMaterialStateColorDarken(context)
              : Utils.getColor(Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }
}

class DoubleInBtn extends StatelessWidget {
  const DoubleInBtn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GameSettingsX01_P gameSettingsX01 = context.read<GameSettingsX01_P>();
    final bool isDoubleModeIn = gameSettingsX01.getModeIn == ModeOutIn.Double;

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
                color: Utils.getPrimaryColorDarken(context),
                width: GAME_SETTINGS_BTN_BORDER_WITH),
            bottom: BorderSide(
                color: Utils.getPrimaryColorDarken(context),
                width: GAME_SETTINGS_BTN_BORDER_WITH),
          ),
        ),
        child: ElevatedButton(
          onPressed: () => {
            gameSettingsX01.setModeIn = ModeOutIn.Double,
            gameSettingsX01.notify()
          },
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'Double in',
              style: TextStyle(
                color: Utils.getTextColorForGameSettingsBtn(
                    isDoubleModeIn, context),
              ),
            ),
          ),
          style: ButtonStyle(
            splashFactory: NoSplash.splashFactory,
            shadowColor: MaterialStateProperty.all(Colors.transparent),
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            ),
            backgroundColor: isDoubleModeIn
                ? Utils.getPrimaryMaterialStateColorDarken(context)
                : Utils.getColor(Theme.of(context).colorScheme.primary),
          ),
        ),
      ),
    );
  }
}

class SingleInBtn extends StatelessWidget {
  const SingleInBtn({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GameSettingsX01_P gameSettingsX01 = context.read<GameSettingsX01_P>();
    final bool isSingleModeIn = gameSettingsX01.getModeIn == ModeOutIn.Single;

    return Expanded(
      child: ElevatedButton(
        onPressed: () => {
          gameSettingsX01.setModeIn = ModeOutIn.Single,
          gameSettingsX01.notify()
        },
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'Single in',
            style: TextStyle(
              color:
                  Utils.getTextColorForGameSettingsBtn(isSingleModeIn, context),
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
          backgroundColor: isSingleModeIn
              ? Utils.getPrimaryMaterialStateColorDarken(context)
              : Utils.getColor(Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }
}
