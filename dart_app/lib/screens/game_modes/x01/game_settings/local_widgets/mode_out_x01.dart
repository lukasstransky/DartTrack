import 'package:dart_app/constants.dart';
import 'package:dart_app/models/game_settings/x01/game_settings_x01_p.dart';
import 'package:dart_app/utils/utils.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class ModeOutX01 extends StatelessWidget {
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
              SingleOutBtn(),
              DoubleOutBtn(),
              MasterOutBtn(),
            ],
          ),
        ),
      ),
    );
  }
}

class SingleOutBtn extends StatelessWidget {
  const SingleOutBtn({Key? key}) : super(key: key);

  _singleOutClicked(GameSettingsX01_P gameSettingsX01) {
    gameSettingsX01.setModeOut = ModeOutIn.Single;
    gameSettingsX01.setEnableCheckoutCounting = false;
    gameSettingsX01.notify();
  }

  @override
  Widget build(BuildContext context) {
    final GameSettingsX01_P gameSettingsX01 = context.read<GameSettingsX01_P>();
    final bool isSingleOutMode = gameSettingsX01.getModeOut == ModeOutIn.Single;

    return Expanded(
      child: ElevatedButton(
        onPressed: () => _singleOutClicked(gameSettingsX01),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'Single out',
            style: TextStyle(
              color: Utils.getTextColorForGameSettingsBtn(
                  isSingleOutMode, context),
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
          backgroundColor: isSingleOutMode
              ? Utils.getPrimaryMaterialStateColorDarken(context)
              : Utils.getColor(Theme.of(context).colorScheme.primary),
        ),
      ),
    );
  }
}

class DoubleOutBtn extends StatelessWidget {
  const DoubleOutBtn({Key? key}) : super(key: key);

  _doubleOutClicked(GameSettingsX01_P gameSettingsX01) {
    gameSettingsX01.setEnableCheckoutCounting = false;
    gameSettingsX01.setModeOut = ModeOutIn.Double;
    gameSettingsX01.notify();
  }

  @override
  Widget build(BuildContext context) {
    final GameSettingsX01_P gameSettingsX01 = context.read<GameSettingsX01_P>();
    final bool isDoubleOutMode = gameSettingsX01.getModeOut == ModeOutIn.Double;

    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
                color: Utils.getPrimaryColorDarken(context),
                width: GAME_SETTINGS_BTN_BORDER_WITH.w),
            bottom: BorderSide(
                color: Utils.getPrimaryColorDarken(context),
                width: GAME_SETTINGS_BTN_BORDER_WITH.w),
          ),
        ),
        child: ElevatedButton(
          onPressed: () => _doubleOutClicked(gameSettingsX01),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'Double out',
              style: TextStyle(
                color: Utils.getTextColorForGameSettingsBtn(
                    isDoubleOutMode, context),
              ),
            ),
          ),
          style: ButtonStyle(
            splashFactory: NoSplash.splashFactory,
            shadowColor: MaterialStateProperty.all(Colors.transparent),
            overlayColor: MaterialStateProperty.all(Colors.transparent),
            backgroundColor: isDoubleOutMode
                ? Utils.getPrimaryMaterialStateColorDarken(context)
                : Utils.getColor(Theme.of(context).colorScheme.primary),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            ),
          ),
        ),
      ),
    );
  }
}

class MasterOutBtn extends StatelessWidget {
  const MasterOutBtn({Key? key}) : super(key: key);

  _masterOutClicked(GameSettingsX01_P gameSettingsX01) {
    gameSettingsX01.setModeOut = ModeOutIn.Master;
    gameSettingsX01.setEnableCheckoutCounting = false;
    gameSettingsX01.notify();
  }

  @override
  Widget build(BuildContext context) {
    final GameSettingsX01_P gameSettingsX01 = context.read<GameSettingsX01_P>();
    final bool isMasterOutMode = gameSettingsX01.getModeOut == ModeOutIn.Master;

    return Expanded(
      child: SizedBox(
        child: ElevatedButton(
          onPressed: () => _masterOutClicked(gameSettingsX01),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'Master out',
              style: TextStyle(
                color: Utils.getTextColorForGameSettingsBtn(
                    isMasterOutMode, context),
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
            backgroundColor: isMasterOutMode
                ? Utils.getPrimaryMaterialStateColorDarken(context)
                : Utils.getColor(Theme.of(context).colorScheme.primary),
          ),
        ),
      ),
    );
  }
}
